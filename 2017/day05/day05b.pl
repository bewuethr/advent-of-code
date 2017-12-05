#!/usr/bin/perl

use strict;
use warnings;

use feature 'say';

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

chomp(my @arr = <$fh>);
my $pos = 0;
my $res = 0;

while (1) {
    my $jump = $arr[$pos];
    if ($jump >= 3) {
        $arr[$pos]--
    }
    else {
        $arr[$pos]++;
    };
    $pos += $jump;
    $res++;
    last if ($pos > $#arr or $pos < 0);
}

say $res;
