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

# chomp(my @arr = <$fh>);
# 
# while (1) {
# }

my @progs = map { chr(ord('a')+$_) } (0 .. 15);

print Dumper(\@progs);

my $line = <$fh>;
chomp $line;
my @instrs = split /,/, $line;

# @instrs = ('s1', 'x3/4', 'pe/b');

foreach my $instr (@instrs) {
    # say "$instr";
    if ($instr =~ /^s(\d+)$/) {
        my $els = $1;
        # say $els;
        my @front;
        my @tail;
        if ($els > 1) {
            @tail = @progs[-$els .. -1];
            @front = @progs[0 .. $#progs-$els];
            # say "@front";
            @progs = (@tail, @front);
        }
        if ($els == 1) {
            my $last = pop @progs;
            unshift @progs, $last;
        }
    }
    elsif ($instr =~ /^x(\d+)\/(\d+)$/) {
        my $idx1 = $1;
        my $idx2 = $2;
        @progs[$idx1, $idx2] = @progs[$idx2, $idx1];
    }
    elsif ($instr =~ /^p(\w)\/(\w)$/) {
        # say $instr;
        # say "$1, $2";
        my $prog1 = $1;
        my $prog2 = $2;
        my $idx1 = firstidx { $_ eq $prog1 } @progs;
        my $idx2 = firstidx { $_ eq $prog2 } @progs;
        @progs[ $idx1, $idx2 ] = @progs[ $idx2, $idx1 ];
    }
    # say "@progs";
}

say join '', @progs;
