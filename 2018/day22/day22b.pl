#!/usr/bin/perl

use warnings;
use strict;

use feature 'say';

use List::Util qw(first max min reduce sum);
use List::MoreUtils qw(firstidx firstval pairwise singleton);
use Algorithm::Combinatorics qw(variations);
use Math::Prime::Util qw(factor is_prime);
use Data::Dumper;
$Data::Dumper::Sortkeys = 1;


my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

my $line = <$fh>;
chomp $line;
my ($depth) = ($line =~ /(\d+)/);
$line = <$fh>;
chomp $line;
my ($tx, $ty) = ($line =~ /(\d+)/g);

sub populate {
	my ($x, $y, $map) = @_;
	my $index;
	if ($x == 0 and $y == 0) {
		$index = 0;
	}
	elsif ($x == $tx and $y == $ty) {
		$index = 0;
	}
	elsif ($y == 0) {
		$index = $x * 16807;
	}
	elsif ($x == 0) {
		$index = $y * 48271;
	}
	else {
		$index = $map->[$y][$x-1]{elevel} * $map->[$y-1][$x]{elevel};
	}

	my $elevel = ($index + $depth) % 20183;
	$map->[$y][$x]{elevel} = $elevel;
	
	my $type = $elevel % 3;
	if ($type == 0) {
		$map->[$y][$x]{type} = "rocky";
	}
	elsif ($type == 1) {
		$map->[$y][$x]{type} = "wet";
	}
	else {
		$map->[$y][$x]{type} = "narrow";
	}
}

sub addrow {
	# say "Adding a row...";
	my ($map, $ymax) = @_;
	my $y = @$map;
	foreach my $x (0 .. $#{$map->[0]}) {
		populate($x, $y, $map);
	}
	$$ymax++;
}

sub addcolumn {
	# say "Adding a column...";
	my ($map, $xmax) = @_;
	foreach my $y (0 .. $#$map) {
		my $x = @{$map->[$y]};
		populate($x, $y, $map);
	}
	$$xmax++;
}

sub equipmentWorks {
	my ($map, $x, $y, $equipped) = @_;
	return 0 if $map->[$y][$x]{type} eq "rocky"  and $equipped eq "neither";
	return 0 if $map->[$y][$x]{type} eq "wet"    and $equipped eq "torch";
	return 0 if $map->[$y][$x]{type} eq "narrow" and $equipped eq "climbing";
	return 1;
}

sub serialize {
	my $state = shift;
	return join ",", @$state{qw(time equipped x y)};
}

sub deserialize {
	my $s = shift;
	my ($time, $equipped, $x, $y) = split ',', $s;
	return {
		time     => $time,
		equipped => $equipped,
		x        => $x,
		y        => $y,
	};
}

my @map;

foreach my $y (0 .. $ty) {
	foreach my $x (0 .. $tx) {
		populate($x, $y, \@map);
	}
}

# Keep track of map dimensions
my $xmax = $#{$map[0]};
my $ymax = $#map;

my %visited;
my $state = {
	equipped => "torch",
	x        => 0,
	y        => 0,
	time     => 0,
};

my @queue;
# push @queue, serialize($state);
push @queue, $state;
my $fastest;
my $counter = 0;

while (1) {
	$counter++;
	# my $state = deserialize(shift @queue);
	my $state = shift @queue;
	if ($counter % 100000 == 0) {
		# say "$counter: ", scalar @queue;
		@queue = sort {
			# (split /,/, $a)[0] <=> (split /,/, $b)[0];
			$a->{time} <=> $b->{time}
		} @queue;
		# say Dumper($state);
	}
	# say Dumper($state);
	$visited{$state->{x},$state->{y}}{$state->{equipped}} = $state->{time};
	# say  Dumper(\%visited);

	# Are we done?
	if ($state->{x} == $tx and $state->{y} == $ty and $state->{equipped} eq "torch") {
		if (not defined $fastest or $state->{time} < $fastest) {
			say "Saved in $state->{time}";
			$fastest = $state->{time};
		}
		next;
	}

	# Check next steps to push on queue
	# Do we have to extend the map?
	addcolumn(\@map, \$xmax) if $state->{x} == $xmax;
	addrow(\@map, \$ymax)    if $state->{y} == $ymax;

	# Check for moves
	foreach my $dx (-1 .. 1) {
		foreach my $dy (-1 .. 1)  {
			next if abs($dx) + abs($dy) != 1;
			my ($newx, $newy) = ($state->{x} + $dx, $state->{y} + $dy);
			next if $newx < 0 or $newy < 0;
			my $prevTime = $visited{$newx,$newy}{$state->{equipped}};
			next if defined $prevTime and $prevTime <= $state->{time} + 1;
			next unless equipmentWorks(\@map, $newx, $newy, $state->{equipped});
			$visited{$newx,$newy}{$state->{equipped}} = $state->{time} + 1;
			push @queue, {
				x        => $newx,
				y        => $newy,
				equipped => $state->{equipped},
				time     => $state->{time} + 1,
			};
		}
	}

	# Check for equipment change
	foreach my $equipment ( qw(torch climbing neither) ) {
		next if $state->{equipped} eq $equipment;
		my $prevTime = $visited{$state->{x},$state->{y}}{$equipment};
		next if defined $prevTime and $prevTime <= $state->{time} + 7;
		next unless equipmentWorks(\@map, $state->{x}, $state->{y}, $equipment);
		my $newstate = { %$state };
		$newstate->{equipped} = $equipment;
		$newstate->{time} += 7;
		$visited{$state->{x},$state->{y}}{$equipment} = $newstate->{time};
		push @queue, $newstate;
	}
}
