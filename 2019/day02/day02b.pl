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
my @prog = split /,/, $line;

my $want = 19690720;

foreach my $noun (0..99) {
	foreach my $verb (0..99) {
		my @p = @prog;
		$p[1] = $noun;
		$p[2] = $verb;

		my $i = 0;
		while (1) {
			last if $p[$i] == 99;
			if ($p[$i] == 1) {
				$p[$p[$i+3]] = $p[$p[$i+1]] + $p[$p[$i+2]];
			}
			elsif ($p[$i] == 2) {
				$p[$p[$i+3]] = $p[$p[$i+1]] * $p[$p[$i+2]];
			}
			else {
				die "illegal opcode at index $i: $p[$i]"
			}
			$i += 4;
		}

		if ($p[0] == $want) {
			say 100 * $noun + $verb;
			exit
		}
	}
}
