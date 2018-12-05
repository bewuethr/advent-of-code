#!/usr/bin/perl

use warnings;
use strict;

use feature 'say';

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

my $line = <$fh>;
chomp $line;

my @arr = split //, $line;
my @new;

my $before = @arr;

while (1) {
	my ($cur, $next) = (0, 1);
	while (1) {
		if ($next > $#arr) {
			push @new, $arr[$cur];
			last;
		}
		if ($arr[$cur] =~ /[[:lower:]]/ and $arr[$next] =~ /[[:upper:]]/ or
			$arr[$cur] =~ /[[:upper:]]/ and $arr[$next] =~ /[[:lower:]]/) {
			if (lc $arr[$cur] eq lc $arr[$next]) {
				$cur = $next + 1;
				$next = $cur + 1;
				next;
			}
		}
		push @new, $arr[$cur];
		$cur++;
		$next++;
	}
	last if @new == $before;
	@arr = ();
	@arr = @new;
	@new = ();
	$before = @arr;
}

say scalar @new;
