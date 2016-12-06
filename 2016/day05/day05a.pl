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

my $idx = 0;
my $passwd;
my $passwd_len = 8;

while (1) {
    my $hash = md5_hex("$id$idx");
    if ( $hash =~ /^0{5}/ ) {
        $passwd .= substr $hash, 5, 1;
        last if length $passwd == $passwd_len;
    }
    $idx++;
}

say $passwd;
