#!/usr/bin/perl

use warnings;
use strict;

use feature 'say';

my $fname = shift;

open my $fh, "<", $fname
  or die "Can't open $fname: $!";

my $input = <$fh>;
chomp $input;
my @digits = split //, $input;

my ( $w, $h ) = ( 25, 6 );

my @layers;

while (@digits) {
    my @layer;
    foreach my $y ( 0 .. $h - 1 ) {
        foreach my $x ( 0 .. $w - 1 ) {
            my $digit = shift @digits;
            $layer[$y][$x] = $digit;
        }
    }
    push @layers, \@layer;
}

my @image;

foreach my $y ( 0 .. $h - 1 ) {
    foreach my $x ( 0 .. $w - 1 ) {
        foreach my $layer (@layers) {
            next if $layer->[$y][$x] == 2;
            $image[$y][$x] = $layer->[$y][$x];
            last;
        }
    }
}

foreach my $row (@image) {
    say map { $_ == 0 ? '.' : '#' } @$row;
}
