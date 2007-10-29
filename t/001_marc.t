#!/usr/bin/perl -w

use strict;
use blib;

use Test::More tests => 53;
use Test::Exception;

BEGIN {
	use_ok( 'MARC::Fast' );
}

my $debug = shift @ARGV;

my $marc_file = 't/camel.usmarc';

if ( $debug ) {
	eval { require Data::Dump; };
	$debug = 0 if ($@);
}

my $marc;
my %param;

throws_ok { $marc = MARC::Fast->new(%param); } qr/marcdb/, "marcdb parametar";

$param{marcdb} = '/foo/bar/file';

throws_ok { $marc = MARC::Fast->new(%param); } qr/foo.bar/, "marcdb exist";

$param{marcdb} = $marc_file if -e $marc_file;

SKIP: {
	skip "no $param{marcdb} test file ", 37 unless (-e $param{marcdb});

	diag "marc file: $marc_file";

	ok($marc = MARC::Fast->new(%param), "new");

	isa_ok ($marc, 'MARC::Fast');

	#diag Dumper($marc);

	cmp_ok($marc->count, '==', scalar @{$marc->{leader}}, "count == leader");
	cmp_ok($marc->count, '==', scalar @{$marc->{fh_offset}}, "count == fh_offset");

	ok(! $marc->fetch(0), "fetch 0");
	ok(! $marc->last_leader, "no last_leader");
	ok($marc->fetch($marc->count), "fetch max:".$marc->count);
	ok(! $marc->fetch($marc->count + 1), "fetch max+1:".($marc->count+1));

	foreach (1 .. 10) {
		ok($marc->fetch($_), "fetch $_");

		ok($marc->last_leader, "last_leader $_");

		ok(my $hash = $marc->to_hash($_), "to_hash $_");
		diag "to_hash($_) = ",Data::Dump::dump($hash) if ($debug);
		ok(my $ascii = $marc->to_ascii($_), "to_ascii $_");
		diag "to_ascii($_) ::\n$ascii" if ($debug);
	}

	ok(! $marc->fetch(0), "fetch 0 again");
	ok(! $marc->last_leader, "no last_leader");
}
