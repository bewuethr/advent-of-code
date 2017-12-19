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

our $debug = 1;

sub walk {
    my ($x, $y, $dx, $dy, $map, $steps) = @_;
    say "at $x/$y, direction $dx/$dy, over $map->[$y][$x]" if $debug;
    do {
        $$steps += 1;
        say $$steps;
        $x += $dx;
        $y += $dy;
        if ($map->[$y][$x] =~ /[A-Z]/) {
            say "Found $map->[$y][$x]" if $debug; 
            if ($map->[$y][$x] eq "S") {
                say $$steps;
                exit;
            }
        }
    } until ($map->[$y][$x] eq "+");
    return ($x, $y);
}

sub finddir {
    my ($x, $y, $dx, $dy, $map) = @_;
    say "finddir: at $x/$y, direction $$dx/$$dy, over $map->[$y][$x]" if $debug;
    my ($dx_next, $dy_next);
    foreach my $dir ([0, 1], [1, 0], [0, -1], [-1, 0]) {
        next if $dir->[0] == $$dx or $dir->[1] == $$dy;
        next if not defined $map->[$y + $dir->[1]][$x + $dir->[0]]
                or not $map->[$y + $dir->[1]][$x + $dir->[0]] =~ /[-|]/;
        ($dx_next, $dy_next) = @$dir;
    }
    return 0 if not  defined $dx_next;
    ($$dx, $$dy) = ($dx_next, $dy_next);
    return 1;
}
        

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

my @map;

while (my $line = <$fh>) {
    chomp $line;
    my @row = split //, $line;
    push @map, \@row;
}

# print Dumper(\@map);

my $y = 0;
my $x = firstidx { $_ eq "|" } @{$map[0]};

my ($dx, $dy) = (0, 1);
my $steps = 1;

while (1) {
    ($x, $y) = walk($x, $y, $dx, $dy, \@map, \$steps);
    last if not finddir($x, $y, \$dx, \$dy, \@map);
}
