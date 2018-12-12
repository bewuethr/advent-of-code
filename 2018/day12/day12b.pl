#!/usr/bin/perl

use warnings;
use strict;

use feature 'say';

use List::Util qw(sum);

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

my $state;
my %rules;

while (my $line = <$fh>) {
	chomp $line;
	if ($line =~ /initial/) {
		$state = (split / /, $line)[2];
		next;
	}
	next if $line =~ /^$/;
	my @arr = split / => /, $line;
	$rules{$arr[0]} = $arr[1];
}

my $pl = 5;	# length of a pattern

my $offset = $pl;

$state = '.' x $offset . $state . '.' x $pl;
say "000: $state";
my $newState = '.' x length($state);

my $gen = 1;
my $step = 0;

while (1) {
	printf "%03d: ", $gen;
	foreach my $idx (2 .. length($state)-3) {
		substr($newState, $idx, 1, $rules{ substr($state, $idx-int($pl/2), $pl) });
	}

	say $newState;
	my ($off, $statePtrn) = $state =~ /(\.*)(#.*#)/;
	my ($newOff, $newStatePtrn) = $newState =~ /(\.*)(#.*#)/;
	$step = length($newOff) - length($off);
	$state = $newState;

	last if $statePtrn eq $newStatePtrn;

	$newState .= '.' if substr($newState, -$pl) =~ /#/;
	if (substr($newState, 0, $pl) =~ /#/) {
		$newState = '.' . $newState;
		$offset++;
	}
	$gen++;
}

my $sum = sum
	map { $_ - $offset }
	grep { substr($state, $_, 1) eq '#' } (0 .. length($state)-1);

my $count = scalar grep { $_ eq '#' } split //, $state;

say $sum + $step * $count * (5_000_000_000 - $gen);
