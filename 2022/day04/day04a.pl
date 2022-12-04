#!/usr/bin/perl

use warnings;
use strict;

use feature 'say';

my $fname = shift;

open my $fh, "<", $fname
  or die "Can't open $fname: $!";

my $count = 0;

while ( my $line = <$fh> ) {
    chomp $line;
    my ( $min1, $max1, $min2, $max2 ) = $line =~ /\d+/g;
    ++$count
      if $min1 <= $min2 and $max1 >= $max2
      or $min1 >= $min2 and $max1 <= $max2;
}

say $count;
