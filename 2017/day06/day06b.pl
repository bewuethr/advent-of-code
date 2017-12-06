#!/usr/bin/perl

use strict;
use warnings;

use feature 'say';

use List::MoreUtils qw(firstidx);
use List::Util qw(max);

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

my $line = <$fh>;
chomp $line;
my @arr = split "\t", $line;

my %seen;
my $ctr = 0;

$seen{"@arr"} = $ctr;

while (1) {
    my $idx_max = firstidx { $_ == max @arr } @arr;
    my $tomove = $arr[$idx_max];
    $arr[$idx_max] = 0;
    my $cur_idx = ($idx_max + 1) % @arr;
    while ($tomove--) {
        $arr[$cur_idx]++;
        $cur_idx = ($cur_idx + 1) % @arr;
    }
    $ctr++;
    last if $seen{"@arr"};
    $seen{"@arr"} = $ctr;
}

say $ctr - $seen{"@arr"};
