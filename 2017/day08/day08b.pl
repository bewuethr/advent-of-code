#!/usr/bin/perl

use strict;
use warnings;

use feature 'say';

use Algorithm::Combinatorics qw(permutations combinations variations);
use Data::Dumper;
use Digest::MD5 qw(md5_hex);
use File::Slurp;
use Graph::Simple;
use List::MoreUtils qw(mesh uniq frequency firstidx lastidx singleton);
use List::Util qw(max min product sum);
use Math::Prime::Util qw(fordivisors);

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

my %vars;
my @maxs;

while (my $line = <$fh>) {
    chomp $line;
    my @arr = split / /, $line;
    foreach my $idx (0, 4) {
        $vars{$arr[$idx]} //= 0;
        $arr[$idx] =~ s/.*/\$vars{$&}/;
    }
    $arr[1] =~ s/inc/+=/;
    $arr[1] =~ s/dec/-=/;
    eval join ' ', @arr;
    push @maxs, max values %vars;
}

say max @maxs;
