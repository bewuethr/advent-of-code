#!/usr/bin/perl

use warnings;
use strict;

use feature 'say';

use List::Util qw(sum);

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

my $line = <$fh>;
chomp $line;
my ($depth) = ($line =~ /(\d+)/);
$line = <$fh>;
chomp $line;
my ($tx, $ty) = ($line =~ /(\d+)/g);

my @map;

foreach my $y (0 .. $ty) {
	foreach my $x (0 .. $tx) {
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
			$index = $map[$y][$x-1]{elevel} * $map[$y-1][$x]{elevel};
		}

		my $elevel = ($index + $depth) % 20183;
		$map[$y][$x]{elevel} = $elevel;
		
		my $type = $elevel % 3;
		$map[$y][$x]{risk} = $type;
		if ($type == 0) {
			$map[$y][$x]{type} = "rocky";
		}
		elsif ($type == 1) {
			$map[$y][$x]{type} = "wet";
		}
		else {
			$map[$y][$x]{type} = "narrow";
		}
	}
}

say sum map { sum map { $_->{risk} } @$_ } @map;
