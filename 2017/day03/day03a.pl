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

my $val = <$fh>;
chomp $val;

my $sqbase = 1;
my $ctr = 1;
my $ydist = 0;

while (1) {
    say "y-dist: $ydist; Side length: $sqbase, lower right corner: $ctr";
    last if $ctr > $val;
    $ydist++;
    $sqbase += 2;
    $ctr = $sqbase ** 2;
}
