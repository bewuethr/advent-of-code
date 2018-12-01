#!/usr/bin/perl

use warnings;
use strict;

use feature 'say';


my $fname = shift;

my $sum;
my %seen;
while (1) {
	open my $fh, "<", $fname
		or die "Can't open $fname: $!";
	while (my $line = <$fh>) {
		$sum += $line;
		$seen{$sum}++;
		if ($seen{$sum} == 2) {
			say $sum;
			exit;
		}
	}
	close $fh;
}
