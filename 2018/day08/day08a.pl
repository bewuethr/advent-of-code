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

sub makenode {
	my ($arr, $idx, $metasum) = @_;
	my ($childCount, $metaCount) = ($arr->[$$idx], $arr->[$$idx+1]);
	$$idx += 2;
	my $node = {
		header => {
			childCount => $childCount,
			metaCount  => $metaCount,
		}
	};
	push @{ $node->{children} }, makenode($arr, $idx, $metasum) while $childCount--;
	push @{ $node->{meta} }, $arr->[$$idx++] while $metaCount--;
	$$metasum += sum @{ $node->{meta} };
	return $node;
}

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

my $line = <$fh>;
chomp $line;
my @arr = split / /, $line;

my $idx = 0;
my $metasum = 0;

my $tree = makenode(\@arr, \$idx, \$metasum);

say Dumper($tree);

say $metasum;
