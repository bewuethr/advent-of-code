#!/usr/bin/perl

use warnings;
use strict;

use feature 'say';

sub draw {
	my ($map, $carts, $signs) = @_;
	my @drawMap = map { [@$_] } @$map;
	foreach my $cart (@$carts) {
		next if $cart->{deleted};
		$drawMap[$cart->{y}][$cart->{x}] = $signs->{"$cart->{dx},$cart->{dy}"};
	}
	say join "\n", map { join '', @$_ } @drawMap;
	<>;
}

sub moveCart {
	my ($map, $cart) = @_;

	$cart->{x} += $cart->{dx};
	$cart->{y} += $cart->{dy};
	my ($x, $y) = @$cart{ qw(x y) };

	if ($map->[$y][$x] =~ /[-|]/) {
		return 1;
	}
	elsif ($map->[$y][$x] eq "/") {
		if ($cart->{dy} == 0) {
			# turn left from horizonal
			@$cart{ qw(dx dy) } = rotLeft(@$cart{ qw(dx dy) });
		}
		else {
			# turn right from vertical
			@$cart{ qw(dx dy) } = rotRight(@$cart{ qw(dx dy) });
		}
	}
	elsif ($map->[$y][$x] eq "\\") {
		if ($cart->{dy} == 0) {
			# turn right from horizonal
			@$cart{ qw(dx dy) } = rotRight(@$cart{ qw(dx dy) });
		}
		else {
			# turn left from vertical
			@$cart{ qw(dx dy) } = rotLeft(@$cart{ qw(dx dy) });
		}
	}
	elsif ($map->[$y][$x] eq "+") {
		if ($cart->{turn} eq "left") {
			@$cart{ qw(dx dy) } = rotLeft(@$cart{ qw(dx dy) });
			$cart->{turn} = "straight";
		}
		elsif ($cart->{turn} eq "straight") {
			$cart->{turn} = "right";
		}
		elsif ($cart->{turn} eq "right") {
			@$cart{ qw(dx dy) } = rotRight(@$cart{ qw(dx dy) });
			$cart->{turn} = "left";
		}
	}
	else {
		die "unknown map element at $x/$y: $map->[$y][$x]";
	}
	return 1;
}

sub rotLeft {
	my ($x, $y) = @_;
	return ($y, -$x);
}

sub rotRight {
	my ($x, $y) = @_;
	return (-$y, $x);
}

sub checkCollisions {
	my ($carts, $idx) = @_;
	foreach my $i (0 .. $#$carts) {
		next if $i == $idx;
		next if ($carts->[$i]{deleted});
		if ($carts->[$i]{x} == $carts->[$idx]{x} and $carts->[$i]{y} == $carts->[$idx]{y}) {
			$carts->[$i]{deleted} = 1;
			$carts->[$idx]{deleted} = 1;
			last;
		}
	}
	return 1;
}

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

my @map;

# Read map
while (my $line = <$fh>) {
	chomp $line;
	push @map, [ split //, $line ];
}

my %signs = (
	'0,1'  => 'v',
	'0,-1' => '^',
	'-1,0' => '<',
	'1,0'  => '>',
);

my %dirs = (
	'v' => { dx => 0,  dy => 1 },
	'^' => { dx => 0,  dy => -1 },
	'<' => { dx => -1, dy => 0 },
	'>' => { dx => 1,  dy => 0 },
);

my @carts;

# Initialize carts and complete map
foreach my $y (0 .. $#map) {
	foreach my $x (0 .. $#{$map[0]}) {
		my $el = $map[$y][$x];
		if ($el =~ /[<>v^]/) {
			push @carts, {
				x    => $x,
				y    => $y,
				dx   => $dirs{$el}{dx},
				dy   => $dirs{$el}{dy},
				turn => 'left',
			};
			$map[$y][$x] =~ tr/<>v^/\-\-||/;
		}
	}
}

while (1) {
	@carts = sort { $a->{y} <=> $b->{y} or $a->{x} <=> $b->{x} } @carts;
	# draw(\@map, \@carts, \%signs);
	foreach my $idx (0 .. $#carts) {
		next if $carts[$idx]{deleted};
		moveCart(\@map, $carts[$idx]);
		checkCollisions(\@carts, $idx);
	}
	my @left = grep { not exists $_->{deleted} } @carts;
	if (@left == 1) {
		say "$left[0]{x},$left[0]{y}";
		exit;
	}
}
