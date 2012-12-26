use inc::Module::Install;
name 'HTML-Validate-Structure-Simple';
all_from 'lib/HTML/Validate/Structure/Simple.pm';

# requires '';
requires 'HTML::Parser';
requires 'HTML::Tagset';
requires 'Class::Accessor::Fast';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
test_requires 'Data::Section::Simple';
auto_set_repository;
auto_include;
WriteAll;
