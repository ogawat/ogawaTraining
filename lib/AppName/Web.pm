package AppName::Web;

use strict;
use warnings;      
use utf8;
use Kossy;
use DBI;
use DBIx::Custom;;
use Data::Dumper;

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
get '/' => [qw/set_title/] => sub {
    my ( $self, $c )  = @_;
    my $result = $dbi->execute("select * from content");
    #my $rows = $result->all;
    $c->render('index.tx', { contents=>$result });

};

#登録
post '/' => sub {
    my ( $self, $c )  = @_;
    my $data =  $c->req->parameters;
<<<<<<< HEAD
=======

$teng->insert('content' => 
{
    'title'         => $data->{"title"},
    'memo'   => $data->{"memo"},
    'priority' => $data->{"priority"},
    'status' => $data->{"status"}
});

print Dumper $teng;

>>>>>>> dc400f1b763ea2a5b56c97668b1a4da934d3825e

$dbi->insert(
    {
    'title'         => $data->{"title"},
    'memo'   => $data->{"memo"},
    'priority' => $data->{"priority"},
    'status' => $data->{"status"}
    },table =>'content');
    return $c->redirect('/');
};


<<<<<<< HEAD
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
    'status' => $data->{"status"}
    },table =>'content',
    where => {id => $c->args->{'id'}}
    );
    return $c->redirect('/');
    $c->redirect('/');
};

 #    my $post = $c->req->parameters;
 #    # バリデーション
 #    my $validate = $c->req->validator([
 #        title     => [['NOT_NULL','名前を入力してください']],        
 #    ]);    

    
 #    # データの更新
 #    $post->{"updated_at"} = \'NOW()';
 #    $model->update("posts" => $post, {'id' => $c->args->{"id"}});
 #    $c->redirect('/');

 #    $dbi->update({
 #        title => $c->args->{'title'}},
 # );
    # my $result = $c->req->validator([
    #     'id' => {
    #         default => '0',
    #         rule => [
    #             [['NOT_NULL','empty id'],]
    #         ],
    #     }
    # ]);

#    print Dumper $id;
#         # memo => $c->args->{'memo'}},
#         # priority => $c->args->{'priority'}},
#         # status => $c->args->{'status'}},
#         # table => 'content', 
#         where => {id => $c->args->{'id'}});

=======
>>>>>>> dc400f1b763ea2a5b56c97668b1a4da934d3825e
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
