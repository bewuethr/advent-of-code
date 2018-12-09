#!/usr/bin/perl

use warnings;
use strict;

use feature 'say';

use List::Util qw(max);

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

my $line = <$fh>;
chomp $line;
$line =~ /(\d+).* (\d+)/;
my ($players, $last) = ($1, $2);

my @circle = ( 0 );
my @scores;
my $current = 0;
my $player = 0;

foreach my $val (1 .. $last) {
	if ($val % 23 == 0) {
		my $removeIdx = ($current + @circle - 7) % @circle;
		$scores[$player] += $val + $circle[$removeIdx];
		splice @circle, $removeIdx, 1;
		$current = $removeIdx > $#circle ? 0 : $removeIdx;
	}
	else {
		my $insertIdx = ($current + 2) % @circle;
		if ($insertIdx == 0) {
			push @circle, $val;
			$insertIdx = $#circle;
		}
		else {
			splice @circle, $insertIdx, 0, $val;
		}
		$current = $insertIdx;
	}
	$player = ($player + 1) % $players;
}

say max @scores;
