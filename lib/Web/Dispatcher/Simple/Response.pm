package Web::Dispatcher::Simple::Response;
use strict;
use warnings;
use Encode;

use base qw/Plack::Response/;

sub encode_body {
    my $self = shift;
    my $encoded_body = Encode::encode('utf8',$self->body);
    $self->body($encoded_body);
    $encoded_body;
}

sub not_found {
    my ($self, $error) = @_;
    $self->status( 500 );
    $self->content_type('text/html; charset=UTF-8');
    $error ||=  'Not Found';
    $self->body( $error );
    $self->content_length($error);
    $self;
}

sub server_error {
    my ($self, $error) = @_;
    $self->status( 500 );
    $self->content_type('text/html; charset=UTF-8');
    $error ||= 'Internal Server Error';
    $self->body( $error );
    $self->content_length($error);
    $self;
}

1;
