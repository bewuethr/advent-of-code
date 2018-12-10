#!/usr/bin/perl

use warnings;
use strict;

use feature 'say';

use List::Util qw(max min);

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

my @lights;

while (my $line = <$fh>) {
	chomp $line;
	$line =~ /(-?\d+),.*?(-?\d+).*?(-?\d), *?(-?\d)/;
	push @lights, { x => $1, y => $2, vx => $3, vy => $4 };
}

my $t = 0;
my ($prevBBSize, $bbSize);

while (1) {
	my $xmin = min map { $_->{x} } @lights;
	my $xmax = max map { $_->{x} } @lights;
	my $ymin = min map { $_->{y} } @lights;
	my $ymax = max map { $_->{y} } @lights;
	$bbSize = ($xmax - $xmin + 1) * ($ymax - $ymin + 1);
	if ($t > 0 and $bbSize > $prevBBSize) {
		say $t - 1;
		exit;
	}

	foreach my $light (@lights) {
		$light->{x} += $light->{vx};
		$light->{y} += $light->{vy};
	}
	$prevBBSize = $bbSize;
	$t++;
}

