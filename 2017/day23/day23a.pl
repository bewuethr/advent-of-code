#!/usr/bin/perl

use strict;
use warnings;
no warnings 'experimental';

use v5.10.1;

my $fname = shift;

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
    given ($instr[0]) {
        when (/set/) {
            $regs{$instr[1]} = $instr[2] =~ /\d/ ? $instr[2] : $regs{$instr[2]};
            $idx++;
        }
        when (/sub/) {
            $regs{$instr[1]} -= $instr[2] =~ /\d/ ? $instr[2] : $regs{$instr[2]};
            $idx++;
        }
        when (/mul/) {
            $regs{$instr[1]} *= $instr[2] =~ /\d/ ? $instr[2] : $regs{$instr[2]};
            $idx++;
            $ctr++;
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
    last if ($idx < 0 or $idx > $#arr);
}

say $ctr;
