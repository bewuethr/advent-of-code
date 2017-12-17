#!/usr/bin/perl

use strict;
use warnings;

use feature 'say';

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

chomp(my $steps = <$fh>);

my $len = 1;
my $pos = 0;
my $res;

for my $num (1..50_000_000) {
    $pos = ($pos + $steps) % $len;
    $res = $num if $pos == 0;
    $len++;
    $pos++;
}

say $res;
