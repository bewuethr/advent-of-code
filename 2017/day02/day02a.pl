#!/usr/bin/perl

use strict;
use warnings;

use feature 'say';

use List::Util qw(max min sum);

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

say sum map { chomp; my @arr = split "\t"; (max @arr) - (min @arr) } <$fh>;
