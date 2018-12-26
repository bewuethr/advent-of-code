#!/usr/bin/perl

use warnings;
use strict;

use feature 'say';

use List::Util qw(max sum);
use Math::Prime::Util qw(factor);

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

my $ptrLine = <$fh>;
chomp $ptrLine;
my $ipIdx = (split / /, $ptrLine)[1];

chomp(my @instr = <$fh>);

@r = (1, 0, 0, 0, 0,  0);
my $ip = $r[$ipIdx];

# Run fifty operations to find large constant
foreach my $i (1 .. 50) {
	my ($opcode, @args) = split / /, $instr[$ip];
	$r[$ipIdx] = $ip;
	$ops{$opcode}(@args);
	$ip = $r[$ipIdx] + 1;
}

my $n = max @r;

say ((sum factor($n)) + 1 + $n);
