package NLLC::Controller::Member::Base;
use strict;
use warnings;
use base 'Catalyst::Controller';

sub auto : Private
{
   my ( $self, $c ) = @_;
   unless ( $c->user_exists )
   {
      NLLC::Controller::Auth->get_login($c);
      return 0;
   }

   $c->log_user_req($c);

   $c->stash->{member}          = 'true';
   $c->stash->{session}         = $c->model('DB::State')->find(1)->value;
   $c->stash->{new_session}     = $c->model('DB::State')->find(4)->value;
   $c->stash->{proposals}       = $c->model('DB::State')->find(2)->value;
   $c->stash->{enrollment}    = $c->model('DB::State')->find(3)->value;
   $c->stash->{current_session} = $c->model('DB::Session')->find( $c->stash->{session} );
   return 1;
}

1;
