#!/usr/bin/perl

use strict;
use warnings;
use feature 'say';

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";
my $str = <$fh>;
chomp $str;

my $len = 35651584;

$str .= "0" . scalar reverse ($str =~ tr/01/10/r) while ((length $str) < $len);

my $chksum = substr $str, 0, $len;

$chksum = join "", map { (substr $_, 0, 1) == (substr $_, 1) ? "1" : "0" } ( $chksum =~ m/../g ) while ((length $chksum) %2 == 0); 

say $chksum;
