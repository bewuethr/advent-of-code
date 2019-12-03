#!/usr/bin/perl

use warnings;
use strict;

use feature 'say';

use List::Util qw(min max sum);

sub move {
    my ( $x, $y, $dir ) = @_;
    if ( $dir eq "R" ) {
        return ( $x + 1, $y );
    }
    elsif ( $dir eq "L" ) {
        return ( $x - 1, $y );
    }
    elsif ( $dir eq "U" ) {
        return ( $x, $y - 1 );
    }
    elsif ( $dir eq "D" ) {
        return ( $x, $y + 1 );
    }
    die "invalid direction: $dir";
}

my $fname = shift;

open my $fh, "<", $fname
  or die "Can't open $fname: $!";

my $wire1 = <$fh>;
chomp $wire1;
my $wire2 = <$fh>;
chomp $wire2;

my @path1 = split /,/, $wire1;
my @path2 = split /,/, $wire2;

my %visited1;
my ( $x, $y ) = ( 0, 0 );

foreach my $edge (@path1) {
    my $dir  = substr( $edge, 0, 1 );
    my $dist = substr( $edge, 1 );
    while ( $dist-- ) {
        ( $x, $y ) = move( $x, $y, $dir );
        $visited1{$x}{$y} = 1;
    }
}

my %both;
( $x, $y ) = ( 0, 0 );

foreach my $edge (@path2) {
    my $dir  = substr( $edge, 0, 1 );
    my $dist = substr( $edge, 1 );
    while ( $dist-- ) {
        ( $x, $y ) = move( $x, $y, $dir );
        $both{$x}{$y} = 1 if defined $visited1{$x}{$y};
    }
}

say min map {
    ( abs $_ ) + min map { abs $_ } keys %{ $both{$_} }
} keys %both;
