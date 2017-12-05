#!/usr/bin/perl

use strict;
use warnings;

use feature 'say';

use Algorithm::Combinatorics qw(permutations combinations variations);
use Data::Dumper;
use Digest::MD5 qw(md5_hex);
use File::Slurp;
use Graph::Simple;
use List::Util qw(max min product sum);
use Math::Prime::Util qw(fordivisors);

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

my @arr = <$fh>;
my $pos = 0;
my $res = 0;

while (1) {
    my $jump = $arr[$pos];
    if ($jump >= 3) {
        $arr[$pos]--
    }
    else {
        $arr[$pos]++;
    };
    $pos += $jump;
    $res++;
    last if ($pos > $#arr or $pos < 0);
}

say $res;
