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
my @metadata;

while (@digits) {
    my @layer;
    my %lData = ( layer => scalar @layers );
    foreach my $y ( 0 .. $h - 1 ) {
        foreach my $x ( 0 .. $w - 1 ) {
            my $digit = shift @digits;
            $layer[$y][$x] = $digit;
            $lData{zeroes}++ if $digit == 0;
            $lData{ones}++   if $digit == 1;
            $lData{twos}++   if $digit == 2;
        }
    }
    push @layers,   \@layer;
    push @metadata, \%lData;
}
my $fewestZeroes =
  ( sort { ( $a->{zeroes} // 0 ) <=> ( $b->{zeroes} // 0 ) } @metadata )[0];

say $fewestZeroes->{ones} * $fewestZeroes->{twos};
