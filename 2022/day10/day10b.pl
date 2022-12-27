#!/usr/bin/perl

use warnings;
use strict;

my $x      = 1;
my $cycle  = 0;
my $sum    = 0;
my $crtPos = 0;

sub tick {
    ++$cycle;
    if ( abs( $x - $crtPos ) <= 1 ) {
        print "#";
    }
    else {
        print ".";
    }

    $crtPos = ( $crtPos + 1 ) % 40;
    print "\n" if $crtPos == 0;
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
