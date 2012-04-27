#!/usr/bin/perl

use strict;
use warnings;

use 5.014;

use File::Find::Object::Rule;
use IO::All;
use List::MoreUtils qw(any);

my @dirs = File::Find::Object::Rule->directory
    ->exec(sub { -e "$_[2]/Makefile.am" })->in(".");

say join(',', @dirs);

my %dirs = (map { $_ => +{} } @dirs);

my @check_targets;
foreach my $d (@dirs)
{
    my @lines = io->file("$d/Makefile.am")->slurp;

    my @subdirs = map { /^SUBDIRS\s*(?:\+=|=)\s*(.*)/ ? (split/\s+/,$1):() } 
        @lines;

    $dirs{$d}->{'subdirs'} = [@subdirs];

    print "Found [@subdirs] for $d\n";

    if ($d eq "src")
    {
        $dirs{$d}->{'text'} = <<'EOF'
SET(tap_LIB_SRCS
   tap.c
)

add_library(tap SHARED ${tap_LIB_SRCS})

target_link_libraries(tap)

set_target_properties(tap PROPERTIES VERSION 4.2.0 SOVERSION 4)
install(TARGETS tap DESTINATION lib)

INSTALL(
    FILES
        "tap.h"
    DESTINATION
        "include"
)
INSTALL_MAN ("tap.3" 3)
EOF
    }
    else
    {
        if ($d =~ m!\Atests/! && (any { m/\Acheck/ } @lines))
        {
            my $target = ($d =~ s{/}{__}gr);

            my $check_target = "check__$target";
            push @check_targets, $check_target;
            $dirs{$d}->{text} = <<"EOF";
LIBTAP_TEST_TARGET("$target")
EOF
        }
        else
        {
            $dirs{$d}->{text} = '';

            if ($d eq '.')
            {
                $dirs{$d}->{text} .= <<'EOF';
INCLUDE( "${CMAKE_CURRENT_SOURCE_DIR}/Common.cmake" )

FUNCTION (LIBTAP_TEST_TARGET target)
    ADD_EXECUTABLE( "${target}" "test.c")
    set_target_properties( "${target}" PROPERTIES OUTPUT_NAME "test")
    target_link_libraries( "${target}" "tap")

    SET (check_target "check__${target}")
    ADD_CUSTOM_TARGET(
        "${check_target}"
        "sh" "test.t"
        )

    FOREACH (file_to_copy "test.t" "test.pl")
        CONFIGURE_FILE("${CMAKE_CURRENT_SOURCE_DIR}/${file_to_copy}" "${CMAKE_CURRENT_BINARY_DIR}/${file_to_copy}" COPYONLY)
    ENDFOREACH (file_to_copy)
ENDFUNCTION (LIBTAP_TEST_TARGET target)

EOF
                $dirs{$d}->{text} .= qq{cmake_minimum_required(VERSION 2.8)\n\n};
            }
        }

        foreach my $subdir (@{ $dirs{$d}{'subdirs'} })
        {
            $dirs{$d}->{text} .= "ADD_SUBDIRECTORY($subdir)\n";
        }
    }
}

$dirs{'.'}->{text} .= "ADD_CUSTOM_TARGET(check true DEPENDS @check_targets)\n";

foreach my $d (@dirs)
{
    io->file("$d/CMakeLists.txt")->print($dirs{$d}->{text} . "\n");
}
io->file("/home/shlomif/progs/freecell/hg/fc-solve/fc-solve/source/Common.cmake") > io->file("./Common.cmake");
