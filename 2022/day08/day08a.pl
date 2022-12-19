#!/usr/bin/perl

use warnings;
use strict;

use feature 'say';

my $fname = shift;

open my $fh, "<", $fname
  or die "Can't open $fname: $!";

my @trees;

while ( my $line = <$fh> ) {
    chomp $line;

    push @trees, [ split //, $line ];
}

my $visible = 0;
my $yMax    = $#trees;
my $xMax    = $#{ $trees[0] };

foreach my $y ( 0 .. $yMax ) {
    foreach my $x ( 0 .. $xMax ) {
        if ( $y == 0 or $y == $yMax or $x == 0 or $x == $xMax ) {
            ++$visible;
            next;
        }

        my $height = $trees[$y][$x];

        # Check visibility from top
        my $isVisible = 1;
        foreach my $yy ( 0 .. $y - 1 ) {
            if ( $trees[$yy][$x] >= $height ) {
                $isVisible = 0;
                last;
            }
        }

        if ($isVisible) {
            ++$visible;
            next;
        }

        # Check visibility from bottom
        $isVisible = 1;
        foreach my $yy ( $y + 1 .. $yMax ) {
            if ( $trees[$yy][$x] >= $height ) {
                $isVisible = 0;
                last;
            }
        }

        if ($isVisible) {
            ++$visible;
            next;
        }

        # Check visibility from left
        $isVisible = 1;
        foreach my $xx ( 0 .. $x - 1 ) {
            if ( $trees[$y][$xx] >= $height ) {
                $isVisible = 0;
                last;
            }
        }

        if ($isVisible) {
            ++$visible;
            next;
        }

        # Check visibility from right
        $isVisible = 1;
        foreach my $xx ( $x + 1 .. $xMax ) {
            if ( $trees[$y][$xx] >= $height ) {
                $isVisible = 0;
                last;
            }
        }

        if ($isVisible) {
            ++$visible;
        }
    }
}

say $visible;
