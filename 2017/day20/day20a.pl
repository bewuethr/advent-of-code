#!/usr/bin/perl

use strict;
use warnings;

use feature 'say';

use Algorithm::Combinatorics qw(permutations combinations variations);
use Data::Dumper;
$Data::Dumper::Sortkeys = 1;
use Digest::MD5 qw(md5_hex);
use File::Slurp;
use Graph::Simple;
use List::MoreUtils qw(firstval mesh uniq frequency firstidx lastidx singleton);
use List::Util qw(reduce max min product sum);
use Math::Prime::Util qw(fordivisors);

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

my @particles;
my %minacc;

while (my $line = <$fh>) {
    chomp $line;
    my @arr = split / /, $line;
    $arr[0] =~ /(-?\d+),(-?\d+),(-?\d+)/g;
    push @particles, { p => { x => $1, y => $2, z => $3 } };
    $arr[1] =~ /(-?\d+),(-?\d+),(-?\d+)/g;
    $particles[-1]->{v} = { x => $1, y => $2, z => $3 };
    $arr[2] =~ /(-?\d+),(-?\d+),(-?\d+)/g;
    $particles[-1]->{a} = { x => $1, y => $2, z => $3 };
    $particles[-1]->{a_abs} = sqrt(sum map { $_ ** 2 } ($1, $2, $3));
    $particles[-1]->{dist} = sum map { abs $_ } values %{ $particles[-1]->{p} };
    if (not %minacc or $particles[-1]->{a_abs} < $minacc{a_abs}) {
        $minacc{a_abs} = $particles[-1]->{a_abs};
        $minacc{idx}  = $#particles;
    }
}

say $minacc{idx};

print Dumper(\@particles);

