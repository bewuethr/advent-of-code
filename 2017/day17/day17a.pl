#!/usr/bin/perl

use strict;
use warnings;

use feature 'say';

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

chomp(my $steps = <$fh>);

my @buffer = (0);
my $pos = 0;

for my $num (1..2017) {
    $pos = ($pos + $steps) % @buffer;
    splice @buffer, $pos+1, 0, $num;
    $pos++;
}

say $buffer[$pos+1];
