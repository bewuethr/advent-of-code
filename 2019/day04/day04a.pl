#!/usr/bin/perl

use warnings;
use strict;

use feature 'say';

my $fname = shift;

open my $fh, "<", $fname
  or die "Can't open $fname: $!";

my $input = <$fh>;
chomp $input;
my ( $from, $to ) = split /-/, $input;

my $count = 0;

OUTER:
foreach my $n ( $from .. $to ) {
    next unless $n =~ /(.)\g1/;
    my $prev = substr( $n, 0, 1 );
    foreach my $digit ( split //, substr( $n, 1 ) ) {
        next OUTER if $digit < $prev;
        $prev = $digit;
    }
    ++$count;
}

say $count;
