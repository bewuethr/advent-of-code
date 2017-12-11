#!/usr/bin/perl

use strict;
use warnings;

use feature 'say';

use List::MoreUtils qw(pairwise);
use List::Util qw(max sum);

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

my $line = <$fh>;
chomp $line;
my @dirs = split /,/, $line;

my @coords = (0, 0, 0);
my $maxdist = 0;

foreach my $dir (@dirs) {
    my @vec = (0, 0, 0);
    $vec[0] =  1 if $dir =~ /e/;
    $vec[0] = -1 if $dir =~ /w/;
    $vec[1] =  1 if $dir =~ /\Anw?\z/;
    $vec[1] = -1 if $dir =~ /\Ase?\z/;
    $vec[2] =  1 if $dir =~ /\Asw?\z/;
    $vec[2] = -1 if $dir =~ /\Ane?\z/;
    @coords = pairwise { $a + $b } @coords, @vec;
    $maxdist = max ((0.5 * sum map { abs } @coords), $maxdist);
}

say $maxdist;
