#!/usr/bin/perl

use v5.10.1;
use warnings;
no warnings 'experimental';
use strict;

use feature 'say';

use List::Util qw(min);

my %dirs = (
	N => { dx => 0,  dy => -1 },
	E => { dx => 1,  dy => 0  },
	S => { dx => 0,  dy => 1  },
	W => { dx => -1, dy => 0  },
);

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

my $re = <$fh>;
chomp $re;
$re = substr($re, 1, length($re) - 2);

my @positions;
my %distances;
$distances{0, 0} = 0;
my @cur = (0, 0);
my @prev = (0, 0);

foreach my $c (split //, $re) {
	if ($c eq '(') {
		push @positions, [@cur];
	}
	elsif ($c eq ')') {
		@cur = @{pop @positions};
	}
	elsif ($c eq '|') {
		@cur = @{$positions[-1]};
	}
	else {
		$cur[0] += $dirs{$c}{dx};
		$cur[1] += $dirs{$c}{dy};
		if (defined $distances{$cur[0], $cur[1]}) {
			$distances{$cur[0], $cur[1]} 
				= min($distances{$cur[0], $cur[1]}, $distances{$prev[0], $prev[1]} + 1);
		}
		else {
			$distances{$cur[0], $cur[1]} = $distances{$prev[0], $prev[1]} + 1;
		}
	}
	@prev = @cur;
}

say scalar grep { $_ >= 1000 } values %distances;
