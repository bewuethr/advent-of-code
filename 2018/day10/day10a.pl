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

my @lights;

while (my $line = <$fh>) {
	chomp $line;
	$line =~ /(-?\d+),.*?(-?\d+).*?(-?\d), *?(-?\d)/;
	push @lights, { x => $1, y => $2, vx => $3, vy => $4 };
}

# say Dumper(\@lights);

my $t = 10_300;
foreach my $light (@lights) {
	$light->{x} += $t * $light->{vx};
	$light->{y} += $t * $light->{vy};
}

while (1) {
	my $xmin = min map { $_->{x} } @lights;
	my $xmax = max map { $_->{x} } @lights;
	my $ymin = min map { $_->{y} } @lights;
	my $ymax = max map { $_->{y} } @lights;

	my %map;
	foreach my $light (@lights) {
		$map{$light->{x},$light->{y}} = 1;
	}

	say "t: $t, BB: " . ($xmax - $xmin + 1) . " by " . ($ymax - $ymin + 1);
	# say "\t$xmin - $xmax, $ymin - $ymax";
	
	foreach my $y ($ymin .. $ymax) {
		foreach my $x ($xmin .. $xmax) {
			if (exists $map{$x,$y}) {
				print "#";
			}
			else {
				print ".";
			}
		}
		say "";
	}

	foreach my $light (@lights) {
		$light->{x} += $light->{vx};
		$light->{y} += $light->{vy};
	}
	$t++;
	say "";
}

