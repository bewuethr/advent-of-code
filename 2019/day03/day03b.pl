#!/usr/bin/perl

use warnings;
use strict;

use feature 'say';

use List::Util qw(min);

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
my ( $x, $y, $l ) = ( 0, 0, 0 );

foreach my $edge (@path1) {
    my $dir  = substr( $edge, 0, 1 );
    my $dist = substr( $edge, 1 );
    while ( $dist-- ) {
        ( $x, $y ) = move( $x, $y, $dir );
        ++$l;
        $visited1{$x}{$y} //= $l;
    }
}

my %both;
( $x, $y, $l ) = ( 0, 0, 0 );

foreach my $edge (@path2) {
    my $dir  = substr( $edge, 0, 1 );
    my $dist = substr( $edge, 1 );
    while ( $dist-- ) {
        ( $x, $y ) = move( $x, $y, $dir );
        ++$l;
        next if defined $both{$x} and defined $both{$x}{$y};
        if ( defined $visited1{$x} and defined $visited1{$x}{$y} ) {
            $both{$x}{$y} = $visited1{$x}{$y} + $l;
        }
    }
}

say min map { values %$_ } values %both;
