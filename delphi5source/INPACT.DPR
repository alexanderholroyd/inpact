program inpact;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  Unit2 in 'Unit2.pas' {Form2};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Inpact';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  changes_saved:=true;
  Application.Run;
end.
