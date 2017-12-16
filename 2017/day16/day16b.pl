#!/usr/bin/perl

use strict;
use warnings;
no warnings 'experimental';

use v5.10.1;

use List::MoreUtils qw(firstidx);

sub dance {
    my ($progs, $instrs) = @_;
    foreach my $instr (@$instrs) {
        given ($instr) {
            when (/^s(\d+)$/) {
                my $els = $1;
                unshift @$progs, pop @$progs while $els--;
            }
            when (/^x(\d+)\/(\d+)$/) {
                @$progs[$1, $2] = @$progs[$2, $1];
            }
            when (/^p(\w)\/(\w)$/) {
                my $idx1 = firstidx { $_ eq $1 } @$progs;
                my $idx2 = firstidx { $_ eq $2 } @$progs;
                @$progs[ $idx1, $idx2 ] = @$progs[ $idx2, $idx1 ];
            }
        }
    }
    return $progs;
}

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

my @progs = map { chr( ord('a') + $_ ) } (0..15);

my $line = <$fh>;
chomp $line;
my @instrs = split /,/, $line;

my $ctr = 1;
my %map;

# Find cycle length
while (1) {
    @progs = @{ dance(\@progs, \@instrs) };
    last if "@progs" eq "a b c d e f g h i j k l m n o p";
    $ctr++;
}

# Find final arrangement
my $reps = 1_000_000_000 % $ctr;
@progs = @{ dance(\@progs, \@instrs) } while $reps--;

say join '', @progs;
