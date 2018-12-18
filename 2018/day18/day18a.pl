#!/usr/bin/perl

use warnings;
use strict;

use feature 'say';

use List::Util qw(sum);

sub draw {
	my $map = shift;
	say join "\n", map { join '', @$_ } @$map;
	return;
}

sub neighbours {
	my ($x, $y, $grid, $type, $min) = @_;
	my $count = 0;
	foreach my $dx (-1 .. 1) {
		foreach my $dy (-1 .. 1) {
			next if $dx == 0 and $dy == 0;
			next if $x + $dx < 0
				or $x + $dx > $#{ $grid->[$y] }
				or $y + $dy < 0
				or $y + $dy > $#$grid;
			$count++ if $grid->[$y+$dy][$x+$dx] eq $type;
		}
	}
	return $count >= $min;
}

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

my @grid;

while (my $line = <$fh>) {
	chomp $line;
	push @grid, [ split //, $line ];
}

foreach my $m (1 .. 10) {
	my @newGrid = map { [@$_] } @grid;
	foreach my $y (0 .. $#grid) {
		foreach my $x (0 .. $#{ $grid[$y] }) {
			my $acre = $grid[$y][$x];
			if ($acre eq '.') {
				$newGrid[$y][$x] = neighbours($x, $y, \@grid, '|', 3) ? '|' : '.';
			}
			elsif ($acre eq '|') {
				$newGrid[$y][$x] = neighbours($x, $y, \@grid, '#', 3) ? '#' : '|';
			}
			else {
				$newGrid[$y][$x] = (neighbours($x, $y, \@grid, '|', 1)
					and neighbours($x, $y, \@grid, '#', 1))
					? '#'
					: '.';
			}
		}
	}
	@grid = @newGrid;
}

draw(\@grid);
my $trees = sum map { scalar grep { $_ eq '|' } @$_ } @grid;
my $yards = sum map { scalar grep { $_ eq '#' } @$_ } @grid;
say $trees * $yards;
