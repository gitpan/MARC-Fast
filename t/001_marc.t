#!/usr/bin/perl -w

use strict;
use blib;

use Test::More tests => 40;
use Test::Exception;
use Data::Dump qw/dump/;

BEGIN { use_ok( 'MARC::Fast' ); }

my $debug = shift @ARGV;

my $marc;
my %param;

throws_ok { $marc = MARC::Fast->new(%param); } qr/marcdb/, "marcdb parametar";

$param{marcdb} = '/foo/bar/file';

throws_ok { $marc = MARC::Fast->new(%param); } qr/foo.bar/, "marcdb exist";

$param{marcdb} = 'data/unimarc.iso';

SKIP: {
	skip "no $param{marcdb} test file ", 37 unless (-e $param{marcdb});

	ok($marc = MARC::Fast->new(%param), "new");

	isa_ok ($marc, 'MARC::Fast');

	#diag Dumper($marc);

	cmp_ok($marc->count, '==', scalar @{$marc->{leaders}}, "count == leaders");
	cmp_ok($marc->count, '==', scalar @{$marc->{fh_offset}}, "count == fh_offset");

	ok(! $marc->fetch(0), "fetch 0");
	ok($marc->fetch($marc->count), "fetch max:".$marc->count);
	ok(! $marc->fetch($marc->count + 1), "fetch max+1:".($marc->count+1));

	foreach (1 .. 10) {
		ok($marc->fetch($_), "fetch $_");

		ok(my $hash = $marc->to_hash($_), "to_hash $_");
		diag "to_hash($_) = ",dump($hash) if ($debug);
		ok(my $ascii = $marc->to_ascii($_), "to_ascii $_");
		diag "to_ascii($_) ::\n$ascii" if ($debug);
	}
}
