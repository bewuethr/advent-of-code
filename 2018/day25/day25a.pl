#!/usr/bin/perl

use warnings;
no warnings 'recursion';
use strict;

use feature 'say';

use List::Util qw(sum);
use List::MoreUtils qw(pairwise);

sub dist {
	my ($p1, $p2) = @_;
	return sum pairwise { abs($a - $b) } @$p1, @$p2;
}

sub traverse {
	my ($i, $constellations, $visited) = @_;
	return if $visited->{$i};
	$visited->{$i} = 1;
	foreach my $idx (@{ $constellations->{$i} }) {
		traverse($idx, $constellations, $visited);
	}
}

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

my @points;

while (my $line = <$fh>) {
	chomp $line;
	my @point = ($line =~ /(-?\d+)/g);
	push @points, \@point;
}

my %constellations;

foreach my $i (0 .. $#points) {
	foreach my $j (0 .. $#points) {
		next if $i == $j;
		if (dist($points[$i], $points[$j]) <= 3) {
			push @{ $constellations{$i} }, $j;
		}
	}
}

my %visited;
my $count = 0;

foreach my $i (0 .. $#points) {
	next if $visited{$i};
	traverse($i, \%constellations, \%visited);
	$count++;
}

say $count;
