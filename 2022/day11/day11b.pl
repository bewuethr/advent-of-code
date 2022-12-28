#!/usr/bin/perl

use warnings;
use strict;

use feature 'say';

use List::Util qw(reduce);

sub turn {
    my ( $monkey, $monkeys, $divisor ) = @_;

    while ( @{ $monkey->{items} } ) {
        ++$monkey->{inspCount};

        my $item = shift @{ $monkey->{items} };

        $item = $monkey->{operation}($item) % $divisor;

        my $receiver = $monkey->{ifFalse};
        if ( $monkey->{test}($item) ) {
            $receiver = $monkey->{ifTrue};
        }

        push @{ $monkeys->[$receiver]{items} }, $item;
    }
}

my $fname = shift;

open my $fh, "<", $fname
  or die "Can't open $fname: $!";

my $monkeys = [];

while ( my $line = <$fh> ) {
    chomp $line;
    if ( $line =~ /Monkey/ ) {
        push @$monkeys, { inspCount => 0 };
    }

    my $monkey = $monkeys->[-1];

    if ( $line =~ /Starting items:/ ) {
        $monkey->{items} = [ map { $_ + 0 } $line =~ /\d+/g ];
    }

    if ( $line =~ /Operation:/ ) {
        $line =~ m/= (.*)/;
        $monkey->{operation} = eval "sub { " . join " ",
          map { $_ eq "old" ? '$_[0]' : $_ } split / /, $1 . " }";
    }

    if ( $line =~ /Test:/ ) {
        my ($divVal) = map { $_ + 0 } ( $line =~ /\d+/g );
        $monkey->{divisible} = $divVal;
        $monkey->{test}      = sub { $_[0] % $divVal == 0 };
    }

    if ( $line =~ /If true:/ ) {
        my ($recVal) = ( $line =~ /\d+/g );
        $monkey->{ifTrue} = $recVal + 0;
    }

    if ( $line =~ /If false:/ ) {
        my ($recVal) = ( $line =~ /\d+/g );
        $monkey->{ifFalse} = $recVal + 0;
    }
}

my $divisor = reduce { $a * $b } map { $_->{divisible} } @$monkeys;

foreach my $round ( 1 .. 10000 ) {
    foreach my $i ( 0 .. $#$monkeys ) {
        turn( $monkeys->[$i], $monkeys, $divisor );
    }
}

my @sorted = sort { $b->{inspCount} <=> $a->{inspCount} } @$monkeys;
say $sorted[0]->{inspCount} * $sorted[1]->{inspCount};
