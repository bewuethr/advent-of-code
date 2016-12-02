#!/usr/bin/perl

use strict;
use warnings;
use 5.022;
use File::Slurp;
use List::Util qw(sum);

use constant TOTAL => 150;

my @buckets = read_file('input');
chomp @buckets;
@buckets = sort { $b <=> $a } @buckets;

my $solutions = 0;

foreach my $combo (1..2**20) {
    my @idx = split //, sprintf "%020b", $combo;
    if ((sum @buckets[grep { $idx[$_] } (0..$#idx)]) == TOTAL) {
        ++$solutions;
    }
}

say "Total solutions: $solutions";
