#!/usr/bin/perl

use warnings;
use strict;

use feature 'say';

use List::Util 'uniq';

sub unique {
    return (scalar uniq @_) == @_;
}

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

my @signal = split //, <$fh>;
my $count = 14;
my @window = @signal[0..$count-1];

while (not unique(@window)) {
    shift @window;
    push @window, $signal[$count++];
}

say "$count";
