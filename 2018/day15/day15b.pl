#!/usr/bin/perl

use warnings;
use strict;

use feature 'say';

use sort 'stable';

use List::Util qw(max min reduce sum);
use List::MoreUtils qw(firstidx firstval pairwise singleton);
use Algorithm::Combinatorics qw(variations);
use Math::Prime::Util qw(is_prime);
use Data::Dumper;
$Data::Dumper::Sortkeys = 1;

sub draw {
	my $map = shift;
	say join "\n", map { join '', @$_ } @$map;
	return;
}

sub drawDist {
	my ($map, $dists) = @_;
	my @drawMap = map { [@$_] } @$map;
	foreach my $coords (keys %$dists) {
		my ($x, $y) = $coords =~ /(\d+).(\d+)/;
		$drawMap[$y][$x] = $dists->{$x,$y} % 10;
	}
	draw(\@drawMap);
}

sub flood {
	my ( $from, $to, $map ) = @_;
	my %dists;
	my @queue;
	$dists{ $from->{x}, $from->{y} } = 0;
	push @queue, $from;
	while (@queue) {
		my $cell = shift @queue;
		foreach my $delta ( [0, -1], [-1, 0], [1, 0], [0, 1] ) {
			my ($x, $y) = ( $cell->{x} + $delta->[0], $cell->{y} + $delta->[1] );
			next if exists $dists{$x,$y};
			next if ($map->[$y][$x] ne '.') and not ($x == $to->{x} and $y == $to->{y});
			$dists{$x,$y} = $dists{ $cell->{x}, $cell->{y} } + 1;
			push @queue, { x => $x, y => $y };
		}
	}

	# Check if we've reached the moving unit
	if ( defined $dists{ $to->{x}, $to->{y} } ) {
		foreach my $delta ( [0, -1], [-1, 0], [1, 0], [0, 1] ) {
			my ($x, $y) = ( $to->{x} + $delta->[0], $to->{y} + $delta->[1] );
			if ( exists $dists{$x, $y} and $dists{$x, $y} == $dists{ $to->{x}, $to->{y} } - 1 ) {
				return {
					dx    => $delta->[0],
					dy    => $delta->[1],
					dist  => $dists{ $to->{x}, $to->{y} },
					xDest => $from->{x},
					yDest => $from->{y},
				};
			}
		}
	}
	return;
}

sub move {
	my ( $unit, $units, $map ) = @_;
	# Return if in striking distance
	foreach my $delta ( [0, -1], [-1, 0], [1, 0], [0, 1] ) {
		return if
			$map->[ $unit->{y} + $delta->[1] ][ $unit->{x} + $delta->[0] ]
			eq ( $unit->{type} eq 'G' ? 'E' : 'G' );
	}
	my @targets = grep { $_->{type} ne $unit->{type} and $_->{hp} > 0 } @$units;
	my %ranges;
	foreach my $target (@targets) {
		foreach my $delta ( [0, -1], [-1, 0], [1, 0], [0, 1] ) {
			my ($x, $y) = ( $target->{x} + $delta->[0], $target->{y} + $delta->[1] );
			$ranges{$x}{$y} = 1 if $map->[$y][$x] eq '.';
		}
	}

	my @steps;
	foreach my $x (keys %ranges) {
		foreach my $y (keys %{ $ranges{$x} }) {
			my $step = flood(
				{ x => $x, y => $y },
				{ x => $unit->{x}, y => $unit->{y} },
				$map
			);
			push @steps, $step if defined $step;
		}
	}
	return unless @steps;

	@steps = sort {
		$a->{dist}  <=> $b->{dist} or
		$a->{yDest} <=> $b->{yDest} or
		$a->{xDest} <=> $b->{xDest} or
		$a->{dy}    <=> $b->{dy} or
		$a->{dx}    <=> $b->{dx}
	} @steps;

	$map->[$unit->{y}][$unit->{x}] = '.';
	$unit->{x} += $steps[0]{dx};
	$unit->{y} += $steps[0]{dy};
	$map->[$unit->{y}][$unit->{x}] = $unit->{type};
	return;
}
 sub distance {
	 my ($u1, $u2) = @_;
	 return abs($u1->{x} - $u2->{x}) + abs($u1->{y} - $u2->{y});
 }

sub fight {
	my ( $unit, $units, $map ) = @_;
	my @enemies;
	my $enemyType = $unit->{type} eq 'G' ? 'E' : 'G';
	my ($x, $y) = $unit->{qw(x y)};
	my @targets =
		sort { $a->{hp} <=> $b->{hp}
			or $a->{y} <=> $b->{y}
			or $a->{x} <=> $b->{x} }
		grep { $_->{type} eq $enemyType
			and $_->{hp} > 0
			and distance($unit, $_) == 1 } @$units;

	return unless @targets;
	
	my $target = $targets[0];
	$target->{hp} -= $unit->{ap};
	$map->[$target->{y}][$target->{x}] = '.' if $target->{hp} <= 0;
	return;
}

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

chomp(my @lines = <$fh>);

my $elfAP = 3;
my $round;
my @units;
my @map;

OUTER: while (1) {
	@map = ();
	@units = ();
	$elfAP++;

	foreach my $y (0 .. $#lines) {
		my @line = split //, $lines[$y];
		foreach my $x (0 .. $#line) {
			if ($line[$x] =~ /[EG]/) {
				push @units, {
					x    => $x,
					y    => $y,
					type => $line[$x],
					hp   => 200,
					ap   => $line[$x] eq 'E' ? $elfAP : 3,
				};
			}
		}
		push @map, \@line;
	}

	$round = 0;

	while (1) {
		@units = sort { $a->{y} <=> $b->{y} or $a->{x} <=> $b->{x} } grep { $_->{hp} > 0 } @units;
		foreach my $unit (@units) {
			# <>;
			next unless $unit->{hp} > 0;
			last OUTER unless scalar grep { $_->{type} ne $unit->{type} and $_->{hp} > 0 } @units;
			move($unit, \@units, \@map);
			fight($unit, \@units, \@map);
			next OUTER if scalar grep { $_->{type} eq 'E' and $_->{hp} <= 0 } @units;
		}
		$round++;
		@units = sort { $a->{y} <=> $b->{y} or $a->{x} <=> $b->{x} } grep { $_->{hp} > 0 } @units;
	}
}

say "$elfAP attack points, $round rounds";
say Dumper(\@units);
draw(\@map);
say $round * sum map { $_->{hp} } grep { $_->{hp} > 0 } @units;
