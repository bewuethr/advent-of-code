#!/usr/bin/perl

use strict;
use warnings;

use feature 'say';

use List::MoreUtils qw(firstval singleton);
use List::Util qw(sum);

sub getweight {
    my ($node, $data) = @_;
    my $weight = $data->{$node}{weight};

    return $weight if not exists $data->{$node}{children};

    foreach my $child (keys %{ $data->{$node}{children} }) {
        $data->{$node}{children}{$child} = getweight($child, $data);
    }
    return $weight + sum values %{ $data->{$node}{children} };
}

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

chomp(my $root = `./day07a input`);

my %data;

# Build data structure
while (my $line = <$fh>) {
    chomp $line;
    my @arr = split /[- (),>]+/, $line;

    $data{$arr[0]}{weight  } = $arr[1];
    $data{$arr[0]}{children} = { map { $_ => 0 } @arr[2..$#arr] } if $#arr > 1;
}

# Get aggregated weights
my $node = $root;
getweight($node, \%data);

my @imbalanced;

# Find program causing imbalance
while (1) {
    push @imbalanced, {
        weight   => $data{$node}{weight},
        children => [ values %{$data{$node}{children}} ]
    };
    my $children = $data{$node}{children};
    my ($bad_weight) = singleton values %$children;
    last if not defined $bad_weight;
    $imbalanced[-1]{bad} = $bad_weight;
    my ($bad_child) = grep { $children->{$_} == $bad_weight } keys %$children;
    $node = $bad_child;
}

my $diff 
    = $imbalanced[-2]{bad}
      - firstval { $_ != $imbalanced[-2]{bad} } @{$imbalanced[-2]{children}};
say $imbalanced[-1]{weight} - $diff;
