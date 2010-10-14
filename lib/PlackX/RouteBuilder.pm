package PlackX::RouteBuilder;
use strict;
use warnings;
our $VERSION = '0.01';

use Carp 'croak';
use Router::Simple;
use Try::Tiny;
use Plack::Request;

my $_ROUTER = Router::Simple->new;

sub import {
    my $caller = caller;

    no strict 'refs';
    no warnings 'redefine';

    *{"${caller}::router"} = \&router;

    my @http_methods = qw/get post put del/;
    for my $http_method (@http_methods) {
        *{"${caller}\::$http_method"} = sub { goto \&$http_method };
    }
}

sub _stub {
    my $name = shift;
    return sub { croak "Can't call $name() outside pina block" };
}

{
    my @declarations = qw(get post put del);
    for my $keyword (@declarations) {
        no strict 'refs';
        *$keyword = _stub $keyword;
    }
}

sub router (&) {
    my $block = shift;

    if ($block) {
        no warnings 'redefine';
        local *get  = sub { do_get(@_) };
        local *post = sub { do_post(@_) };
        local *put  = sub { do_put(@_) };
        local *del  = sub { do_del(@_) };
        $block->();

        return sub { dispatch(shift) }
    }
}

# HTTP Methods
sub route {
    my ( $pattern, $code, $method ) = @_;
    $_ROUTER->connect( $pattern, { action => $code }, { method => $method } );
}

sub do_get {
    my ( $pattern, $code ) = @_;
    route( $pattern, $code, 'GET' );
}

sub do_post {
    my ( $pattern, $code ) = @_;
    route( $pattern, $code, 'POST' );
}

sub do_put {
    my ( $pattern, $code ) = @_;
    route( $pattern, $code, 'PUT' );
}

sub do_del {
    my ( $pattern, $code ) = @_;
    route( $pattern, $code, 'DELETE' );
}

# dispatch
sub dispatch {
    my $env = shift;
    if ( my $match = $_ROUTER->match($env) ) {
        my $req = Plack::Request->new($env);
        return process_request( $req, $match );
    }
    else {
        return handle_not_found();
    }
}

sub process_request {
    my ( $req, $match ) = @_;
    my $code = delete $match->{action};
    if ( ref $code eq 'CODE' ) {
        my $res = try {
            $code->( $req, $match );
        }
        catch {
            my $e = shift;
            return handle_exception($e);
        };
        return try { $res->finalize } || $res;
    }
    else {
        return internal_server_error();
    }
}

sub handle_exception {
    my $e = shift;
    return internal_server_error();
}

sub handle_not_found {
    return not_found();
}

sub not_found {
    [ 404, [], ['Not Found'] ];
}

sub internal_server_error {
    return [ 500, [], ['Internal server error'] ];
}

1;

__END__

=encoding utf-8

=head1 NAME

PlackX::RouteBuilder - Minimalistic routing sugar for your Plack

=head1 SYNOPSIS

  # app.psgi
  use PlackX::RouteBuilder;
  my $app = router {
    get '/api' => sub {
      my $req = shift;
      my $res = $req->new_response(200);
      $res->body('Hello world');
      $res;
    },
    post '/comment/{id}' => sub {
      my ($req, $args)  = @_;
      my $id = $args->{id};
      my $res = $req->new_response(200);
      $res;
    }
  };


=head1 DESCRIPTION

PlackX::RouteBuilder is Minimalistic routing sugar for your Plack

=head1 SOURCE AVAILABILITY

This source is in Github:

  http://github.com/dann/

=head1 CONTRIBUTORS

Many thanks to:

=head1 AUTHOR

dann E<lt>techmemo@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut1;

