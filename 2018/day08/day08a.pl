#!/usr/bin/perl

use warnings;
use strict;

use feature 'say';

use List::Util qw(sum);

sub makenode {
	my ($arr, $idx, $metasum) = @_;
	my ($childCount, $metaCount) = ($arr->[$$idx], $arr->[$$idx+1]);
	$$idx += 2;
	my $node = {};
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

say $metasum;
