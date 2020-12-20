unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, FileCtrl;

type
  TForm2 = class(TForm)
    GroupBox1: TGroupBox;
    Splitter1: TSplitter;
    GroupBox2: TGroupBox;
    lib_list: TFileListBox;
    Panel1: TPanel;
    select_but: TButton;
    done_but: TButton;
    meth_list: TListBox;
    procedure FormCreate(Sender: TObject);
    procedure lib_listChange(Sender: TObject);
    procedure select_butClick(Sender: TObject);
    procedure done_butClick(Sender: TObject);
    procedure meth_listDblClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

uses Unit1;

{$R *.DFM}

procedure load_settings;
var
  f:textfile;
  z:integer;
  s:string;
  tf:tfont;
begin
  if not fileexists(settings_file) then
    exit;
  assignfile(f,settings_file);
  reset(f);
  with form1 do
  begin

    readln(f,z);
    top:=z;
    readln(f,z);
    left:=z;
    readln(f,z);
    form2.top:=z;
    readln(f,z);
    form2.left:=z;
    readln(f,z);
    height:=z;
    readln(f,z);
    width:=z;
    readln(f,z);
    panel2.height:=z;
    readln(f,z);
    groupbox2.width:=z;
    readln(f,z);
    form2.Width:=z;
    readln(f,z);
    form2.height:=z;
    readln(f,z);
    form2.groupbox1.Width:=z;

    tf:=tfont.Create;
    readln(f,s);
    tf.name:=s;
    readln(f,z);
    tf.size:=z;
    readln(f,z);
    tf.Charset:=z;
    tf.Style:=[];
    readln(f,z);
    if z=1 then
      tf.style:=tf.style+[fsbold];
    readln(f,z);
    if z=1 then
      tf.style:=tf.style+[fsitalic];
    main.font:=tf;
    music_win.Font:=tf;

  end;
  closefile(f);
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  {forcecurrentdirectory:=true;}
  load_settings;
end;

procedure TForm2.lib_listChange(Sender: TObject);
begin
  if lib_list.itemindex>=0 then
  begin
    meth_list.clear;
    meth_list.items.loadfromfile(lib_list.filename);
    meth_list.items.delete(0);
    meth_list.items.Delete(meth_list.items.count-1);
  end;
end;

function decode_le(x:string):string;
var
  letter:char;
  rest:string;
  l:integer;
begin
  l:=lastdelimiter('abcdefghijklmnopqrstuvwxyz',x);
  letter:=x[l];
  rest:=copy(x,1,l-1);
  case letter of
    'a'..'f','p','q': result:='2';
    'g'..'m','r','s': result:='1';
    'z': result:=rest;
  end;
end;

function mstoinp(x:string):string;
var
  y,a,meth,le,hl,pn:string;
begin
  meth:=trim(copy(x,1,pos(' ',x)));
  y:=trim(copy(x,pos(' ',x),999999));
  le:=trim(copy(y,1,pos(' ',y)));
  hl:=trim(copy(y,pos(' ',y),999999));
  if hl[1]='+' then
    pn:=copy(hl,2,999999)
  else
    pn:=hl+' '+decode_le(le);
    result:=meth+' ['+pn+']';
end;

procedure insert_method;
begin
  if form2.meth_list.itemindex>=0 then
    form1.main.seltext:=mstoinp(form2.meth_list.items[form2.meth_list.itemindex])+#13#10;
end;

procedure TForm2.select_butClick(Sender: TObject);
begin
  insert_method;
end;

procedure TForm2.done_butClick(Sender: TObject);
begin
  insert_method;
  form2.close;
end;

procedure TForm2.meth_listDblClick(Sender: TObject);
begin
  insert_method;
end;

procedure TForm2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  form1.enabled:=true;
end;



end.
