#!/usr/bin/perl -w

# A script to extract statistics from the Linux kernel git log.
# (C) 2006-2007 Jean Delvare <jdelvare@suse.de>
# Released under the GPL v2.
#
# Command used to extract the information from git (for year 2006):
# git log --since=2006-01-01 --until=2006-12-31 --no-merges --pretty=medium
#
# Uncomment the various lines at the end of the script, one by one, to
# get the numbers you're interested in.

use strict;
use vars qw(%authors %alt_addresses $patches $reviews);

# %authors count the number of patches from each contributor and
# also stores the canonical contributor's e-mail address
# %alt_addresses stores mappings between known addresses and canonical
# addresses, this helps finding people with different names _and_
# different addresses

sub best_name($$)
{
	my ($name1, $name2) = @_;

	# A real name is better than an address
	return $name2 if $name1 =~ m/\@/ && $name2 !~ m/\@/;
	return $name1 if $name2 =~ m/\@/ && $name1 !~ m/\@/;

	# No space is suspicious
	return $name2 if $name1 !~ m/ / && $name2 =~ m/ /;
	return $name1 if $name2 !~ m/ / && $name1 =~ m/ /;

	# Discard encoded names
	return $name2 if $name1 =~ m/\=/ && $name2 !~ m/\=/;
	return $name1 if $name2 =~ m/\=/ && $name1 !~ m/\=/;

	# ASCII is prefered
	return $name2 if $name1 !~ m/^[\w\d.-]$/ && $name2 =~ m/^[\w\d.-]$/;
	return $name1 if $name2 !~ m/^[\w\d.-]$/ && $name1 =~ m/^[\w\d.-]$/;

	# Arbitrary decision
	return ($name1 cmp $name2) < 0 ? $name1 : $name2;
}

sub best_address($$)
{
	my ($addr1, $addr2) = @_;

	# Prefer real addresses
	return $addr1 if $addr2 =~ m/\(none\)$/ && $addr1 !~ m/\(none\)$/;
	return $addr2 if $addr1 =~ m/\(none\)$/ && $addr2 !~ m/\(none\)$/;

	# Prefer good-looking domains
	my $gooddom = qr/\@[\w\d-]+\.([a-z]{2}|com|org|net|biz|info)$/;
	return $addr1 if $addr1 =~ m/$gooddom/ && $addr2 !~ m/$gooddom/;
	return $addr2 if $addr2 =~ m/$gooddom/ && $addr1 !~ m/$gooddom/;

	# Preserve company or community address
	$gooddom = qr/\@.*\b(redhat\.com|novell\.com|suse\.|oracle\.com|ibm\.com|mandrake\.|mandriva\.|conectiva\.|compaq\.com|hp\.com|sgi\.com|dell\.com|intel\.com|amd\.com|google\.com|gentoo\.org|ubuntu\.com|debian\.org|nokia\.com|mvista\.com|cisco\.com|lsil\.com|osdl\.org)/;
	return $addr1 if $addr1 =~ m/$gooddom/ && $addr2 !~ m/$gooddom/;
	return $addr2 if $addr2 =~ m/$gooddom/ && $addr1 !~ m/$gooddom/;

	# Arbitrary decision
	return ($addr1 cmp $addr2) < 0 ? $addr1 : $addr2;
}

sub comma {
	(@_ == 0) ? '"'				:
	(@_ == 1) ? join("\"",$_[0])			:
	(@_ == 2) ? join("\" \"", @_)		:
		    join("\" -> ", @_[0 .. ($#_-1)], " \"$_[-1]\"");
}


my $current_person;
my $line_number;
$line_number = 0;
my $prev_person;
my @people;
while (<>) {
	$line_number++;
	next unless m/(^Author| +Signed-off-by| +Acked-by): (.*)/;
#	next unless m/^(Author): (.*)/;
	my $type = $1;
	if ($type eq 'Author') {
		$patches++;
	} else {
		$reviews++;
	}

	# Clean up the name <address> line
	my $person = lc $2;
	$person =~ s/\\//g;
	$person =~ s/\"//g;	# leading and trailing " sometimes
	$person =~ s/([\w\d.-]+) <at / <$1@/;
	if ($person !~ m/^(.+) <(.*)>$/) {
		print STDERR "Warning: \"$person\" doesn't match the expected author pattern, line $line_number\n";
		next;
	}

	# We extract the name and the address and clean them up
	$person = $1;
	my $address = $2;
	$address =~ s/-at-(.*)-dot-com/\@$1.com/;
	$address =~ s/ at /\@/;
	$address =~ s/^([\w\d-]+)\.([\w\d-]+\.[\w\d]+)$/$1\@$2/;
	if ($address !~ m/@/) {
		print STDERR "Warning: \"$address\" doesn't match the expected address pattern, line \"$line_number\"\n";
		next;
	}
	$person =~ s/^(.*), *(.*)$/$2 $1/;
	$person =~ s/\s+$//;
	$person =~ s/^\s+//;

	if ($person =~ /\@/) {
		print STDERR "Warning: \"$person\" has a @ in the author name, line $line_number\n";
		next;
	}

	my $item;
	if ($type eq 'Author') {
		my %seen;
		my @uniq;
		%seen = ();
		@uniq = ();
		foreach $item (@people) {
			unless ($seen{$item}) {
				$seen{$item} = 1;
				push(@uniq, $item);
			}
		}
#		my $num_in_list;
#		my $count;
#		$num_in_list = 0;
#		$count = 0;
#		foreach $item (@uniq) {
#			$num_in_list++;
#		}
#
#		foreach $item (@uniq) {
#			print "\"$item\"";
#			$count++;
#			if ($count ne $num_in_list) {
#				print " -> ";
#			}
#		}
#		print ";\n";

		my $length = @uniq;
		my $i;
#		print "length = $length\n";
		for ($i=0; $i < $length-1; $i++) {
			my $name1;
			my $name2;
			# sort the names so we don't end up doing graphs both
			# ways (cuts down on rendering time, hey, we need
			# everything we can get these days...
			if ($uniq[$i] gt $uniq[$i+1]) {
				$name1 = $uniq[$i+1];
				$name2 = $uniq[$i];
			} else {
				$name1 = $uniq[$i];
				$name2 = $uniq[$i+1];
			}

			print "\"$name1\" -- \"$name2\";\n"
		}

		@people = ();
		push (@people, $person);
	} else {
		push (@people, $person);
#		print "\"$person\"";
#		print " -> ";
#		}
#		$prev_person = $person;
#		print " -> ";
	}
#	print "\"$person\"";

}

#exit 2 unless check_patch_count();
