#!/usr/bin/perl

use warnings;
use strict;

use feature 'say';

use List::Util qw(max min reduce sum);
use List::MoreUtils qw(firstidx firstval pairwise singleton);
use Algorithm::Combinatorics qw(variations);
use Math::Prime::Util qw(is_prime);
use Data::Dumper;
$Data::Dumper::Sortkeys = 1;

our @r;

our $debug = 1;

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
@r = (0, 10551200, 10551277, 1, 10551200, 4);
@r = (1, 959200, 10551277, 11, 10551200, 4);
@r = (12, 10551275, 10551277, 11, 116064025, 4);
@r = (12, 10, 10551277, 959207, 9592070, 4);
@r = (959219, 1, 10551277, 10551277, 0, 3);
@r = (11510496, 10551276, 10551277, 10551277, 0, 3);
my $ip = $r[$ipIdx];
$ip = 3;

while (1) {
	my ($opcode, @args) = split / /, $instr[$ip];
	$r[$ipIdx] = $ip;
	printf "ip=%2d [" . "%8d, " x 5 . "%8d] $opcode @args ", $ip, @r if $debug;
	$ops{$opcode}(@args);
	printf "[" . "%8d, " x 5 . "%8d]\n", @r if $debug;
	$ip = $r[$ipIdx] + 1;
	last if $ip > $#instr or $ip < 0;
}

say $r[0];
