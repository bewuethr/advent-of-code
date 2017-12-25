#!/usr/bin/perl

use strict;
use warnings;

use feature 'say';

use Math::Prime::Util qw(is_prime);

my $fname = shift;
my $debug = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

chomp(my @arr = <$fh>);

@arr = map { [ split / /, $_ ] } @arr;

my $b    = $arr[0]->[2] * $arr[4]->[2] - $arr[5]->[2];
my $c    = $b - $arr[7]->[2];
my $step = -$arr[30]->[2];

my $ctr = 0;

for (my $num = $b; $num <= $c; $num += $step) {
    $ctr++ unless is_prime($num);
}

say $ctr;
