#!/usr/bin/perl

use warnings;
use strict;

use feature 'say';

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

my $sum;
while (my $num = <$fh>) {
	chomp $num;
	$sum += int($num / 3) - 2;
}

say $sum;
