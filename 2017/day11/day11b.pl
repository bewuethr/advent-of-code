#!/usr/bin/perl

use strict;
use warnings;

use feature 'say';

use Algorithm::Combinatorics qw(permutations combinations variations);
use Data::Dumper;
use Digest::MD5 qw(md5_hex);
use File::Slurp;
use Graph::Simple;
use List::MoreUtils qw(firstval pairwise mesh uniq frequency firstidx lastidx singleton);
use List::Util qw(reduce max min product sum);
use Math::Prime::Util qw(fordivisors);

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
    $vec[0] = 1 if $dir =~ /e/;
    $vec[0] = -1 if $dir =~ /w/;
    $vec[1] = 1 if $dir =~ /\Anw?\z/;
    $vec[1] = -1 if $dir =~ /\Ase?\z/;
    $vec[2] = 1 if $dir =~ /\Asw?\z/;
    $vec[2] = -1 if $dir =~ /\Ane?\z/;
    @coords = pairwise { $a + $b } @coords, @vec;
    my $dist = 0.5 * sum map { abs } @coords;
    $maxdist = max ($dist, $maxdist);
    say "$dir: @coords, dist: $dist";
}

say $maxdist;
