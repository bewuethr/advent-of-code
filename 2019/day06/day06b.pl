#!/usr/bin/perl

use warnings;
use strict;

use feature 'say';
no warnings 'recursion';

my %astroMap;
my %distance;
my ( $start, $target );

sub visit {
    my $cur = shift;
    foreach my $next ( @{ $astroMap{$cur} } ) {
        next if defined $distance{$next};
        if ( $next eq $target ) {
            say $distance{$cur} + 1;
            exit;
        }
        $distance{$next} = $distance{$cur} + 1;
        visit($next);
    }
}

my $fname = shift;

open my $fh, "<", $fname
  or die "Can't open $fname: $!";

chomp( my @lines = <$fh> );

foreach my $edge ( map { [ split /\)/, $_ ] } @lines ) {
    push @{ $astroMap{ $edge->[0] } }, $edge->[1];
    push @{ $astroMap{ $edge->[1] } }, $edge->[0];
}

( $start, $target ) = ( $astroMap{"YOU"}[0], $astroMap{"SAN"}[0] );
$distance{$start} = 0;

visit($start);
