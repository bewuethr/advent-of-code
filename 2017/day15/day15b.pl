#!/usr/bin/perl

use strict;
use warnings;

use feature 'say';

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

chomp(my @arr = <$fh>);

"@arr" =~ /(\d+).*?(\d+)/;
my ($valA, $valB) = ($1, $2);

my ($facA, $facB) = (16807, 48271);
my $divi = 2147483647;

my $count = 0;

foreach my $i ( 1 .. 5_000_000 ) {
    do { $valA = $valA * $facA % $divi } while $valA % 4;
    do { $valB = $valB * $facB % $divi } while $valB % 8;
    $count++ if ($valA & 0xffff) == ($valB & 0xffff);
}

say $count;
