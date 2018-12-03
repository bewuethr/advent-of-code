#!/usr/bin/perl

use warnings;
use strict;

use feature 'say';

use List::Util qw(max min reduce sum);
use List::MoreUtils qw(firstidx firstval pairwise singleton);
use Algorithm::Combinatorics qw(variations);
use Math::Prime::Util qw(is_prime);
use Data::Dumper;

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

my %squares;

while (my $line = <$fh>) {
	chomp $line;
	# say $line;
	my (undef, $id, $dx, $dy, $w, $h) = split qr{[# @,:x]+}, $line;
	foreach my $y ($dy .. $dy+$h-1)  {
		foreach my $x ($dx .. $dx+$w-1) {
			# say "x: $x, y: $y";
			$squares{$x, $y}++;
			# say Dumper(\%squares);
		}
	}
}

my $count = 0;
foreach my $val (values %squares) {
	$count++ if $val > 1;
}

say $count;
