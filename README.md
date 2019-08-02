tap -- write tests that implement the Test Anything Protocol

# NOTE:

This library is deprecated in favour of [cmocka](https://cmocka.org/)
or perhaps [the newer libtap](https://github.com/shlomif/libtap) .
See https://github.com/shlomif/libtap-prev/issues/1 .

## SYNOPSIS

```
#include <tap.h>
```

## DESCRIPTION

The tap library provides functions for writing test scripts that produce
output consistent with the Test Anything Protocol.  A test harness that
parses this protocol can run these tests and produce useful reports indi-
cating their success or failure.

=============

The libtap homepage is at:

- http://www.shlomifish.org/open-source/projects/libtap/
