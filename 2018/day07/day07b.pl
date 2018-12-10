#!/usr/bin/perl

use warnings;
use strict;

use feature 'say';

use List::Util qw(sum);

sub duration {
	my $letter = shift;
	return ord($letter) - ord("A") + 61;
}

sub getnext {
	my ($degrees, $steps) = @_;
	my @roots = sort grep { $degrees->{$_} == 0 } keys %$degrees;
	return "" if @roots == 0;
	delete $degrees->{$roots[0]};
	return $roots[0];
}

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

my (%steps, %degrees);

while (my $line = <$fh>) {
	chomp $line;
	$line =~ /Step (.).*step (.)/;
	my ($from, $to) = ($1, $2);
	push @{$steps{$from}}, $to;
	$degrees{$from} //= 0;
	$degrees{$to}++;
}

my $seconds = 0;

my @workers = (
	["", 0],
	["", 0],
	["", 0],
	["", 0],
	["", 0],
);

while (1) {
	foreach my $i (0 .. $#workers) {
		if ($workers[$i][1] == 0) {
			if ($workers[$i][0] ne "") {
				foreach my $node (@{ $steps{$workers[$i][0]} }) {
					$degrees{$node}--;
				}
				$workers[$i][0] = "";
			}
		}
	}
	foreach my $i (0 .. $#workers) {
		if ($workers[$i][0] eq "" and $workers[$i][1] == 0) {
			my $next = getnext(\%degrees, \%steps);
			if ($next ne "") {
				$workers[$i] = [$next, duration($next)];
			}
		}
	}
	last if (sum map { $_->[1] } @workers) == 0 and (keys %degrees) == 0;

	foreach my $i (0 .. $#workers) {
		if ($workers[$i][0] ne "") {
			$workers[$i][1]--;
		}
	}
	$seconds++;
}

say $seconds;
