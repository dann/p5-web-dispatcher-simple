use strict;
use warnings FATAL => 'all';
use Module::Build;

my $build = Module::Build->new(
    name        => 'Web-Dispatcher-Simple',
    module_name => 'Web::Dispatcher::Simple',
    dist_author          => 'Dann',
    dist_version_from    => 'lib/Web/Dispatcher/Simple.pm',
    license              => 'perl',
    recursive_test_files => 1,
    dynamic_config       => 0,
    build_requires       => { 
        'Test::More' => '0.88',
        'Plack::Test' => '0',
    },
    configure_requires   => { 
        'Module::Build' => '0.38' 
    },
    requires             => {
        'Router::Simple'   => '0.07',
        'Plack'            => '0.9951',
        'Try::Tiny'        => '0.06',
        'Carp'             => '0',
        'Scalar::Util'     => '0',
        'Encode'           => '0',
        'Hash::MultiValue' => '0',
    },
    no_index    => { 'directory' => [ 'inc', 't', 'xt' ] },
    test_files => $ENV{RELEASE_TESTING} ? 't/ xt/' : 't/',
    create_readme  => 1,
    create_license => 1,
    meta_merge     => {
        resources => { 
            'repository' => 'http://github.com/dann/p5-web-dispatcher-simple'
        }
    },
);
$build->create_build_script();
