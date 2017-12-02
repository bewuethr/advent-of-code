#!/usr/bin/perl

use strict;
use warnings;

use feature 'say';

use Data::Dumper;
use Digest::MD5 qw(md5_hex);
use File::Slurp;
use Graph::Simple;
use List::Util qw(max min product sum);
use Math::Prime::Util qw(fordivisors);

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

my $sum = 0;
while (my $line = <$fh>) {
    chomp $line;
    my @arr = split "\t", $line;
    $sum += (max @arr) - (min @arr);
}
say $sum;
