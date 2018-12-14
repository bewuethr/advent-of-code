#!/usr/bin/perl

use warnings;
use strict;

use feature 'say';

use List::Util qw(sum);

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

chomp(my $num = <$fh> + 0);

my @r = (3, 7);

my ($i, $j) = (0, 1);

while (@r < $num + 10) {
	my $sum = sum @r[$i, $j];
	push @r, split( //, $sum);
	$i = ($i + $r[$i] + 1) % @r;
	$j = ($j + $r[$j] + 1) % @r;
}

say join "", @r[$num .. $num+9];
