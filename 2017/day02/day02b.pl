#!/usr/bin/perl

use strict;
use warnings;

use feature 'say';

use Algorithm::Combinatorics qw(variations);
use List::Util qw(sum);

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

say sum map {
    chomp;
    my @arr = split "\t";
    sum map { $_->[0] / $_->[1] } grep { $_->[0] % $_->[1] == 0 } variations(\@arr, 2);
} <$fh>;
