#!/usr/bin/perl

# Math program for kids
# Written by Richard Arends (richard@unixguru.nl) for his
# 6 year old son
#
# Version 0.1 16-01-2005
#
# The program knows 10 levels. A level stands for
# the highest number we calculate with. So within level 1
# the highest number will be 5 and within level 7 the
# highest number will be 100
#
# It works with the operands + and - but is easily extended
# with more.
#
# Exit with 'q' to get statistics

use strict;
use warnings;

my %levels = ("1", "5", "2", "10", "3", "15", "4", "20", "5", "30", "6", "50", "7", "100", "8", "200", "9", "500", "10", "1000");
my %operands = ("0", "+", "1", "-");
my $curr_level = 1;

my %lvl_good;
my %answer_hist;

my $good = 0;
my $wrong = 0;
my $total = 0;

while (1) {
	system("clear");
	my $get_operand = (int(rand keys %operands));
	my $operand = "$operands{$get_operand}";
	my $numbers = GetNumber($curr_level);
	my ($first, $second) = split(/:/, $numbers);
	print "$first $operand $second\n";
	print "Answer: ";
	my $answer = <STDIN>;

	my $sum;

	if ( $operand eq "+" ) {
		$sum = ($first + $second);
	} elsif ( $operand eq "-" ) {
		$sum = ($first - $second);
	}

	if ( $answer !~ m/^\d+$/ ) {
		# input is not a number
		system("clear");
		print "\n\n\n\n\n\n\n\n\n\t\t\t\t\t\tTotal\t\t: $total\n";
		print "\t\t\t\t\t\tGood\t\t: $good\n";
		print "\t\t\t\t\t\tWrong\t\t: $wrong\n";

		for my $answer_levels (sort keys %answer_hist) {
			if ( ! defined $answer_hist{$answer_levels}{"good"} ) {
				$answer_hist{$answer_levels}{"good"} = 0;
			}
			if ( ! defined $answer_hist{$answer_levels}{"wrong"} ) {
				$answer_hist{$answer_levels}{"wrong"} = 0;
			}

			print "\n";
			print "\t\t\t\t\t\tLevel $answer_levels good\t: $answer_hist{$answer_levels}{good}\n";
			print "\t\t\t\t\t\tLevel $answer_levels wrong\t: $answer_hist{$answer_levels}{wrong}\n";
		}

		exit;
	} else {
		if ( $answer == $sum ) {
			print "Good\n";
			$good++;

			if ( ! defined $answer_hist{$curr_level}{"good"} ) {
				$answer_hist{$curr_level}{"good"} = 0; 
			}

			$answer_hist{$curr_level}{"good"}++;
			$lvl_good{$curr_level}++;
			sleep(2);
			system("clear");
		} else {
			print "Wrong\n";
			$wrong++;

			if ( ! defined $answer_hist{$curr_level}{"wrong"} ) {
				$answer_hist{$curr_level}{"wrong"} = 0; 
			}

			$answer_hist{$curr_level}{"wrong"}++;
			$lvl_good{$curr_level}--;
			print "\n\nThe right answer is: $sum\n";
			sleep(5);
			system("clear");
		}

		$total++;
	}

	if ( $lvl_good{$curr_level} == 3 ) {
		$curr_level++;
		print "Level $curr_level\n";
		sleep(2);
		system("clear");
	} elsif ( $lvl_good{$curr_level} < 0 ) {
		$lvl_good{$curr_level} = 0;

		if ( $curr_level > 1 ) {
			$curr_level--;
			$lvl_good{$curr_level} = 0;
			print "Level $curr_level\n";
			sleep(2);
			system("clear");
		}
	}
}

sub GetNumber {
	my $input_level = shift;
	my $first_nr = (int(rand $levels{$input_level}));
	my $second_nr = (int(rand $levels{$input_level}));
	
	if ( $first_nr > $second_nr ) {
		return "$first_nr:$second_nr";
	} else {
		return "$second_nr:$first_nr";
	}
}
