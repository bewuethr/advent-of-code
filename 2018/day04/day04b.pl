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


my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

my $times;

my $re1 = qr/:..\] Guard #(\w+) begins/;
my $re2 =  qr/(..)\] falls/;
my $re3 =  qr/(..)\] wakes/;

my $currentGuard;
my ($from, $to);

while (my $line = <$fh>) {
	chomp $line;
	if ($line =~ $re1) {
		say $line;
		# say $1;
		$currentGuard = $1;
	}
	if ($line =~ $re2) {
		say $line;
		$from = $1;
		# say $from;
	}
	if ($line =~ $re3) {
		say $line;
		$to = $1;
		# say $to;
		$times->{$currentGuard}{total} += $to - $from;
		foreach my $minute ($from .. $to-1) {
			$times->{$currentGuard}{minutes}{$minute}++;
		}
		# say Dumper($times);
	}
}
say Dumper($times);

my $max = 0;
my $bestMinute;
my $sid;
foreach my $guard (keys %$times) {
	foreach my $minute (keys %{$times->{$guard}{minutes}}) {
		if ($times->{$guard}{minutes}{$minute} > $max) {
			$max = $times->{$guard}{minutes}{$minute};
			$bestMinute = $minute;
			$sid = $guard;
		}
	}
}

say $sid * $bestMinute;
