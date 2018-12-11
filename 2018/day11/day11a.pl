#!/usr/bin/perl

use warnings;
use strict;

use feature 'say';

sub getPower {
	my ($x, $y, $serNum) = @_;
	my $power = (($x + 10) * $y + $serNum) * ($x + 10);
	$power =~ /(.)..$/;
	return ($1 // 0) - 5;
}

sub getPowerSquare {
	my ($x, $y, $serNum) = @_;
	my $power = 0;
	for my $xx ($x..$x+2) {
		for my $yy ($y..$y+2) {
			$power += getPower($xx, $yy, $serNum);
		}
	}
	return $power;
}

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

my $serNum = <$fh>;
chomp $serNum;

my $maxPower = getPowerSquare(1, 1, $serNum);
my @maxCoords = (1, 1);

for my $x (1..298) {
	for my $y (1..298) {
		my $power = getPowerSquare($x, $y, $serNum);
		if ($power > $maxPower) {
			$maxPower = $power;
			@maxCoords = ($x, $y);
		}
	}
}

say join ",", @maxCoords;
