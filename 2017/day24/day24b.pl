#!/usr/bin/perl

use strict;
use warnings;

use feature 'say';

use List::Util qw(sum);

sub findlongest {
    my ($first, $comps) = @_;
    my %longestprops = (
        strength => 0,
        length => 0,
    );

    foreach my $idx (0 .. $#$comps) {
        if ( grep { $_ == $first } @{ $comps->[$idx] } ) {
            my $newfirst = $comps->[$idx][0] == $first ? $comps->[$idx][1] : $comps->[$idx][0];
            my @newcomps = @$comps;
            splice @newcomps, $idx, 1;
            my $strength = sum @{ $comps->[$idx] };
            my $length   = 1;
            my $subprops = findlongest($newfirst, \@newcomps);

            $strength += $subprops->{strength};
            $length   += $subprops->{length};

            if ($length > $longestprops{length} or
                $length == $longestprops{length} and $strength > $longestprops{strength})
            {
                @longestprops{qw/strength length/} = ($strength, $length);
            }
        }
    }
    return \%longestprops;
}

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

chomp(my @comps = <$fh>);
my @starts;

foreach my $idx (0 .. $#comps) {
    $comps[$idx] = [ split /\//, $comps[$idx] ];
}

my $longest = findlongest(0, \@comps);

say $longest->{strength};
