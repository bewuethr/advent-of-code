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

my (%minToValue, %valueToMin);

my $m = 0;
OUTER: while (1) {
	my @newGrid = map { [@$_] } @grid;
	my $value = (sum map { scalar grep { $_ eq '|' } @$_ } @grid)
		* (sum map { scalar grep { $_ eq '#' } @$_ } @grid);
	$minToValue{$m} = $value;
	push @{ $valueToMin{$value} }, $m;
	
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
	$m++;

	if ($m % 1000 == 0) {
		my @repeated = grep { @$_ > 5 } values %valueToMin;
		next unless @repeated;
		my $period = $repeated[0][1] - $repeated[0][0];
		say $period;
		for (my $minute = 1000000000 % $period; $minute < $m; $minute += $period) {
			if ($minute > $repeated[0][0] and defined $minToValue{$minute}) {
				say $minToValue{$minute};
				last OUTER;
			}
		}
	}
}
