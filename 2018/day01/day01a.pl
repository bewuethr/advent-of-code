#!/usr/bin/perl

use warnings;
use strict;

use feature 'say';

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

my $sum;
while (my $line = <$fh>) {
	$sum += $line;
}
say $sum;
