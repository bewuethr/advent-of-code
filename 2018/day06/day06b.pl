#!/usr/bin/perl

use warnings;
use strict;

use feature 'say';

use List::Util qw(max min sum);
use List::MoreUtils qw(firstidx);

sub getdist {
	my ($x, $y, $p) = @_;
	return abs($p->[0] - $x) + abs($p->[1] - $y);
}

sub isinregion {
	my ($x, $y, $map) = @_;
	my $totaldist = sum map { getdist($x, $y, $_) } @$map;
	return $totaldist < 10000;
}

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

my @map;

while (my $line = <$fh>) {
	chomp $line;
	$line =~ m/(\d+), (\d+)/;
	push @map, [$1, $2];
}

# Bounding box
my ($xmin, $xmax, $ymin, $ymax) = (
	(min map { $_->[0] } @map),
	(max map { $_->[0] } @map),
	(min map { $_->[1] } @map),
	(max map { $_->[1] } @map),
);

my %area;
my $count;
foreach my $y ($ymin .. $ymax) {
	foreach my $x ($xmin .. $xmax) {
		my $val = isinregion($x, $y, \@map);
		$count += $val;
		print $val ? "X" : ".";
	}
	say "";
}

say $count;
