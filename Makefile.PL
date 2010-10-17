use inc::Module::Install;
name 'Web-Dispatcher';
all_from 'lib/Web/Dispatcher/Simple.pm';

requires(
    'Router::Simple' => 0.07,
    'Plack::Request' => 0.09,
    'Try::Tiny'      => 0.06,
    'Carp'           => 0,
    'Scalar::Util'   => 0,
);
test_requires(
    'Test::More'  => 0.88,
    'Plack::Test' => 0,
);
use_test_base;
auto_include;
WriteAll;
