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

my $line = <$fh>;
chomp $line;
my $shortest = length $line;

foreach my $remove ('a' .. 'z') {
	my $input = $line =~ s/$remove//gir;
	# say $input;

	my @arr = split //, $input;
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
					# say "cur: $cur - $arr[$cur], next: $next - $arr[$next]";
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
		# say "@arr";
		# say $before;
	}

	if (@new < $shortest) {
		$shortest = @new;
		say "New shortest: $shortest";
	}
}

say $shortest;
