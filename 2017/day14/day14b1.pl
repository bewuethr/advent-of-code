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

my @matrix;

foreach my $suffix (0..127) {

    my @lengths = map { ord } split //, $line . "-$suffix";
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
    push @matrix, [ split //, join '', map { sprintf '%08b', $_ } @densehash ];
}

foreach my $y ( 0 .. $#matrix ) {
    my $line = $matrix[$y];
    foreach my $x ( 0 .. $#$line ) {
        next if $line->[$x] == 0;
        my @connected;
        push @connected, ($x-1) . "/" . $y if $x > 0 and $matrix[$y]->[$x-1];
        push @connected, ($x+1) . "/" . $y if $x < $#$line and $matrix[$y]->[$x+1];
        push @connected, $x . "/" . ($y-1) if $y > 0 and $matrix[$y-1]->[$x];
        push @connected, $x . "/" . ($y+1) if $y < $#matrix and $matrix[$y+1]->[$x];
        say "$x/$y <-> " . join ", ", @connected if @connected;
        say "$x/$y <-> $x/$y" if not @connected;
    }
}
