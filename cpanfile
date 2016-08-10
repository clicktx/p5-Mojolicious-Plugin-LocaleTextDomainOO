requires 'Mojolicious',            '6.64';
requires 'Locale::TextDomain::OO', '1.023';
requires 'Safe',                   '2.32'; # Hack for Devel::Cover

on build => sub {
    requires 'ExtUtils::MakeMaker';
};

on test => sub {
    requires 'Test::More';
};
