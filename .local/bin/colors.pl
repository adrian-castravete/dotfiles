#!/usr/bin/env perl

use strict;
use warnings;

sub printLine {
	my $ch = "██";
	my $_ch = shift;
	if ($_ch) {
		$ch = $_ch;
	}

	for my $i (0 .. 7) {
		print "\e[3${i}m$ch";
	}
	for my $i (0 .. 7) {
		print "\e[9${i}m$ch";
	}
	print "\e[m\n";
}

print "Colors -";
printLine();
print "\n";
for my $i (0 .. 7) {
	if ($i == 0) {
		print "\e[47m";
	}
	print "\e[3${i}mBG$i •░\e[m -\e[4${i}m";
	printLine("•░");
	if ($i == 0) {
		print "\e[47m";
	}
	print "\e[3${i}m    ▒▓\e[m  \e[4${i}m";
	printLine("▒▓");
}
