#!/usr/bin/perl

use warnings;
use strict;

use feature 'say';

use List::Util qw(max min sum);

sub dist {
	my ($from, $to) = @_;
	return abs($from->{x} - $to->{x})
		+ abs($from->{y} - $to->{y})
		+ abs($from->{z} - $to->{z});
}

sub distFromBox {
	my ($point, $box) = @_;
	my $dist = 0;
	$dist += $point->{x} - $box->{xmax} if $point->{x} > $box->{xmax};
	$dist += $box->{xmin} - $point->{x} if $point->{x} < $box->{xmin};
	$dist += $point->{y} - $box->{ymax} if $point->{y} > $box->{ymax};
	$dist += $box->{ymin} - $point->{y} if $point->{y} < $box->{ymin};
	$dist += $point->{z} - $box->{zmax} if $point->{z} > $box->{zmax};
	$dist += $box->{zmin} - $point->{z} if $point->{z} < $box->{zmin};
	return $dist;
}

sub inrange {
	my ($box, $bots) = @_;
	my $count  = sum map { distFromBox($_, $box) <= $_->{r} } @$bots;
	return $count;
}

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

my @bots;

while (my $line = <$fh>) {
	chomp $line;
	my ($x, $y, $z, $r) = ( $line =~ /(-?\d+)/g );
	push @bots, { x => $x, y => $y, z => $z, r => $r };
}

# Get bounding box
my $xmin = min map { $_->{x} } @bots;
my $xmax = max map { $_->{x} } @bots;
my $ymin = min map { $_->{y} } @bots;
my $ymax = max map { $_->{y} } @bots;
my $zmin = min map { $_->{z} } @bots;
my $zmax = max map { $_->{z} } @bots;

# Create cube with edge length a power of 2 containing the bounding box
my $maxlen = max ($xmax-$xmin, $ymax-$ymin, $zmax-$zmin);
my $side = 2;
while ($side < $maxlen+1) {
	$side *= 2;
}

my $box = { xmin => $xmin, ymin => $ymin, zmin => $zmin, side => $side };
@$box{qw(xmax ymax zmax)} = (
	$xmin + $side - 1,
	$ymin + $side - 1,
	$zmin + $side - 1,
);

# Calculate within the range of how many bots the box is
$box->{inrange} = inrange($box, \@bots);

# Calculate the distance the box has from the origin
$box->{dist} = distFromBox( { x => 0, y => 0, z => 0 }, $box );

my @boxes = ($box);

while (1) {
	# Get next box
	@boxes = sort {
		$b->{inrange} <=> $a->{inrange} or
		$a->{dist}    <=> $b->{dist} or
		$a->{side}    <=> $b->{side}
	} @boxes;
	$box = shift @boxes;

	last if $box->{side} == 1;

	# Cut box into 8 smaller boxes
	my $newside = $box->{side} / 2;
	foreach my $x ($box->{xmin}, $box->{xmin}+$newside) {
		foreach my $y ($box->{ymin}, $box->{ymin}+$newside) {
			foreach my $z ($box->{zmin}, $box->{zmin}+$newside) {
				my $newbox = { xmin => $x, ymin => $y, zmin => $z, side => $newside };
				@$newbox{qw(xmax ymax zmax)} = (
					$x + $newside - 1,
					$y + $newside - 1,
					$z + $newside - 1,
				);
				$newbox->{inrange} = inrange($newbox, \@bots);
				$newbox->{dist} = distFromBox( { x => 0, y => 0, z => 0 }, $newbox );
				push @boxes, $newbox;
			}
		}
	}
}

say $box->{dist};
