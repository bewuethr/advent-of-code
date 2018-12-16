#!/usr/bin/perl

use 5.010;
use warnings;
no warnings 'experimental';
use strict;

use feature 'say';

sub matches {
	my ($rb, $i, $ra, $cands) = @_;

	# addr
	$cands->{$i->{op}}{addr} = 1 if $ra->[$i->{C}] == $rb->[$i->{A}] + $rb->[$i->{B}];

	# addi
	$cands->{$i->{op}}{addi} = 1 if $ra->[$i->{C}] == $rb->[$i->{A}] + $i->{B};

	# mulr
	$cands->{$i->{op}}{mulr} = 1 if $ra->[$i->{C}] == $rb->[$i->{A}] * $rb->[$i->{B}];

	# muli
	$cands->{$i->{op}}{muli} = 1 if $ra->[$i->{C}] == $rb->[$i->{A}] * $i->{B};

	# banr
	$cands->{$i->{op}}{banr} = 1 if $ra->[$i->{C}] == ($rb->[$i->{A}] & $rb->[$i->{B}]);

	# bani
	$cands->{$i->{op}}{bani} = 1 if $ra->[$i->{C}] == ($rb->[$i->{A}] & $i->{B});

	# borr
	$cands->{$i->{op}}{borr} = 1 if $ra->[$i->{C}] == ($rb->[$i->{A}] | $rb->[$i->{B}]);

	# bori
	$cands->{$i->{op}}{bori} = 1 if $ra->[$i->{C}] == ($rb->[$i->{A}] | $i->{B});

	# setr
	$cands->{$i->{op}}{setr} = 1 if $ra->[$i->{C}] == $rb->[$i->{A}];

	# seti
	$cands->{$i->{op}}{seti} = 1 if $ra->[$i->{C}] == $i->{A};

	# gtir
	$cands->{$i->{op}}{gtir} = 1 if $ra->[$i->{C}] == ($i->{A} > $rb->[$i->{B}]);

	# gtri
	$cands->{$i->{op}}{gtri} = 1 if $ra->[$i->{C}] == ($rb->[$i->{A}] > $i->{B});

	# gtrr
	$cands->{$i->{op}}{gtrr} = 1 if $ra->[$i->{C}] == ($rb->[$i->{A}] > $rb->[$i->{B}]);

	# eqir
	$cands->{$i->{op}}{eqir} = 1 if $ra->[$i->{C}] == ($i->{A} == $rb->[$i->{B}]);

	# eqri
	$cands->{$i->{op}}{eqri} = 1 if $ra->[$i->{C}] == ($rb->[$i->{A}] == $i->{B});

	# eqrr
	$cands->{$i->{op}}{eqrr} = 1 if $ra->[$i->{C}] == ($rb->[$i->{A}] == $rb->[$i->{B}]);
}

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

my %cands;

while (1) {
	my $before = <$fh>;
	chomp $before;
	last if $before eq "";
	my $instr = <$fh>;
	chomp $instr;
	my $after = <$fh>;
	chomp $after;
	my $blank = <$fh>;

	my (@rb) = $before =~ /(\d+), (\d+), (\d+), (\d)/;
	my ($opcode, $A, $B, $C) = split / /, $instr;
	my %i = (
		op => $opcode,
		A => $A,
		B => $B,
		C => $C,
	);
	my (@ra) = $after =~ /(\d+), (\d+), (\d+), (\d)/;

	matches(\@rb, \%i, \@ra, \%cands);
}

my %opcodes;

# Find opcodes
while (1) {
	last unless scalar keys %cands;
	my @unambi = grep { my @k = keys %{ $cands{$_} }; @k == 1 } keys %cands;
	foreach my $opcode (@unambi) {
		$opcodes{$opcode} = (keys %{ $cands{$opcode} })[0];
		delete $cands{$opcode};
		foreach my $key (keys %cands) {
			delete $cands{$key}{$opcodes{$opcode}};
		}
	}
}

my @r = (0, 0, 0, 0);

# Read and solve program
while (my $line = <$fh>) {
	chomp $line;
	next if $line eq "";
	my ($opcode, $A, $B, $C) = split / /, $line;

	given ($opcodes{$opcode}) {
		when('addr') { $r[$C] = $r[$A] + $r[$B] }
		when('addi') { $r[$C] = $r[$A] + $B }
		when('mulr') { $r[$C] = $r[$A] * $r[$B] }
		when('muli') { $r[$C] = $r[$A] * $B }
		when('banr') { $r[$C] = $r[$A] & $r[$B] }
		when('bani') { $r[$C] = $r[$A] & $B }
		when('borr') { $r[$C] = $r[$A] | $r[$B] }
		when('bori') { $r[$C] = $r[$A] | $B }
		when('setr') { $r[$C] = $r[$A] }
		when('seti') { $r[$C] = $A }
		when('gtir') { $r[$C] = $A > $r[$B] }
		when('gtri') { $r[$C] = $r[$A] > $B }
		when('gtrr') { $r[$C] = $r[$A] > $r[$B] }
		when('eqir') { $r[$C] = $A == $r[$B] }
		when('eqri') { $r[$C] = $r[$A] == $B }
		when('eqrr') { $r[$C] = $r[$A] == $r[$B] }
		default      { die "unknown opcode $opcodes{$opcode}" }
	}
}

say $r[0];
