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

my $min_conts = 20;
my @solutions;

foreach my $combo (1..2**20) {
    my @idx = split //, sprintf "%020b", $combo;
    my $n_conts = sum @idx;
    if ((sum @buckets[grep { $idx[$_] } (0..$#idx)]) == TOTAL) {
        push @solutions, \@idx;
        $min_conts = $n_conts if $n_conts < $min_conts;
    }
}

my $min_solutions = scalar grep { sum(@{$_}) == $min_conts } @solutions;

say "Number of solutions with minimum amount of containers: $min_solutions";
