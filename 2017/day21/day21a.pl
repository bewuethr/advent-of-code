#!/usr/bin/perl

use strict;
use warnings;

use feature 'say';

use Algorithm::Combinatorics qw(permutations combinations variations);
use Data::Dumper;
use Digest::MD5 qw(md5_hex);
use File::Slurp;
use Graph::Simple;
use List::MoreUtils qw(firstval mesh uniq frequency firstidx lastidx pairwise singleton);
use List::Util qw(reduce max min product sum);
use Math::Prime::Util qw(fordivisors);

our $debug = 1;

sub transform {
    my ($square, $rules) = @_;

    say "Looking for match for $$square" if $debug;

    foreach my $pattern (keys %$rules) {
        say "Now testing $pattern" if $debug;

        if ($pattern eq $$square) {
            $$square = $rules->{$pattern};
            say "Match: $pattern" if $debug;
            return;
        }
        
        # Rotations
        foreach my $i (1..4) {
            if (length $$square == 5) {
                $$square =~ s{(.)(.)/(.)(.)}{$3$1/$4$2};
            }
            else {
                $$square =~ s{(.)(.)(.)/(.)(.)(.)/(.)(.)(.)}{$7$4$1/$8$5$2/$9$6$3};
            }
            say "Rotated: testing $$square" if $debug;
            if ($pattern eq $$square) {
                $$square = $rules->{$pattern};
                say "Match: $pattern" if $debug;
                return;
            }
        }

        # Vertical flip
        $$square = join "/", reverse split /\//, $$square;
        say "Vertically flipped: testing $$square" if $debug;
        if ($pattern eq $$square) {
            $$square = $rules->{$pattern};
            say "Match: $pattern" if $debug;
            return;
        }

        # Flip back
        $$square = join "/", reverse split /\//, $$square;

        # Horizontal flip
        if (length $$square == 5) {
            $$square =~ s{(.)(.)/(.)(.)}{$2$1/$4$3};
        }
        else {
            $$square =~ s{(.)(.)(.)/(.)(.)(.)/(.)(.)(.)}{$3$2$1/$6$5$4/$9$8$7};
            say "Flipped: testing $$square" if $debug;
        }
        if ($pattern eq $$square) {
            $$square = $rules->{$pattern};
            say "Match: $pattern" if $debug;
            return;
        }
        say "No match: $pattern" if $debug;
    }
    say "Could not find match for $$square";
    exit;
}

sub resquare {
    my $picture = shift;
    print "Picture in resquare: ", Dumper($picture);
    my @joined;
    my $rowidx = 0;
    my $size = length $picture->[0][0] == 11 ? 3 : 4;
    foreach my $row (@$picture) {
        foreach my $square (@$row) {
            my @arr = split /\//, $square;
            foreach my $sqrowidx (0..$#arr) {
                $joined[$rowidx+$sqrowidx] .= $arr[$sqrowidx];
            }
        }
        $rowidx += $size;;
    }
    print "Joined: ", Dumper(\@joined) if $debug;

    @$picture = ();
    my $row = 0;
    $size = $size == 4 ? 2 : 3;
    while ($row < @joined) {
        my @squarerow = ( $joined[$row] =~ /(.{$size})/g );
        for (my $subrow = $row + 1; $subrow <= $row + $size - 1; $subrow++) {
            my @nextrow = ( $joined[$subrow] =~ /(.{$size})/g );
            @squarerow = pairwise { $a . "/" . $b } @squarerow, @nextrow;
        }
        push @$picture, [ @squarerow ];
        $row += $size;
    }

    print "Resquared: ", Dumper($picture) if $debug;
    return;
}


my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

my (%rules2, %rules3);

while (my $line = <$fh>) {
    chomp $line;
    my @arr = split / => /, $line;
    if ( length $arr[0] == 5 ) {
        $rules2{$arr[0]} = $arr[1];
    }
    else {
        $rules3{$arr[0]} = $arr[1];
    }
}

# print Dumper(\%rules2, \%rules3);

my @picture = ( [ '.#./..#/###' ] );

# Odd i: multiple of 3, even i: multiple of 2
foreach my $i (1..5) {
    foreach my $row (@picture) {
        foreach my $square (@$row) {
            if (length $square == 5) {
                transform(\$square, \%rules2);
            }
            else {
                transform(\$square, \%rules3);
            }
        }
    }
    resquare(\@picture);
    say "##### end of iteration $i" if $debug;
}

say sum map { map { scalar grep { $_ eq '#' } split //, $_ } @$_ } @picture;
