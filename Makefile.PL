use ExtUtils::MakeMaker;

WriteMakefile(
    NAME          => 'AppName',
    VERSION_FROM  => 'lib/AppName.pm',
    PREREQ_PM     => {
        'Kossy' =>  '0.19',
    },
    MIN_PERL_VERSION => '5.008001'
);

