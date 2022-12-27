#!/usr/bin/perl

use warnings;
use strict;

use feature 'say';

my $x     = 1;
my $cycle = 0;
my $sum   = 0;

sub tick {
    ++$cycle;
    if ( ( $cycle - 20 ) % 40 == 0 ) {
        $sum += $cycle * $x;
    }
}

my $fname = shift;

open my $fh, "<", $fname
  or die "Can't open $fname: $!";

while ( my $line = <$fh> ) {
    chomp $line;
    my ( $op, $n ) = split / /, $line;

    if ( $op eq "noop" ) {
        tick();
    }
    elsif ( $op eq "addx" ) {
        tick();
        tick();
        $x += $n;
    }
    else {
        die "invalid operation $op";
    }
}

say $sum;
