use ExtUtils::MakeMaker;

require 5.005;

WriteMakefile(
    'NAME'          => 'BZ::Client::REST',
    'VERSION_FROM'  => 'lib/BZ/Client/REST.pm',
    'ABSTRACT_FROM' => 'lib/BZ/Client/REST.pm',
    'PREREQ_PM'     => {
        'Class::Accessor' => 0,
        'REST::Client'    => 0,
        'JSON'            => 0,
        'Encode'          => 0,
    },
    'BUILD_REQUIRES' => {
        'Test'       => 0,
        'Test::More' => 0,
    },
    AUTHOR => 'Kyle M Hall <kyle@bywatersolutions.com>'
);
