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

my $len = length($state);

say $state;
say Dumper(\%rules);

my $offset = 20;

$state = '.' x $offset . $state . '.' x 50;
say "000: $state";
my $newState = '.' x length($state);

foreach my $gen (1 .. 100) {
	printf "%03d: ", $gen;
	foreach my $idx (2 .. length($state)-3) {
		substr $newState, $idx, 1, $rules{substr $state, $idx-2, 5};
	}
	$newState .= '.' if $newState =~ /#\.{4}$/;
	say $newState;
	$state = $newState;
}

my $sum = 0;

foreach my $idx (0 .. length($state)-1) {
	$sum += $idx - $offset if (substr($state, $idx, 1) eq '#');
}

say $sum;

say scalar grep { $_ eq '#' } split //, $state;

__END__

And then use bc:
4184 + 38 * (50000000000 - 100)
