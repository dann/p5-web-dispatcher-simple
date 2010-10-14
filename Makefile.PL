use inc::Module::Install;
name 'PlackX-RouteBuilder';
all_from 'lib/PlackX/RouteBuilder.pm';

requires(
    'Carp'           => 0,
    'Router::Simple' => 0.07,
    'Plack::Request' => 0,
    'Try::Tiny'      => 0,
);
test_requires( 'Test::More' => 0, );
use_test_base;
auto_include;
WriteAll;
