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

# Clean up garbage
$line =~ s/<.*?>//g;

# Where we go, we need no commas
$line =~ s/,//g;

my $indent = 1;

foreach my $char (split //, $line) {
    if ($char eq '{') {
        $res += $indent;
        $indent++;
    }
    $indent-- if $char eq '}';
}

say $res;
