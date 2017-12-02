#!/usr/bin/perl

use strict;
use warnings;

use feature 'say';

use Algorithm::Combinatorics qw(variations);

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

my $sum = 0;
while (my $line = <$fh>) {
    chomp $line;
    my @arr = split "\t", $line;
    $sum += (
        map { $_->[0] / $_->[1] }
        grep { $_->[0] % $_->[1] == 0 } variations(\@arr, 2)
    )[0];
}
say $sum;
