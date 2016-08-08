requires 'Mojolicious', '6.64';
requires 'Locale::TextDomain::OO', '1.023';

on build => sub {
    requires 'ExtUtils::MakeMaker';
};
