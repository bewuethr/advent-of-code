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

my @buffer = (0);
my $pos = 0;

# chomp(my @arr = <$fh>);
# 
# while (1) {
# }

for my $num (1..2017) {
    $pos = ($pos + $steps) % @buffer;
    splice @buffer, $pos+1, 0, $num;
    $pos++;
    # say "@buffer";
}

say $buffer[ (firstidx { $_ == 2017 } @buffer) + 1 ];
