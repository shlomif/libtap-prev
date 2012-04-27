#!/usr/bin/perl

use strict;
use warnings;

use File::Find::Object::Rule;

my @makefile_ams = File::Find::Object::Rule->file->name('Makefile.am')->in(".");

print join(',', @makefile_ams), "\n";
