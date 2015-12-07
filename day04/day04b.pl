#!/bin/perl

use 5.022;
use warnings;
use Digest::MD5 qw(md5_hex);

my $secret = "yzbqklnj";
my $try = 282749;    # Answer from part 1

while (1) {
    my $md5 = md5_hex("$secret$try");
    if ( $md5 =~ /^0{6}/ ) {
        say "$secret with an attached $try has a hash starting with 000000.";
        last;
    }
    $try++;
}
