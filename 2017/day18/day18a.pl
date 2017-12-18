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
my $freq;
my %regs;

while (1) {
    my @instr = split / /, $arr[$idx];
    $regs{$instr[1]} //= 0 if not $instr[1] =~ /\d/;
    given ($instr[0]) {
        when (/snd/) {
            $freq = $instr[1] =~ /\d/ ? $instr[1] : $regs{$instr[1]};
            $idx++;
        }
        when (/set/) {
            $regs{$instr[1]} = $instr[2] =~ /\d/ ? $instr[2] : $regs{$instr[2]};
            $idx++;
        }
        when (/add/) {
            $regs{$instr[1]} += $instr[2] =~ /\d/ ? $instr[2] : $regs{$instr[2]};
            $idx++;
        }
        when (/mul/) {
            $regs{$instr[1]} *= $instr[2] =~ /\d/ ? $instr[2] : $regs{$instr[2]};
            $idx++;
        }
        when (/mod/) {
            $regs{$instr[1]} %= $instr[2] =~ /\d/ ? $instr[2] : $regs{$instr[2]};
            $idx++;
        }
        when (/rcv/) {
            if ($regs{$instr[1]} != 0) {
                say $freq;
                exit;
            }
            $idx++;
        }
        when (/jgz/) {
            if ($regs{$instr[1]} > 0) {
                $idx += $instr[2] =~ /\d/ ? $instr[2] : $regs{$instr[2]};
            }
            else {
                $idx++;
            }
        }
    }
}
