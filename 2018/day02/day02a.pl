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

my ($twos, $threes);

chomp(my @lines = <$fh>);

foreach my $line (@lines) {
	my @arr = split //, $line;
	foreach my $l (@arr) {
		my $count = () = $line =~ /$l/g;
		if ($count == 2) {
			++$twos;
			last;
		}
	}
}

foreach my $line (@lines) {
	my @arr = split //, $line;
	foreach my $l (@arr) {
		my $count = () = $line =~ /$l/g;
		if ($count == 3) {
			++$threes;
			last;
		}
	}
}

say $twos * $threes;
