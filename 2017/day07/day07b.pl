#!/usr/bin/perl

use strict;
use warnings;

use feature 'say';

use Algorithm::Combinatorics qw(permutations combinations variations);
use Data::Dumper;
use Digest::MD5 qw(md5_hex);
use File::Slurp;
use Graph::Simple;
use List::MoreUtils qw(mesh uniq frequency firstidx lastidx);
use List::Util qw(max min product sum);
use Math::Prime::Util qw(fordivisors);

sub getweight {
    my ($node, $data) = @_;
    my $debug = 0;
    say "looking at $node" if $debug;
    my $weight = $data->{$node}{weight};
    return $weight if not exists $data->{$node}{children};
    say "$node has children" if $debug;

    foreach my $child (keys %{ $data->{$node}{children} }) {
        say "getting weight for $child" if $debug;
        $data->{$node}{children}{$child} = getweight($child, $data);
        say "weight for $child is $data->{$node}{children}{$child}" if $debug;
    }
    print "Children of $node: " . Dumper($data->{$node}{children}) if $debug;
    return $weight + sum values %{ $data->{$node}{children} };
}


my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

my $res = 0;

my $root = 'dgoocsw';
# my $root = 'tknk';
my %data;

while (my $line = <$fh>) {
    chomp $line;
    my @arr = split /[- (),>]+/, $line;
    $data{$arr[0]}{weight} = $arr[1];
    $data{$arr[0]}{children} = { map { $_ => 0 }  @arr[2..$#arr] } if $#arr > 1;
}

my $node = $root;
getweight($node, \%data);

print Dumper(\%data);

say $res; # Now inspect me manually!
