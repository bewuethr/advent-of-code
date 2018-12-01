#!/usr/bin/perl

use warnings;
use strict;
use Data::Dumper;

use feature 'say';

use List::Util qw(max min reduce sum);
use List::MoreUtils qw(firstidx firstval pairwise singleton);
use Algorithm::Combinatorics qw(variations);
use Math::Prime::Util qw(is_prime);

my $fname = shift;


my $sum;
my %seen;
while (1) {
	open my $fh, "<", $fname
		or die "Can't open $fname: $!";
	while (my $line = <$fh>) {
		$sum += $line;
		# say $sum;
		$seen{$sum}++;
		# say Dumper(\%seen);
		if ($seen{$sum} == 2) {
			say $sum;
			exit;
		}
	}
	close $fh;
}
