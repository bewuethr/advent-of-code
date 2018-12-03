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
			$squares{$x, $y}[0]++;
			push @{$squares{$x, $y}[1]}, $id;
		}
	}
}

my %singles;
my %multiples;
foreach my $idlist (values %squares) {
	if (@{$idlist->[1]} == 1) {
		$singles{$idlist->[1][0]} = 1;
	}
	else {
		foreach my $id (@{$idlist->[1]}) {
			$multiples{$id} = 1;
		}
	}
}

say grep { not exists $multiples{$_} } keys %singles;
