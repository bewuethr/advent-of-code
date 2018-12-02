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
	my $count = 0;
	my $common;
	foreach my $idx (0 .. length($l1)-1) {
		if (substr($l1, $idx, 1) ne substr($l2, $idx, 1)) {
			++$count;
		}
		else {
			$common .= substr($l1, $idx, 1);
		}
	}
	if ($count == 1) {
		say $common;
		exit;
	}
	return;
}
