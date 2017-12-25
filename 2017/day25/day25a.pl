#!/usr/bin/perl

use strict;
use warnings;

use feature 'say';

use List::Util qw(sum);

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

my $line = <$fh>;
my ($state) = $line =~ /state ([A-Z])/;
$line = <$fh>;
my ($steps) = $line =~ /(\d+)/;

my %states;

while ($line = <$fh>) {
    chomp $line;
    if ($line =~ /^In state/) {
        my ($key) = $line =~ /^In state ([A-Z])/;
        foreach my $curval (0, 1) {
            <$fh>;
            my ($w) = <$fh> =~ /(\d+)/;
            my ($m) = <$fh> =~ /(left|right)/;
            my ($c) = <$fh> =~ /state ([A-Z])/;
            $states{$key}{$curval} = {
                w => $w,
                m => $m eq 'left' ? -1 : 1,
                c => $c,
            };
        }
    }
}

my @tape = (0);
my $cursor = 0;

while ($steps--) {
    my $instrucs = $states{$state}{$tape[$cursor]};
    $tape[$cursor] = $instrucs->{w};
    $cursor += $instrucs->{m};
    if ($cursor < 0) {
        unshift @tape, 0;
        $cursor++;
    }
    if ($cursor > $#tape) {
        push @tape, 0;
    }
    $state = $instrucs->{c};
}

say sum @tape;
