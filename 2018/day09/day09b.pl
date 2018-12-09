#!/usr/bin/perl

use warnings;
use strict;

use feature 'say';

use List::Util qw(max min reduce sum);
use List::MoreUtils qw(firstidx firstval mesh pairwise singleton);
use Algorithm::Combinatorics qw(variations);
use Math::Prime::Util qw(is_prime);
use Data::Dumper;
$Data::Dumper::Sortkeys = 1;

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

my $line = <$fh>;
chomp $line;
$line =~ /(\d+).* (\d+)/;
my ($players, $last) = ($1, 100 * $2);
# my ($players, $last) = (9, 25);

my $node = { val => 0 };
$node->{next} = $node;
$node->{prev} = $node;
# say Dumper($node);

my @scores = (0) x $players;
my $current = $node;

my $player = 0;

foreach my $val (1 .. $last) {
	if ($val % 23 == 0) {
		$current = $current->{prev} for (1..7);
		$scores[$player] += $val + $current->{val};
		$current->{prev}{next} = $current->{next};
		$current->{next}{prev} = $current->{prev};
		$current = $current->{next};
	}
	else {
		$current = $current->{next};
		my $newNode = {
			val => $val,
			prev => $current,
			next => $current->{next},
		};
			
		$current->{next}{prev} = $newNode;
		$current->{next} = $newNode;
		$current = $newNode;
	}
	$player = ($player + 1) % $players;
	# say Dumper($node);
}

# say "@scores";
say max @scores;
