#!/usr/bin/perl

use strict;
use warnings;

use feature 'say';

use Data::Dumper;
$Data::Dumper::Sortkeys = 1;
use List::MoreUtils qw(firstval);

sub visit {
    my ($con, $seen, $el) = @_;

    foreach my $val ( @{ $con->{$el} } ) {
        # print Dumper($seen);
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

# print Dumper(\%con);

my %seen;
my $groups = 0;

while (scalar keys %seen < $progs) {
    my $el = firstval { not $seen{$_} } ( keys %con );
    # say $el;
    $seen{$el}++;
    visit(\%con, \%seen, $el);
    $groups++;
}

say $groups;
