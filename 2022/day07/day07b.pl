#!/usr/bin/perl

use warnings;
use strict;

use feature 'say';

use List::Util qw(min sum);

my @curDir    = ();
my $tree      = {};
my $sumTotals = 0;
my @candidates;

sub cd {
    my $dir = shift;
    if ( $dir eq "/" ) {
        @curDir = ();
    }
    elsif ( $dir eq ".." ) {
        pop @curDir;
    }
    else {
        push @curDir, $dir;
    }

    my $cur = $tree;
    foreach my $subDir (@curDir) {
        $cur = $cur->{dirs}{$subDir};
    }

    return $cur;
}

sub totalSize {
    my $dir = shift;

    my $total = sum map { $_->{size} } @{ $dir->{files} };

    if ( exists $dir->{dirs} ) {
        $total += sum map { totalSize($_) } values %{ $dir->{dirs} };
    }

    return $total;
}

sub findToDelete {
    my ($dir, $minSize) = @_;

    my $total = sum map { $_->{size} } @{ $dir->{files} };

    if ( exists $dir->{dirs} ) {
        $total += sum map { findToDelete($_, $minSize) } values %{ $dir->{dirs} };
    }

    push @candidates, $total if $total > $minSize;

    return $total;
}

my $fname = shift;
my $cur;

open my $fh, "<", $fname
  or die "Can't open $fname: $!";

while ( my $line = <$fh> ) {
    chomp $line;

    my @tokens = split / /, $line;
    if ( $tokens[0] eq '$' ) {
        if ( $tokens[1] eq "cd" ) {
            $cur = cd( $tokens[2] );
        }

        next;
    }

    if ( $tokens[0] eq "dir" ) {
        $cur->{dirs}{ $tokens[1] } //= {};
    }
    else {
        push @{ $cur->{files} },
          {
            name => $tokens[1],
            size => $tokens[0] + 0,
          };
    }
}

my $usedTotal = totalSize($tree);

my $diskSpace     = 70_000_000;
my $requiredEmpty = 30_000_000;
my $gap           = $requiredEmpty - ( $diskSpace - $usedTotal );

findToDelete($tree, $gap);
say min @candidates;
