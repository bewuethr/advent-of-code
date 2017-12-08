#!/usr/bin/perl

use strict;
use warnings;

use feature 'say';

use List::Util qw(max);

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

my %vars;

while (my $line = <$fh>) {
    chomp $line;
    my @arr = split / /, $line;
    foreach my $idx (0, 4) {
        $vars{$arr[$idx]} //= 0;
        $arr[$idx] =~ s/.*/\$vars{$&}/;
    }
    $arr[1] =~ s/inc/+=/;
    $arr[1] =~ s/dec/-=/;
    eval "@arr";
}

say max values %vars;
