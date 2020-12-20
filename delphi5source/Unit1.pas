unit Unit1;
{$R+}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, math, ExtCtrls, ComCtrls, Menus, StdActns, ActnList, printers, filectrl;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Exit1: TMenuItem;
    PrintSetup1: TMenuItem;
    Print1: TMenuItem;
    N2: TMenuItem;
    SaveAs1: TMenuItem;
    Save1: TMenuItem;
    Open1: TMenuItem;
    New1: TMenuItem;
    Edit1: TMenuItem;
    Paste1: TMenuItem;
    Copy1: TMenuItem;
    Cut1: TMenuItem;
    N5: TMenuItem;
    Undo1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    Contents1: TMenuItem;
    t1: TMenuItem;
    Music1: TMenuItem;
    New2: TMenuItem;
    Open2: TMenuItem;
    SaveAs2: TMenuItem;
    RunRightclick1: TMenuItem;
    OpenCloseBlockdoubleclick1: TMenuItem;
    N1: TMenuItem;
    ActionList1: TActionList;
    EditCopy1: TEditCopy;
    EditCut1: TEditCut;
    EditPaste1: TEditPaste;
    EditUndo1: TEditUndo;
    OpenDialog_music: TOpenDialog;
    SaveDialog_music: TSaveDialog;
    HelpContents1: THelpContents;
    PrintDialog1: TPrintDialog;
    PrinterSetupDialog1: TPrinterSetupDialog;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    N3: TMenuItem;
    Font1: TMenuItem;
    FontDialog1: TFontDialog;
    Panel1: TPanel;
    Panel2: TPanel;
    Splitter1: TSplitter;
    GroupBox2: TGroupBox;
    Splitter2: TSplitter;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    main: TRichEdit;
    music_win: TRichEdit;
    report_win: TRichEdit;
    stage_selector: TComboBox;
    title_win: TMemo;
    EditSelectAll1: TEditSelectAll;
    SelectAll1: TMenuItem;
    N4: TMenuItem;
    Insertmethod1: TMenuItem;
    procedure open_buttonClick(Sender: TObject);
    procedure prove_buttonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure mainMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RunRightclick1Click(Sender: TObject);
    procedure OpenCloseBlockdoubleclick1Click(Sender: TObject);
    procedure New2Click(Sender: TObject);
    procedure SaveAs2Click(Sender: TObject);
    procedure Open2Click(Sender: TObject);
    procedure music_winMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure mainKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Print1Click(Sender: TObject);
    procedure PrintSetup1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure New1Click(Sender: TObject);
    procedure SaveAs1Click(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Font1Click(Sender: TObject);
    procedure music_winChange(Sender: TObject);
    procedure stage_selectorChange(Sender: TObject);
    procedure title_winChange(Sender: TObject);
    procedure mainChange(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure Insertmethod1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

const
  whitespace=[' ',#0,#10,#13,#9];
  specialchars=['[',']',':'];
  pnchars=['1'..'9','0','E','T','A'..'D','X','-','.'];

const
  inf=999999999;

const
  bellchars='1234567890ETABCD';
  evenbells='24680TBD';

type
  row=int64;
  pn=record
    leftmask,rightmask,placemask:int64;
  end;
  pattern=record
    mask,res:int64;
  end;
type
  atomkind=(l,r,u,p,b);
  atom=record
    name:string;
    ok:boolean;
    case kind:atomkind of
      l:();
      r:();
      u:();
      p:(notn:pn);
      b:(
        block:tlist;
        defined_this_time:boolean;
        );
    end;
  patom=^atom;
  thing=record
    index:integer;
    data:row;
  end;
  pthing=^thing;

const
  raw_rounds:row=$FEDCBA9876543210;

var
  file_atoms,stored_atoms:tlist;
  left_bracket,right_bracket:atom;
  pleft_bracket,pright_bracket:patom;
  partner:array of integer;
  active,frag_end:array of boolean;
  err,mus_err:boolean;
  errmsg,report,mus_errmsg,mus_report:string;
  cur_atom,near_atom,show_atom:integer;
  row_num,frag_num:integer;
  rounds,the_row:row;
  stage:integer;
  short_pnchars,short_chars:string;
  table:array of array of string;
  came_round:integer;
  proving,had_rounds:boolean;
  prove_list:tlist;
  f1,f2:integer;
  is_true,comes_round:boolean;
  touch_len:integer;
  last_selstart:integer;
  music_name:array of string;
  music_count,music_total:array of integer;
  pat_music:array of integer;
  pat_pat:array of pattern;
  last_file:string;
  changes_saved:boolean;
  meth_dir,main_dir,settings_file:string;

implementation

uses Unit2;

{$R *.DFM}

function comp(x,y:pointer):integer;
var
  a,b,nf1,nf2:integer;
  d:int64;
begin
  d:=thing(x^).data-thing(y^).data;
  if d<0 then
    result:=-1
  else if d=0 then
    result:=0
  else
    result:=1;
  if (d=0) and not(x=y) then
  begin
    a:=thing(x^).index;
    b:=thing(y^).index;
    nf1:=min(a,b);
    nf2:=max(a,b);
    if (nf2<f2) or ((nf2=f2) and (nf1<f1)) then
    begin
      f1:=nf1;
      f2:=nf2;
    end;
  end;
end;

function bellnum(x:char):integer;
begin
  result:=pos(x,bellchars)-1;
end;

function isbell(x:char):boolean;
begin
  result:=pos(x,short_chars)>0;
end;

function bellchar(x:integer):char;
begin
  result:=bellchars[x+1]
end;

function strtorow(s:string):row;
var
  i:integer;
begin
  result:=0;
  for i:=stage downto 1 do
    result:=((result shl 4) or bellnum(s[i]));
end;

function rowtostr(r:row):string;
var
  i:integer;
  x:int64;
begin
  x:=r;
  setlength(result,stage);
  for i:=1 to stage do
  begin
    result[i]:=bellchar(x and 15);
    x:=x shr 4;
  end;
end;

function strtopn(s:string):pn;
var
  i:integer;
  s1:string;
  x:int64;
begin
  if (length(s)>0) and isdelimiter(evenbells,s,1) then
    s1:='1'+s
  else
    s1:=s;
  i:=0;
  x:=15;
  result.leftmask:=0; result.rightmask:=0; result.placemask:=0;
  repeat
  begin
    if (pos(bellchar(i),s1)>0) or (i=stage-1) then
    begin
      {i makes place}
      result.placemask:=result.placemask or x;
      inc(i);
      x:=x shl 4;
    end
    else
    begin
      {i,i+1 swap}
      result.rightmask:=result.rightmask or x;
      result.leftmask:=result.leftmask or (x shl 4);
      inc(i,2);
      x:=x shl 8;
    end;
  end
  until i>=stage;
end;

procedure apply(ch:pn);
begin
  the_row:=(the_row and ch.placemask) or ((the_row shr 4) and ch.rightmask) or ((the_row shl 4) and ch.leftmask);
end;

function strtopat(s:string):pattern;
var
  i:integer;
  t:string;
begin
  t:=stringreplace(s,'*',stringofchar('?',stage-length(s)+1),[]);
  if length(t)=stage then
  begin
    result.mask:=0; result.res:=0;
    for i:=stage downto 1 do
    begin
      result.mask:=result.mask shl 4; result.res:=result.res shl 4;
      if isbell(t[i]) then
      begin
        result.res:=result.res or bellnum(t[i]);
        result.mask:=result.mask or 15
      end
      else if t[i]<>'?' then
      begin
        mus_err:=true;
        mus_errmsg:=('Syntax error in '+s);
      end;
    end;
  end
  else
  begin
    mus_err:=true;
    mus_errmsg:='Wrong length: '+s;
  end;
end;

function fits(x:row; pat:pattern):boolean;
begin
  result:=((x and pat.mask)=pat.res);
end;

{function atom_end(x:integer):integer; //end of atom starting at x
begin
  result:=x;
  with form1.main do
    if text[x] in specialchars then
      inc(result)
    else
      while not(text[result] in (whitespace+specialchars)) do
        inc(result)
end;

function atom_next(x:integer):integer; //start of atom after that ending at x
begin
  result:=x;
  with form1.main do
    while text[result] in whitespace+[':'] do
    begin
      if text[result]=':' then
        while text[result]<>#10 do
          inc(result);
      inc(result);
    end;
end;


function sym_start(x:integer):integer; //start of symbol which x is in or touching
begin
  result:=x;
  with form1.main do
    if (text[x] in (whitespace+specialchars)) and (text[x-1] in (whitespace+specialchars)) then
      result:=-1  //there isnt one
    else
      while not(text[result-1] in (whitespace+specialchars)) do
        dec(result)
end;  }

function looks_like_pn(s:string):boolean;
var
  i:integer;
begin
  result:=true;
  for i:=1 to length(s) do
    result:=result and (pos(s[i],short_pnchars)>0);
end;

function atom_find(s:string):patom; //return a pointer to a stored atom with name s
var                                 //also classify as p or b
  i:integer;
  a:patom;
begin
  a:=nil;
  for i:=0 to stored_atoms.count-1 do
  begin
    if atom(stored_atoms.Items[i]^).name=s then
      a:=stored_atoms.items[i];
  end;
  if a=nil then
  begin
    new(a);
    a^.name:=s;
    if looks_like_pn(s) then
      a^.kind:=p
    else
    begin
      a^.kind:=b;
      a^.block:=tlist.create;
    end;                 
    stored_atoms.add(a);
  end;
  result:=a;
end;

{procedure get_atomso;              //defunct
var
  x,y,c:integer;
  a:string;
begin
  file_atoms.Clear;
  cur_atom:=-1;
  c:=sym_start(form1.main.selstart+1);
  x:=1;
  //                   skip header - not yet written
  while x<=length(form1.main.text) do
  begin
    y:=x;
    x:=atom_end(x);
    a:=copy(form1.main.text,y,x-y);
    x:=atom_next(x);
    if a='[' then
      file_atoms.add(pleft_bracket)
    else if a=']' then
      file_atoms.add(pright_bracket)
    else
      file_atoms.add(atom_find(a));
    if (cur_atom=-1) and (x>c) and (c>-1) then
      cur_atom:=file_atoms.count-1;
  end;

  if file_atoms.count=0 then
  begin
    err:=true;
    errmsg:='No file!';
  end;
end; }

procedure parse(s:string);
var
  t,a:string;
  c:char;
  sym:boolean;
  j,init_fac,final_fac:integer;
begin
  sym:=(s[1]='&');
  if sym then
    t:=copy(s,2,inf)
  else
    t:=s;
  if looks_like_pn(t) then
  begin
    init_fac:=file_atoms.Count;
    a:='';
    for j:=1 to length(t) do
    begin
      c:=t[j];
      case c of
        '.': begin
          if a<>'' then
            file_atoms.Add(atom_find(a));
          a:='';
        end;
        '-','X': begin
          if a<>'' then
            file_atoms.Add(atom_find(a));
          file_atoms.add(atom_find(c));
          a:='';
        end;
      else
        a:=a+c;
      end;
    end;
    if a<>'' then
      file_atoms.Add(atom_find(a));
    final_fac:=file_atoms.count;
    if sym and (final_fac-init_fac>1) then
      for j:=final_fac-2 downto init_fac do
        file_atoms.add(file_atoms.Items[j]);
  end
  else
    file_atoms.add(atom_find(s));
end;

procedure get_atoms;
var
  i,k,l:integer;
  c:char;
begin
  file_atoms.Clear;
  cur_atom:=-1;
  near_atom:=-1;

  with form1.main do
  begin

  i:=1;
  l:=length(text);
  while i<=l do
  begin
    while isdelimiter(' '#10#13,text,i) do   //skip whitesapce
      inc(i);
    if i>l then break;
    c:=text[i];
    case c of
      '[': begin
        file_atoms.add(pleft_bracket);
        inc(i);
      end;
      ']': begin
        file_atoms.add(pright_bracket);
        inc(i);
      end;
      ':': repeat                          //skip annotations
        inc(i)
      until isdelimiter(#10,text,i) or (i>l);
    else
      begin
        k:=i;
        repeat
          inc(i)
        until isdelimiter('[]: '#10#13,text,i) or (i>l);

        {file_atoms.add(atom_find(copy(text,k,i-k)));}   //modify this
        parse(copy(text,k,i-k));

        if (k<=last_selstart+1) and (i>last_selstart) then
          cur_atom:=file_atoms.count-1;
      end
    end;
    if (near_atom=-1) and (i>last_selstart) then
      near_atom:=file_atoms.count-1;
  end;
  end;
  if file_atoms.count=0 then
  begin
    err:=true;
    errmsg:='No touch!';
  end;
  if cur_atom=-1 then
    show_atom:=near_atom
  else
    show_atom:=cur_atom;
end;

procedure get_music;
var
  i,k,l,depth,mus_num,pat_num:integer;
  prev_mus_empty:boolean;
  c:char;
begin
  mus_err:=false;
  mus_errmsg:='';
  with form1.music_win do
  begin
    l:=length(text);
    setlength(music_name,l);
    setlength(pat_music,l);
    setlength(pat_pat,l);

  i:=1;
  depth:=0;
  mus_num:=0;
  pat_num:=0;
  prev_mus_empty:=false;
  while (i<=l) and not mus_err do
  begin
    while isdelimiter(' '#10#13,text,i) do   //skip whitesapce
      inc(i);
    if i>l then break;
    c:=text[i];
    case c of
      '[': begin
        inc(depth);
        if depth>1 then
        begin
          mus_err:=true;
          mus_errmsg:='Too many [s';
          break;
        end;
        if not prev_mus_empty then
        begin
          mus_err:=true;
          mus_errmsg:='Missing name';
          break;
        end;
        inc(i);
      end;
      ']': begin
        dec(depth);
        if depth<0 then
        begin
          mus_err:=true;
          mus_errmsg:='Too many ]s';
          break;
        end;
        inc(i);
      end;
    else
      begin
        k:=i;
        repeat
          inc(i)
        until isdelimiter('[]: '#10#13,text,i) or (i>l);
        if (depth=0) then
        begin
          if prev_mus_empty then
          begin
            pat_pat[pat_num]:=strtopat(music_name[mus_num-1]);
            pat_music[pat_num]:=mus_num-1;
            inc(pat_num);
          end;
          if mus_err then
            break;
          music_name[mus_num]:=copy(text,k,i-k);
          inc(mus_num);
          prev_mus_empty:=true;
        end
        else if mus_num>0 then    //(else [ opened without name)
        begin
          pat_pat[pat_num]:=strtopat(copy(text,k,i-k));
          if mus_err then
            break;
          pat_music[pat_num]:=mus_num-1;
          inc(pat_num);
          prev_mus_empty:=false;
        end
        else
          mus_err:=true;
          mus_errmsg:='Missing name';
        {file_atoms.add(atom_find(copy(text,k,i-k)));}
      end
    end;
  end;
  if (not mus_err) and prev_mus_empty then
  begin
    pat_pat[pat_num]:=strtopat(music_name[mus_num-1]);
    pat_music[pat_num]:=mus_num-1;
    inc(pat_num);
  end;

  if (not mus_err) and (depth>0) then
  begin
    mus_err:=true;
    mus_errmsg:='Missing ]';
  end;
  setlength(music_name,mus_num);
  setlength(pat_pat,pat_num);
  setlength(pat_music,pat_num);
  end;
  if mus_err then
  begin
    setlength(music_name,0);
    setlength(pat_pat,0);
    setlength(pat_music,0);
  end;
end;

procedure get_stage;
var
  code:integer;
begin
  val(form1.stage_selector.text,stage,code);
  if (code<>0) or not (stage in [4..16]) then
  begin
    stage:=4;
    form1.stage_selector.itemindex:=0;
  end;
  rounds:=raw_rounds and (int64((int64(1) shl (stage*4))-1));
  short_pnchars:=copy('.-X1234567890ETABCD',1,stage+3);
  short_chars:=copy('1234567890ETABCD',1,stage);
end;

procedure find_pns;
var
  i:integer;
  this:patom;
begin
  for i:=0 to stored_atoms.count-1 do
  begin
    this:=stored_atoms.items[i];
    if this^.kind=p then
      this^.notn:=strtopn(this^.name);
  end;
end;

procedure no_error;
begin
  err:=false;
  errmsg:='OK';
  report:='OK';
end;

procedure show_error;
begin
  if err then
  begin
    form1.report_win.text:=errmsg;
    beep
  end
  else
    form1.report_win.text:=report;
  changes_saved:=false;
end;

procedure check_syntax;
var
  i:integer;
  this,last:patom;
begin
  this:=file_atoms.items[0];
  if this=pleft_bracket then
  begin
    err:=true;
    errmsg:='Syntax error: initial ['
  end
  else
  begin

  for i:=1 to file_atoms.count-1 do
  begin
    last:=this;
    this:=file_atoms.Items[i];
    if ((last=pleft_bracket) and (this=pleft_bracket))
      or ((last=pleft_bracket) and (this=pright_bracket))
      or ((last=pright_bracket) and (this=pleft_bracket)) then
    begin
      err:=true;
      errmsg:='Syntax error: ';
      break;
    end;
    if ((last^.kind=p) and (this=pleft_bracket)) then
    begin
      err:=true;
      errmsg:='Can''t redefine place notation: ';
      break;
    end;
  end;
  if err then
    errmsg:=errmsg+last^.name+' '+this^.name;
  end;
end;

procedure check_brackets;
var
  i,depth:integer;
  opened:array of integer;
  this:patom;
begin
  setlength(partner,file_atoms.Count);
  setlength(opened,file_atoms.count);
  depth:=0;
  for i:=0 to file_atoms.count-1 do
  begin
    this:=file_atoms.items[i];
    if (this=pleft_bracket) then
    begin
      inc(depth);
      opened[depth]:=i;
    end
    else if (this=pright_bracket) then
    begin
      if depth=0 then
      begin
        err:=true;
        errmsg:='Too many ]s';
        break;
      end;
      partner[i]:=opened[depth];
      partner[opened[depth]]:=i;
      dec(depth);
    end;
  end;
  if depth>0 then
  begin
    err:=true;
    errmsg:='Not enough ]s';
  end;
end;

function tlist_equal(a,b:tlist):boolean;
var
  i:integer;
begin
  if a.count<>b.count then
    result:=false
  else
  begin
    result:=true;
    for i:=0 to a.count-1 do
      if a.items[i]<>b.items[i] then
      begin
        result:=false;
        break;
      end;
  end;
end;

procedure read_blocks;
var
  i,j:integer;
  this,child:patom;
  blockdef:tlist;
begin
  for i:=0 to stored_atoms.count-1 do
    if atom(stored_atoms.items[i]^).kind=b then
      atom(stored_atoms.items[i]^).defined_this_time:=false;
  for i:=0 to file_atoms.count-2 do
  begin
    this:=file_atoms.items[i];
    if (this^.kind=b) and (atom(file_atoms.items[i+1]^).kind=l) then

    begin                           //read the defintion of this^ into blockdef
      blockdef:=tlist.create;
      j:=i+2;
      while j<partner[i+1] do
      begin
        child:=file_atoms.Items[j];
        if child^.kind=l then
          j:=partner[j]+1
        else
        begin
          blockdef.Add(child);
          inc(j);
        end;
      end;

      if this^.defined_this_time then     //check whther defn is consistent
      begin
        if not tlist_equal(blockdef,this^.block) then
        begin
          err:=true;
          errmsg:='Conflicting definitions of '+this^.name;
          blockdef.Free;                  // !!
                                          // !!!!
          break;
        end
        else
          blockdef.free;                 //(blockdef won't be used in this case)
      end
      else                               //take blockdef as the new defn
        begin
          tlist(this^.block).Free;
          this^.block:=blockdef;
          this^.defined_this_time:=true;
        end;
    end;

  end;
end;

function first_bad_child(t:patom):patom;
var
  i:integer;
  child:patom;
begin
  if (t=nil) or (t^.kind<>b) or (t^.ok) or (tlist(t^.block).count=0) then
    result:=nil
  else
    for i:=0 to tlist(t^.block).count-1 do
    begin
      child:=tlist(t^.block).items[i];
      if not child^.ok then
      begin
        result:=child;
        break;
      end;
    end;
end;

procedure identify_def_error(t:patom);
var
  slow,fast:patom;
begin
  err:=true;
  slow:=t;
  fast:=t;
  repeat
    if first_bad_child(slow)=nil then
    begin
      errmsg:='No definition of '+slow^.name;
      break;
    end;
    slow:=first_bad_child(slow);
    fast:=first_bad_child(first_bad_child(fast));
    if slow=fast then
    begin
      errmsg:='Circular definition of '+slow^.name;
      break;
    end;
  until false;
end;

procedure check_logic;
var
  changed,tmp:boolean;
  i,j:integer;
  this,child:patom;
begin
  for i:=0 to stored_atoms.count-1 do
  begin
    this:=stored_atoms.items[i];
    this^.ok:=(this^.kind=p);          //place notations are ok
  end;

  repeat
  begin
    changed:=false;
    for i:=0 to stored_atoms.count-1 do
    begin
      this:=stored_atoms.items[i];
      if not this^.ok then
      begin
        tmp:=(tlist(this^.block).count>0);
        for j:=0 to tlist(this^.block).count-1 do
        begin
          child:=tlist(this^.block).items[j];  //this^ is ok if all its children are
          tmp:=tmp and (child^.ok);
        end;
        this^.ok:=tmp;
        changed:=changed or tmp;
      end;
    end;
  end
  until not changed;

  for i:=0 to file_atoms.count-1 do
  begin
    this:=file_atoms.items[i];
    if this^.kind=b then
      if not this^.ok then
      begin
        {err:=true;
        errmsg:='Missing or circular definition in '+this^.name;}
        identify_def_error(this);
        break;
      end;
  end;
end;


{procedure make_file;
var
  i:integer;
  res:string;
begin
  res:='';
  for i:=0 to file_atoms.count-1 do
    res:=res+atom(file_atoms.items[i]^).name+' ';
  form1.main.text:=res;
end;}

{procedure line_up;
var
  x,a,tab,col:integer;
  atom,oatom,res:string;
  tabcol:array[0..100] of integer;
begin
  col:=0;
  tab:=0;
  tabcol[tab]:=0;
  x:=1;
  res:='';
  atom:='';
  while x<=length(form1.main.text) do
  begin
    oatom:=atom;
    a:=x;
    x:=atom_end(x);
    atom:=copy(form1.main.text,a,x-a);
    x:=atom_next(x);
    if oatom='[' then
    begin
      inc(tab);
      tabcol[tab]:=col;
    end
    else if oatom=']' then
      if tab>0 then
        dec(tab);
    if (oatom<>'[') and (oatom<>'') and not (atom[1] in specialchars) then
      begin
        res:=res+#13#10+stringofchar(' ',tabcol[tab]);
        col:=tabcol[tab]
      end;
    res:=res+atom;
    col:=col+length(atom)
  end;
  form1.main.text:=res
end;}

procedure annotate; forward;
procedure open_close;
var
  i,a,b,c,tl:integer;
  this:patom;
begin
  {$B-}
  no_error;
  get_stage;
  get_atoms;
  if not err then
    find_pns;
  if not err then
    check_syntax;
  if not err then
    check_brackets;
  if not err then
    read_blocks;
  if not err then            //was once commented out
    check_logic;
  if not err then
    if cur_atom=-1 then
    begin
      err:=true;
      errmsg:='Which block?';
    end
    else
    begin
      this:=file_atoms.items[cur_atom];
      if this^.kind=p then
      begin
        err:=true;
        errmsg:='Can''t expand place notation';
      end
      else
        if (cur_atom=file_atoms.count-1) or not (atom(file_atoms.items[cur_atom+1]^).kind=l) then
          begin {open}
            tl:=tlist(this^.block).count;
            if tl=0 then
            begin
              err:=true;
              errmsg:='No definition for '+this^.name;
            end
            else
            begin
              a:=cur_atom+1;
              b:=a+tl+1;
              c:=file_atoms.count+tl+1;
              file_atoms.count:=c+1;
              for i:=c downto b+1 do
                file_atoms.items[i]:=file_atoms[i-tl-2];
              for i:=a+1 to b-1 do
                file_atoms.items[i]:=tlist(this^.block).items[i-a-1];
              file_atoms.items[a]:=pleft_bracket;
              file_atoms.items[b]:=pright_bracket;
            end
          end
        else
          begin {close}
            a:=cur_atom+1;
            b:=partner[a];
            c:=file_atoms.count-1;
            for i:=b+1 to c do
              file_atoms.items[i-b-1+a]:=file_atoms.items[i];
            file_atoms.count:=c-b+a;
          end;
    end;
  if not err then
  begin
    {make_file;
    line_up;}
    annotate;
  end;
  show_error;
end;

procedure rec_ring(this:patom);
var
  i:integer;
  pt:pthing;
begin
  if this^.kind=p then              //ring a pn
  begin
    inc(row_num);
    apply(this^.notn);
    {had_rounds:=had_rounds or (the_row=rounds);}
    if (the_row=rounds) then
    begin
      had_rounds:=true;
      if not comes_round then
      begin
        comes_round:=true;
        touch_len:=row_num;
      end;
    end;

    if proving then
    begin
      new(pt);
      pt^.index:=frag_num;
      pt^.data:=the_row;
      prove_list.add(pt);

      if not mus_err then
      begin
        for i:=0 to length(pat_music)-1 do
          if fits(the_row,pat_pat[i]) then
          begin
            inc(music_count[pat_music[i]]);
            inc(music_total[pat_music[i]]);
          end;
      end;

    end;
    proving:=proving and not(had_rounds);

  end
  else if this^.kind=b then          //recurse for a block
  begin
    for i:=0 to tlist(this^.block).count-1 do
      rec_ring(tlist(this^.block).items[i]);
  end;
end;

procedure put_cursor(x:integer);
begin
  form1.main.setfocus;
  if x>-1 then
    begin
      form1.main.selstart:=x;
      form1.main.seltext:=' ';         //ridiculous XP bug hack!
      form1.main.selstart:=x;
      form1.main.sellength:=1;
      form1.main.clearselection;
      last_selstart:=x;
    end;
end;

procedure annotate;
var
  i,j,nfrags,cw,col,tab,cur_frag,cur_col,cur_char:integer;
  frag,res:string;
  this:patom;
  thiskind,nextkind:atomkind;
  tabcol:array[0..100] of integer;
begin
  nfrags:=0;
  for i:=0 to file_atoms.count-1 do
    case atom(file_atoms.items[i]^).kind of
      p,b:inc(nfrags);
      l:dec(nfrags);
    end;

  setlength(music_count,length(music_name));
  setlength(music_total,length(music_name));
  for i:=0 to length(music_name)-1 do
  begin
    music_count[i]:=0;
    music_total[i]:=0;
  end;

  setlength(table,nfrags+1,4+length(music_name));
  for i:=low(table) to high(table) do
    for j:=low(table[0]) to high(table[0]) do
      table[i,j]:='';

  res:='';
  frag:='';
  frag_num:=0;
  row_num:=0;
  col:=0;
  tab:=0;
  tabcol[tab]:=0;
  cur_frag:=-1;

  the_row:=rounds;
  had_rounds:=false;
  comes_round:=false;
  proving:=true;
  prove_list:=tlist.create;

  table[0,1]:=' : '+rowtostr(rounds);
  if not mus_err then
    for j:=0 to length(music_name)-1 do
      table[0,4+j]:=' '+music_name[j];

  for i:=0 to file_atoms.count-1 do
  begin
    this:=file_atoms.items[i];
    thiskind:=this^.kind;
    if (i=file_atoms.count-1) then
      nextkind:=p
    else
      nextkind:=atom(file_atoms.items[i+1]^).kind;

    if i=show_atom then            //record line to put cursor on
    begin
      cur_frag:=frag_num;
      cur_col:=length(frag);
    end;

    frag:=frag+this^.name;
    {if (thiskind in [p,b]) and (nextkind in [p,b]) then
      frag:=frag+' '; }

    if (thiskind=l) then
    begin
      inc(tab);
      tabcol[tab]:=length(frag);
    end;
    if (thiskind=r) then
      if tab>0 then
        dec(tab);
    if (thiskind in [p,b]) and not (nextkind=l) then
    begin                                             //ring a pn or block
      if not mus_err then
        for j:=0 to length(music_name)-1 do
          music_count[j]:=0;
      rec_ring(this);
    end;

    if not(thiskind=l) and (nextkind in [p,b]) then
    begin
      {frag:=frag+stringofchar(' ',12-(length(frag) mod 12));
      res:=res+frag+' :'+rowtostr(the_row)+' '+inttostr(row_num)+#13#10;}
      table[frag_num+1,0]:=frag;
      table[frag_num+1,1]:=' : '+rowtostr(the_row);
      if had_rounds then
        table[frag_num+1,3]:=' Rounds';
      table[frag_num+1,2]:=' '+inttostr(row_num);
      if not mus_err then                                //add music to table
        for j:=0 to length(music_name)-1 do
          if music_count[j]>0 then
            table[frag_num+1,4+j]:=' '+inttostr(music_count[j])
          else
            table[frag_num+1,4+j]:=' .';

      inc(frag_num);
      frag:=stringofchar(' ',tabcol[tab]);
      had_rounds:=false;
    end;
  end;
  if not comes_round then
    touch_len:=row_num;

  f1:=inf; f2:=inf;                               //check truth
  prove_list.sort(comp);
  is_true:=true;
  if (f1<inf) then
  begin
    is_true:=false;
    table[f1+1,3]:=' False'+table[f1+1,3];
    table[f2+1,3]:=' False'+table[f2+1,3];
  end;

  for i:=0 to prove_list.count-1 do
    dispose(prove_list.items[i]);
  prove_list.destroy;

  for j:=low(table[0]) to high(table[0]) do       //draw table
  begin
    cw:=0;
    for i:=low(table) to high(table) do
      cw:=max(cw,length(table[i,j]));
    for i:=low(table) to high(table) do
      table[i,j]:=table[i,j]+stringofchar(' ',cw-length(table[i,j]));
  end;
  for i:=low(table) to high(table) do
  begin
    if (i=cur_frag+1) then
      cur_char:=length(res)+cur_col;
    for j:=low(table[0]) to high(table[0]) do
    begin
      res:=res+table[i,j];
    end;
    res:=res+#13#10;
  end;
  form1.main.text:=res;

  put_cursor(cur_char);
  setlength(table,0,0);

  if is_true then                  //write report
    report:='TRUE.'#13#10
  else
    report:='FALSE.'#13#10;
  {form1.report_win.text:=report;}
  if comes_round then
    report:=report+'Comes round after'#13#10
  else
    report:=report+'Has not come round after'#13#10;
  report:=report+inttostr(touch_len)+' rows.'#13#10#13#10;

  if mus_err then
    report:=report+'Music error:'#13#10+mus_errmsg+#13#10
  else
    for j:=0 to length(music_name)-1 do
      report:=report+inttostr(music_total[j])+' '+music_name[j]+'.'#13#10;
  changes_saved:=false;
end;


(*
procedure get_info;
begin
  no_error;
  get_atoms;
  {label1.caption:=inttostr(file_atoms.count);
  label2.caption:=inttostr(cur_atom);}
  if not err then
    find_pns;
  if not err then
    check_syntax;
  if not err then
    check_brackets;
  if not err then
    read_blocks;
  if not err then
    check_logic;
end;
*)

procedure prove;
begin
  form1.activecontrol:=form1.main;
  no_error;
  get_stage;
  get_atoms;
  get_music;
  {label1.caption:=inttostr(file_atoms.count);
  label2.caption:=inttostr(cur_atom);}
  if not err then
    find_pns;
  if not err then
    check_syntax;
  if not err then
    check_brackets;
  if not err then
    read_blocks;
  if not err then
    check_logic;
  {if not err then
    make_file;}
  if not err then
    annotate;           
  show_error;
  {line_up;}
end;

procedure TForm1.open_buttonClick(Sender: TObject);
begin
  {main.selstart:=sym_start(main.selstart+1)-1;}
  open_close;
  {form1.activecontrol:=main}
end;

{procedure TForm1.Button2Click(Sender: TObject);
begin
  line_up;
  form1.activecontrol:=main
end;}

procedure TForm1.prove_buttonClick(Sender: TObject);
var i:integer;
begin
  prove;
end;

procedure destroy_stored_atoms;
var
  i:integer;
  this:patom;
begin
  for i:=0 to stored_atoms.count-1 do
  begin
    this:=patom(stored_atoms[i]);
    if this^.kind=b then
      this^.block.free;
    if this^.kind in [u,p,b] then
      dispose(this);
  end;
  stored_atoms.clear;
end;

procedure save_settings;
var
  f:textfile;
  z:integer;
  tf:tfont;
begin
  assignfile(f,settings_file);
  rewrite(f);
  with form1 do
  begin
    z:=top;
    writeln(f,z);
    z:=left;
    writeln(f,z);     
    z:=form2.top;
    writeln(f,z);
    z:=form2.left;
    writeln(f,z);
    z:=height;
    writeln(f,z);
    z:=width;
    writeln(f,z);
    z:=panel2.height;
    writeln(f,z);
    z:=groupbox2.width;
    writeln(f,z);
    z:=form2.Width;
    writeln(f,z);
    z:=form2.height;
    writeln(f,z);
    z:=form2.groupbox1.Width;
    writeln(f,z);
    tf:=main.font;
    writeln(f,tf.name);
    writeln(f,tf.size);
    writeln(f,tf.charset);
    if fsbold in tf.style then
      writeln(f,1)
    else
      writeln(f,0);
    if fsitalic in tf.style then
      writeln(f,1)
    else
      writeln(f,0);
  end;
  closefile(f);
end;

procedure query_new; forward;

procedure TForm1.FormCreate(Sender: TObject);
begin
  file_atoms:=tlist.create;
  stored_atoms:=tlist.create;
  left_bracket.kind:=l;
  right_bracket.kind:=r;
  left_bracket.name:='[';
  right_bracket.name:=']';
  pleft_bracket:=@left_bracket;
  pright_bracket:=@right_bracket;
  {forcecurrentdirectory:=true;}
  main_dir:=getcurrentdir;
  meth_dir:=getcurrentdir+'\methlib';
  settings_file:=main_dir+'\inpcfg.dat';
  opendialog1.InitialDir:=main_dir;
  savedialog1.InitialDir:=main_dir;
  opendialog_music.InitialDir:=main_dir;
  savedialog_music.InitialDir:=main_dir;

  last_file:='';
  changes_saved:=true;
  query_new;
end;

procedure TForm1.mainMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if shift=[ssleft] then
    last_selstart:=main.selstart;
  if ssdouble in shift then
  begin
    shift:=[];
    main.sellength:=0;
    open_close;
  end;
  if ssright in shift then
    prove;
end;

procedure TForm1.RunRightclick1Click(Sender: TObject);
begin
  prove;
end;

procedure TForm1.OpenCloseBlockdoubleclick1Click(Sender: TObject);
begin
  open_close;
end;

procedure TForm1.New2Click(Sender: TObject);
begin
  music_win.Clear;
end;

procedure TForm1.SaveAs2Click(Sender: TObject);
begin
  with savedialog_music do
  begin
    title:='Save Music As';
    filter:='Music Files (*.mus)|*.mus';
    defaultext:='mus';
    music_win.plaintext:=true;
    if execute then
      music_win.lines.SaveToFile(filename) ;
  end;
end;

procedure TForm1.Open2Click(Sender: TObject);
begin
  with opendialog_music do
  begin
    title:='Open Music';
    filter:='Music Files (*.mus)|*.mus';
    defaultext:='mus';
    music_win.plaintext:=true;
    if execute then
      music_win.lines.loadfromFile(filename) ;
  end;
end;

procedure TForm1.music_winMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if ssright in shift then
    prove;
end;


procedure TForm1.mainKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   last_selstart:=main.selstart;
end;

procedure TForm1.Print1Click(Sender: TObject);
var
  i:integer;
  PrintText: TextFile;
begin
  with printdialog1 do
  if execute then
  begin
    printer.Canvas.Font.Name:='Courier New';
    AssignPrn(PrintText);
    Rewrite(PrintText);
    writeln(printtext, '--- Inpact ---');
    writeln(printtext, title_win.text);
    writeln(printtext);
    for i := 0 to report_win.Lines.Count - 1 do
      Writeln(PrintText, report_win.Lines[i]);
    writeln(printtext);
    for i := 0 to main.Lines.Count - 1 do
      Writeln(PrintText, main.Lines[i]);
    writeln(printtext);
    for i := 0 to music_win.Lines.Count - 1 do
      Writeln(PrintText, music_win.Lines[i]);
    CloseFile(PrintText);
  end;
end;

procedure TForm1.PrintSetup1Click(Sender: TObject);
begin
  printersetupdialog1.execute;
end;

function query_saveas:boolean; forward;
procedure save_inpfile(filename:string); forward;

function save_last_file:boolean;
begin
  if last_file<>'' then
    begin
      save_inpfile(last_file);
      result:=true;
    end
  else
    result:=query_saveas;
end;

function query_savechanges:boolean; //asks about saving changes if necessary
var
  a:word;
begin                               //returns false if clicked Cancel
  result:=true;
  if not(changes_saved) then
    case messagedlg('Save Changes?', mtconfirmation, [mbYes, mbNo, mbCancel],0) of
      mryes: result:=save_last_file;
      mrcancel: result:=false;
    end;
end;

procedure query_quit;
begin
  if query_savechanges then
  begin
    save_settings;
    destroy_stored_atoms;
    stored_atoms.free;
    file_atoms.free;
    application.terminate;
  end;
end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
  query_quit;
end;

procedure query_new;
begin
  with form1 do
  if query_savechanges then
  begin
    destroy_stored_atoms;
    main.Clear;
    music_win.Clear;
    report_win.text:='--- Inpact ---';
    title_win.text:='New touch';
    last_file:='';
    changes_saved:=true;
  end;
end;

procedure TForm1.New1Click(Sender: TObject);
begin
  query_new;
end;

procedure save_inpfile(filename:string);
var
  f:textfile;
  this,child:patom;
  i,j:integer;
begin
  assignfile(f,filename);
  rewrite(f);
  with form1 do
  begin
    get_stage;
    writeln(f, stage_selector.itemindex);
    writeln(f, music_win.lines.count);
    for i:=0 to music_win.lines.count-1 do
      writeln(f, music_win.lines[i]);
    writeln(f, main.lines.count);
    for i:=0 to main.lines.count-1 do
      writeln(f, main.lines[i]);

    writeln(f,stored_atoms.count);
    for i:=0 to stored_atoms.count-1 do
    begin
      this:=patom(stored_atoms[i]);
      writeln(f,this^.name);
      if this^.kind=b then
        writeln(f,1)
      else
        writeln(f,0);
      if this^.kind=b then
      begin
        writeln(f,this^.block.count);
        for j:=0 to this^.block.count-1 do
        begin
          child:=this^.block[j];
          writeln(f,child^.name);
        end;
      end;
    end;
    writeln(f,title_win.text);

  end;

  closefile(f);
  last_file:=filename;
  changes_saved:=true;
end;

procedure load_inpfile(filename:string);
var
  f:textfile;
  this,child:patom;
  s:string;
  i,j,c,cc,z:integer;
begin
  assignfile(f,filename);
  reset(f);

  with form1 do
  begin
    readln(f,z);
    stage_selector.itemindex:=z;
    get_stage;
    report_win.clear;
    music_win.clear;
    readln(f, c);
    for i:=0 to c-1 do
    begin
      readln(f,s);
      music_win.lines.add(s);
    end;
    main.clear;
    readln(f, c);
    for i:=0 to c-1 do
    begin
      readln(f,s);
      main.lines.add(s);
    end;

    destroy_stored_atoms;

    readln(f, c);
    for i:=0 to c-1 do
    begin
      readln(f,s);
      this:=atom_find(s);
      readln(f,z);
      if z=1 then
      begin
        this^.kind:=b;
        this^.block:=tlist.create;
        readln(f,cc);
        for j:=0 to cc-1 do
        begin
          readln(f,s);
          child:=atom_find(s);
          this^.block.add(child);
        end;
      end;
    end;
    readln(f,s);
    title_win.text:=s;

    {writeln(f,stored_atoms.count);
    for i:=0 to stored_atoms.count-1 do
    begin
      this:=patom(stored_atoms[i]);
      writeln(f,this^.name);
      writeln(f,ord(this^.kind));
      if this^.kind=b then
      begin
        writeln(f,this^.block.count);
        for j:=0 to this^.block.count-1 do
        begin
          child:=this^.block[j];
          writeln(f,child^.name);
        end;
      end;
    end;

      }
  end;

  closefile(f);
  last_file:=filename;
  changes_saved:=true;
end;

function query_saveas:boolean;  //returns false if click Cancel
var
  x,o:boolean;
begin
  with form1.savedialog1 do
  repeat
    x:=execute;
    if x then
      begin
        if fileexists(filename) then
          o:=(messagedlg('File exists.  Overwrite?',mtconfirmation,[mbyes,mbno],0)=mryes)
        else
          o:=true;
        if o then
          save_inpfile(filename);
      end
  until ((not x) or o);
  result:=x;
end;

procedure TForm1.SaveAs1Click(Sender: TObject);
begin
  query_saveas;
end;

procedure TForm1.Open1Click(Sender: TObject);
begin
  if query_savechanges then
    with opendialog1 do
      if execute then
        load_inpfile(filename);

end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  action:=canone;
  query_quit;
end;

procedure TForm1.Font1Click(Sender: TObject);
begin
  fontdialog1.options:=[fdfixedpitchonly];
  if fontdialog1.execute then
  begin
    main.font:=fontdialog1.font;
    music_win.font:=fontdialog1.font;
  end;
end;

procedure TForm1.music_winChange(Sender: TObject);
begin
  changes_saved:=false;
end;

procedure TForm1.stage_selectorChange(Sender: TObject);
begin
  changes_saved:=false;
  form2.lib_list.itemindex:=-1;
  form2.meth_list.clear;
end;

procedure TForm1.title_winChange(Sender: TObject);
begin
  changes_saved:=false;
end;

procedure TForm1.mainChange(Sender: TObject);
begin
  changes_saved:=false;
end;

procedure TForm1.Save1Click(Sender: TObject);
begin
  if last_file<>'' then
    save_inpfile(last_file)
  else
    query_saveas;
end;

procedure TForm1.About1Click(Sender: TObject);
begin
  messagedlg(('--- Inpact ---'#13#10'Interactive Proving and Composing Tool'#13#10'Version 1.2 (C) Alexander E Holroyd 2004'),mtinformation,[mbok],0);
end;

procedure TForm1.Insertmethod1Click(Sender: TObject);
begin
  if directoryexists(meth_dir) then
  begin
    get_stage;
    form2.lib_list.directory:=meth_dir;
    form2.lib_list.mask:='?'+inttostr(stage)+'.txt;tp'+inttostr(stage)+'.txt';
    form2.visible:=true;
    form1.enabled:=false;
  end
  else
    messagedlg('Method libraries not found.'+getcurrentdir,mtWarning,[mbcancel],0);
end;

end.
