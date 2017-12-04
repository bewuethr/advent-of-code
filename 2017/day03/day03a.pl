#!/usr/bin/perl

use strict;
use warnings;

use feature 'say';

sub rot_left {
    my $dir = shift;
    @$dir = (-$dir->[1], $dir->[0]);
}

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

my $target = <$fh>;
chomp $target;

my ($x, $y) = (0, 0);
my $val = 1;

my $dir = [1, 0];
my $steps = 1;

OUTER: while (1) {
    foreach my $side (1..2) {
        foreach my $step (1..$steps) {
            ($x, $y) = ($x + $dir->[0], $y + $dir->[1]);
            $val++;
            last OUTER if $val == $target;
        }
        rot_left($dir);
    }
    $steps++;
}

say abs $x + abs $y;
