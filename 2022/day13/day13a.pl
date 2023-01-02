#!/usr/bin/perl

use warnings;
use strict;

use feature 'say';

sub comp {
    my ( $left, $right ) = @_;

    my $leftRef  = ref $left;
    my $rightRef = ref $right;

    if ( $leftRef eq "" and $rightRef eq "" ) {
        return 0  if $left == $right;
        return -1 if $left < $right;
        return 1  if $left > $right;
    }

    if ( $leftRef eq "ARRAY" and $rightRef eq "ARRAY" ) {
        return -1 if not exists $left->[0] and exists $right->[0];
        foreach my $idx ( 0 .. $#$left ) {
            return 1 if not exists $right->[$idx];

            my $compRes = comp( $left->[$idx], $right->[$idx] );
            return -1 if $compRes == -1;
            return 1  if $compRes == 1;
            return -1
              if not exists $left->[ $idx + 1 ] and exists $right->[ $idx + 1 ];
        }

        return 0;
    }

    if ( $leftRef eq "" and $rightRef eq "ARRAY" ) {
        return comp( [$left], $right );
    }
    elsif ( $leftRef eq "ARRAY" and $rightRef eq "" ) {
        return comp( $left, [$right] );
    }
    else {
        die "invalid parameter combination '$leftRef'/'$rightRef'";
    }
}

my $fname = shift;

open my $fh, "<", $fname
  or die "Can't open $fname: $!";

my $count = 0;
my $idx   = 1;

while ( my ( $left, $right ) = ( eval <$fh>, eval <$fh> ) ) {
    if ( comp( $left, $right ) == -1 ) {
        $count += $idx;
    }
    ++$idx;
    <$fh> or last;
}

say $count;
