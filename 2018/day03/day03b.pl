#!/usr/bin/perl

use warnings;
use strict;

use feature 'say';

use List::Util qw(max min reduce sum);
use List::MoreUtils qw(firstidx firstval pairwise singleton listcmp);
use Algorithm::Combinatorics qw(variations);
use Math::Prime::Util qw(is_prime);
use Data::Dumper;
$Data::Dumper::Sortkeys = 1;

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

my %squares;

while (my $line = <$fh>) {
	chomp $line;
	# say $line;
	my (undef, $id, $dx, $dy, $w, $h) = split qr{[# @,:x]+}, $line;
	foreach my $y ($dy .. $dy+$h-1)  {
		foreach my $x ($dx .. $dx+$w-1) {
			# say "x: $x, y: $y";
			$squares{$x, $y}[0]++;
			push @{$squares{$x, $y}[1]}, $id;
			# say Dumper(\%squares);
		}
	}
}

# say Dumper(\%squares);

my %singles;
my %multiples;
foreach my $idlist (values %squares) {
	if (@{$idlist->[1]} == 1) {
		$singles{$idlist->[1][0]} = 1;
	}
	else {
		foreach my $id (@{$idlist->[1]}) {
			$multiples{$id} = 1;
		}
	}
}

# say Dumper(\%singles);
# say Dumper(\%multiples);

say grep { not exists $multiples{$_} } keys %singles;
