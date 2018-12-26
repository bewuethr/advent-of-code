#!/usr/bin/perl

use warnings;
use strict;

use feature 'say';

use Data::Dumper;

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

chomp(my @instr = <$fh>);

# Find index of relevant instruction: register comparison involving register 0
my ($relIdx) = grep {
	$instr[$_] =~ /^eqrr/ and (
		(split / /, $instr[$_])[1] == 0 or
		(split / /, $instr[$_])[2] == 0
	)
} (0 .. $#instr);

my @relInstr = split / /, $instr[$relIdx];
my $relReg = $relInstr[1] == 0 ? $relInstr[2] : $relInstr[1];

@r = (0, 0, 0, 0, 0, 0);
my $ip = $r[$ipIdx];

while (1) {
	my ($opcode, @args) = split / /, $instr[$ip];

	# Make sure that arguments are not treated as strings
	@args = map { $_ + 0 } @args;

	$r[$ipIdx] = $ip;
	$ops{$opcode}(@args);

	if ($ip == $relIdx) {
		say "Register $relReg: $r[$relReg]";
		exit;
	}
	$ip = $r[$ipIdx] + 1;
}
