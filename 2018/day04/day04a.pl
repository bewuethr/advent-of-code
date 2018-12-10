#!/usr/bin/perl

use warnings;
use strict;

use feature 'say';

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

chomp (my @lines = sort <$fh>);

my $times;

my $re1 = qr/:..\] Guard #(\w+) begins/;
my $re2 =  qr/(..)\] falls/;
my $re3 =  qr/(..)\] wakes/;

my $currentGuard;
my ($from, $to);

foreach my $line (@lines) {
	chomp $line;
	if ($line =~ $re1) {
		$currentGuard = $1;
	}
	if ($line =~ $re2) {
		$from = $1;
	}
	if ($line =~ $re3) {
		$to = $1;
		$times->{$currentGuard}{total} += $to - $from;
		foreach my $minute ($from .. $to-1) {
			$times->{$currentGuard}{minutes}{$minute}++;
		}
	}
}

my $max = 0;
my $sleepiest;
my $sid;
foreach my $guard (keys %$times) {
	if ($times->{$guard}{total} > $max) {
		$max = $times->{$guard}{total};
		$sleepiest = $times->{$guard};
		$sid = $guard;
	}
}

my $minuteMax = 0;
my $bestMinute = -1;
foreach my $minute (keys %{$sleepiest->{minutes}}) {
	if ($sleepiest->{minutes}{$minute} > $minuteMax) {
		$minuteMax = $sleepiest->{minutes}{$minute};
		$bestMinute = $minute;
	}
}

say $sid * $bestMinute;
