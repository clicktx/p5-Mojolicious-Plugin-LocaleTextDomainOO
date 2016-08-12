package Mojolicious::Plugin::LocaleTextDomainOO;
use Mojo::Base 'Mojolicious::Plugin';

use Locale::TextDomain::OO;
use Locale::TextDomain::OO::Lexicon::File::PO;
use Locale::TextDomain::OO::Lexicon::File::MO;

our $VERSION = '0.01';

has 'po' => sub { Locale::TextDomain::OO::Lexicon::File::PO->new };
has 'mo' => sub { Locale::TextDomain::OO::Lexicon::File::MO->new };

sub register {
    my ( $plugin, $app, $plugin_config ) = @_;

    my $logger = sub {
        my ( $message, $arg_ref ) = @_;
        my $type = $arg_ref->{type};

        # $app->log->$type($message);
        $app->log->debug($message);
        return;
    };

    my $lexicon;
    my $file_type = $plugin_config->{file_type} // 'po';
    $lexicon = $plugin->$file_type;
    $lexicon->logger($logger);

    # Add "lexicon" helper
    $app->helper(
        lexicon => sub {
            my ( $app, $conf ) = @_;

            # Default: utf8 flaged
            $conf->{decode} = $conf->{decode} // 1;
            $lexicon->lexicon_ref($conf);
        }
    );

    # Add "locale" helper
    $app->helper(
        locale => sub {
            my ($self) = @_;
            my $plugins = [qw/Expand::Gettext::DomainAndCategory/];
            push @$plugins, @{ $plugin_config->{plugins} }
              if ( ref $plugin_config->{plugins} eq 'ARRAY' );
            my $language = $plugin_config->{default_language} // 'en';

            Locale::TextDomain::OO->instance(
                plugins  => $plugins,
                language => $language,
                logger   => $logger,
            );
        }
    );

    # Add "language" helper
    $app->helper(
        language => sub {
            my ( $self, $lang ) = @_;
            if ($lang) {
                $self->locale->language($lang);
            }
            else {
                return $self->locale->language;
            }
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


Plugin configuration

  # your app in startup
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

=head1 DESCRIPTION

L<Mojolicious::Plugin::LocaleTextDomainOO> is internationalization  plugin for L<Mojolicious>.

This module is similar to L<Mojolicious::Plugin::I18N>.
But, L<Locale::MakeText> is not using "text domain"...

=head1 OPTIONS

=head1 HELPERS

=over

=item * C<locale>

    # Mojolicious Lite
    my $loc = app->locale;

Returned Locale::TextDomain::OO object.

=item * C<lexicon>

    $self->lexicon(
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
See Also L<Locale::TextDomain::OO::Lexicon::File::PO> L<Locale::TextDomain::OO::Lexicon::File::MO>

=item * C<language>

    app->language('ja');
    my $language = app->language;

Set or Get language.

=item * __, __x, __n, __nx

=item * __p, __px, __np, __npx

=item * N__, N__x, N__n, N__nx, N__p, N__px, N__np, N__npx

=item * __begin_d, __end_d, __d, __dn, __dp, __dnp, __dx, __dnx, __dpx, __dnpx

=item * N__d, N__dn, N__dp, N__dnp, N__dx, N__dnx, N__dpx, N__dnpx

=back

=head1 METHODS

L<Mojolicious::Plugin::LocaleTextDomainOO> inherits all methods from
L<Mojolicious::Plugin> and implements the following new ones.

=head2 register

  $plugin->register(Mojolicious->new);

Register plugin in L<Mojolicious> application.

=head1 AUTHOR

Munenori Sugimura <clicktx@gmail.com>

=head1 SEE ALSO

L<Mojolicious>, L<Mojolicious::Guides>, L<http://mojolicious.org>.

=cut
