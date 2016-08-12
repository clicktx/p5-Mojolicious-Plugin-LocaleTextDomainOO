[![Build Status](https://travis-ci.org/clicktx/p5-Mojolicious-Plugin-LocaleTextDomainOO.svg?branch=master)](https://travis-ci.org/clicktx/p5-Mojolicious-Plugin-LocaleTextDomainOO)
# NAME

Mojolicious::Plugin::LocaleTextDomainOO - I18N(GNU getext) for Mojolicious.

# SYNOPSIS

    # Mojolicious
    $self->plugin('LocaleTextDomainOO');

    # Mojolicious::Lite
    plugin 'LocaleTextDomainOO';

## Plugin configuration

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

# DESCRIPTION

[Locale::TextDomain::OO](https://metacpan.org/pod/Locale::TextDomain::OO) is a I18N tool of perl OO interface.
[Mojolicious::Plugin::LocaleTextDomainOO](https://metacpan.org/pod/Mojolicious::Plugin::LocaleTextDomainOO) is internationalization  plugin for [Mojolicious](https://metacpan.org/pod/Mojolicious).

This module is similar to [Mojolicious::Plugin::I18N](https://metacpan.org/pod/Mojolicious::Plugin::I18N).
But, [Locale::MakeText](https://metacpan.org/pod/Locale::MakeText) is not using "text domain"...

# OPTIONS

## `file_type`

    plugin LocaleTextDomainOO => { file_type => 'po' };

Gettext lexicon File type. default to `po`.

## `default_language`

    plugin LocaleTextDomainOO => { default_language => 'ja' };

Default language. default to `en`.

## `plugins`

    plugin LocaleTextDomainOO => { plugins => [ qw /Your::LocaleTextDomainOO::Plugin/ ] };

Add plugin. default to `Expand::Gettext::DomainAndCategory` plugin onry.

# HELPERS

## `locale`

    # Mojolicious Lite
    my $loc = app->locale;

Returned Locale::TextDomain::OO object.

## `lexicon`

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

Gettext '\*.po' or '\*.mo' file as lexicon.
See [Locale::TextDomain::OO::Lexicon::File::PO](https://metacpan.org/pod/Locale::TextDomain::OO::Lexicon::File::PO) [Locale::TextDomain::OO::Lexicon::File::MO](https://metacpan.org/pod/Locale::TextDomain::OO::Lexicon::File::MO)

## `language`

    app->language('ja');
    my $language = app->language;

Set or Get language.

## `__, __x, __n, __nx`

    # In controller
    app->__('hello');
    app->__x('hello, {name}', name => 'World');

    # In template
    <%= __ 'hello' %>
    <%= __x 'hello, {name}', name => 'World' %>

See [Locale::TextDomain::OO::Plugin::Expand::Gettext](https://metacpan.org/pod/Locale::TextDomain::OO::Plugin::Expand::Gettext)

## `__p, __px, __np, __npx`

    # In controller
    app->__p(
        'time',  # Context (msgctxt)
        'hello'
    );

    # In template
    <%= __p 'time', 'hello' %>

See [Locale::TextDomain::OO::Plugin::Expand::Gettext](https://metacpan.org/pod/Locale::TextDomain::OO::Plugin::Expand::Gettext)

## `N__, N__x, N__n, N__nx, N__p, N__px, N__np, N__npx`

See [Locale::TextDomain::OO::Plugin::Expand::Gettext](https://metacpan.org/pod/Locale::TextDomain::OO::Plugin::Expand::Gettext)

## `__begin_d, __end_d, __d, __dn, __dp, __dnp, __dx, __dnx, __dpx, __dnpx`

    # In controller
    app->__d(
        'domain',  # Text Domain
        'hello'
    );

    # In template
    <%= __d 'domain', 'hello' %>

See [Locale::TextDomain::OO::Plugin::Expand::Gettext::DomainAndCategory](https://metacpan.org/pod/Locale::TextDomain::OO::Plugin::Expand::Gettext::DomainAndCategory)

## `N__d, N__dn, N__dp, N__dnp, N__dx, N__dnx, N__dpx, N__dnpx`

See [Locale::TextDomain::OO::Plugin::Expand::Gettext::DomainAndCategory](https://metacpan.org/pod/Locale::TextDomain::OO::Plugin::Expand::Gettext::DomainAndCategory)

# METHODS

[Mojolicious::Plugin::LocaleTextDomainOO](https://metacpan.org/pod/Mojolicious::Plugin::LocaleTextDomainOO) inherits all methods from
[Mojolicious::Plugin](https://metacpan.org/pod/Mojolicious::Plugin) and implements the following new ones.

## register

    $plugin->register(Mojolicious->new);

Register plugin in [Mojolicious](https://metacpan.org/pod/Mojolicious) application.

# DEBUG MODE

    # debug mode on
    BEGIN { $ENV{MOJO_I18N_DEBUG} = 1 }

    # or
    MOJO_I18N_DEBUG=1 perl script.pl

# AUTHOR

Munenori Sugimura <clicktx@gmail.com>

# SEE ALSO

[Locale::TextDomain::OO](https://metacpan.org/pod/Locale::TextDomain::OO), [Mojolicious](https://metacpan.org/pod/Mojolicious), [Mojolicious::Guides](https://metacpan.org/pod/Mojolicious::Guides), [http://mojolicious.org](http://mojolicious.org).

# LICENSE

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See [perlartistic](https://metacpan.org/pod/perlartistic).
