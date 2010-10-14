use Test::Dependencies
    exclude => [qw/Test::Dependencies Test::Base Test::Perl::Critic PlackX::RouteBuilder/],
    style   => 'light';
ok_dependencies();
