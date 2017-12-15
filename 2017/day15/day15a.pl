#!/usr/bin/perl

use strict;
use warnings;

use feature 'say';

use Algorithm::Combinatorics qw(permutations combinations variations);
use Data::Dumper;
use Digest::MD5 qw(md5_hex);
use File::Slurp;
use Graph::Simple;
use List::MoreUtils qw(firstval mesh uniq frequency firstidx lastidx singleton);
use List::Util qw(reduce max min product sum);
use Math::Prime::Util qw(fordivisors);

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

chomp(my @arr = <$fh>);

$arr[0] =~ /(\d+)/;
my $valA = $1;

$arr[1] =~ /(\d+)/;
my $valB = $1;

my ($facA, $facB) = (16807, 48271);
my $divi = 2147483647;

my $count = 0;

# ($valA, $valB) = (65, 8921);

# foreach my $i ( 1 .. 5 ) {
foreach my $i ( 1 .. 40_000_000 ) {
    $valA = $valA * $facA % $divi;
    $valB = $valB * $facB % $divi;
    # printf "%032b\n%032b\n\n", $valA, $valB;
    # printf "%016b\n%016b\n\n", ($valA & 0xffff), ($valB & 0xffff);
    $count++ if (($valA & 0xffff) == ($valB & 0xffff));
    # say "$valA\t$valB";
}

say $count;
