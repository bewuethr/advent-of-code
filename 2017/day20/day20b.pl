#!/usr/bin/perl

use strict;
use warnings;

use feature 'say';

use Algorithm::Combinatorics qw(permutations combinations variations);
use Data::Dumper;
$Data::Dumper::Sortkeys = 1;
use Digest::MD5 qw(md5_hex);
use File::Slurp;
use Graph::Simple;
use List::MoreUtils qw(firstval mesh uniq frequency firstidx lastidx singleton);
use List::Util qw(reduce max min product sum);
use Math::Prime::Util qw(fordivisors);

sub eliminate {
    my ($particles, $poshash) = @_;
    # print "Eliminate: ", Dumper($poshash);
    foreach my $coord (keys %$poshash) {
        if (@{ $poshash->{$coord} } > 1) {
            # say "Deleting!";
            delete $particles->{$_} for @{ $poshash->{$coord} };
        }
    }
}

sub update {
    my ($particles) = @_;
    my $poshash = {};
    foreach my $idx (keys %$particles) {
        my $particle = $particles->{$idx};
        foreach my $coord (qw{x y z}) {
            $particle->{v}{$coord} += $particle->{a}{$coord};
            $particle->{p}{$coord} += $particle->{v}{$coord};
        }
        push @{ $poshash->{ join "/", map { $particle->{p}{$_} } sort keys %{ $particle->{p} } } }, $idx;
        $particles->{$idx} = $particle;
    }
    # print "At end of update loop: ", Dumper($poshash);
    return $poshash;
}

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

my %particles;
my $poshash;

while (my $line = <$fh>) {
    chomp $line;
    my @arr = split / /, $line;
    my $idx = keys %particles;
    $particles{$idx} = {};
    my $newest = $particles{$idx};
    $arr[0] =~ /(-?\d+),(-?\d+),(-?\d+)/g;
    $newest->{p} = { x => $1, y => $2, z => $3 };
    $arr[1] =~ /(-?\d+),(-?\d+),(-?\d+)/g;
    $newest->{v} = { x => $1, y => $2, z => $3 };
    $arr[2] =~ /(-?\d+),(-?\d+),(-?\d+)/g;
    $newest->{a} = { x => $1, y => $2, z => $3 };
    push @{ $poshash->{ join "/", map { $newest->{p}{$_} } sort keys %{ $newest->{p} } } }, $idx;
}

# print Dumper(\%particles);
# print Dumper($poshash);

my $ctr = 0;

while (1) {
    say "Iteration ", ++$ctr, ": ", scalar keys %particles, " particles";
    eliminate(\%particles, $poshash);
    $poshash = update(\%particles);
    # print Dumper(\%poshash);
}
