#!/usr/bin/perl

use strict;
use warnings;

use feature 'say';

use List::MoreUtils qw(firstval);

sub visit {
    my ($con, $seen, $el) = @_;

    foreach my $val ( @{ $con->{$el} } ) {
        if (not $seen->{$val}++) {
            visit($con, $seen, $val);
        }
    }
    return;
}

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

my %con;
my $progs = 0;

while (my $line = <$fh>) {
    chomp $line;
    my @arr = split /[ <>,-]+/, $line;
    $con{$arr[0]} = [ @arr[1 .. $#arr] ];
    $progs++;
}

my %seen;
my $groups = 0;

while (scalar keys %seen < $progs) {
    my $el = firstval { not $seen{$_} } ( 0 .. $progs-1 );
    $seen{$el}++;
    visit(\%con, \%seen, $el);
    $groups++;
}

say $groups;
