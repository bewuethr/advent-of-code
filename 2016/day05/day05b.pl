#!/usr/bin/perl

use strict;
use warnings;
use Digest::MD5 qw(md5_hex);
use feature 'say';

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";
my $id = <$fh>;
chomp $id;

my $idx = -1;
my @passwd;
my $passwd_len = 8;
my $found = 0;

while (1) {
    ++$idx;
    my $hash = md5_hex("$id$idx");
    if ( $hash =~ /^0{5}[0-7]/ ) {
        my $pos = substr $hash, 5, 1;
        next if defined $passwd[$pos];

        $passwd[$pos] = substr $hash, 6, 1;
        $found++;
        last if $found == $passwd_len;
    }
}

say @passwd;
