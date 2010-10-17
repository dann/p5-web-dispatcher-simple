use Plack::Test;
use HTTP::Request;
use Test::More;

use PlackX::RouteBuilder;
my $app = router {
    get '/get' => sub {
        my $req = shift;
        my $res = $req->new_response(200);
        $res->body('get');
        $res;
    },
    post '/post/{id}' => sub {
        my ( $req, $args ) = @_;
        my $id  = $args->{id};
        my $res = $req->new_response(200);
        $res->body('post');
        $res;
    },
    any [ 'GET', 'POST' ] => '/any' => sub {
        my ( $req, $args ) = @_;
        my $res = $req->new_response(200);
        $res->body('any');
        $res;
    }
};

test_psgi $app, sub {
    my $cb  = shift;
    my $req = HTTP::Request->new( GET => q{http://localhost/get} );
    my $res = $cb->($req);

    is $res->code,    200;
    is $res->content, "get";
};

test_psgi $app, sub {
    my $cb  = shift;
    my $req = HTTP::Request->new( POST => q{http://localhost/post/1} );
    my $res = $cb->($req);

    is $res->code,    200;
    is $res->content, "post";
};

test_psgi $app, sub {
    my $cb  = shift;
    my $req = HTTP::Request->new( GET => q{http://localhost/any} );
    my $res = $cb->($req);

    is $res->code,    200;
    is $res->content, "any";
};

done_testing;
