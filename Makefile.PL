use inc::Module::Install;

name 'NLLC';
all_from 'lib/NLLC.pm';

requires 'Catalyst::Runtime' => '5.7012';
requires 'Catalyst::Plugin::ConfigLoader';
requires 'Config::Any::Perl';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Plugin::Log::Dispatch';
requires 'Catalyst::Plugin::Authorization::Roles';
requires 'Catalyst::View::TT';
requires 'Catalyst::View::FillInForm';
requires 'HTML::FormHandler';
requires 'HTML::FormHandler::Model::DBIC';
requires 'DateTime::Format::ICal';
requires 'Data::ICal';
requires 'Log::Dispatch::Config';
requires 'Catalyst::Action::RenderView';
requires 'YAML'; # This should reflect the config file format you've chosen
                 # See Catalyst::Plugin::ConfigLoader for supported formats
catalyst;

install_script glob('script/*.pl');
auto_install;
WriteAll;
