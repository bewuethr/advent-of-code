#!/usr/bin/perl

use strict;
use warnings;

use feature 'say';

use List::Util qw(max sum);

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

my %fwall;

while (my $line = <$fh>) {
    chomp $line;
    my ($depth, $range) = split /: /, $line;
    @{$fwall{$depth}}{ qw(range pos dir) } = ($range, 1, 1);
}

my @topmatrix;

my $t = 0;
my $maxkey = max keys %fwall;

while (1) {
    push @topmatrix,
         [
             map {
                 (defined $fwall{$_} and $fwall{$_}{pos} == 1) ? 1 : 0
             } ( 0 .. $maxkey )
         ];
    foreach my $key (keys %fwall) {
        $fwall{$key}{pos} += $fwall{$key}{dir};
        $fwall{$key}{dir} *= -1 if (   $fwall{$key}{pos} == $fwall{$key}{range}
                                    or $fwall{$key}{pos} == 1);
    }
    if ($t >= $maxkey) {
        last unless grep { $topmatrix[$_]->[$_] } ( 0 .. $maxkey );
        shift @topmatrix;
    }
    $t++;
}

say $t - $maxkey;
