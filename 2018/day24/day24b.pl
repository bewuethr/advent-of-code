#!/usr/bin/perl

use warnings;
use strict;

use feature 'say';

use List::Util qw(sum);
use List::MoreUtils qw(firstidx);

sub selectTarget {
	my ($group, $groups) = @_;
	my %damageHash;

	# Group by damage dealt
	foreach my $target (@$groups) {
		next if ($target->{army} eq $group->{army}) or $target->{targeted};
		my $damage;
		next if exists $target->{immune}{$group->{attackType}};
		if (exists $target->{weak}{$group->{attackType}}) {
			push @{ $damageHash{2*$group->{effPower}} }, $target;
		}
		else {
			push @{ $damageHash{$group->{effPower}} }, $target;
		}
	}

	# Get group of weakest enemies
	return unless scalar keys %damageHash;
	my $targetKey = ( sort { $b+0 <=> $a+0 } keys %damageHash )[0];

	my $target = (
		sort {
			$b->{effPower} <=> $a->{effPower} or
			$b->{initiative} <=> $a->{initiative}
		} @{ $damageHash{ ( sort { $b+0 <=> $a+0 } keys %damageHash )[0] } }
	)[0];
	
	$group->{target} = firstidx { $_ == $target } @$groups;
	$target->{targeted} = 1;
}

sub attack {
	my ($group, $groups) = @_;
	return unless $group->{units} > 0;
	return if not exists $group->{target};

	my $target = $groups->[$group->{target}];
	my $multiplier = exists $target->{weak}{$group->{attackType}} ? 2 : 1;

	use integer;
	$target->{units} -= $group->{effPower} * $multiplier /  $target->{hitPoints};

	# Recalculate effective power of target
	$target->{effPower} = $target->{units} * $target->{attackDamage};
}

my $fname = shift;

my $boost = 1;

while (1) {
	open my $fh, "<", $fname
		or die "Can't open $fname: $!";

	my @groups;
	my $army;

	while (my $line = <$fh>) {
		chomp $line;
		if ($line =~ /^Immune/) {
			$army = "immune";
			next;
		}
		if ($line =~ /^Infection/) {
			$army = "infection";
			next;
		}
		if ($line =~ /^$/) {
			next;
		}

		$line =~ /(\d+) units.*?(\d+) hit points.*?(\d+) (\w+) damage at initiative (\d+)/;
		my $group = {
			army         => $army,
			units        => $1,
			hitPoints    => $2,
			attackDamage => $3,
			attackType   => $4,
			initiative   => $5,
		};

		$group->{attackDamage} += $boost if $army eq "immune";

		if ($line =~ /weak to ([\w, ]+)/) {
			my @weaknesses = split /, /, $1;
			$group->{weak} = { map { $_ => 1 } @weaknesses };
		}

		if ($line =~ /immune to ([\w, ]+)/) {
			my @immunities = split /, /, $1;
			$group->{immune} = { map { $_ => 1 } @immunities };
		}

		push @groups, $group;
	}

	my $units = sum map { $_->{units} } @groups;

	while (1) {
		# Remove groups with no units left
		@groups = grep { $_->{units} > 0 } @groups;

		# Check if one army has disappeared
		last unless scalar grep { $_->{army} eq "immune" } @groups;
		last unless scalar grep { $_->{army} eq "infection" } @groups;

		$_->{effPower} = $_->{units} * $_->{attackDamage} for @groups;

		# Reset all target tags
		@groups = map { delete @{$_}{qw(targeted target)}; $_ } @groups;

		# Sort by effective power, then initiative
		@groups = sort {
			$b->{effPower} <=> $a->{effPower} or
			$b->{initiative} <=> $a->{initiative}
		} grep { $_->{units} > 0 } @groups;

		# Target selection
		selectTarget($_, \@groups) for @groups;

		# Attacking phase
		attack($_, \@groups) for sort { $b->{initiative} <=> $a->{initiative} } @groups;

		my $newUnits = sum map { $_->{units} } @groups;
		last if $newUnits == $units;	# Fight will never end
		$units = $newUnits;
	}

	say "$boost: $units units";
	last if ( scalar grep { $_->{army} eq "infection" } @groups ) == 0;
	$boost++;
}

say "Immune system won last round";
