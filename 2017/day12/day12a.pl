#!/usr/bin/perl

use strict;
use warnings;

use feature 'say';

use Algorithm::Combinatorics qw(permutations combinations variations);
use Data::Dumper;
use Digest::MD5 qw(md5_hex);
use File::Slurp;
use Graph::Simple;
use List::MoreUtils qw(firstval mesh uniq frequency firstidx lastidx singleton);
use List::Util qw(reduce max min product sum);
use Math::Prime::Util qw(fordivisors);

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

# chomp(my @arr = <$fh>);
# 
# while (1) {
# }

my %con;

while (my $line = <$fh>) {
    chomp $line;
    my @arr = split /[ <>,-]+/, $line;
    $con{$arr[0]} = [ @arr[1 .. $#arr] ];
}

# print Dumper(\%con);

my $el = 0;
my %seen = ( $el => 1 );

visit(\%con, \%seen, $el);

say scalar keys %seen;
