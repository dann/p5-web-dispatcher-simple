use inc::Module::Install;
name 'PlackX-RouteBuilder';
all_from 'lib/PlackX/RouteBuilder.pm';

requires(

);
test_requires(
  'Test::More'                   => 0,
  'Test::Class'                  => 0,
  'Module::Install::AuthorTests' => 0,
);
use_test_base;
auto_include;
WriteAll;
