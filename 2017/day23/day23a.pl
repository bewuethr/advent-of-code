#!/usr/bin/perl

use strict;
use warnings;
no warnings 'experimental';

use v5.10.1;

use Algorithm::Combinatorics qw(permutations combinations variations);
use Data::Dumper;
use Digest::MD5 qw(md5_hex);
use File::Slurp;
use Graph::Simple;
use List::MoreUtils qw(firstval mesh uniq frequency firstidx lastidx pairwise singleton);
use List::Util qw(reduce max min product sum);
use Math::Prime::Util qw(fordivisors);

my $fname = shift;
my $debug = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

chomp(my @arr = <$fh>);

my $idx = 0;
my $ctr =0;
my %regs = (
    a => 0,
    b => 0,
    c => 0,
    d => 0,
    e => 0,
    f => 0,
    g => 0,
    h => 0,
);

while (1) {
    my @instr = split / /, $arr[$idx];
    say $idx+1, ": @instr" if $debug;
    given ($instr[0]) {
        when (/set/) {
            $regs{$instr[1]} = $instr[2] =~ /\d/ ? $instr[2] : $regs{$instr[2]};
            $idx++;
        }
        when (/sub/) {
            $regs{$instr[1]} -= $instr[2] =~ /\d/ ? $instr[2] : $regs{$instr[2]};
            $idx++;
        }
        when (/add/) {
            $regs{$instr[1]} += $instr[2] =~ /\d/ ? $instr[2] : $regs{$instr[2]};
            $idx++;
        }
        when (/mul/) {
            $regs{$instr[1]} *= $instr[2] =~ /\d/ ? $instr[2] : $regs{$instr[2]};
            $idx++;
            $ctr++;
        }
        when (/mod/) {
            $regs{$instr[1]} %= $instr[2] =~ /\d/ ? $instr[2] : $regs{$instr[2]};
            $idx++;
        }
        when (/jnz/) {
            if ( ( $instr[1] =~ /\d/ ? $instr[1] : $regs{$instr[1]} ) != 0) {
                $idx += $instr[2] =~ /\d/ ? $instr[2] : $regs{$instr[2]};
            }
            else {
                $idx++;
            }
        }
    }
    if ($debug) {
        say "a\tb\tc\td\te\tf\tg\th";
        say join "\t", @regs{qw/a b c d e f g h/}, "\n====";
    }
    last if ($idx < 0 or $idx > $#arr);
}

say $ctr;
