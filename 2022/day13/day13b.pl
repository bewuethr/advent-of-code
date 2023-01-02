#!/usr/bin/perl

use warnings;
use strict;

use feature 'say';

use Test::Deep qw(eq_deeply);
use List::MoreUtils qw(firstidx);

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

my @list;

while ( my $line = <$fh> ) {
    push @list, eval $line;
}

push @list, [ [2] ], [ [6] ];

my @sorted = sort { comp( $a, $b ) } @list;

my $div1 = firstidx { eq_deeply( $_, [ [2] ] ) } @sorted;
my $div2 = firstidx { eq_deeply( $_, [ [6] ] ) } @sorted;

say( ( $div1 + 1 ) * ( $div2 + 1 ) );
