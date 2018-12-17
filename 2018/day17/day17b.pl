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

our $debug = 0;
our ($xmin, $xmax, $ymin, $ymax);

sub draw {
	my $map = shift;
	say join "\n", map { join '', @$_ } @$map;
}

sub fall {
	my ($x, $y, $map) = @_;
	say "start fall at $x/$y" if $debug;
	while ($y < $ymax and $map->[$y+1][$x] =~ /[.|]/) {
		$y++;
		$map->[$y][$x] = '|';
	}
	draw($map) if $debug;
	<> if $debug;
	spread($x, $y, $map) unless $y == $ymax;
}


sub spread {
	my ($xinit, $yinit, $map) = @_;
	say "start spread at $xinit/$yinit" if $debug;
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
		draw($map) if $debug;
		<> if $debug;
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
		draw($map) if $debug;
		<> if $debug;
		fall($x+1, $y, $map);
	}
	else {
		$xmax = $x;
	}

	if ($pool) {
		splice(@{$map->[$yinit]}, $xmin, $xmax-$xmin+1, ('~') x ($xmax-$xmin+1));
	}
	draw($map) if $debug;
	<> if $debug;
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

$xmin = min keys %clay;
$xmax = max keys %clay;
$ymin = min map { keys %$_ } values %clay;
$ymax = max map { keys %$_ } values %clay;

say "$xmin/$ymin to $xmax/$ymax";

my @map;

foreach my $y (0 .. $ymax) {
	foreach my $x ($xmin-3 .. $xmax+3) {
		$map[$y][$x-$xmin+3] = exists $clay{$x}{$y} ? '#' : '.';
	}
}
my ($xs, $ys) = (500, 0);
$map[$ys][$xs-$xmin+3] = '+';

my ($wx, $wy) = ($xs-$xmin+3, $ys);

while (1) {
	fall($wx, $wy, \@map);
	say Dumper(\@map[0..-1]);
	say "Total water: ", sum map { scalar grep { $_ =~ /[~]/ } @$_ } @map[$ymin .. $ymax];
	# my $newcount = sum map { scalar grep { $_ =~ /[~|]/ } @$_ } @map;
	# say "Total water: $newcount";
	# draw(\@map) if $newcount == $oldcount;
	# last if $newcount == $oldcount;
	# $oldcount = $newcount;
}
