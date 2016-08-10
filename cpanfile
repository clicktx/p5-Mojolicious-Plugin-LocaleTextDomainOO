requires 'Mojolicious',            '6.64';
requires 'Locale::TextDomain::OO', '1.023';
requires 'Safe',                   '2.23'; # Hack

on build => sub {
    requires 'ExtUtils::MakeMaker';
};

on test => sub {
    requires 'Test::More';
};
