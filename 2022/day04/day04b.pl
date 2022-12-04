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
      if $min2 >= $min1 and $min2 <= $max1
      or $max2 >= $min1 and $max2 <= $max1
      or $min1 >= $min2 and $min1 <= $max2
      or $max1 >= $min2 and $max1 <= $max2;
}

say "$count";
