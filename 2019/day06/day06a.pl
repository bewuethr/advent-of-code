#!/usr/bin/perl

use warnings;
use strict;

use feature 'say';
no warnings 'recursion';

my %orbitHash;
my $checksum;

sub buildTree {
    my ( $key, $depth ) = @_;
    return 1 if ( not defined $orbitHash{$key} );
    ++$depth;
    my $subtree;
    foreach my $val ( @{ $orbitHash{$key} } ) {
        $checksum += $depth;
        $subtree->{$val} = buildTree( $val, $depth );
    }
    return $subtree;
}

my $fname = shift;

open my $fh, "<", $fname
  or die "Can't open $fname: $!";

chomp( my @lines = <$fh> );

my @orbits =
  map { my ( $k, $v ) = split /\)/, $_; my $s = { $k => $v }; $s } @lines;

foreach my $orbit (@orbits) {
    my ($k) = keys %$orbit;
    my ($v) = values %$orbit;
    push @{ $orbitHash{$k} }, $v;
}

my $tree = { "COM" => buildTree( "COM", 0 ) };

say $checksum;
