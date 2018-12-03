#!/usr/bin/perl

use warnings;
use strict;

use feature 'say';

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

my %squares;

while (my $line = <$fh>) {
	chomp $line;
	my (undef, $id, $dx, $dy, $w, $h) = split qr{[# @,:x]+}, $line;
	foreach my $y ($dy .. $dy+$h-1)  {
		foreach my $x ($dx .. $dx+$w-1) {
			$squares{$x, $y}++;
		}
	}
}

say scalar grep { $_ > 1 } values %squares;
