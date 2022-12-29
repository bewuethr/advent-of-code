#!/usr/bin/perl

use warnings;
use strict;

use feature 'say';

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

    return ord($char) unless $char =~ /S|E/;
    return ord("a") if $char eq "S";
    return ord("z") if $char eq "E";

    die "invalid charachter $char";
}

my $fname = shift;

open my $fh, "<", $fname
  or die "Can't open $fname: $!";

my @map;
my @queue;

while ( my $line = <$fh> ) {
    chomp $line;

    push @map, [ map { { val => $_ } } split //, $line ];

    my $idx = index( $line, "S" );
    if ( $idx != -1 ) {
        push @queue,
          {
            x => $idx,
            y => $#map,
          };
        $map[-1][$idx]->{seen} = 1;
    }
}

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
          if height( $w->{val} ) - height( $map[ $v->{y} ][ $v->{x} ]{val} ) >
          1;

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
          if height( $w->{val} ) - height( $map[ $v->{y} ][ $v->{x} ]{val} ) >
          1;

        $w->{seen}   = 1;
        $w->{parent} = $map[ $v->{y} ][ $v->{x} ];

        push @queue, { x => $newX, y => $v->{y} };
    }
}


my $length = 0;
my $cur    = $map[ $v->{y} ][ $v->{x} ];

while ( exists $cur->{parent} ) {
    $cur->{val} = "X";
    ++$length;
    $cur = $cur->{parent};
}

# pretty( \@map );

say $length;
