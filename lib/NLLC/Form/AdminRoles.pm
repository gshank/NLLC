package NLLC::Form::AdminRoles;
use HTML::FormHandler::Moose;
extends 'HTML::FormHandler';

has 'schema' => ( is => 'ro', required => 1 );
has '+widget_wrapper' => ( default => 'None' );

has_field 'admin_roles' => ( type => 'Repeatable' );
has_field 'admin_roles.family'    => ( type => 'Hidden' );
has_field 'admin_roles.family_id' => ( type => 'PrimaryKey' );
has_field 'admin_roles.admin_flag' => ( type => 'Boolean', label => 'Admin' );

sub init_object {
    my $self = shift;

    my @is_admin;
    my @is_not_admin;
    my $active_families = $self->schema->resultset('Family')->search( { active => 1 } );
    while ( my $fam = $active_families->next ) {
        my $admin_flag = $fam->search_related('user_roles', { role_id => 2 } )->count > 0 ? 1 : 0;
        my $family_name = $fam->name1 . ", " . $fam->name2;
        my $elem =  { family => $family_name, family_id => $fam->family_id, admin_flag => $admin_flag };
        if( $admin_flag ) {
            push @is_admin, $elem;
        }
        else {
            push @is_not_admin, $elem;
        }
    } 
    # sort into admin flag first, then family_name
    @is_admin = sort { $a->{family} cmp $b->{family} } @is_admin;
    @is_not_admin = sort { $a->{family} cmp $b->{family} } @is_not_admin;
    return { admin_roles => [@is_admin, @is_not_admin] };
}

sub html_admin_roles_family {
    my ( $self, $field ) = @_;

    my $name = $field->value;
    return "<b>$name</b>";
}

sub update_model {
    my $self = shift;

    my $families = $self->schema->resultset('Family');
    my $family_roles = $self->value->{admin_roles};
    foreach my $elem ( @{$family_roles} ) {
        my $fam = $families->find( $elem->{family_id} );
        my $has_admin_flag = $fam->search_related('user_roles', { role_id => 2 } )->count > 0;
        if( $elem->{admin_flag} == 1 && !$has_admin_flag ) {
            $fam->create_related('user_roles', { role_id => 2 } );
        }
        elsif( $elem->{admin_flag} == 0 && $has_admin_flag ) {
            $fam->delete_related('user_roles', { role_id => 2 } );
        }
    }  
}



1;
