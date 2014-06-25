unit Mian;

interface

uses
  Classes, Graphics, Controls, Forms, Dialogs, EPX_TLB, ComObj,
  StrFuncs, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    Edit1: TEdit;
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  this: TExcelPanelX;
  CommandLine, OfficeAddin: Variant;

implementation
var imgPath: Variant;
    MagicPath : string;

{$R *.DFM}

{->begin-<}{
CreateForm1;
//Use the skin files, please uncomment follow line.
//Form1.ApplySkin('Put your skin file path at here.');
//Set window alpha, please uncomment follow line.
//Form1.Alpha := $800000 or $FF;
//What's New In 3.0: Support Office Addin Develope and Support DLL Addin Mode.
//Buildin Global Variable: CommandLine,OfficeAddin.
//Include New EPX.
//RedLeaf Hint: Put your initialize code here.
<<<::

::>>>
//RedLeaf Hint: Put your start code here.
//              Don't remove these code, otherwice project can't run.


Form1.ShowModal;
FreeAndNil(Form1);
}{->end<-}

procedure TForm1.FormShow(Sender: TObject);
begin
  if this.Windows64Bit then
  begin
    MagicPath := this.ReadRegistryValue( 2,'SOFTWARE\Wow6432Node\ImageMagick\6.8.9\Q:16','BinPath' );
  end else
  begin
    MagicPath := this.ReadRegistryValue( 2,'SOFTWARE\ImageMagick\6.8.9\Q:16','BinPath' );
  end;
  if this.DirectoryExistsOrNot( MagicPath ) then
  begin
    MagicPath := this.Replace( MagicPath,'/','\' );
    if Copy( MagicPath,Length(MagicPath),1 ) = '\' then
    begin
      Delete( MagicPath,Length(MagicPath),1 );
    end;  
    MagicPath := MagicPath + '\convert.exe';
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var imgList: Variant;
  I: Integer;
  CmdLine,ASourcePath,ATargetPath : string;
begin
  imgPath := this.FilePathDialogExecute('ѡ��·��', '');
  Edit1.Text := imgPath;
  imgList := this.FindFileList(imgPath, '*.bmp', True, True, False);
  this.Alert(imgList);
  if imgList.count > 0 then
  begin
    for I := 0 to imgList.count - 1 do
    begin
      ASourcePath := imgList.strings[I];
      ATargetPath := this.GetFileAttribute(ASourcePath,4)+this.GetFileAttribute(ASourcePath,9)+'_abbr.jpg';
      CmdLine := MagicPath+' -blur 80 '+ASourcePath+' '+ATargetPath;
    {  CmdLine := '"' + MagicPath + '" ' +
        '"' + '-resize' + '" ' +
        '"' + '48X48' + '" ' +
        ' "' + ASourcePath + '" ' +
        ' "' + ATargetPath + '" ';   }
    this.Alert(CmdLine);
      this.Run(CmdLine, 0, True);
    end;
  end;
end;

end.

 