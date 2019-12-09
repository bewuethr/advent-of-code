#!/usr/bin/perl

use warnings;
use strict;

use feature 'say';

my $fname = shift;

open my $fh, "<", $fname
  or die "Can't open $fname: $!";

my $line = <$fh>;
chomp $line;
my @p = split /,/, $line;

my $step;

my $radiatiorID = 5;
my $i           = 0;
while (1) {
    my $instr = $p[$i];
    my $opcode;
    my @modes = ( 0, 0, 0 );
    if ( length $instr > 2 ) {
        $opcode = substr( $instr, -1 );
        @modes  = reverse split //, $instr =~ s/..$//r;
        push @modes, 0 while @modes < 3;
    }
    else {
        $opcode = $instr;
    }
    last if $opcode == 99;
    if ( $opcode == 1 ) {    # addition
        my $arg1 = $modes[0] == 0 ? $p[ $p[ $i + 1 ] ] : $p[ $i + 1 ];
        my $arg2 = $modes[1] == 0 ? $p[ $p[ $i + 2 ] ] : $p[ $i + 2 ];
        $p[ $p[ $i + 3 ] ] = $arg1 + $arg2;
        $step = 4;
    }
    elsif ( $opcode == 2 ) {    # multiplication
        my $arg1 = $modes[0] == 0 ? $p[ $p[ $i + 1 ] ] : $p[ $i + 1 ];
        my $arg2 = $modes[1] == 0 ? $p[ $p[ $i + 2 ] ] : $p[ $i + 2 ];
        $p[ $p[ $i + 3 ] ] = $arg1 * $arg2;
        $step = 4;
    }
    elsif ( $opcode == 3 ) {    # input
        $p[ $p[ $i + 1 ] ] = $radiatiorID;
        $step = 2;
    }
    elsif ( $opcode == 4 ) {    # output
        my $arg1 = $modes[0] == 0 ? $p[ $p[ $i + 1 ] ] : $p[ $i + 1 ];
        say $arg1;
        $step = 2;
    }
    elsif ( $opcode == 5 ) {    # jump-if-true
        my $arg1 = $modes[0] == 0 ? $p[ $p[ $i + 1 ] ] : $p[ $i + 1 ];
        my $arg2 = $modes[1] == 0 ? $p[ $p[ $i + 2 ] ] : $p[ $i + 2 ];
        if ( $arg1 != 0 ) {
            $i    = $arg2;
            $step = 0;
        }
        else {
            $step = 3;
        }
    }
    elsif ( $opcode == 6 ) {    # jump-if-false
        my $arg1 = $modes[0] == 0 ? $p[ $p[ $i + 1 ] ] : $p[ $i + 1 ];
        my $arg2 = $modes[1] == 0 ? $p[ $p[ $i + 2 ] ] : $p[ $i + 2 ];
        if ( $arg1 == 0 ) {
            $i    = $arg2;
            $step = 0;
        }
        else {
            $step = 3;
        }
    }
    elsif ( $opcode == 7 ) {    # less-than
        my $arg1 = $modes[0] == 0 ? $p[ $p[ $i + 1 ] ] : $p[ $i + 1 ];
        my $arg2 = $modes[1] == 0 ? $p[ $p[ $i + 2 ] ] : $p[ $i + 2 ];
        $p[ $p[ $i + 3 ] ] = $arg1 < $arg2 ? 1 : 0;
        $step = 4;
    }
    elsif ( $opcode == 8 ) {    # equals
        my $arg1 = $modes[0] == 0 ? $p[ $p[ $i + 1 ] ] : $p[ $i + 1 ];
        my $arg2 = $modes[1] == 0 ? $p[ $p[ $i + 2 ] ] : $p[ $i + 2 ];
        $p[ $p[ $i + 3 ] ] = $arg1 == $arg2 ? 1 : 0;
        $step = 4;
    }
    else {
        die "illegal opcode at index $i: $opcode";
    }
    $i += $step;
}
