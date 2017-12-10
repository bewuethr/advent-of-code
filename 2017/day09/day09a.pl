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

# chomp(my @arr = <$fh>);

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
