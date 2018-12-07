#!/usr/bin/perl

use warnings;
use strict;

use feature 'say';

use List::Util qw(max min);
use List::MoreUtils qw(firstidx);

sub getdist {
	my ($x, $y, $p) = @_;
	return abs($p->[0] - $x) + abs($p->[1] - $y);
}

sub getnearest {
	my ($x, $y, $map) = @_;
	my @distances = map { getdist($x, $y, $_) } @$map;
	my $mindistance = min(@distances);
	if ( (grep { $_ == $mindistance } @distances) > 1 ) {
		return -1;
	}
	return firstidx { $_ == $mindistance } @distances;
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
foreach my $y ($ymin .. $ymax) {
	foreach my $x ($xmin .. $xmax) {
		my $val = getnearest($x, $y, \@map);
		$area{$val}++;
		print $val == -1 ? "." : chr(65+$val);
	}
	say "";
}

# Find points with infinite areas
my %infinite;
foreach my $x ($xmin .. $xmax) {
	$infinite{getnearest($x, $ymin, \@map)} //= 1;
	$infinite{getnearest($x, $ymax, \@map)} //= 1;
}
foreach my $y ($ymin .. $ymax) {
	$infinite{getnearest($xmin, $y, \@map)} //= 1;
	$infinite{getnearest($xmax, $y, \@map)} //= 1;
}

say max( @area{ grep { not exists $infinite{$_} } keys %area } );
