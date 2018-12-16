#!/usr/bin/perl

use warnings;
no warnings 'experimental';
use strict;

use feature 'say';

our @r;

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
	gtir => sub { $r[$_[2]] = $_[0] > $r[$_[1]] },
	gtri => sub { $r[$_[2]] = $r[$_[0]] > $_[1] },
	gtrr => sub { $r[$_[2]] = $r[$_[0]] > $r[$_[1]] },
	eqir => sub { $r[$_[2]] = $_[0] == $r[$_[1]] },
	eqri => sub { $r[$_[2]] = $r[$_[0]] == $_[1] },
	eqrr => sub { $r[$_[2]] = $r[$_[0]] == $r[$_[1]] },
);

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

	my @rBefore = $before =~ /(\d+), (\d+), (\d+), (\d)/;
	my ($opcode, @args) = split / /, $instr;
	my (@rExpect) = $after =~ /(\d+), (\d+), (\d+), (\d)/;

	foreach my $op (keys %ops) {
		@r = @rBefore;
		$ops{$op}(@args);
		$cands{$opcode}{$op} = 1 if @r ~~ @rExpect;
	}
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

@r = (0, 0, 0, 0);

# Read and solve program
while (my $line = <$fh>) {
	chomp $line;
	next if $line eq "";
	my ($opcode, @args) = split / /, $line;

	$ops{$opcodes{$opcode}}(@args);
}

say $r[0];
