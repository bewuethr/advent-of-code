#!/usr/bin/perl

use warnings;
use strict;

use feature 'say';

use List::Util qw(first max);

sub dist {
	my ($from, $to) = @_;
	return abs($from->{x} - $to->{x})
		+ abs($from->{y} - $to->{y})
		+ abs($from->{z} - $to->{z});
}

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

my @bots;

while (my $line = <$fh>) {
	chomp $line;
	my ($x, $y, $z, $r) = ( $line =~ /(-?\d+)/g );
	push @bots, { x => $x, y => $y, z => $z, r => $r };
}

my $strongest = first { $_->{r} == max map { $_->{r} } @bots } @bots;

say scalar grep { dist($strongest, $_) <= $strongest->{r} } @bots;
