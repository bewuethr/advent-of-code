#!/usr/bin/perl

use strict;
use warnings;

use feature 'say';

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

while (my $line = <$fh>) {
    chomp $line;
    my @arr = split /[ <>,-]+/, $line;
    $con{$arr[0]} = [ @arr[1 .. $#arr] ];
}

my $el = 0;
my %seen = ( $el => 1 );

visit(\%con, \%seen, $el);

say scalar keys %seen;
