#!/usr/bin/perl

use strict;
use warnings;

use feature 'say';

use Algorithm::Combinatorics qw(permutations combinations variations);
use Data::Dumper;
use Digest::MD5 qw(md5_hex);
use File::Slurp;
use Graph::Simple;
use List::MoreUtils qw(firstval mesh uniq frequency firstidx lastidx pairwise singleton);
use List::Util qw(reduce max min product sum);
use Math::Prime::Util qw(fordivisors is_prime);

# my $fname = shift;
# 
# open my $fh, "<", $fname
#     or die "Can't open $fname: $!";

my $steps = 12134527;

my %states = (
    A => {
        0 => {
            w => 1,
            m => 1,
            c => "B",
        },
        1 => {
            w => 0,
            m => -1,
            c => "C",
        },
    },
    B => {
        0 => {
            w => 1,
            m => -1,
            c => "A",
        },
        1 => {
            w => 1,
            m => 1,
            c => "C",
        },
    },
    C => {
        0 => {
            w => 1,
            m => 1,
            c => "A",
        },
        1 => {
            w => 0,
            m => -1,
            c => "D",
        },
    },
    D => {
        0 => {
            w => 1,
            m => -1,
            c => "E",
        },
        1 => {
            w => 1,
            m => -1,
            c => "C",
        },
    },
    E => {
        0 => {
            w => 1,
            m => 1,
            c => "F",
        },
        1 => {
            w => 1,
            m => 1,
            c => "A",
        },
    },
    F => {
        0 => {
            w => 1,
            m => 1,
            c => "A",
        },
        1 => {
            w => 1,
            m => 1,
            c => "E",
        },
    },
);

my @tape = (0);
my $cursor = 0;
my $state = "A";

while ($steps--) {
    # say "Tape: @tape";
    # say "State: $state";
    my %instrucs = %{ $states{$state}->{$tape[$cursor]} };
    $tape[$cursor] = $instrucs{w};
    $cursor += $instrucs{m};
    if ($cursor < 0) {
        unshift @tape, 0;
        $cursor++;
    }
    if ($cursor > $#tape) {
        push @tape, 0;
    }
    $state = $instrucs{c};
}

say sum @tape;
