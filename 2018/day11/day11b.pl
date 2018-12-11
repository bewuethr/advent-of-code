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

sub getPower {
	my ($x, $y, $serNum) = @_;
	my $power = $x + 10;
	$power *= $y;
	$power += $serNum;
	$power *= $x + 10;
	$power =~ /(.)..$/;
	$power = $1;
	$power //= 0;
	$power -= 5;
	return $power;
}

sub getPowerBoundary {
	my ($x, $y, $offset, $powerMap) = @_;
	# say "x: $x, y: $y, size: $size";
	my $power = 0;
	for my $xx ($x .. $x+$offset-1) {
		$power += $powerMap->[$y+$offset][$xx];
	}
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
