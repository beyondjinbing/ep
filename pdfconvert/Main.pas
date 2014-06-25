unit Main;

interface

uses
  Classes, Graphics, Controls, Forms, Dialogs, EPX_TLB, ComObj,
  StrFuncs, StdCtrls, OleCtrls;

type
  TForm1 = class(TForm)
    pdfEP: TExcelPanelX;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
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
var pdf: Variant;
  bmp: TBitmap;

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

procedure TForm1.Button1Click(Sender: TObject);
var pdfPath: string;
  pdfFile, pdfName, bmpName: string;
  curPage: Variant;
  pdfFileList: Variant;
  I: Integer;
begin
  pdfPath := this.FilePathDialogExecute('选择文件', '');
  pdfFileList := this.FindFileList(pdfPath, '*.pdf', True, False, False);
  if pdfFileList.count > 0 then
  begin
    for I := 0 to pdfFileList.count - 1 do
    begin
      pdfFile := pdfFileList.Strings[I];
      if (this.FileExists(pdfFile)) then
      begin
        pdf.OpenFile(pdfFile, '');
        curPage := pdf.curPage;
        bmp.Handle := pdf.GetBitmap(curPage, 480, 480, 0, 0, pdf.GetPageWidth(curPage), pdf.GetPageHeight(curPage), 2);
        if (bmp.Handle > 0) then
        begin
          try
            pdfName := this.GetFileAttribute(pdfFile, 9);
            bmpName := this.GetFileAttribute(pdfFile,4)  + pdfName + '_abbr.bmp';
            bmp.SaveToFile(bmpName);
          except
            this.Alert('异常');
          end;
        end;
      end;
    end;
  end;


end;

procedure TForm1.FormShow(Sender: TObject);
begin
  bmp := TBitmap.create;
  bmp.Width := 48;
  bmp.Height := 48;
  bmp.PixelFormat := 2;
  pdfEP.ActivePDFFileViewer := True;
  pdf := pdfEP.PDFViewer;
end;

procedure TForm1.Button2Click(Sender: TObject);
var pdfFile,curPage,pdfName,bmpName: string;
begin
  pdfFile := this.OpenDialogExecute('*.pdf|*.pdf', '', False);
  if (this.FileExists(pdfFile)) then
  begin
    pdf.OpenFile(pdfFile, '');
    curPage := pdf.curPage;
    bmp.Handle := pdf.GetBitmap(curPage, 480, 480, 0, 0, pdf.GetPageWidth(curPage), pdf.GetPageHeight(curPage), 2);
    if (bmp.Handle > 0) then
    begin
      try
        pdfName := this.GetFileAttribute(pdfFile, 9);
        bmpName := this.GetFileAttribute(pdfFile,4)  + pdfName + '_abbr.bmp';
        bmp.SaveToFile(bmpName);
        this.Alert('转换成功！');
      except
        this.Alert('转换异常！');
      end;
    end;
  end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  bmp.Free;
  pdfEP.FreeMe;
end;

end.

 