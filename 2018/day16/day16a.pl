#!/usr/bin/perl

use warnings;
use strict;

use feature 'say';

sub matches {
	my ($rb, $i, $ra) = @_;
	my $count = 0;

	# addr
	$count++ if $ra->[$i->{C}] == $rb->[$i->{A}] + $rb->[$i->{B}];

	# addi
	$count++ if $ra->[$i->{C}] == $rb->[$i->{A}] + $i->{B};

	# mulr
	$count++ if $ra->[$i->{C}] == $rb->[$i->{A}] * $rb->[$i->{B}];

	# muli
	$count++ if $ra->[$i->{C}] == $rb->[$i->{A}] * $i->{B};

	# banr
	$count++ if $ra->[$i->{C}] == ($rb->[$i->{A}] & $rb->[$i->{B}]);

	# bani
	$count++ if $ra->[$i->{C}] == ($rb->[$i->{A}] & $i->{B});

	# borr
	$count++ if $ra->[$i->{C}] == ($rb->[$i->{A}] | $rb->[$i->{B}]);

	# bori
	$count++ if $ra->[$i->{C}] == ($rb->[$i->{A}] | $i->{B});

	# setr
	$count++ if $ra->[$i->{C}] == $rb->[$i->{A}];

	# seti
	$count++ if $ra->[$i->{C}] == $i->{A};

	# gtir
	$count++ if $ra->[$i->{C}] == ($i->{A} > $rb->[$i->{B}]);

	# gtri
	$count++ if $ra->[$i->{C}] == ($rb->[$i->{A}] > $i->{B});

	# gtrr
	$count++ if $ra->[$i->{C}] == ($rb->[$i->{A}] > $rb->[$i->{B}]);

	# eqir
	$count++ if $ra->[$i->{C}] == ($i->{A} == $rb->[$i->{B}]);

	# eqri
	$count++ if $ra->[$i->{C}] == ($rb->[$i->{A}] == $i->{B});

	# eqrr
	$count++ if $ra->[$i->{C}] == ($rb->[$i->{A}] == $rb->[$i->{B}]);

	return $count;
}

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

	my (@rb) = $before =~ /(\d+), (\d+), (\d+), (\d)/;
	my ($opcode, $A, $B, $C) = split / /, $instr;
	my %i = (
		op => $opcode,
		A => $A,
		B => $B,
		C => $C,
	);
	my (@ra) = $after =~ /(\d+), (\d+), (\d+), (\d)/;

	my $count = matches(\@rb, \%i, \@ra);
	$total++ if $count >= 3;
}

say $total;
