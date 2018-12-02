#!/usr/bin/perl

use warnings;
use strict;

use feature 'say';

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

my ($twos, $threes);

chomp(my @lines = <$fh>);

foreach my $line (@lines) {
	++$twos   if (hasrepeated($line, 2));
	++$threes if (hasrepeated($line, 3));
}

say $twos * $threes;

sub hasrepeated {
	my ($str, $n) = @_;
	foreach my $l (split //, $str) {
		if ((() = $str =~ /$l/g) == $n) {
			return 1;
		}
	}
	return 0;
}
