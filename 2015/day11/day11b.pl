#!/bin/perl

use strict;
use warnings;
use 5.022;

my $passwd = 'vzbxxyzz';

while (1) {
    ++$passwd; 
    next if $passwd =~ m/i|o|l/;
    last if $passwd =~ m/abc|bcd|cde|def|efg|fgh|ghi|hij|ijk|jkl|klm|lmn|mno|nop|opq|pqr|qrs|rst|stu|tuv|uvw|vwx|wxy|xyz/ and $passwd =~ m/(.)\1.*(?!\1)(.)\2/;
}
say "$passwd";
