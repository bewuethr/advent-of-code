#!/usr/bin/perl

use warnings;
use strict;

use feature 'say';

my @r;

my %ops = (
	addr => sub { $r[$_[2]] = $r[$_[0]] + $r[$_[1]] },
	addi => sub { $r[$_[2]] = $r[$_[0]] + $_[1] },
	mulr => sub { $r[$_[2]] = $r[$_[0]] * $r[$_[1]] },
	muli => sub { $r[$_[2]] = $r[$_[0]] * $_[1] },
	banr => sub { $r[$_[2]] = ($r[$_[0]] & $r[$_[1]]) },
	bani => sub { $r[$_[2]] = ($r[$_[0]] & $_[1]) },
	borr => sub { $r[$_[2]] = ($r[$_[0]] | $r[$_[1]]) },
	bori => sub { $r[$_[2]] = ($r[$_[0]] | $_[1]) },
	setr => sub { $r[$_[2]] = $r[$_[0]] },
	seti => sub { $r[$_[2]] = $_[0] },
	gtir => sub { $r[$_[2]] = ($_[0] > $r[$_[1]]) + 0 },
	gtri => sub { $r[$_[2]] = ($r[$_[0]] > $_[1]) + 0 },
	gtrr => sub { $r[$_[2]] = ($r[$_[0]] > $r[$_[1]]) + 0 },
	eqir => sub { $r[$_[2]] = ($_[0] == $r[$_[1]]) + 0 },
	eqri => sub { $r[$_[2]] = ($r[$_[0]] == $_[1]) + 0 },
	eqrr => sub { $r[$_[2]] = ($r[$_[0]] == $r[$_[1]]) + 0 },
);

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

my $ptrLine = <$fh>;
chomp $ptrLine;
my $ipIdx = (split / /, $ptrLine)[1];

my @instr;

while (my $line = <$fh>) {
	chomp $line;
	my @arr = split / /, $line;
	push @instr, {
		opcode => $arr[0],
		args   => [ map { $_ + 0 } @arr[1 .. $#arr]  ],
	};
}

# Find index of relevant instruction: register comparison involving register 0
my ($relIdx) = grep {
	$instr[$_]{opcode} eq "eqrr" and (
		$instr[$_]{args}[0] == 0 or
		$instr[$_]{args}[1] == 0
	)
} (0 .. $#instr);

my @relInstr = split / /, $instr[$relIdx];
my $relReg = $instr[$relIdx]{args}[0] == 0 ? $instr[$relIdx]{args}[1] : $instr[$relIdx]{args}[0];

my %counts;

@r = (0, 0, 0, 0, 0, 0);
my $ip = $r[$ipIdx];
my $prev;

while (1) {
	$r[$ipIdx] = $ip;
	$ops{$instr[$ip]{opcode}}( @{ $instr[$ip]{args}  } );

	if ($ip == $relIdx) {
		$counts{$r[$relReg]}++;
		if ($counts{$r[$relReg]} == 2) {
			say $prev;
			last;
		}
		$prev = $r[$relReg];
	}
	$ip = $r[$ipIdx] + 1;
}
