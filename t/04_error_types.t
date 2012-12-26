use strict;
use warnings;
use utf8;
use Test::More;
use HTML::Validate::Structure::Simple;
use Data::Section::Simple qw(get_data_section);;

my $html = get_data_section();

subtest 'only head unclosed' => sub {
    my $v = HTML::Validate::Structure::Simple->new();
    $v->parse( $html->{'only_head_unclosed.html'} );
    is scalar $v->errors(), 1, 'num errors';
    for my $error ( $v->errors() ) {
        is $error->type, 'unclosed', 'type';
        is $error->tag, 'head', 'tag';
        subtest 'as_string' => sub {
            my $type = $error->type;
            my $tag = $error->tag;
            like $error->as_string, qr/^\(\d+:\d+\) $tag is $type\.$/, 'as_string';
        };
    }
};

subtest 'only h1 unopened' => sub {
    my $v = HTML::Validate::Structure::Simple->new();
    $v->parse( $html->{'only_h1_unopened.html'} );
    is scalar $v->errors(), 1, 'num errors';
    for my $error ( $v->errors() ) {
        is $error->type, 'unopened', 'type';
        is $error->tag, 'h1', 'tag';
        subtest 'as_string' => sub {
            my $type = $error->type;
            my $tag = $error->tag;
            like $error->as_string, qr/^\(\d+:\d+\) $tag is $type\.$/, 'as_string';
        };
    }
};

subtest 'mixed unclosed and unopened' => sub {
    my $v = HTML::Validate::Structure::Simple->new();
    $v->parse( $html->{'mixed_unclosed_and_unopened.html'} );
    is scalar $v->errors(), 2, 'num errors';
};


done_testing();

__DATA__

@@ only_head_unclosed.html
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

@@ only_h1_unopened.html
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>TEST</title>
  </head>
  <body>
    マルチバイト</h1>
    <div class="hoge">
      <a href="http://example.com/"><img src="http://example.com/image.jpg" /></a>
    </div>
    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
  </body>
</html>

@@ mixed_unclosed_and_unopened.html
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>TEST</title>
  <body>
    マルチバイト</h1>
    <div class="hoge">
      <a href="http://example.com/"><img src="http://example.com/image.jpg" /></a>
    </div>
    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
  </body>
</html>

