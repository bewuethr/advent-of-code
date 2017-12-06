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

$seen{ join ' ', @arr } = 1;

while (1) {
    my $idx_max = firstidx { $_ == max @arr } @arr;
    my $tomove = $arr[$idx_max];
    $arr[$idx_max] = 0;
    my $cur_idx = ($idx_max + 1) % scalar @arr;
    while ($tomove--) {
        $arr[$cur_idx]++;
        $cur_idx = ($cur_idx + 1) % scalar @arr;
    }
    $ctr++;
    last if $seen{ join ' ', @arr };
    $seen{ join ' ', @arr } = 1;
}

say $ctr;
