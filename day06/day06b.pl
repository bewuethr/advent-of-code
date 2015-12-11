#!/bin/perl

use 5.022;
use warnings;
no warnings 'experimental';
use List::Util qw(sum);
use Data::Dumper;

my @grid;
my $ifname = "input";

open my $fh, '<', $ifname;

while (my $line = <$fh>) {
    chomp $line;
    my ($action, $x1, $y1, $x2, $y2) = $line =~ /(.*) (\d+),(\d+) through (\d+),(\d+)/;
    foreach my $y ($y1..$y2) {
        foreach my $x ($x1..$x2) {
            for ($action) {
                when (/turn on/)  { $grid[$y][$x]++ }
                when (/turn off/) { $grid[$y][$x]-- if defined $grid[$y][$x] and $grid[$y][$x] > 0 }
                when (/toggle/)   { $grid[$y][$x] += 2 }
                default           { die "Illegal action: $action" }
            }
        }
    }
}

close $fh;

my $brightness = sum map { sum grep { defined $_ } @$_ } grep { defined $_ } @grid;

say "Total brightness is $brightness.";
