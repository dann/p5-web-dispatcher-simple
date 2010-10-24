package Web::Dispatcher::Simple::Request;
use strict;
use warnings;
use base qw/Plack::Request/;
use Web::Dispatcher::Simple::Response;

sub new_response {
    my $self = shift;
    Web::Dispatcher::Simple::Response->new(@_);
}

sub uri_for {
    my ( $self, $path, $args ) = @_;
    my $uri = $self->base;
    $uri->path($path);
    $uri->query_form(@$args) if $args;
    $uri;
}

1;
