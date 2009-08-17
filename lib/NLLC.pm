package NLLC;

use strict;
use warnings;
use Data::Dumper;

use Catalyst::Runtime;

use Catalyst (
   '-LOG=warn',                 
   'ConfigLoader',
   'FillInForm',
   'Form::Processor',        
#   'FillInForm',
   'Authentication',         
   'Authorization::Roles',
   'Session',                
   'Session::Store::FastMmap',
   'Session::State::Cookie', 
   'Static::Simple',
   'Log::Dispatch',
#   'Params::Nested',
);

our $VERSION = '0.01';

NLLC->config(
   {
      name    => 'NLLC',
      session => { flash_to_stash => 1 },
      default_view => 'TT',
   }
);

NLLC->config->{authentication} = {
   default_realm => 'default',
   realms        => {
      default => {
         credential => {
            class          => 'Password',
            password_field => 'password',
            password_type  => 'clear',
         },
         store => {
            class      => 'DBIx::Class',
            user_class => 'DB::Family',
            role_relation => 'roles',
            role_field    => 'role',
         }
      },
   }
};
NLLC->config->{form} = {
   pre_load_forms  => 1,
   form_name_space => 'NLLC::Form',
};

NLLC->config->{'Log::Dispatch'} = [
   {
      class       => 'File',
      name        => 'file',
      min_level   => 'warning',
      filename    => NLLC->path_to('logs/nllc.log')->stringify,
      mode        => 'append',
      format      => '%d{%m%d.%R} %m %n',
      permissions => 0666,
   },
   {
      class       => 'File',
      name        => 'error_log',
      min_level   => 'error',
      filename    => NLLC->path_to('logs/error.log')->stringify,
      mode        => 'append',
      format      => '%d{%m%d.%R} [%p] %P: %m %n',
      permissions => 0666,
   }
];

NLLC->config->{'View::JSON'} = {
#   allow_callback => 1,
#   callback_param => 'callback',
   expose_stash => 'json_data',
};

# Start the application

NLLC->setup;

sub finalize_error
{
   my ($c) = @_;

   $c->response->content_type('text/html; charset=utf-8');
   $c->log->error("500 error: \n" . Dumper($c->error)); 
   $c->response->body( "<h2>An error occurred</h2> <p>We apologize for the inconvenience.</p>" );
   $c->response->status(500);
}


=head1 NAME

NLLC - Catalyst based application

=head1 SYNOPSIS

    script/nllc_server.pl

=head1 DESCRIPTION

[enter your description here]

=head1 SEE ALSO

L<NLLC::Controller::Root>, L<Catalyst>

=head1 AUTHOR

Gerda Shank

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

sub log_user_req
{
   my ( $self, $c ) = @_;
   my $log_str = "   " . $c->req->address;
   $log_str .= "  " . $c->user->username if ($c->user_exists);
   $log_str .= "  " . $c->req->path;
   $log_str .= "\n      " . $c->req->user_agent unless ($c->user_exists);     

   $c->log->warn($log_str);
}

1;
