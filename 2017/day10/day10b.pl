#!/usr/bin/perl

use strict;
use warnings;

use feature 'say';

use List::Util qw(reduce);

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

foreach my $i (1..64) {
    foreach my $len (@lengths) {
        my @longlist = (@list, @list);
        my @sublist;
        if ($len == 0) {
            @sublist = ();
        }
        else {
            @sublist = @longlist[ $cur .. $cur+$len-1 ];
        }
        my @head;
        if ($cur == 0) {
            @head = ();
        }
        else {
            @head = @longlist[ 0 .. $cur-1 ];
        }
        my @mod_longlist = (@head, (reverse @sublist), @longlist[ $cur+$len .. $#longlist ]);
        @list = @mod_longlist[ 0 .. $#list ];
        if ($cur+$len-1 > $#list) {
            @list[ 0 .. ($cur+$len-1) % @list ] = @mod_longlist[ @list .. $cur+$len-1 ];
        }
        $cur = ($cur + $len + $skip) % @list;
        $skip++;
    }
}

my @densehash = map { reduce { $a ^ $b } @list[$_*16..($_+1)*16-1] } (0..15);
say join '', map { sprintf '%02x', $_ } @densehash;
