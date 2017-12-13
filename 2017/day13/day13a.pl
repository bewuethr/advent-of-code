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

# chomp(my @arr = <$fh>);
# 
# while (1) {
# }

my %fwall;

while (my $line = <$fh>) {
    chomp $line;
    my ($depth, $range) = split /: /, $line;
    $fwall{$depth}{range} = $range;
    $fwall{$depth}{pos} = 1;
    $fwall{$depth}{dir} = 1;
}

my $severity = 0;

foreach my $t ( 0 .. max keys %fwall ) {
    say "t = $t";
    if ($fwall{$t} and $fwall{$t}{pos} == 1) {
        $severity += $t * $fwall{$t}{range};
        say "Busted, total now $severity";
    }
    foreach my $key (keys %fwall) {
        $fwall{$key}{pos} += $fwall{$key}{dir};
        $fwall{$key}{dir} *= -1 if ($fwall{$key}{pos} == $fwall{$key}{range} or $fwall{$key}{pos} == 1);
    }
    print Dumper(\@{fwall}{(0..5)});
}

say $severity;
