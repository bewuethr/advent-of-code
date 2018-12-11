#!/usr/bin/perl

use warnings;
use strict;

use feature 'say';

use List::Util qw(max sum);

sub getPower {
	my ($x, $y, $serNum) = @_;
	my $power = (($x + 10) * $y + $serNum) * ($x + 10);
	$power =~ /(.)..$/;
	return ($1 // 0) - 5;
}

sub getPowerBoundary {
	my ($x, $y, $offset, $powerMap) = @_;
	my $power = sum @{ $powerMap->[$y+$offset] }[$x .. $x+$offset-1];
	for my $yy ($y .. $y+$offset) {
		$power += $powerMap->[$yy][$x+$offset];
	}
	return $power;
}

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

my $serNum = <$fh>;
chomp $serNum;

my @powerMap;

for my $x (1..300) {
	for my $y (1..300) {
		$powerMap[$y][$x] = getPower($x, $y, $serNum);
	}
}

my $maxPower = getPower(1, 1, $serNum);
my $maxSize;
my @maxCoords;

for my $y (1..300) {
	for my $x (1..300) {
		my $power = getPower($x, $y, $serNum);
		if ($power > $maxPower) {
			$maxPower = $power;
			@maxCoords = ($x, $y);
			$maxSize = 1;
		}
		for my $offset (1 .. 300-(max($x,$y))) {
			$power += getPowerBoundary($x, $y, $offset, \@powerMap);
			if ($power > $maxPower) {
				$maxPower = $power;
				@maxCoords = ($x, $y);
				$maxSize = $offset + 1;
			}
		}
	}
	say "y: $y";
}

say join ",", (@maxCoords, $maxSize);
