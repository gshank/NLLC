package NLLC::Controller::Admin::CmsPage;

use Moose;
BEGIN { extends 'NLLC::Controller::Admin::Base'; }
use NLLC::Form::CmsPage;

=head1 NAME

NLLC::Controller::Admin::CmsPage - Allow editing of dynamic pages 

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index 

=cut

sub create : Local {
    my ( $self, $c ) = @_;
$DB::single=1;  
    my $page = $c->model('DB')->resultset('CmsPage')->new_result({});
    return $self->form($c, $page );
}

sub edit : Local
{
    my ( $self, $c, $page_id) = @_;

    my $page = $c->model('DB')->resultset('CmsPage')->find($page_id);
    return $self->form($c, $page);
}

sub form {
    my ( $self, $c, $page ) = @_;

    my $form = NLLC::Form::CmsPage->new;
    $form->process(item => $page, params => $c->req->params);
    $c->stash( template => 'admin/page/edit.tt', form => $form );
    return unless $form->validated;

    # form validated. Display...
    $c->flash->{message} = 'Page saved';
    $c->res->redirect( $c->uri_for('view', $page->id));
}

sub list : Local
{
    my ( $self, $c ) = @_;

    $c->stash->{pages} = $c->model('DB')->resultset('CmsPage');
    $c->stash->{template} = 'admin/page/list.tt';
}

sub view : Local
{
    my ( $self, $c, $page_id ) = @_;
    my $page = $c->model('DB')->resultset('CmsPage')->find($page_id);
    $c->stash( page => $page,
               template => 'admin/page/view.tt' );
}


=head1 AUTHOR

Gerda Shank

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
