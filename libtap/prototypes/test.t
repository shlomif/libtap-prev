#!/bin/sh

#-- AUTOMATICALLY INSTALLED -- DO NOT EDIT!  (original location in "prototypes/" directory)

cd `dirname $0`

echo '1..2'

make 2>&1 > /dev/null

perl ./test.pl 2>&1 \
    | perl -pe '$_="",next if /^\#\s*(?:at|Looks like you failed)/; ' \
            -e 's/\#\s*(Failed\s+(\(TODO\)\s+)?test)\b.*/\#  $1/; ' \
            -e 's/(You tried to plan twice|You said to run 0 tests) at.*/$1!/;' \
    > test.pl.out

perlstatus=$?

./test 2>&1 \
    | perl -pe '$_="",next if /^\#\s*(?:at|Looks like your test died before|Looks like you failed \d+)/; ' \
            -e '/^#/  and  s/(\d+) test(s?) but ran (\d+) extra/"$1 test$2 but ran ".($1+$3)/e; ' \
            -e 's/\#\s*(Failed\s+(\(TODO\)\s+)?test)\b.*/\#  $1/;' \
            -e 's/ +You.ve got to run something.//;' \
    > test.c.out
cstatus=$?

diff -u test.pl.out test.c.out

ec=0

if [ $? -eq 0 ]; then
	echo 'ok 1 - output is identical'
else
	echo 'not ok 1 - output is identical'
	ec=1
fi

if [ $perlstatus -eq $cstatus ]; then
	echo 'ok 2 - status code'
else
	echo 'not ok 2 - status code'
	echo "# perlstatus = $perlstatus"
	echo "#    cstatus = $cstatus"
	ec=1
fi

exit $ec
