#!/usr/bin/perl

use strict;
use warnings;

use feature 'say';

use Algorithm::Combinatorics qw(permutations combinations variations);
use Data::Dumper;
$Data::Dumper::Sortkeys = 1;
use Digest::MD5 qw(md5_hex);
use File::Slurp;
use Graph::Simple;
use List::MoreUtils qw(firstval mesh uniq frequency firstidx lastidx pairwise singleton);
use List::Util qw(reduce max min product sum);
use Math::Prime::Util qw(fordivisors);

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

my %grid;
my ($x, $y) = (1, 1);


while (my $line = <$fh>) {
    chomp $line;
    my @arr = split //, $line;
    foreach my $el (@arr) {
        $grid{$x++ . "/$y"} = $el;
    }
    $x = 1;
    $y++;
}

print Dumper(\%grid);

my $infect = 0;
my ($xpos, $ypos) = (13, 13);
my ($dx, $dy) = (0, -1);


foreach my $i (1..10_000_000) {
    # say "Position is $xpos/$ypos";
    # say "Direction is $dx/$dy";
    $grid{"$xpos/$ypos"} //= '.';
    # say "Current node is ". $grid{"$xpos/$ypos"};
    if ($grid{"$xpos/$ypos"} eq '#') {
        # rotate right
        ($dx, $dy) = (-$dy, $dx);
        $grid{"$xpos/$ypos"} = 'F';
    }
    elsif ($grid{"$xpos/$ypos"} eq '.') {
        # rotate left
        ($dx, $dy) = ($dy, -$dx);
        $grid{"$xpos/$ypos"} = 'W';
    }
    elsif ($grid{"$xpos/$ypos"} eq 'W') {
        $grid{"$xpos/$ypos"} = '#';
        $infect++;
        # say "Infecting...";
    }
    elsif ($grid{"$xpos/$ypos"} eq 'F') {
        # turn around
        ($dx, $dy) = (-$dx, -$dy);
        $grid{"$xpos/$ypos"} = '.';
    }
    $xpos += $dx;
    $ypos += $dy;
}

say $infect;
