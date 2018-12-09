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

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

my $line = <$fh>;
chomp $line;
$line =~ /(\d+).* (\d+)/;
my ($players, $last) = ($1, $2);
# my ($players, $last) = (9, 25);

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
		# say "@circle";
	}
	$player = ($player + 1) % $players;
}

say max @scores;
