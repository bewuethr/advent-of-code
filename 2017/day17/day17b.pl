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

# my $fname = shift;
# 
# open my $fh, "<", $fname
#     or die "Can't open $fname: $!";

my $steps = 356;
# my $steps = 3;

my $len = 1;
my $pos = 0;
my $res;

# chomp(my @arr = <$fh>);
# 
# while (1) {
# }

for my $num (1..50_000_000) {
    $pos = ($pos + $steps) % $len;
    $res = $num if $pos == 0;
    # say "Round $num, pos $pos";
    $len++;
    $pos++;
    # say "@buffer";
}

say $res;
