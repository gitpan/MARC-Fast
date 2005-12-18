#!/usr/bin/perl -w

use strict;
use blib;

use Test::More tests => 20;
use Test::Exception;
use Data::Dumper;

BEGIN { use_ok( 'MARC::Fast' ); }

my $marc;
my %param;

throws_ok { $marc = MARC::Fast->new(%param); } qr/marcdb/, "marcdb parametar";

$param{marcdb} = '/foo/bar/file';

throws_ok { $marc = MARC::Fast->new(%param); } qr/foo.bar/, "marcdb exist";

$param{marcdb} = 'data/unimarc.iso';

SKIP: {
	skip "no $param{marcdb} test file ", 17 unless (-e $param{marcdb});

	ok($marc = MARC::Fast->new(%param), "new");

	isa_ok ($marc, 'MARC::Fast');

	cmp_ok($marc->count, '==', scalar @{$marc->{leaders}}, "count == leaders");
	cmp_ok($marc->count, '==', scalar @{$marc->{fh_offset}}, "count == fh_offset");

	ok(! $marc->fetch(0), "fetch 0");
	ok($marc->fetch($marc->count), "fetch max:".$marc->count);
	ok(! $marc->fetch($marc->count + 1), "fetch max+1:".($marc->count+1));

	foreach (1 .. 10) {
		ok($marc->fetch($_), "fetch $_");
	}
}
