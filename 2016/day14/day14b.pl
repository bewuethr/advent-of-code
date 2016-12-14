#!/usr/bin/perl

use strict;
use warnings;
use Digest::MD5 qw(md5_hex);
use feature 'say';

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";
my $salt = <$fh>;
chomp $salt;

my $idx = 0;
my $ctr = 0;
my %triples;

while (1) {
    my $hash = md5_hex("$salt$idx");
    for (my $i = 0; $i < 2016; $i++) {
        $hash = md5_hex($hash);
    }

    if ($hash =~ /((.)\2\2)/) {
        $triples{$idx} = $1;
    }

    if ($hash =~ /((.)\2{4})/) {
        my $quintuple = $1;
        say "Found $quintuple at $idx";

        foreach my $tri_idx (sort { $a <=> $b } keys %triples) {
            if (index($quintuple, $triples{$tri_idx}) != -1
                && $idx - $tri_idx <= 1000
                && $idx != $tri_idx)
            {
                $ctr++;
                say "$triples{$tri_idx} at $tri_idx is key number $ctr";
                delete $triples{$tri_idx};
                if ($ctr == 64) {
                    say "Triple index $tri_idx was the 64th key";
                    exit
                }
            }
        }
    }
    $idx++;
}
