package NLLC::Controller::Admin::Base;
use strict;
use warnings;
use base 'Catalyst::Controller';

sub auto : Private
{
   my ( $self, $c ) = @_;
$DB::single=1;
   unless ( $c->user_exists )
   {
      NLLC::Controller::Auth->get_login($c);
      return 0;
   }
   unless ( $c->check_user_roles('admin') )
   {
      $c->flash->{message} = 'You are not an administrator';
      $c->res->redirect( $c->uri_for('/') );
      $c->detach;
      return 0;
   }

   $c->log_user_req($c);

   $c->stash->{admin}           = 'true';
   $c->stash->{session}         = $c->model('DB::State')->find(1)->value;
   $c->stash->{new_session}     = $c->model('DB::State')->find(4)->value;
   $c->stash->{proposals}       = $c->model('DB::State')->find(2)->value;
   $c->stash->{enrollment}    = $c->model('DB::State')->find(3)->value;
   $c->stash->{current_session} = $c->model('DB::Session')->find( $c->stash->{session} );
   $c->stash->{next_session} = $c->model('DB::Session')->find( $c->stash->{new_session} );
   return 1;
}

1;
