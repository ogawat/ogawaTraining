package AppName::Web;

use strict;
use warnings;      
use utf8;
use Kossy;
use DBI;
use DBIx::Custom;;
use Data::Dumper;
use Time::Piece;
use Time::Seconds;

my $dsn    = 'dbi:mysql:AppName';
my $user   = 'root';
my $passwd = 'tokki';

my $dbi = DBIx::Custom->connect(
  dsn => "dbi:mysql:database=AppName",
  user => 'root',
  password => 'tokki',
  option => {mysql_enable_utf8 => 1}
);

filter 'set_title' => sub {
    my $app = shift;
    sub {
        my ( $self, $c ) = @_;
        $c->stash->{site_name} = __PACKAGE__;
        $app->($self,$c);
    }
};

#一覧表示
# get '/' => [qw/set_title/] => sub {
#     my ( $self, $c )  = @_;
#     my $result = $dbi->execute("select * from content");
#     #my $rows = $result->all;
#     $c->render('index.tx', { contents=>$result });

# };

 #アラート
 get '/' => [qw/set_title/] => sub {
     print Dumper 'ああああああ';
     my ( $self, $c )  = @_;
     my $dt = localtime;
        my $content = $dbi->select(table => 'content');
        my @view_title;
        my $count=0;
        my $result = $dbi->execute("select * from content");
        
          while (my $row = $content->fetch_hash){
                 my $deadline =Time::Piece->strptime($row->{deadline},'%Y-%m-%d %H:%M:%S');
                 print Dumper $row->{deadline};
                 my $sub_date = $deadline - $dt;
                 if($sub_date->days < 1)
                 {
                     $view_title[$count] = $row->{title};
                     $count++;
                  }

                  print Dumper $deadline->ymd;                                   
                  print Dumper $dt->ymd;                                         
                  print Dumper int($sub_date->days);                             
            }
            $c->render('index.tx', { title => \@view_title,contents=>$result});
           # $c->render('graph.tx',{week => \@view_week,busy_point => \@busy_point});

        };
    

#登録
post '/' => sub {
    my ( $self, $c )  = @_;
    my $data =  $c->req->parameters;

$dbi->insert(
    {
    'title'         => $data->{"title"},
    'memo'   => $data->{"memo"},
    'priority' => $data->{"priority"},
    'status' => $data->{"status"},
    'deadline' => $data->{"deadline"},
    },table =>'content');
    return $c->redirect('/');
};


#削除
post '/{id}/delete' => sub {
    my ($self, $c) = @_;
    $dbi->delete(where => {id => $c->args->{'id'}}, table => 'content');
    $c->redirect('/');
};
   #   my $result = $c->req->validator([
   #      'id' => {
   #          default => '0',
   #          rule => [
   #              [['NOT_NULL','empty id'],]
   #          ],
   #      }
   #  ]);
   # print Dumper $result;
  # $rows->delete('posts' => {'id' => $c->args->{'id'}}); 
  #   $dbi->delete(where => {id => {$result->valid->get('id')}}, table => 'content');

post '/{id}/edit' => sub {
    my ($self, $c) = @_;
    my $data =  $c->req->parameters;
    
    $dbi->update(
    {
    'title'         => $data->{"title"},
    'memo'   => $data->{"memo"},
    'priority' => $data->{"priority"},
    'status' => $data->{"status"},
    'deadline' => $data->{"deadline"}
    },table =>'content',
    where => {id => $c->args->{'id'}}
    );
    return $c->redirect('/');
    $c->redirect('/');
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
