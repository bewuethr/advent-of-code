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

my $acID = 1;
my $i    = 0;
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
    if ( $opcode == 1 ) {    # Addition
        my $arg1 = $modes[0] == 0 ? $p[ $p[ $i + 1 ] ] : $p[ $i + 1 ];
        my $arg2 = $modes[1] == 0 ? $p[ $p[ $i + 2 ] ] : $p[ $i + 2 ];
        $p[ $p[ $i + 3 ] ] = $arg1 + $arg2;
        $step = 4;
    }
    elsif ( $opcode == 2 ) {    # Multiplication
        my $arg1 = $modes[0] == 0 ? $p[ $p[ $i + 1 ] ] : $p[ $i + 1 ];
        my $arg2 = $modes[1] == 0 ? $p[ $p[ $i + 2 ] ] : $p[ $i + 2 ];
        $p[ $p[ $i + 3 ] ] = $arg1 * $arg2;
        $step = 4;
    }
    elsif ( $opcode == 3 ) {    # Input
        $p[ $p[ $i + 1 ] ] = $acID;
        $step = 2;
    }
    elsif ( $opcode == 4 ) {    # Output
        my $arg1 = $modes[0] == 0 ? $p[ $p[ $i + 1 ] ] : $p[ $i + 1 ];
        say $arg1;
        $step = 2;
    }
    else {
        die "illegal opcode at index $i: $opcode";
    }
    $i += $step;
}
