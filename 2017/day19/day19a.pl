#!/usr/bin/perl

use strict;
use warnings;

use feature 'say';

use List::MoreUtils qw(firstidx);

sub walk {
    my ($x, $y, $dx, $dy, $map, $solution) = @_;
    do {
        $x += $dx;
        $y += $dy;
        if ($map->[$y][$x] =~ /[A-Z]/) {
            $$solution .= $map->[$y][$x];
        }
    } until ($map->[$y][$x] =~ /[+ ]/ or not defined $map->[$y][$x]);
    return ($x, $y);
}

sub finddir {
    my ($x, $y, $dx, $dy, $map) = @_;
    my ($dx_next, $dy_next);
    foreach my $dir ([0, 1], [1, 0], [0, -1], [-1, 0]) {
        next if $dir->[0] == $$dx or $dir->[1] == $$dy;
        next if not defined $map->[$y + $dir->[1]][$x + $dir->[0]]
                or not $map->[$y + $dir->[1]][$x + $dir->[0]] =~ /[-|]/;
        ($dx_next, $dy_next) = @$dir;
    }
    return 0 if not  defined $dx_next;
    ($$dx, $$dy) = ($dx_next, $dy_next);
    return 1;
}
        

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

my @map;

while (my $line = <$fh>) {
    chomp $line;
    my @row = split //, $line;
    push @map, \@row;
}

my $y = 0;
my $x = firstidx { $_ eq "|" } @{$map[0]};

my $solution;
my ($dx, $dy) = (0, 1);

while (1) {
    ($x, $y) = walk($x, $y, $dx, $dy, \@map, \$solution);
    last if not finddir($x, $y, \$dx, \$dy, \@map);
}

say $solution;
