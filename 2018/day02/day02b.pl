#!/usr/bin/perl

use warnings;
use strict;

use feature 'say';

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

chomp(my @lines = <$fh>);

foreach my $idx1 (0 .. $#lines-1) {
	foreach my $idx2 ($idx1+1 .. $#lines) {
		compare($lines[$idx1], $lines[$idx2]);
	}
}

sub compare {
	my ($l1, $l2) = @_;
	my @arr1 = split //, $l1;
	my @arr2 = split //, $l2;
	my $count = 0;
	my $common;
	foreach my $idx (0 .. $#arr1) {
		if ($arr1[$idx] ne $arr2[$idx]) {
			++$count;
		}
		else {
			$common .= $arr1[$idx];
		}
	}
	if ($count == 1) {
		say $common;
		exit;
	}
	return;
}
