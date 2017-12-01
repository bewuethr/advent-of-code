#!/usr/bin/perl

use strict;
use warnings;

use feature 'say';

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

my $line = <$fh>;
chomp $line;

my @nums = split //, $line;
my $len = scalar @nums;
my $half = $len / 2;

my $sum = 0;
foreach my $idx (0..$#nums) {
    $sum += $nums[$idx] == $nums[ ($idx+$half) % $len ] ? $nums[$idx] : 0;
}

say $sum;
