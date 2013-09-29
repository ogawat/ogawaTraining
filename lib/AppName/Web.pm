package AppName::Web;

use strict;
use warnings;      
use utf8;
use Kossy;
use Teng;
use Teng::Schema::Loader;
use Data::Dumper;

my $dsn    = 'dbi:mysql:AppName';
my $user   = 'root';
my $passwd = 'tokki';
my $dbh = DBI->connect($dsn, $user, $passwd, {
        'mysql_enable_utf8' => 1,
    });
my $teng = Teng::Schema::Loader->load(
    'dbh'       => $dbh,
    'namespace' => 'MyApp::DB',
);


filter 'set_title' => sub {
    my $app = shift;
    sub {
        my ( $self, $c )  = @_;
        $c->stash->{site_name} = __PACKAGE__;
        $app->($self,$c);
    }
};

#一覧表示
get '/' => [qw/set_title/] => sub {
    my ( $self, $c )  = @_;
    my $rows = $teng->search('message', {});
    my $messages = $rows->all;
    $c->render('index.tx', { messages => $messages });
};

#登録
post '/' => sub {
    my ( $self, $c )  = @_;
    my $data =  $c->req->parameters;

$teng->insert('content' => 
{
    'title'         => $data->{"title"},
    'memo'   => $data->{"memo"},
    'priority' => $data->{"priority"},
    'status' => $data->{"status"}
});

print Dumper $teng;


    return $c->redirect('/');
};


get '/json' => sub {
    my ( $self, $c )  = @_;
    my $result = $c->req->validator([
        'q' => {
            default => 'Hello',
            rule => [
                [['CHOICE',qw/Hello Bye/],'Hello or Bye']
            ],
        }
    ]);
    $c->render_json({ greeting => $result->valid->get('q') });
};
