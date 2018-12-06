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

sub getdist {
	my ($x, $y, $p) = @_;
	# say "$x, $y, @$p";
	return abs($p->[0] - $x) + abs($p->[1] - $y);
}

sub getnearest {
	my ($x, $y, $map) = @_;
	my @distances = map { getdist($x, $y, $_) } @$map;
	# say "@distances";
	my $mindistance = min(@distances);
	# say "min: $mindistance";
	if ((grep { $_ == $mindistance } @distances) > 1) {
		# say "-1";
		return -1;
	}
	# say firstidx { $_ == $mindistance } @distances;
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

# say Dumper(\@map);

# Bounding box
my ($xmin, $xmax, $ymin, $ymax) = ($map[0][0], $map[0][0], $map[0][1], $map[0][1]);
foreach my $coord (@map) {
	$xmin = $$coord[0] if $$coord[0] < $xmin;
	$xmax = $$coord[0] if $$coord[0] > $xmax;
	$ymin = $$coord[1] if $$coord[1] < $ymin;
	$ymax = $$coord[1] if $$coord[1] > $ymax;
}

($xmin, $ymin) = (0, 0);
$xmax += 100;
$ymax += 100;

# say "$xmin, $xmax, $ymin, $ymax";
my %area;
foreach my $y ($ymin .. $ymax) {
	foreach my $x ($xmin .. $xmax) {
		# $nearest[$y][$x] = getnearest($x, $y, \@map);
		my $val = getnearest($x, $y, \@map);
		$area{$val}++;
		print $val == -1 ? "." : chr(65+$val);
		# say Dumper(\%area);
		# <>;
	}
	say "";
	# say "@{$nearest[$y]}";
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

say Dumper(\%area);
say Dumper(\%infinite);

say max( @area{ grep { not exists $infinite{$_} } keys %area } );
