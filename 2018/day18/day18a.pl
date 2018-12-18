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

sub draw {
	my $map = shift;
	say join "\n", map { join '', @$_ } @$map;
	return;
}

sub trees {
	my ($x, $y, $grid) = @_;
	my $count = 0;
	foreach my $dx (-1 .. 1) {
		foreach my $dy (-1 .. 1) {
			next if $dx == 0 and $dy == 0;
			next if $x + $dx < 0 or $x + $dx > $#{ $grid->[$y] };
			next if $y + $dy < 0 or $y + $dy > $#$grid;
			$count++ if $grid->[$y+$dy][$x+$dx] eq '|';
		}
	}
	return $count;
}

sub yards {
	my ($x, $y, $grid) = @_;
	my $count = 0;
	foreach my $dx (-1 .. 1) {
		foreach my $dy (-1 .. 1) {
			next if $dx == 0 and $dy == 0;
			next if $x + $dx < 0 or $x + $dx > $#{ $grid->[$y] };
			next if $y + $dy < 0 or $y + $dy > $#$grid;
			$count++ if $grid->[$y+$dy][$x+$dx] eq '#';
		}
	}
	return $count;
}

sub oneyardonetree {
	my ($x, $y, $grid) = @_;
	my ($yard, $tree) = (0, 0);
	foreach my $dx (-1 .. 1) {
		foreach my $dy (-1 .. 1) {
			next if $dx == 0 and $dy == 0;
			next if $x + $dx < 0 or $x + $dx > $#{ $grid->[$y] };
			next if $y + $dy < 0 or $y + $dy > $#$grid;
			$yard++ if $grid->[$y+$dy][$x+$dx] eq '#';
			$tree++ if $grid->[$y+$dy][$x+$dx] eq '|';
		}
	}
	return ($yard >= 1 and $tree >=1);
}

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

my @grid;

while (my $line = <$fh>) {
	chomp $line;
	push @grid, [ split //, $line ];
}

draw(\@grid);

foreach my $m (1 .. 10) {
	my @newGrid = map { [@$_] } @grid;
	foreach my $y (0 .. $#grid) {
		foreach my $x (0 .. $#{ $grid[$y] }) {
			my $acre = $grid[$y][$x];
			if ($acre eq '.') {
				$newGrid[$y][$x] = trees($x, $y, \@grid) >= 3 ? '|' : '.';
			}
			elsif ($acre eq '|') {
				$newGrid[$y][$x] = yards($x, $y, \@grid) >= 3 ? '#' : '|';
			}
			else {
				$newGrid[$y][$x] = oneyardonetree($x, $y, \@grid) ? '#' : '.';
			}
		}
	}
	# @grid = @newGrid;
	@grid = map { [@$_] } @newGrid;
	say "t = $m";
	draw(\@grid);
	say "";
}

draw(\@grid);
my $trees = sum map { scalar grep { $_ eq '|' } @$_ } @grid;
my $yards = sum map { scalar grep { $_ eq '#' } @$_ } @grid;
say $trees * $yards;
