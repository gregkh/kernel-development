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

sub check_patch_count()
{
	my $alt_patches;
	foreach (values %authors) {
		$alt_patches += $_->{'author'};
	}
	if ($alt_patches != $patches) {
		print STDERR "Warning: ".($patches - $alt_patches)." patches were lost\n";
		return 0;
	}
	return 1;
}

my $current_person;
while (<>) {
#	next unless m/(^Author| +Signed-off-by| +Acked-by): (.*)/;
	next unless m/^(Author): (.*)/;
	my $type = $1;
	if ($type eq 'Author') {
		$patches++;
	} else {
		$reviews++;
	} 

	# Clean up the name <address> line
	my $person = lc $2;
	$person =~ s/\\//;
	$person =~ s/([\w\d.-]+) <at / <$1@/;
	if ($person !~ m/^(.+) <(.*)>$/) {
		print STDERR "Warning: \"$person\" doesn't match the expected author pattern\n";
		next;
	}

	# We extract the name and the address and clean them up
	$person = $1;
	my $address = $2;
	$address =~ s/-at-(.*)-dot-com/\@$1.com/;
	$address =~ s/ at /\@/;
	$address =~ s/^([\w\d-]+)\.([\w\d-]+\.[\w\d]+)$/$1\@$2/;
	if ($address !~ m/@/) {
		print STDERR "Warning: \"$address\" doesn't match the expected address pattern\n";
		next;
	}
	$person =~ s/^(.*), *(.*)$/$2 $1/;
	$person =~ s/\s+$//;
	$person =~ s/^\s+//;

	if ($type eq 'Author') {
		$authors{$person}{'author'}++;
	} else {
		$authors{$person}{'review'}++;
	}
	if (exists $authors{$person}{'address'}) {
		# We already know that person
		if ($authors{$person}{'address'} ne $address) {
			# ... but with a different address; pick the best
			my $best = best_address($authors{$person}{'address'}, $address);
			if ($best eq $address) {
				# The new one is better
#				print STDERR "($authors{$person}{address}, $address)) -> $best\n";
				$alt_addresses{$authors{$person}{'address'}} = $best;
				$authors{$person}{'address'} = $best;
			} else {
				# The old one is better
				$alt_addresses{$address} = $best;
			}
		}
	} else {
		$authors{$person}{'address'} = $address;
	}
}

# If someone is found to have an alternative address, replace it with the
# corresponding canonical address (unlikely). It means we have a duplicate
# (two names, one address), this will be solved in the next step.
foreach (keys %authors) {
	while (exists $alt_addresses{$authors{$_}{'address'}}) {
#		print STDERR "$_ <".$authors{$_}{'address'}."> -> <".$alt_addresses{$authors{$_}{'address'}}.">\n";
		$authors{$_}{'address'} = $alt_addresses{$authors{$_}{'address'}};
	}
}

#print STDERR scalar(keys %authors)." authors after first pass\n";

# Lastly we can search for duplicates: two names for the same address.
# We build an extra hash mapping addresses to names. Each collision means
# we have a duplicate, in which case we consolidate the patch count then
# delete the second entry.
my %h;
foreach (keys %authors) {
	if (exists $h{$authors{$_}{'address'}}) {
		my $oldname = $h{$authors{$_}{'address'}};
		my $goodname = best_name($oldname, $_);
#		print STDERR "$_ and $oldname are the same person\n";
		if ($goodname eq $oldname) {
			$authors{$oldname}{'author'} += $authors{$_}{'author'};
#			$authors{$oldname}{'review'} += $authors{$_}{'review'};
			delete $authors{$_};
		} else {
			$authors{$_}{'author'} += $authors{$oldname}{'author'};
#			$authors{$_}{'review'} += $authors{$oldname}{'review'};
			delete $authors{$oldname};
			$h{$authors{$_}{'address'}} = $_;
		}
		next;
	}
	$h{$authors{$_}{'address'}} = $_;
}

exit 2 unless check_patch_count();

# Good, everything is clean now, we can print some numbers

sub print_main_stats()
{
	print "$patches patches\n";
	print scalar(keys %authors)." contributors\n";
}

sub print_patch_counts()
{
	foreach (sort keys %authors) {
		print "$_;$authors{$_}{address};$authors{$_}{author}\n";
	}
}

sub print_histo($)
{
	my $key = shift,
	my @histo;

	foreach (values %authors) {
		$histo[$_->{$key}]++;
	}

	for (my $i = 1; $i < @histo; $i++) {
		print "$i;".($histo[$i] || 0)."\n";
	}
}

sub print_topN($)
{
	my $Npc = shift;
	my $total = 0;
	my $top = 0;

	foreach (sort { $b->{'author'} <=> $a->{'author'} } values %authors) {
		last if ($top >= scalar(keys %authors) * ($Npc / 100));
		$total += $_->{'author'};
		$top++;
	}
	print "$Npc\% of the authors contributed ".($total * 100 / $patches)."\% of the patches\n";
}

sub print_domains()
{
	my %ppc;

	foreach (keys %authors) {
		if ($authors{$_}{address} =~ m/[@.]([^.@]+)\.(org|co|ac|ne|id|com|edu)\.[^.]+$/
		 || $authors{$_}{address} =~ m/[@.]([^.@]+)\.[^.]+$/) {
			$ppc{$1} += $authors{$_}{author};
		}
	}	

	foreach (sort { $ppc{$a} <=> $ppc{$b} } keys %ppc) {
		print "$_;$ppc{$_}\n";
	}
}

print_main_stats();
#print_patch_counts();
#print_domains();
print_histo('author');
#print_topN(50);
