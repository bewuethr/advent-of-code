#!/usr/bin/perl

use strict;
use warnings;

use feature 'say';

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

my $res = 0;

my $line = <$fh>;
chomp $line;

# Clean up escapes
$line =~ s/!.//g;

# Count garbage
while ($line =~ s/<(.*?)>//) {
    $res += length $1;
}

say $res;
