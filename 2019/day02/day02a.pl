#!/usr/bin/perl

use warnings;
use strict;

use feature 'say';

my $fname = shift;

open my $fh, "<", $fname
  or die "Can't open $fname: $!";

my $line = <$fh>;
chomp $line;
my @p = split /,/, $line;
@p[ 1, 2 ] = ( 12, 2 );

my $i = 0;
while (1) {
    last if $p[$i] == 99;
    if ( $p[$i] == 1 ) {
        $p[ $p[ $i + 3 ] ] = $p[ $p[ $i + 1 ] ] + $p[ $p[ $i + 2 ] ];
    }
    elsif ( $p[$i] == 2 ) {
        $p[ $p[ $i + 3 ] ] = $p[ $p[ $i + 1 ] ] * $p[ $p[ $i + 2 ] ];
    }
    else {
        die "illegal opcode at index $i: $p[$i]";
    }
    $i += 4;
}

say $p[0];
