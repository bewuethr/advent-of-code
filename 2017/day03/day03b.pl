#!/usr/bin/perl

use strict;
use warnings;

use feature 'say';

sub rot_left {
    my $dir = shift;
    @$dir = (-$dir->[1], $dir->[0]);
}

sub calc_val {
    my ($cx, $cy, $grid) = @_;
    my $newval = 0;
    foreach my $x ($cx-1..$cx+1) {
        foreach my $y ($cy-1..$cy+1) {
            $newval += $grid->{$x}{$y} if defined $grid->{$x}{$y};
        }
    }
    return $newval;
}

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

my $target = <$fh>;
chomp $target;

my ($x, $y) = (0, 0);
my $grid;
my $val = 1;
$grid->{$x}{$y} = $val;

my $dir = [1, 0];
my $steps = 1;

OUTER: while (1) {
    foreach my $side (1..2) {
        foreach my $step (1..$steps) {
            ($x, $y) = ($x + $dir->[0], $y + $dir->[1]);

            $grid->{$x}{$y} = calc_val($x, $y, $grid);
            say "$x/$y: $grid->{$x}{$y}";
            last OUTER if $grid->{$x}{$y} > $target;
        }
        rot_left($dir);
    }
    $steps++;
}

say $grid->{$x}{$y};
