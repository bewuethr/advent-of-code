#!/usr/bin/perl

use warnings;
use strict;

use feature 'say';
my $fname = shift;

my %stacks = (
    1 => [qw/B W N/],
    2 => [qw/L Z S P T D M B/],
    3 => [qw/Q H Z W R/],
    4 => [qw/W D V J Z R/],
    5 => [qw/S H M B/],
    6 => [qw/L G N J H V P B/],
    7 => [qw/J Q Z F H D L S/],
    8 => [qw/W S F J G Q B/],
    9 => [qw/Z W M S C D J/]
);
open my $fh, "<", $fname
  or die "Can't open $fname: $!";

while ( my $line = <$fh> ) {
    chomp $line;
    next if $line !~ /^move/;
    my ( $n, $from, $to ) = $line =~ /\d+/g;

    while ( $n-- ) {
        push @{ $stacks{$to} }, pop @{ $stacks{$from} };
    }
}

my $crates = "";
foreach my $key ( sort { $a <=> $b } keys %stacks ) {
    $crates .= pop @{ $stacks{$key} };
}

say "$crates";
