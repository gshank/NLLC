package NLLC::Controller::Member::Enroll;
use strict;
use warnings;

use base 'NLLC::Controller::Member::Base';

sub begin : Private
{
    my ( $self, $c ) = @_;
    
}

sub index : Path Args 
{
   my ( $self, $c ) = @_;

   $c->stash(template => 'member/enroll/index.tt');
}

sub select : Local
{
    my ( $self, $c ) = @_;

    my $monday_activities = $c->model('DB::Event')->search(
       {"me.session_id" => $c->stash->{session}, 
        "me.activity_id" => { "!=", undef }, 
        weekday => 1 }, {order_by => ['hour']})->
        search_related('activity', {}, { distinct => 1});
    my $tuesday_activities = $c->model('DB::Event')->search(
       {"me.session_id" => $c->stash->{session}, 
        "me.activity_id" => { "!=", undef }, 
        weekday => 2 }, {order_by => ['hour']})->
        search_related('activity', {}, { distinct => 1});
    my $wednesday_activities = $c->model('DB::Event')->search(
       {"me.session_id" => $c->stash->{session}, 
        "me.activity_id" => { "!=", undef }, 
        weekday => 3 }, {order_by => ['hour']})->
        search_related('activity', {}, {distinct => 1});
    my $thursday_activities = $c->model('DB::Event')->search(
       {"me.session_id" => $c->stash->{session}, 
        "me.activity_id" => { "!=", undef }, 
        weekday => 4 }, {order_by => ['hour']})->
        search_related('activity', {}, {distinct => 1});
    my $friday_activities = $c->model('DB::Event')->search(
       {"me.session_id" => $c->stash->{session}, 
        "me.activity_id" => { "!=", undef }, 
        weekday => 5 }, {order_by => ['hour']})->
        search_related('activity', {}, {distinct => 1});
    my $saturday_activities = $c->model('DB::Event')->search(
       {"me.session_id" => $c->stash->{session}, 
        "me.activity_id" => { "!=", undef }, 
        weekday => 6 }, {order_by => ['hour']})->
        search_related('activity', {}, {distinct => 1});
    my $sunday_activities = $c->model('DB::Event')->search(
       {"me.session_id" => $c->stash->{session}, 
        "me.activity_id" => { "!=", undef }, 
        weekday => 7 }, {order_by => ['hour']})->
        search_related('activity', {}, {distinct => 1});

    # Activities by day
    $c->stash( monday_activities => $monday_activities,
               tuesday_activities => $tuesday_activities,
               wednesday_activities => $wednesday_activities,
               thursday_activities => $thursday_activities,
               friday_activities => $friday_activities,
               saturday_activities => $saturday_activities,
               sunday_activities => $sunday_activities );
    # cart selections
    my $cart = $c->model('DB::Cart')->search({family_id => $c->user->id}); 
    $c->stash( cart => $cart, javascript => 'select.js',
                template => 'member/enroll/select.tt' );
}

sub add_activity : Local
{
    my ( $self, $c, $activity_id) = @_;

    # Store selection in Cart table
    $c->model('DB::Cart')->find_or_create( 
       {activity_id => $activity_id,
        family_id => $c->user->id}, {key => 'act_fam'});

    $c->res->redirect($c->uri_for('select'));
    $c->detach;
}

sub add_activity_js : Local
{
    my ( $self, $c, $activity_id) = @_;

    # Store selection in Cart table
    $c->model('DB::Cart')->find_or_create( 
       {activity_id => $activity_id,
        family_id => $c->user->id}, {key => 'act_fam'});
    $c->stash->{json_data} = "Activity added";
    $c->forward('NLLC::View::JSON');
}

sub remove_activity : Local
{
   my ( $self, $c, $activity_id ) = @_;
   # Store selection in Cart table
   my $selection = $c->model('DB::Cart')->find( 
      {activity_id => $activity_id,
       family_id => $c->user->id}, {key => 'act_fam'});
   $selection->delete if $selection;

   $c->res->redirect($c->uri_for('select'));
   $c->detach;

}

sub cart : Local
{
   my ( $self, $c ) = @_;

   # make a list of children's names for table headings
   my $children = $c->model('DB::Child')->search(
      {family_id => $c->user->id}, {order_by => 'firstname'});
   my @children;
   while (my $child = $children->next)
   {
      push @children, $child->firstname;
   }
   $children->reset;

   # Pull things in from the cart
   my @cart;
   my $dbcart = $c->model('DB::Cart')->search({family_id => $c->user->id});
   if ($dbcart->count > 0 )
   {
      while (my $cart_item = $dbcart->next)
      {
         my %activity;
         my $activity_id = $cart_item->activity_id; 
         $activity{id} = $activity_id;
         $activity{name} = $cart_item->activity->name;
         while (my $child = $children->next)
         {
            my $child = {id => $child->id,
                         name => $child->firstname,
                         interest => undef, };
            push @{$activity{children}}, $child; 
         }
         $children->reset;
         push @cart, \%activity;
      }
   }

   # Get fillinform parameters either from db or form just submitted
   my $params ||= $c->stash->{fillinform}; 
   unless ($params) # not here from "do_cart", load from database
   {
      # Check to see if enrollment info exists, to create params for FillInForm
      my $old_choices = $c->model('DB::Family')->find({family_id => $c->user->id})->
         search_related('children')->search_related('child_activities', 
            {session_id => $c->stash->{session}});
      if ($old_choices->count > 0)
      {
         while (my $choice = $old_choices->next)
         {
            $params->{$choice->activity_id . "." . $choice->child_id} = $choice->interest;
         }
      }
   } # end 

   # If no activities selected and no existing activities, error message
   if ( $dbcart->count == 0 && !$params )
   {
      $c->flash->{message} = "You must select activities first";
      $c->res->redirect($c->uri_for('select'));
      $c->detach;
   }
   $c->stash->{fillinform} = $params;
   $c->stash->{children} = \@children;
   $c->stash->{cart} = \@cart;
   $c->stash( template => 'member/enroll/cart.tt');
}

sub do_cart : Local
{
   my ( $self, $c ) = @_;

   my $params = $c->req->params;
   my %cart;
   my %selections;
   my @errors;
   # remove last round of params
   delete $c->stash->{fillinform};
   # massage params into hash
   foreach my $key ( keys %{$params} )
   {
      if ($params->{$key} eq '' || $params->{$key} eq 'Save')
      {
         delete $params->{$key};
         next;
      }
      unless ($params->{$key} =~ /^\d+$/ )
      {
         push @errors, "Value $params->{$key} is not a number";
         next;
      }
      my ($activity_id, $child_id) =  split (/\./, $key);
      
      $cart{$activity_id}{$child_id} = $params->{$key};
      $selections{$child_id}[$params->{$key}] += 1 if ($params->{$key} != 0 && $params->{$key} < 90);
   }
   # Check for duplicate interest numbers
   foreach my $key ( keys %selections )
   {
      foreach my $count ( @{$selections{$key}} )
      { 
         push (@errors, "duplicate interest number") 
             if ($count && $count > 1 );
      }
   } 
   if (scalar @errors > 0)
   {
      # redisplay form
      $c->flash->{errors} = \@errors;
      $c->flash->{fillinform} = $params;
      $c->res->redirect('cart');
      $c->detach;
   }
   
   # Else: no errors found. Save in database.

   # Must remove all previous records from database first...
   my $old_choices = $c->model('DB::Child')->
      search({"family_id" => $c->user->id})->
      search_related('child_activities',
      { session_id => $c->stash->{session}});

   while (my $child_activity = $old_choices->next)
   {
      $child_activity->delete;
   }
   
   # Create the ChildActivity records
   # And update cart choices to match
   $c->model('DB::Cart')->search({family_id => $c->user->id})->delete;
   foreach my $activity_key ( keys %cart )
   {
      foreach my $child_key ( keys %{$cart{$activity_key}} )
      {
         # save choice in ChildActivity table
         $c->model('DB::ChildActivity')->update_or_create(
          {child_id => $child_key,
           activity_id => $activity_key,
           interest => $cart{$activity_key}{$child_key},
           session_id => $c->stash->{session} },
          {key => 'act_child'});
          # update cart to record this choice
          $c->model('DB::Cart')->find_or_create( {activity_id => $activity_key,
            family_id => $c->user->id}, { key => 'act_fam'});
      }
   }

   $c->flash->{message} = "Enrollment saved";
   $c->res->redirect('view');
   $c->detach;

}

sub enroll_list : Local
{
   my ( $self, $c ) = @_;

    my $session = $c->stash->{session};
    my $activities = $c->model('DB::Event')->search(
        {"me.session_id" => $session,
         "me.activity_id" => { '!=', undef} },
        { order_by => ['weekday', 'hour'] })->
        search_related('activity', {}, {distinct => 1});
    $c->stash->{activities} = $activities;

    my $db_children = $c->model('DB::ChildActivity')->search(
       { "session_id" => $session })->search_related( 'child',
       {}, { distinct => 1 });
    my %children;
    while (my $child = $db_children->next)
    {
       my $child_id = $child->child_id;
       $children{$child_id}{name} = $child->firstname . " " . $child->lastname;
       $children{$child_id}{num_activities} = $child->search_related('child_activities', {session_id => $session})->count;
       $children{$child_id}{parent} = $child->family->first_name1 . " " . $child->family->last_name1;
       $children{$child_id}{email} = $child->family->email;
    }
    $c->stash->{children} = \%children;
    $c->stash->{template} = 'member/enroll/enroll_list.tt';
}

sub family_enroll_list : Local
{
   my ( $self, $c ) = @_;

   my $families = $c->model('DB::Family')->search({active => 1}, {order_by => ['last_name1']});
   $c->stash->{families} = $families;
   $c->stash->{template} = 'member/enroll/family_enroll_list.tt';

}

sub view : Local
{
   my ( $self, $c ) = @_;

   my $children = $c->model('DB::Child')->
      search({"family_id" => $c->user->id});
   $c->stash(children => $children);
}


=pod

sub end : Private
{
   my ( $self, $c ) = @_;

   $c->forward('render');
   $c->fillform($c->stash->{fillinform}) if $c->stash->{fillinform};
}
sub render : ActionClass('RenderView') { }

=cut

1;
