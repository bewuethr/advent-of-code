#!/usr/bin/perl

use strict;
use warnings;

use feature 'say';

use List::Util qw(max);

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

my %fwall;

while (my $line = <$fh>) {
    chomp $line;
    my ($depth, $range) = split /: /, $line;
    @{$fwall{$depth}}{ qw(range pos dir) } = ($range, 1, 1);
}

my $severity = 0;

foreach my $t ( 0 .. max keys %fwall ) {
    if ($fwall{$t} and $fwall{$t}{pos} == 1) {
        $severity += $t * $fwall{$t}{range};
        say "Busted at t = $t, total now $severity";
    }
    foreach my $key (keys %fwall) {
        $fwall{$key}{pos} += $fwall{$key}{dir};
        $fwall{$key}{dir} *= -1 if (   $fwall{$key}{pos} == $fwall{$key}{range}
                                    or $fwall{$key}{pos} == 1);
    }
}

say $severity;
