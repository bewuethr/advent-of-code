#!/usr/bin/perl

use strict;
use warnings;

use feature 'say';

use List::MoreUtils qw(firstval);
use List::Util qw(reduce);

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

my $line = <$fh>;
chomp $line;

my @matrix;

foreach my $suffix (0..127) {

    my @lengths = map { ord } split //, $line . "-$suffix";
    push @lengths, (17, 31, 73, 47, 23);

    my $skip = 0;
    my $cur = 0;

    my @list = (0..255);

    foreach my $i (1..64) {
        foreach my $len (@lengths) {
            my @longlist     = (@list, @list);
            my @sublist      = $len ? @longlist[ $cur .. $cur+$len-1 ] : ();
            my @head         = $cur ? @longlist[ 0 .. $cur-1 ] : ();
            my @mod_longlist = (@head, (reverse @sublist), @longlist[ $cur+$len .. $#longlist ]);

            @list = @mod_longlist[ 0 .. $#list ];
            if ($cur+$len-1 > $#list) {
                @list[ 0 .. ($cur+$len-1) % @list ] = @mod_longlist[ @list .. $cur+$len-1 ];
            }

            $cur = ($cur + $len + $skip) % @list;
            $skip++;
        }
    }

    my @densehash = map { reduce { $a ^ $b } @list[$_*16..($_+1)*16-1] } (0..15);
    push @matrix, [ split //, join '', map { sprintf '%08b', $_ } @densehash ];
}

my %con;
my $progs = 0;

foreach my $y ( 0 .. $#matrix ) {
    my $line = $matrix[$y];
    foreach my $x ( 0 .. $#$line ) {
        next if $line->[$x] == 0;
        my @connected;
        push @connected, ($x-1) . "/" . $y if $x > 0 and $matrix[$y]->[$x-1];
        push @connected, ($x+1) . "/" . $y if $x < $#$line and $matrix[$y]->[$x+1];
        push @connected, $x . "/" . ($y-1) if $y > 0 and $matrix[$y-1]->[$x];
        push @connected, $x . "/" . ($y+1) if $y < $#matrix and $matrix[$y+1]->[$x];
        $con{"$x/$y"} = @connected ? \@connected : [ "$x/$y" ];
        $progs++;
    }
}

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
