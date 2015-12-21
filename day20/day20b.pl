#!/usr/bin/perl

use strict;
use warnings;
use 5.022;
use Math::Prime::Util qw(fordivisors);

open my $fh, '<', 'input';
chomp(my $input = <$fh>);

my @houses;

foreach my $i (1 .. $input/11) {
    my $sum = 0; 
    fordivisors { $sum += 11 * $_ unless $i/50 > $_ } $i;
    if ($sum > $input) {
        say "House $i gets more than $input presents!";
        last;
    }
}
