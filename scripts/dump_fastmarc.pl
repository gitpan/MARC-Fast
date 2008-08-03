#!/usr/bin/perl -w

use strict;
use blib;

use MARC::Fast;
use Getopt::Std;
use Data::Dump qw/dump/;

=head1 NAME

dump_fastmarc.pl - display MARC records

=head2 USAGE

  dump_fastmarc.pl /path/to/dump.marc

=head2 OPTIONS

=over 16

=item -o offset

dump records starting with C<offset>

=item -l limit

dump just C<limit> records

=item -h

dump result of C<to_hash> on record

=item -d

turn debugging output on

=back

=cut

my %opt;
getopts('do:l:h', \%opt);

my $file = shift @ARGV || die "usage: $0 [-o offset] [-l limit] [-h] [-d] file.marc\n";

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
	print "rec is ",dump($rec) if ($opt{d});
	print "REC $mfn\n";
	print $marc->last_leader,"\n";
	print $marc->to_ascii($mfn),"\n";
	print "hash is ",dump($marc->to_hash($mfn)) if ($opt{h});
}
