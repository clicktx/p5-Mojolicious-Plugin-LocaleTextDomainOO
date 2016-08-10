[![Build Status](https://travis-ci.org/clicktx/p5-Mojolicious-Plugin-LocaleTextDomainOO.svg?branch=master)](https://travis-ci.org/clicktx/p5-Mojolicious-Plugin-LocaleTextDomainOO) [![Coverage Status](https://img.shields.io/coveralls/clicktx/p5-Mojolicious-Plugin-LocaleTextDomainOO/master.svg?style=flat)](https://coveralls.io/r/clicktx/p5-Mojolicious-Plugin-LocaleTextDomainOO?branch=master)
# NAME

Mojolicious::Plugin::LocaleTextDomainOO - Mojolicious Plugin

# SYNOPSIS

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
            search_dirs => [qw(your/my_app/locale)],
            # gettext_to_maketext => $boolean,
            decode => 1,
            data   => [ '*::' => '*.po' ],
        }
    );

# DESCRIPTION

[Mojolicious::Plugin::LocaleTextDomainOO](https://metacpan.org/pod/Mojolicious::Plugin::LocaleTextDomainOO) is a [Mojolicious](https://metacpan.org/pod/Mojolicious) plugin.

# OPTIONS

# HELPERS

## `lexicon`

    $self->lexicon(
        {
            search_dirs => [qw(your/my_app/locale)],
            gettext_to_maketext => $boolean,
            decode => $boolean,
            data   => [
                '*::' => '*.po',
                '*:CATEGORY:DOMAIN' => '*/test.po',
            ],
        }
    );

Gettext po or mo file as lexicon.
Locale::TextDomain::OO::Lexicon::File::(PO/MO) object.
[Locale::TextDomain::OO::Lexicon::File::PO](https://metacpan.org/pod/Locale::TextDomain::OO::Lexicon::File::PO)
[Locale::TextDomain::OO::Lexicon::File::MO](https://metacpan.org/pod/Locale::TextDomain::OO::Lexicon::File::MO)

# METHODS

[Mojolicious::Plugin::LocaleTextDomainOO](https://metacpan.org/pod/Mojolicious::Plugin::LocaleTextDomainOO) inherits all methods from
[Mojolicious::Plugin](https://metacpan.org/pod/Mojolicious::Plugin) and implements the following new ones.

## register

    $plugin->register(Mojolicious->new);

Register plugin in [Mojolicious](https://metacpan.org/pod/Mojolicious) application.

# AUTHOR

Munenori Sugimura <clicktx@gmail.com>

# SEE ALSO

[Mojolicious](https://metacpan.org/pod/Mojolicious), [Mojolicious::Guides](https://metacpan.org/pod/Mojolicious::Guides), [http://mojolicious.org](http://mojolicious.org).
