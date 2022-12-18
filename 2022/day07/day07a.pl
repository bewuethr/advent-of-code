#!/usr/bin/perl

use warnings;
use strict;

use feature 'say';

use List::Util qw(sum);

my @curDir    = ();
my $tree      = {};
my $sumTotals = 0;
my $threshold  = 100_000;

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

    $sumTotals += $total if $total < $threshold;

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

totalSize($tree);

say "$sumTotals";
