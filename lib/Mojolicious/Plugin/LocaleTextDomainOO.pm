package Mojolicious::Plugin::LocaleTextDomainOO;
use Mojo::Base 'Mojolicious::Plugin';

use Locale::TextDomain::OO;
use Locale::TextDomain::OO::Lexicon::File::PO;
use Locale::TextDomain::OO::Lexicon::File::MO;
use constant DEBUG => $ENV{MOJO_I18N_DEBUG} || 0;

our $VERSION = '0.01';

has 'po' => sub { Locale::TextDomain::OO::Lexicon::File::PO->new };
has 'mo' => sub { Locale::TextDomain::OO::Lexicon::File::MO->new };

my $plugins_default = [qw/Expand::Gettext::DomainAndCategory/];

sub register {
    my ( $plugin, $app, $plugin_config ) = @_;

    # Initialize
    my $language = $plugin_config->{default_language} || 'en';
    my $plugins = $plugins_default;
    push @$plugins, @{ $plugin_config->{plugins} }
      if ( ref $plugin_config->{plugins} eq 'ARRAY' );

    my $logger = sub {};
    $logger = sub {
        my ( $message, $arg_ref ) = @_;
        my $type = $arg_ref->{type} || 'debug';
        $app->log->$type($message);
        return;
    } if DEBUG;

    my $lexicon;
    my $file_type = $plugin_config->{file_type} || 'po';
    $lexicon = $plugin->$file_type;

    # Add "locale" helper
    $app->helper(
        locale => sub {
            my ($self) = @_;
            Locale::TextDomain::OO->instance(
                plugins  => $plugins,
                language => $language,
                logger   => $logger,
            );
        }
    );

    # Add "lexicon" helper
    $app->helper(
        lexicon => sub {
            my ( $app, $conf ) = @_;
            $conf->{decode} = $conf->{decode} // 1;    # Default: utf8 flaged
            $lexicon->lexicon_ref($conf);
        }
    );

    # Add "language" helper
    $app->helper(
        language => sub {
            my ( $self, $lang ) = @_;
            if   ($lang) { $self->locale->language($lang) }
            else         { $self->locale->language }
        }
    );

    # Add helper from gettext methods
    my @methods = (
        qw/
          __
          __x
          __n
          __nx
          __p
          __px
          __np
          __npx

          N__
          N__x
          N__n
          N__nx
          N__p
          N__px
          N__np
          N__npx

          __begin_d
          __end_d
          __d
          __dn
          __dp
          __dnp
          __dx
          __dnx
          __dpx
          __dnpx

          N__d
          N__dn
          N__dp
          N__dnp
          N__dx
          N__dnx
          N__dpx
          N__dnpx
          /
    );

    foreach my $method (@methods) {
        $app->helper( $method => sub { shift->app->locale->$method(@_) } );
    }
}

1;
__END__

=encoding utf8

=head1 NAME

Mojolicious::Plugin::LocaleTextDomainOO - I18N(GNU getext) for Mojolicious.

=head1 SYNOPSIS

  # Mojolicious
  $self->plugin('LocaleTextDomainOO');

  # Mojolicious::Lite
  plugin 'LocaleTextDomainOO';


=head2 Plugin configuration

  # your app in startup method
  sub startup {
      $self->plugin('LocaleTextDomainOO',
        {
            file_type => 'po',              # or 'mo'. default: po
            default_language => 'ja',       # default en
            plugins => [                    # more Locale::TextDomain::OO plugins.
                qw/ +Your::Special::Plugin  # default Expand::Gettext::DomainAndCategory plugin onry.
            /],
        }
      );

      $self->lexicon(
          {
              search_dirs => [qw(/path/my_app/locale)],
              gettext_to_maketext => $boolean,              # option
              decode => $boolean,                           # option
              data   => [ '*::' => '*.po' ],
          }
      );
    ...
  }

=head1 DESCRIPTION

L<Locale::TextDomain::OO> is a I18N tool of perl OO interface.
L<Mojolicious::Plugin::LocaleTextDomainOO> is internationalization  plugin for L<Mojolicious>.

This module is similar to L<Mojolicious::Plugin::I18N>.
But, L<Locale::MakeText> is not using "text domain"...

=head1 OPTIONS

=head2 C<file_type>

    plugin LocaleTextDomainOO => { file_type => 'po' };

Gettext lexicon File type. default to C<po>.

=head2 C<default_language>

    plugin LocaleTextDomainOO => { default_language => 'ja' };

Default language. default to C<en>.

=head2 C<plugins>

    plugin LocaleTextDomainOO => { plugins => [ qw /Your::LocaleTextDomainOO::Plugin/ ] };

Add plugin. default to C<Expand::Gettext::DomainAndCategory> plugin onry.

=head1 HELPERS

=head2 C<locale>

    # Mojolicious Lite
    my $loc = app->locale;

Returned Locale::TextDomain::OO object.

=head2 C<lexicon>

    app->lexicon(
        {
            search_dirs => [qw(your/my_app/locale)],
            gettext_to_maketext => $boolean,
            decode => $boolean,                         # default true. *** utf8 flaged ***
            data   => [
                '*::' => '*.po',
                '*:CATEGORY:DOMAIN' => '*/test.po',
            ],
        }
    );

Gettext '*.po' or '*.mo' file as lexicon.
See L<Locale::TextDomain::OO::Lexicon::File::PO> L<Locale::TextDomain::OO::Lexicon::File::MO>

=head2 C<language>

    app->language('ja');
    my $language = app->language;

Set or Get language.

=head2 C<__, __x, __n, __nx>

    # In controller
    app->__('hello');
    app->__x('hello, {name}', name => 'World');

    # In template
    <%= __ 'hello' %>
    <%= __x 'hello, {name}', name => 'World' %>

See L<Locale::TextDomain::OO::Plugin::Expand::Gettext>

=head2 C<__p, __px, __np, __npx>

    # In controller
    app->__p(
        'time',  # Context (msgctxt)
        'hello'
    );

    # In template
    <%= __p 'time', 'hello' %>

See L<Locale::TextDomain::OO::Plugin::Expand::Gettext>

=head2 C<N__, N__x, N__n, N__nx, N__p, N__px, N__np, N__npx>

See L<Locale::TextDomain::OO::Plugin::Expand::Gettext>

=head2 C<__begin_d, __end_d, __d, __dn, __dp, __dnp, __dx, __dnx, __dpx, __dnpx>

    # In controller
    app->__d(
        'domain',  # Text Domain
        'hello'
    );

    # In template
    <%= __d 'domain', 'hello' %>

See L<Locale::TextDomain::OO::Plugin::Expand::Gettext::DomainAndCategory>

=head2 C<N__d, N__dn, N__dp, N__dnp, N__dx, N__dnx, N__dpx, N__dnpx>

See L<Locale::TextDomain::OO::Plugin::Expand::Gettext::DomainAndCategory>

=head1 METHODS

L<Mojolicious::Plugin::LocaleTextDomainOO> inherits all methods from
L<Mojolicious::Plugin> and implements the following new ones.

=head2 register

  $plugin->register(Mojolicious->new);

Register plugin in L<Mojolicious> application.

=head1 DEBUG MODE

    # debug mode on
    BEGIN { $ENV{MOJO_I18N_DEBUG} = 1 }

    # or
    MOJO_I18N_DEBUG=1 perl script.pl

=head1 AUTHOR

Munenori Sugimura <clicktx@gmail.com>

=head1 SEE ALSO

L<Locale::TextDomain::OO>, L<Mojolicious>, L<Mojolicious::Guides>, L<http://mojolicious.org>.

=head1 LICENSE

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

=cut
