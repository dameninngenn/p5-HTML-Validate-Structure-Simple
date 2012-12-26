use strict;
use warnings;
use utf8;
use Test::More;
use HTML::Validate::Structure::Simple;
use Data::Section::Simple qw(get_data_section);;

my $html = get_data_section();

subtest 'no errors' => sub {
    my $v = HTML::Validate::Structure::Simple->new();
    $v->parse( $html->{'valid.html'} );
    is scalar $v->errors(), 0, 'no errors';
};

subtest 'has errors' => sub {
    my $v = HTML::Validate::Structure::Simple->new();
    $v->parse( $html->{'invalid.html'} );
    isnt scalar $v->errors(), 0, 'has errors';
};


done_testing();

__DATA__

@@ valid.html
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>TEST</title>
  </head>
  <body>
    <h1>マルチバイト</h1>
    <div class="hoge">
      <a href="http://example.com/"><img src="http://example.com/image.jpg" /></a>
    </div>
    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
  </body>
</html>

@@ invalid.html
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>TEST</title>
  <body>
    <h1>マルチバイト</h1>
    <div class="hoge">
      <a href="http://example.com/"><img src="http://example.com/image.jpg" /></a>
    </div>
    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
  </body>
</html>

