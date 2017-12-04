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

my $ctr = 0;

while (my $line = <$fh>) {
    chomp $line;
    my @arr = split / /, $line;
    print Dumper (\@arr);
    @arr = map { my @chars = split //, $_; join '', sort @chars } @arr;
    print Dumper (\@arr);
    $ctr++ if not ( (join ' ', @arr) =~ /(\b\w+\b).*\1/ );
}

say $ctr;
