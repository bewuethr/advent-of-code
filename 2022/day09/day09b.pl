#!/usr/bin/perl

use warnings;
use strict;

use feature 'say';

sub add {
    my ( $visited, $tail ) = @_;
    $visited->{"$tail->{x}/$tail->{y}"} = 1;
}

sub move {
    my ( $head, $dir ) = @_;

    if ( $dir eq "R" ) {
        ++$head->{x};
    }
    elsif ( $dir eq "L" ) {
        --$head->{x};
    }
    elsif ( $dir eq "U" ) {
        --$head->{y};
    }
    elsif ( $dir eq "D" ) {
        ++$head->{y};
    }
    else {
        die("invalid direction $dir");
    }
}

sub follow {
    my ( $head, $tail ) = @_;

    if ( $head->{y} eq $tail->{y} ) {
        if ( $head->{x} == $tail->{x} + 2 ) {
            ++$tail->{x};
        }
        elsif ( $head->{x} == $tail->{x} - 2 ) {
            --$tail->{x};
        }
    }
    elsif ( $head->{x} eq $tail->{x} ) {
        if ( $head->{y} == $tail->{y} + 2 ) {
            ++$tail->{y};
        }
        elsif ( $head->{y} == $tail->{y} - 2 ) {
            --$tail->{y};
        }
    }
    elsif (
        abs( $head->{x} - $tail->{x} ) + abs( $head->{y} - $tail->{y} ) > 2 )
    {
        $tail->{x} += $head->{x} > $tail->{x} ? 1 : -1;
        $tail->{y} += $head->{y} > $tail->{y} ? 1 : -1;
    }
}

my $fname = shift;

open my $fh, "<", $fname
  or die "Can't open $fname: $!";

my $rope;
push @$rope, { x => 0, y => 0 } for ( 0 .. 9 );

my $visited = {};

add( $visited, $rope->[-1] );

while ( my $line = <$fh> ) {
    chomp $line;
    my ( $dir, $n ) = split / /, $line;

    while ( $n-- ) {
        move( $rope->[0], $dir );
        for my $idx ( 0 .. $#$rope - 1 ) {
            follow( $rope->[$idx], $rope->[ $idx + 1 ] );
        }
        add( $visited, $rope->[-1] );

    }
}

say scalar keys %$visited;
