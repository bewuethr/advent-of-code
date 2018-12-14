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

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

chomp(my $num = <$fh>);

my $r = '37';
my ($i, $j) = (0, 1);
my $idx;

while (1) {
	my $sum = substr($r, $i, 1) + substr($r, $j, 1);
	$r .= "$sum";
	$i = ($i + substr($r, $i, 1) + 1) % length($r);
	$j = ($j + substr($r, $j, 1) + 1) % length($r);
	next if length($r) < length($num) + 2;
	$idx = index( $r, $num, length($r) - length($num) - 2 );
	last if $idx != -1;
}

say $idx;
