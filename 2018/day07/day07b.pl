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
$Data::Dumper::Indent = 2;

sub duration {
	my $letter = shift;
	return ord($letter) - ord("A") + 61;
	# return ord($letter) - ord("A") + 1;
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

# say Dumper(\%steps);
# say Dumper(\%degrees);

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
	say "Time: $seconds";
	say Dumper(\@workers);
	$Data::Dumper::Indent = 0;
	say Dumper(\%steps);
	$Data::Dumper::Indent = 2;
	say Dumper(\%degrees);
	last if (sum map { $_->[1] } @workers) == 0 and (keys %degrees) == 0;

	foreach my $i (0 .. $#workers) {
		if ($workers[$i][0] ne "") {
			$workers[$i][1]--;
		}
	}
	$seconds++;
}

say $seconds;
