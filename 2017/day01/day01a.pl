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

my $sum = 0;
foreach my $idx (0..$#nums-1) {
    $sum += $nums[$idx] == $nums[$idx+1] ? $nums[$idx] : 0;
}
$sum += $nums[-1] == $nums[0] ? $nums[-1] : 0;

say $sum;
