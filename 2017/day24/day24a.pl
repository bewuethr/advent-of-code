#!/usr/bin/perl

use strict;
use warnings;

use feature 'say';

use Algorithm::Combinatorics qw(permutations combinations variations);
use Data::Dumper;
$Data::Dumper::Sortkeys = 1;
$Data::Dumper::Indent = 0;
use Digest::MD5 qw(md5_hex);
use File::Slurp;
use Graph::Simple;
use List::MoreUtils qw(firstval mesh uniq frequency firstidx lastidx pairwise singleton);
use List::Util qw(reduce max min product sum);
use Math::Prime::Util qw(fordivisors);

our $debug = 0;

sub findstrongest {
    my ($first, $comps) = @_;
    say "Called with head $first, elements: ", Dumper($comps) if $debug;
    my $strongest = 0;
    foreach my $idx (0 .. $#$comps) {
        if ($comps->[$idx][0] == $first or $comps->[$idx][1] == $first) {
            say "Checking subbridge starting with ", Dumper($comps->[$idx]) if $debug;
            my $newfirst = $comps->[$idx][0] == $first ? $comps->[$idx][1] : $comps->[$idx][0];
            my @newcomps = @$comps;
            splice @newcomps, $idx, 1;
            my $strength = sum @{ $comps->[$idx] };
            $strength += findstrongest($newfirst, \@newcomps);
            $strongest = max ($strongest, $strength);
            say "Current strongest: $strongest" if $debug;
        }
    }
    return $strongest;
}

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

chomp(my @comps = <$fh>);
my @starts;

foreach my $idx (0 .. $#comps) {
    $comps[$idx] = [ sort { $a+0 <=> $b+0 } split /\//, $comps[$idx] ];
}

# print Dumper(\@comps);

my $strongest = findstrongest(0, \@comps);

say $strongest;
