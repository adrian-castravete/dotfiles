#!/usr/bin/env perl

use strict;
use warnings;

for my $line (<>) {
  if ($line =~ /^\s*([0-9]+)\s+([0-9]+)\s+([0-9]+)\s*$/) {
    my ($r, $g, $b) = ($1, $2, $3);
    if ((0+$r+$g+$b)/3<32) {
      print("\e[47m");
    }
    printf("\e[38;2;$r;$g;${b}m#%02x%02x%02x - ████\e[m\n", $1, $2, $3);
  }
}

# vim: set sw=2 ts=2 et:
