#!/usr/bin/perl

use strict;
use warnings;
use 5.022;
use List::Util qw(sum);

sub get_neighbours {
    my ($x, $y, $grid) = @_;
    my $count = 0;
    foreach my $yy ($y-1 .. $y+1) {
        next if $yy < 0 or $yy > $#{$grid};
        foreach my $xx ($x-1 .. $x+1) {
            next if $xx < 0 or $xx > $#{$grid->[$y]} or $xx == $x and $yy == $y;
            ++$count if $grid->[$yy][$xx] eq '#';
        }
    }
    return $count;
}

my @grid;
open my $fh, '<', 'input' or die "Can't open input file: $!";
while (<$fh>) {
    chomp;
    push @grid, [ split // ];
}

# Turn corners on
$grid[0][0]   = '#';
$grid[0][-1]  = '#';
$grid[-1][0]  = '#';
$grid[-1][-1] = '#';


foreach (1..100) {
    my @ncount;
    foreach my $y (0..$#grid) {
        foreach my $x (0 .. $#{$grid[$y]}) {
            push @{$ncount[$y]}, get_neighbours($x, $y, \@grid);
        }
    }

    foreach my $y (0..$#grid) {
        foreach my $x (0 .. $#{$grid[$y]}) {
            next if $x == 0      and $y == 0      or
                    $x == $#grid and $y == 0      or
                    $x == 0      and $y == $#grid or
                    $x == $#grid and $y == $#grid;
            if ($grid[$y][$x] eq '#') {
                if ($ncount[$y][$x] != 2 and $ncount[$y][$x] != 3) {
                    $grid[$y][$x] = '.';
                }
            }
            else {
                $grid[$y][$x] = '#' if $ncount[$y][$x] == 3;
            }
        }
    }
}

my $lights_on = sum map { scalar grep { $_ eq '#' } @{$_} } @grid;
say "There are $lights_on lights on.";
