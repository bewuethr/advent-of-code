#!/usr/bin/perl

use warnings;
use strict;

use feature 'say';
use Clone qw(clone);

sub pretty {
    my $map = shift;
    say join "\n", map {
        join "",
          map { $_->{val} }
          @$_
    } @$map;
}

sub height {
    my $char = shift;

    return ord("z") if $char eq "E";
    return ord($char);
}

sub getDistance {
    my ( $x, $y, $blankMap ) = @_;
    my @queue = ( { x => $x, y => $y } );
    my @map   = @{ clone($blankMap) };
    $map[$y][$x]{seen} = 1;
    my $v;

    while (@queue) {

        # Unqueue
        $v = shift @queue;

        # Check if we have reached the goal
        last if $map[ $v->{y} ][ $v->{x} ]{val} eq "E";

        # Add all unvisited neighbours to the queue
        foreach my $dy ( -1, 1 ) {
            my $newY = $v->{y} + $dy;
            next if $newY < 0 or $newY > $#map;

            my $w = $map[$newY][ $v->{x} ];
            next if exists $w->{seen};
            next
              if height( $w->{val} ) -
              height( $map[ $v->{y} ][ $v->{x} ]{val} ) > 1;

            $w->{seen}   = 1;
            $w->{parent} = $map[ $v->{y} ][ $v->{x} ];

            push @queue, { x => $v->{x}, y => $newY };
        }

        foreach my $dx ( -1, 1 ) {
            my $newX = $v->{x} + $dx;
            next if $newX < 0 or $newX > $#{ $map[0] };

            my $w = $map[ $v->{y} ][$newX];
            next if exists $w->{seen};
            next
              if height( $w->{val} ) -
              height( $map[ $v->{y} ][ $v->{x} ]{val} ) > 1;

            $w->{seen}   = 1;
            $w->{parent} = $map[ $v->{y} ][ $v->{x} ];

            push @queue, { x => $newX, y => $v->{y} };
        }
    }

    my $length = 0;
    my $cur    = $map[ $v->{y} ][ $v->{x} ];

    if ($cur->{val} ne "E") {
        return (0, 0);
    }

    while ( exists $cur->{parent} ) {
        $cur->{val} = "X";
        ++$length;
        $cur = $cur->{parent};
    }

    return (1, $length);
}

my $fname = shift;

open my $fh, "<", $fname
  or die "Can't open $fname: $!";

my @map;
my @queue;

while ( my $line = <$fh> ) {
    chomp $line;

    push @map, [ map { { val => $_ eq "S" ? "a" : $_ } } split //, $line ];
}

# pretty( \@map );

my $shortest = 0;

foreach my $y ( 0 .. $#map ) {
    foreach my $x ( 0 .. $#{ $map[$y] } ) {
        if ( $map[$y][$x]{val} eq "a" ) {
            my ($success, $length) = getDistance( $x, $y, \@map );
            next unless $success;

            if ( $shortest == 0 or $length < $shortest ) {
                $shortest = $length;
            }
        }
    }
}

say $shortest;

