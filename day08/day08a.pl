#!/bin/perl

use strict;
use warnings;
use 5.022;

my $ifname = 'input';
open my $fh, '<', $ifname or die "Can't open $ifname: $!";

my $total;

while (<$fh>) {
    chomp;

    my $len = length $_;

    s/^"(.*)"$/$1/;
    s/\\\\/S/g;
    s/\\"/Q/g;
    s/\\x[[:xdigit:]]{2}/X/g;

    $total += $len - length $_;
}

say "Total diff: $total";
