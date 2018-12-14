#!/usr/bin/perl

use warnings;
use strict;

use feature 'say';

use List::Util qw(max min reduce sum);
use List::MoreUtils qw(firstidx firstval pairwise singleton);
use Algorithm::Combinatorics qw(variations);
use Math::Prime::Util qw(is_prime);
use Data::Dumper;
$Data::Dumper::Sortkeys = 1;

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
	# say "@r";
}

say join "", @r[$num .. $num+9];
