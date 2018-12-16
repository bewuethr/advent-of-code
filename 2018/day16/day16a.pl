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

my $total = 0;

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

	my $count = 0;
	foreach my $op (keys %ops) {
		@r = @rBefore;
		$ops{$op}(@args);
		$count++ if @r ~~ @rExpect;
	}

	$total++ if $count >= 3;
}

say $total;
