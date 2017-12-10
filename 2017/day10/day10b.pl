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
use List::Util qw(reduce max min product sum);
use Math::Prime::Util qw(fordivisors);

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

my $line = <$fh>;
chomp $line;

my @lengths = map { ord } split //, $line;
push @lengths, (17, 31, 73, 47, 23);

my $skip = 0;
my $cur = 0;

my @list = (0..255);
# my @list = (0..4);
my @list2 = @list;

my $debug = 0;

foreach my $i (1..64) {
    foreach my $len (@lengths) {
        say '============' if $debug;
        say "cur: $cur, len: $len, skip: $skip" if $debug;
        say "@list (list)" if $debug;
        my @longlist = (@list, @list2);
        say "@longlist (longlist)" if $debug;
        my @sublist;
        if ($len == 0) {
            @sublist = ();
        }
        else {
            @sublist = @longlist[$cur..$cur+$len-1];
        }
        print "sublist: " . Dumper(\@sublist) if $debug;
        my @head;
        if ($cur == 0) {
            @head = ();
        }
        else {
            @head = @longlist[0..$cur-1];
        }
        print "head " . Dumper(\@head) if $debug;
        my @mod_longlist = (@head, (reverse @sublist), @longlist[ $cur+$len .. $#longlist]);
        print "mod_longlist " . Dumper(\@mod_longlist) if $debug;
        @list = @mod_longlist[0..$#list];
        if ($cur+$len-1 > $#list) {
            @list[ 0 .. ($cur+$len-1) % @list ] = @mod_longlist[ scalar @list .. $cur+$len-1 ];
        }
        @list2 = @list;
        $cur += $len + $skip;
        $cur %= @list;
        $skip++;
        say "@list (list at end)" if $debug;
    }
}

say "@list";

say $#list;

my @densehash = map { reduce { $a ^ $b } @list[$_*16..($_+1)*16-1] } (0..15);
print Dumper(\@densehash);

say "@densehash";

say join '', map { sprintf '%02x', $_ } @densehash;
