#!/usr/bin/perl -w

use strict;
use blib;

use MARC::Fast;
use Getopt::Std;
use Data::Dumper;

=head1 NAME

dump_fastmarc.pl - display MARC records

=head2 USAGE

  dump_fastmarc.pl /path/to/dump.marc

=head2 OPTIONS

=over 16

=item -n number

dump just record C<number>

=item -l limit

import just first C<limit> records

=item -h

dump result of C<to_hash> on record

=item -d

turn debugging output on

=back

=cut

my %opt;
getopts('dn:l:h', \%opt);

my $file = shift @ARGV || die "usage: $0 [-n number] [-l limit] [-h] [-d] file.marc\n";

my $marc = new MARC::Fast(
	marcdb => $file,
	debug => $opt{d},
);


my $min = 1;
my $max = $marc->count;

if (my $mfn = $opt{n}) {
	$min = $max = $mfn;
	print STDERR "Dumping $mfn only\n";
} elsif (my $limit = $opt{l}) {
	print STDERR "$file has $max records, using first $limit\n";
	$max = $limit;
} else {
	print STDERR "$file has $max records...\n";
}

for my $mfn ($min .. $max) {
	my $rec = $marc->fetch($mfn) || next;
	print "rec is ",Dumper($rec) if ($opt{d});
	print "REC $mfn\n";
	foreach my $f (sort keys %{$rec}) {
		my $dump = join('', @{ $rec->{$f} });
		$dump =~ s/\x1e$//;
		$dump =~ s/\x1f/\$/g;
		print "$f\t$dump\n";
	}
	print "\n";
	print "hash is ",Dumper($marc->to_hash($mfn)) if ($opt{h});
}
