#!/usr/local/bin/perl
use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib";
use NLLC::Schema::DB;

my $schema = NLLC::Schema::DB->connect('DBI:mysql:nllc', 'nllc_admin', 'nllcpw');

my $family = $schema->resultset('Family')->find(42);

print "Family for " . $family->first_name1 . " " . $family.last_name1 . " and " . $family->first_name2 . "\n";

my $children = $family->children;
$DB::single=1;


while (my $child = $children->next)
{
    print $child->firstname . "\n";

    print "child->activities\n";
    my $activities = $child->activities;
    while (my $activity = $activities->next)
    {
        print "****" . $activity->name . "\n";
    }
    print "child->current_activities\n";
#    my $current_activities = $child->search_related('child_activities')->search_related('activity', {current => 1});
    my $current_activities = $child->current_activities;
    while (my $activity = $current_activities->next)
    {
        print "****" . $activity->name . "\n";
    }
    print "===========================================\n";
}


