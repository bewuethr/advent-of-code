#!/usr/bin/perl

use strict;
use warnings;

use feature 'say';

sub eliminate {
    my ($particles, $poshash) = @_;
    foreach my $coord (keys %$poshash) {
        if (@{ $poshash->{$coord} } > 1) {
            delete $particles->{$_} for @{ $poshash->{$coord} };
        }
    }
}

sub update {
    my ($particles, $poshash) = @_;
    %$poshash = ();
    foreach my $idx (keys %$particles) {
        my $particle = $particles->{$idx};
        foreach my $coord (qw{x y z}) {
            $particle->{v}{$coord} += $particle->{a}{$coord};
            $particle->{p}{$coord} += $particle->{v}{$coord};
        }
        push @{ $poshash->{ join "/", map { $particle->{p}{$_} } sort keys %{ $particle->{p} } } }, $idx;
    }
}

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

my %particles;
my %poshash;

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
    push @{ $poshash{ join "/", map { $newest->{p}{$_} } sort keys %{ $newest->{p} } } }, $idx;
}

my @n_particles;

while (1) {
    push @n_particles, scalar keys %particles;
    shift @n_particles if @n_particles > 50;
    last if @n_particles == 50 and $n_particles[0] == $n_particles[-1];
    eliminate(\%particles, \%poshash);
    update(\%particles, \%poshash);
}

say $n_particles[0];
