#!/usr/bin/perl

use warnings;
use strict;

use feature 'say';

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

my $line = <$fh>;
chomp $line;
my $shortest = length $line;

foreach my $remove ('a' .. 'z') {
	my $input = $line =~ s/$remove//gir;

	my @arr = split //, $input;
	my @new;

	my $before = @arr;

	while (1) {
		my $cur = 0;
		while (1) {
			if ($cur >= $#arr) {
				push @new, $arr[$cur] if defined $arr[$cur];
				last;
			}
			if ($arr[$cur] =~ /[[:lower:]]/ and $arr[$cur+1] =~ /[[:upper:]]/ or
				$arr[$cur] =~ /[[:upper:]]/ and $arr[$cur+1] =~ /[[:lower:]]/) {
				if (lc $arr[$cur] eq lc $arr[$cur+1]) {
					$cur += 2;
					next;
				}
			}
			push @new, $arr[$cur];
			$cur++;
		}
		last if @new == $before;
		@arr = ();
		@arr = @new;
		@new = ();
		$before = @arr;
	}

	$shortest = @new if @new < $shortest;
}

say $shortest;
