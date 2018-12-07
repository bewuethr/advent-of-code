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

my (%steps, %degrees);

while (my $line = <$fh>) {
	chomp $line;
	$line =~ /Step (.).*step (.)/;
	my ($from, $to) = ($1, $2);
	push @{$steps{$from}}, $to;
	$degrees{$from} //= 0;
	$degrees{$to}++;
}

say Dumper(\%steps);
say Dumper(\%degrees);

my $result;

while (1) {
	my @roots = sort grep { $degrees{$_} == 0 } keys %degrees;
	last if @roots == 0;
	$result .= $roots[0];
	foreach my $node (@{ $steps{$roots[0]} }) {
		$degrees{$node}--;
	}
	delete $degrees{$roots[0]};
}

say $result;
