#!/usr/bin/perl

use warnings;
use strict;

use feature 'say';

use List::Util 'max';

my $fname = shift;

open my $fh, "<", $fname
  or die "Can't open $fname: $!";

my @trees;

while ( my $line = <$fh> ) {
    chomp $line;

    push @trees, [ split //, $line ];
}

my $visible  = 0;
my $yMax     = $#trees;
my $xMax     = $#{ $trees[0] };
my $maxScore = 0;

foreach my $y ( 1 .. $yMax - 1 ) {
    foreach my $x ( 1 .. $xMax - 1 ) {
        my $height = $trees[$y][$x];

        # Check upwards score
        my $count = 0;
        foreach my $yy ( reverse 0 .. $y - 1 ) {
            ++$count;
            last if $trees[$yy][$x] >= $height;
        }

        my $score = $count;

        # Check downwards score
        $count = 0;
        foreach my $yy ( $y + 1 .. $yMax ) {
            ++$count;
            last if $trees[$yy][$x] >= $height;
        }

        $score *= $count;

        # Check left score
        $count = 0;
        foreach my $xx ( reverse 0 .. $x - 1 ) {
            ++$count;
            last if $trees[$y][$xx] >= $height;
        }

        $score *= $count;

        # Check right score
        $count = 0;
        foreach my $xx ( $x + 1 .. $xMax ) {
            ++$count;
            last if $trees[$y][$xx] >= $height;
        }

        $score *= $count;

        $maxScore = max( $score, $maxScore );
    }
}

say $maxScore;
