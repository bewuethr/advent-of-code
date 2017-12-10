#!/usr/bin/perl

use strict;
use warnings;

use feature 'say';

use Algorithm::Combinatorics qw(permutations combinations variations);
use Data::Dumper;
use Digest::MD5 qw(md5_hex);
use File::Slurp;
use Graph::Simple;
use List::MoreUtils qw(firstval mesh uniq frequency firstidx lastidx singleton);
use List::Util qw(max min product sum);
use Math::Prime::Util qw(fordivisors);

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
