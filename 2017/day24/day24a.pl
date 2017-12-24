#!/usr/bin/perl

use strict;
use warnings;

use feature 'say';

use List::Util qw(sum max);

sub findstrongest {
    my ($first, $comps) = @_;
    my $strongest = 0;
    foreach my $idx (0 .. $#$comps) {
        if ( grep { $_ == $first } @{ $comps->[$idx] } ) {
            my $newfirst = $comps->[$idx][0] == $first ? $comps->[$idx][1] : $comps->[$idx][0];
            my @newcomps = @$comps;
            splice @newcomps, $idx, 1;
            my $strength = ( sum @{ $comps->[$idx] } ) + findstrongest($newfirst, \@newcomps);
            $strongest = max ($strongest, $strength);
        }
    }
    return $strongest;
}

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

chomp(my @comps = <$fh>);

foreach my $idx (0 .. $#comps) {
    $comps[$idx] = [ split /\//, $comps[$idx] ];
}

my $strongest = findstrongest(0, \@comps);

say $strongest;
