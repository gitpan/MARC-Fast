use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME         => 'MARC::Fast',
    VERSION_FROM => 'Fast.pm', # finds $VERSION
    AUTHOR       => 'Dobrica Pavlinusic (dpavlin@rot13.org)',
    ABSTRACT     => '',
    PREREQ_PM    => {
	'Test::Simple' => 0.44,
	'Test::Exception' => 0,
	'Carp' => 0,
    },
);
