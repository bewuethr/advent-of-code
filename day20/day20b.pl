#!/usr/bin/perl

use strict;
use warnings;
use 5.022;
use List::Util qw(first);

open my $fh, '<', 'input';
chomp(my $input = <$fh>);

my @houses;

foreach my $i (1 .. $input/11) {
    my $j = $i;
    foreach (1..50) {
        $houses[$j] += $i;
        $j += $i * 11;
    }
}

my $first = first { $_ > $input } @houses;
say "The first house with more than $input presents is $first";
