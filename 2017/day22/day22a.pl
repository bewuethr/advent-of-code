#!/usr/bin/perl

use strict;
use warnings;

use feature 'say';

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

my %grid;
my ($x, $y) = (1, 1);

while (my $line = <$fh>) {
    chomp $line;
    my @arr = split //, $line;
    foreach my $el (@arr) {
        $grid{$x++ . "/$y"} = $el;
    }
    $x = 1;
    $y++;
}

my $infect = 0;
my ($xpos, $ypos) = (13, 13);
my ($dx, $dy) = (0, -1);

foreach my $i (1..10_000) {
    $grid{"$xpos/$ypos"} //= '.';
    if ($grid{"$xpos/$ypos"} eq '#') {
        # rotate right
        ($dx, $dy) = (-$dy, $dx);
        $grid{"$xpos/$ypos"} = '.';
    }
    else {
        # rotate left
        ($dx, $dy) = ($dy, -$dx);
        $grid{"$xpos/$ypos"} = '#';
        $infect++;
    }
    $xpos += $dx;
    $ypos += $dy;
}

say $infect;
