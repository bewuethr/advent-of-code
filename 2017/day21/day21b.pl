#!/usr/bin/perl

use strict;
use warnings;

use feature 'say';

use List::MoreUtils qw(pairwise);
use List::Util qw(sum);

sub transform {
    my ($square, $rules) = @_;

    foreach my $pattern (keys %$rules) {
        if ($pattern eq $$square) {
            $$square = $rules->{$pattern};
            return;
        }
        
        # Rotations
        foreach my $i (1..4) {

            # Vertical flip
            $$square = join "/", reverse split /\//, $$square;
            if ($pattern eq $$square) {
                $$square = $rules->{$pattern};
                return;
            }

            # Flip back
            $$square = join "/", reverse split /\//, $$square;
            if (length $$square == 5) {
                $$square =~ s{(.)(.)/(.)(.)}{$3$1/$4$2};
            }
            else {
                $$square =~ s{(.)(.)(.)/(.)(.)(.)/(.)(.)(.)}{$7$4$1/$8$5$2/$9$6$3};
            }

            if ($pattern eq $$square) {
                $$square = $rules->{$pattern};
                return;
            }
        }
    }
    say "Could not find match for $$square";
    exit;
}

sub resquare {
    my $picture = shift;
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

    @$picture = ();
    my $row = 0;
    $size = (length $joined[0]) % 2 ? 3 : 2;
    while ($row < @joined) {
        my @squarerow = ( $joined[$row] =~ /(.{$size})/g );
        for (my $subrow = $row + 1; $subrow <= $row + $size - 1; $subrow++) {
            my @nextrow = ( $joined[$subrow] =~ /(.{$size})/g );
            @squarerow = pairwise { $a . "/" . $b } @squarerow, @nextrow;
        }
        push @$picture, [ @squarerow ];
        $row += $size;
    }
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

my @picture = ( [ '.#./..#/###' ] );

foreach my $i (1..18) {
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
}

say sum map { map { scalar grep { $_ eq '#' } split //, $_ } @$_ } @picture;
