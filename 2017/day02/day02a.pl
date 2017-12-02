#!/usr/bin/perl

use strict;
use warnings;

use feature 'say';

use List::Util qw(max min);

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

my $sum = 0;
while (my $line = <$fh>) {
    chomp $line;
    my @arr = split "\t", $line;
    $sum += (max @arr) - (min @arr);
}
say $sum;
