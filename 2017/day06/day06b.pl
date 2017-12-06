#!/usr/bin/perl

use strict;
use warnings;

use feature 'say';

use Algorithm::Combinatorics qw(permutations combinations variations);
use Data::Dumper;
use Digest::MD5 qw(md5_hex);
use File::Slurp;
use Graph::Simple;
use List::MoreUtils qw(firstidx);
use List::Util qw(max min product sum);
use Math::Prime::Util qw(fordivisors);

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

# chomp(my @arr = <$fh>);
my $res = 0;

#  while (1) {
#
#  }l

my %seen;

my $line = <$fh>;
chomp $line;
my @arr = split "\t", $line;

$seen{ join ' ', @arr }{flag} = 1;
$seen{ join ' ', @arr }{idx} = $res;

while (1) {
    my $idx_max = firstidx { $_ == max @arr } @arr;
    my $tomove = $arr[$idx_max];
    $arr[$idx_max] = 0;
    my $cur_idx = ($idx_max + 1) % scalar @arr;
    while ($tomove--) {
        $arr[$cur_idx]++;
        $cur_idx = ($cur_idx + 1) % scalar @arr;
    }
    $res++;
    last if $seen{ join ' ', @arr }{flag};
    $seen{ join ' ', @arr }{flag} = 1;
    $seen{ join ' ', @arr }{idx} = $res;
}

say $res - $seen{ join ' ', @arr }{idx};
