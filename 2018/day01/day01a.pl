#!/usr/bin/perl

use warnings;
use strict;

use feature 'say';

use List::Util qw(max min reduce sum);
use List::MoreUtils qw(firstidx firstval pairwise singleton);
use Algorithm::Combinatorics qw(variations);
use Math::Prime::Util qw(is_prime);

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

my $sum;
while (my $line = <$fh>) {
	$sum += $line;
}
say $sum;
