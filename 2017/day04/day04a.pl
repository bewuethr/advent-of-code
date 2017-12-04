#!/usr/bin/perl

use strict;
use warnings;

use feature 'say';

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

my $ctr = 0;

while (my $line = <$fh>) {
    chomp $line;
    $ctr++ if not $line =~ /(\b\w+\b).*\1/;
}

say $ctr;
