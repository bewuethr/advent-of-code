#!/usr/bin/perl

use strict;
use warnings;
use 5.022;

sub player_loses {
    my ($p_hp, $p_att, $p_arm, $b_hp, $b_att, $b_arm) = @_;
    while (1) {
        $b_hp -= $p_att;
        return 0 if $b_hp <= 0;
        $p_hp -= $b_att;
        return 1 if $p_hp <= 0;
    }
}

open my $fh, '<', 'input' or die "Can't open input: $!";

my $b_hp = <$fh>;
($b_hp) = $b_hp =~ m/(\d+)/;

my $b_dmg = <$fh>;
($b_dmg) = $b_dmg =~ m/(\d+)/;

my $b_arm = <$fh>;
($b_arm) = $b_arm =~ m/(\d+)/;

my $p_hp = 100;

my @weapons = (
    [8,  4],
    [10, 5],
    [25, 6],
    [40, 7],
    [74, 8],
);

my @armors = (
    [0,   0],
    [13,  1],
    [31,  2],
    [53,  3],
    [75,  4],
    [102, 5],
);

my @rings = (
    [0,   0, 0],
    [0,   0, 0],
    [25,  1, 0],
    [50,  2, 0],
    [100, 3, 0],
    [20,  0, 1],
    [40,  0, 2],
    [80,  0, 3],
);

my $max_cost = 0;

foreach my $weapon (@weapons) {
    foreach my $armor (@armors) {
        foreach my $ring1 (0..$#rings-1) {
            foreach my $ring2 ($ring1+1..$#rings) {
                my $cost = $weapon->[0] + $armor->[0] + $rings[$ring1][0] + $rings[$ring2][0];
                my $p_dmg = $weapon->[1] + $rings[$ring1][1] + $rings[$ring2][1];
                my $p_arm = $armor->[1] + $rings[$ring1][2] + $rings[$ring2][2];
                my $p_attack = $p_dmg > $b_arm ? $p_dmg - $b_arm : 1;
                my $b_attack = $b_dmg > $p_arm ? $b_dmg - $p_arm : 1;
                if (player_loses($p_hp, $p_attack, $p_arm, $b_hp, $b_attack, $b_arm)) {
                    if ($cost > $max_cost) {
                        $max_cost = $cost;
                        say "New most expensive equipment to lose: $max_cost";
                    }
                }
            }
        }
    }
}
