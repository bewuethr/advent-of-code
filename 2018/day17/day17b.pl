#!/usr/bin/perl

use warnings;
use strict;

use feature 'say';

use List::Util qw(max min sum);

our $ymax;

sub draw {
	my $map = shift;
	say join "\n", map { join '', @$_ } @$map;
}

sub fall {
	my ($x, $y, $map) = @_;
	while ($y < $ymax and $map->[$y+1][$x] =~ /[.|]/) {
		$y++;
		$map->[$y][$x] = '|';
	}
	spread($x, $y, $map) unless $y == $ymax;
}


sub spread {
	my ($xinit, $yinit, $map) = @_;
	my $pool = 1;
	my ($x, $y) = ($xinit, $yinit);
	my ($xmin, $xmax);
	
	# Check left
	while ($map->[$y][$x-1] =~ /[.|]/ and $map->[$y+1][$x-1] =~ /[~#]/) {
		$x--;
		$map->[$y][$x] = '|';
	}
	if ($map->[$y+1][$x-1] =~ /[.|]/) {
		$pool = 0;
		$map->[$y][$x-1] = '|';
		fall($x-1, $y, $map);
	}
	else {
		$xmin = $x;
	}

	($x, $y) = ($xinit, $yinit);

	# Check right
	while ($map->[$y][$x+1] =~ /[.|]/ and $map->[$y+1][$x+1] =~ /[~#]/) {
		$x++;
		$map->[$y][$x] = '|';
	}
	if ($map->[$y+1][$x+1] =~ /[.|]/) {
		$pool = 0;
		$map->[$y][$x+1] = '|';
		fall($x+1, $y, $map);
	}
	else {
		$xmax = $x;
	}

	if ($pool) {
		splice(@{$map->[$yinit]}, $xmin, $xmax-$xmin+1, ('~') x ($xmax-$xmin+1));
	}
}

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

my %clay;

while (my $line = <$fh>) {
	chomp $line;
	my ($xrange) = $line =~ /x=([\d.]+)/;
	my ($yrange) = $line =~ /y=([\d.]+)/;
	my (@xrange, @yrange);
	if ($xrange =~ /\./) {
		$xrange =~ /(\d+)..(\d+)/;
		@xrange = ($1 .. $2)
	}
	else {
		@xrange = ($xrange);
	}
	if ($yrange =~ /\./) {
		$yrange =~ /(\d+)..(\d+)/;
		@yrange = ($1 .. $2)
	}
	else {
		@yrange = ($yrange);
	}

	foreach my $x (@xrange) {
		foreach my $y (@yrange) {
			$clay{$x}{$y} = 1;
		}
	};
}

my $xmin = min keys %clay;
my $xmax = max keys %clay;
my $ymin = min map { keys %$_ } values %clay;
$ymax = max map { keys %$_ } values %clay;

my @map;

foreach my $y (0 .. $ymax) {
	foreach my $x ($xmin-1 .. $xmax+3) {
		$map[$y][$x-$xmin+1] = exists $clay{$x}{$y} ? '#' : '.';
	}
}
my ($xs, $ys) = (500, 0);
$map[$ys][$xs-$xmin+1] = '+';

my ($wx, $wy) = ($xs-$xmin+1, $ys);

my $oldcount = 0;
while (1) {
	fall($wx, $wy, \@map);
	my $newcount = sum map { scalar grep { $_ eq '~' } @$_ } @map[$ymin .. $ymax];
	last if $newcount == $oldcount;
	$oldcount = $newcount;
}
say "Total standing water: $oldcount";
