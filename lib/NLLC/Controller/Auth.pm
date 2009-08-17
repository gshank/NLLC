package NLLC::Controller::Auth;
use strict;
use warnings;
use base 'Catalyst::Controller';

=head1 NAME

NLLC::Auth

=cut

sub get_login : Local
{
    my ( $self, $c ) = @_;
    $c->flash->{destination} = $c->req->path;
    $c->flash->{message} = "Please log in";
    $c->res->redirect($c->uri_for('/auth/login'));
    $c->detach;
}

sub logout : Local
{
    my ( $self, $c ) = @_;
    $c->logout;
    $c->flash->{message} = 'Logged out';
    $c->res->redirect($c->uri_for('/'));
    $c->detach;
}

sub login : Local
{
    my ( $self, $c ) = @_;

    my $username = $c->req->params->{username};
    my $password = $c->req->params->{password};
    # The following is because the destination won't last through
    # the login cycle without being temporarily passed through the form
    my $dest = $c->flash->{destination} ||= $c->req->params->{destination} || "";
    $c->stash->{remember} = $c->req->params->{remember};
    if ( $username && $password )
    {
        if ( $c->authenticate( { username => $username,
                                 password => $password } ) )
        {
            $c->{session}{expires} = 999999999999 if $c->req->params->{remember};
            $c->flash->{message} = "Logged in";
            $c->res->redirect($c->uri_for("/" . $dest));
            $c->detach;
        }
        else
        {
            # login incorrect
            $c->log->warn("login failed. username: $username pw: $password");
            $c->stash->{message} = "Invalid username or password";
        } 
     }
     $c->stash->{template} = 'auth/login.tt';
}

1;
