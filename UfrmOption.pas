{******************************************************************************}
{                                                                              }
{  系统设置对话框:OptionSetForm        Version 04.10.27                        }
{                                                                              }
{  作者：刘鹰                                                                  }
{                                                                              }
{                                                                              }
{  功能：1.系统设置对话框                                                      }
{                                                                              }
{  功能:                                                                       }
{  修改历史：                                                                  }
{  调用方法：                                                                  }
{  声明                                                                        }
{funtion ShowOptionForm(const pCaption,pTabSheetCaption,pItemInfo,pInifile:Pchar):boolean;stdcall;external 'OptionSetForm.dll';
{                                                                              }
{procedure TForm1.Button3Click(Sender: TObject);                               }
{var                                                                           }
{  ss:string;                                                                  }
{begin                                                                         }
{  ss:='Item1'+#2+'Combobox'+#2+'Default1'+#13+'aaa'+#13+'bbb'+#2+'1'+#2+#2+#3+}
{      'Item2'+#2+'Edit'+#2+'Default2'+#2+'2'+#2+#2+'1'+#3+                    }
{      'Item3'+#2+'RadioGroup'+#2+'Default2'+#13+'aaa'+#2+'0'+#2+'说明'+#13+'dddd'+#2+#3+
{      'Item4'+#2+'CheckListBox'+#2+#2+'0'+#2+'说明'+#13+'dddd'+#2;            }
{  if ShowOptionForm('窗口标题','标题1'+#2+'标题2',Pchar(ss),'C:\Documents and Settings\new\桌面\设置窗体\aa.ini') then
{    //do something                                                            }
{end;                                                                          }
{                                                                              }
{                                                                              }
{  他是一个免费软件,如果你修改了他,希望我能有幸看到你的杰作                    }
{                                                                              }
{  我的 Email: Liuying1129@163.com                                             }
{                                                                              }
{  版权所有,欲用于商业用途,请与我联系!!!                                       }
{                                                                              }
{  Bug:                                                                        }
{  1.                                                                          }
{******************************************************************************}

Unit UfrmOption;

interface

uses
  Forms,SysUtils{strtointdef},Buttons, Math{ifThen}, CheckLst, LYEdit,IniFiles,
  ExtCtrls, StdCtrls, ComCtrls, Controls, Classes, Graphics{clBlue};
  
type
  TfrmOption = class(TForm)
    PageControl1: TPageControl;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
    { Private declarations }
    FTabSheetCaption:string;
    FItemInfo:string;
    FInifile:string;
    procedure ReadIni;
    procedure WriteIni;

  public
    { Public declarations }
  end;
  
function ShowOptionForm(const pCaption,pTabSheetCaption,pItemInfo,pInifile:Pchar):Boolean;stdcall;
//参数说明:
//Caption:窗口标题
//TabSheetCaption:各个TabSheet的标题,用#2分隔
//ItemInfo:节信息.各节用#3分隔.
//节信息:项目名#2输入框类型#2组信息#2该节所属TabSheet#2说明#2是否加密保存.各节可以没有值,但位置必须存在(即相应的#2必须存在)
//输入框类型:Edit--编辑框;Combobox--下拉框;CheckListBox--检查组框;Dir--目录选择框;DBConn--数据库连接串框;RadioGroup--单选组;File--文件选择框
//组信息:例如Combobox的值为一组选项.各组用#13分隔.输入框类型为File时,组信息表示文件过滤属性,如*.bak|*.bak|所有文件|*.*
//该节所属TabSheet:0表示第1个TabSheet,1表示第2个TabSheet,依此类推
//说明:支持多行说明，各行用#13分隔
//是否DES加密保存(星号密显):第1个字符为1,表示启用该功能,且1后的字符为密钥,如1后无字符,则默认密钥为lc.
//Inifile:ini文件的路径及文件名

//读ini文件需知:RadioGroup项是整数,其他项均为字符串

implementation

var
  ffrmOption:TfrmOption;
  CryptStr:string;

{$R *.dfm}


function DeCryptStr(aStr: Pchar; aKey: Pchar): Pchar;stdcall;external 'LYFunction.dll';//解密
function EnCryptStr(aStr: Pchar; aKey: Pchar): Pchar;stdcall;external 'LYFunction.dll';//加密
function ManyStr(const pSS, pSourStr: Pchar): integer;stdcall;external 'LYFunction.dll';//计算pSourStr中有多少个pSS


function StrToList(const SourStr:string;const Separator:string):TStrings;
//根据指定的分隔字符串(Separator)将字符串(SourStr)导入到字符串列表中
var
  vSourStr,s:string;
  ll,lll:integer;
begin
  vSourStr:=SourStr;
  Result := TStringList.Create;
  lll:=length(Separator);

  while pos(Separator,vSourStr)<>0 do
  begin
    ll:=pos(Separator,vSourStr);
    Result.Add(copy(vSourStr,1,ll-1));
    delete(vSourStr,1,ll+lll-1);
  end;
  Result.Add(vSourStr);
  s:=vSourStr;
end;

function ShowOptionForm(const pCaption,pTabSheetCaption,pItemInfo,pInifile:Pchar):Boolean;
var
  i:integer;
begin
  ffrmOption:=TfrmOption.Create(nil);
  ffrmOption.Caption:=StrPas(pCaption);

  setlength(ffrmOption.fTabSheetCaption,length(pTabSheetCaption));
  for i :=1  to length(pTabSheetCaption) do ffrmOption.fTabSheetCaption[i]:=pTabSheetCaption[i-1];
  setlength(ffrmOption.fItemInfo,length(pItemInfo));
  for i :=1  to length(pItemInfo) do ffrmOption.fItemInfo[i]:=pItemInfo[i-1];
  setlength(ffrmOption.FInifile,length(pInifile));
  for i :=1  to length(pInifile) do ffrmOption.FInifile[i]:=pInifile[i-1];

  try
    ffrmOption.ShowModal;
    if ffrmOption.ModalResult=mrOk then result:=true else result:=false;
  finally
    ffrmOption.Free;
  end;
end;


procedure TfrmOption.FormShow(Sender: TObject);
var
  i,j:integer;
  slTabSheetCaption,slItem,slItemInfo,sl4:tstrings;
  Panel:array of TPanel;
  ScrollBox:array of TScrollBox;
  TabSheet:array of TTabSheet;
  TabSheetCount:integer;
begin
  slTabSheetCaption:=StrToList(fTabSheetCaption,#2);
  TabSheetCount:=slTabSheetCaption.Count;
  setlength(TabSheet,TabSheetCount);
  setlength(ScrollBox,TabSheetCount);
  for i :=0  to TabSheetCount-1 do
  begin
    TabSheet[i]:=TTabSheet.Create(self);
    TabSheet[i].PageControl:=PageControl1;
    TabSheet[i].Caption:=slTabSheetCaption[i];

    ScrollBox[i]:=TScrollBox.Create(self);
    ScrollBox[i].Parent:=TabSheet[i];
    ScrollBox[i].Align:=alClient;
  end;
  slTabSheetCaption.Free;

  slItem:=StrToList(fItemInfo,#3);//每节用#3分开
  setlength(Panel,slItem.Count);
  for i :=0  to slItem.Count-1 do
  begin
    if slItem[i]='' then continue;//该节信息为空
    
    slItemInfo:=StrToList(slItem[i],#2);
    Panel[i]:=TPanel.Create(self);
    Panel[i].Parent:=ScrollBox[ifthen(strtointdef(slItemInfo[3],0)<=TabSheetCount-1,strtointdef(slItemInfo[3],0))];
    Panel[i].Top:=maxint;//使各个Panel按创建顺序排列
    Panel[i].Align:=alTop;
    Panel[i].Tag:=i+1;
    with TLabel.Create(self) do
    begin
      Parent:=Panel[i];
      autosize:=true;
      top:=2;
      left:=8;
      Caption:=slItemInfo[0];
      tag:=i+1;
    end;

    if slItemInfo[4]<>'' then//创建"说明"标签
    begin
      with TLabel.Create(self) do
      begin
        Parent:=Panel[i];
        autosize:=true;
        top:=38;
        left:=8;
        Caption:=slItemInfo[4];
        Font.Color:=clBlue;
        Panel[i].Height:=Panel[i].Height+(manystr(#13,Pchar(slItemInfo[4]))+1)*13;//增加Panel的高度
      end;
    end;

    if uppercase(slItemInfo[1])=uppercase('Edit') then
    begin
      with TEdit.Create(self) do
      begin
        Parent:=Panel[i];
        width:=self.Width-50;
        top:=16;
        left:=8;
        if slItemInfo[5]<>'' then
        begin
          if slItemInfo[5][1]='1' then
          begin
            PasswordChar:='*';
            CryptStr:=copy(slItemInfo[5],2,MaxInt);
            if CryptStr='' then CryptStr:='lc';
          end;
        end;
      end;
    end;
    if uppercase(slItemInfo[1])=uppercase('Date') then
    begin
      with TDateTimePicker.Create(self) do
      begin
        Parent:=Panel[i];
        Kind:=dtkDate;
        width:=self.Width-50;
        top:=16;
        left:=8;
      end;
    end;
    if uppercase(slItemInfo[1])=uppercase('Time') then
    begin
      with TDateTimePicker.Create(self) do
      begin
        Parent:=Panel[i];
        Kind:=dtkTime;
        width:=self.Width-50;
        top:=16;
        left:=8;
      end;
    end;
    if uppercase(slItemInfo[1])=uppercase('Dir') then
    begin
      with TLYEdit.Create(self) do
      begin
        Parent:=Panel[i];
        EditType:=etDir;
        width:=self.Width-50;
        top:=16;
        left:=8;
      end;
    end;
    if uppercase(slItemInfo[1])=uppercase('File') then
    begin
      with TLYEdit.Create(self) do
      begin
        Parent:=Panel[i];
        EditType:=etFile;
        width:=self.Width-50;
        top:=16;
        left:=8;
        Filter:=slItemInfo[2];
      end;
    end;
    if uppercase(slItemInfo[1])=uppercase('DBConn') then
    begin
      with TLYEdit.Create(self) do
      begin
        Parent:=Panel[i];
        EditType:=etDBConn;
        width:=self.Width-50;
        top:=16;
        left:=8;
      end;
    end;
    if uppercase(slItemInfo[1])=uppercase('UniConn') then
    begin
      with TLYEdit.Create(self) do
      begin
        Parent:=Panel[i];
        EditType:=etUniConn;
        width:=self.Width-50;
        top:=16;
        left:=8;
      end;
    end;
    if uppercase(slItemInfo[1])=uppercase('Combobox') then
    begin
      with TCombobox.Create(self) do
      begin
        Parent:=Panel[i];
        width:=self.Width-50;
        top:=16;
        left:=8;
        Items.Text:=slItemInfo[2];
      end;
    end;
    if uppercase(slItemInfo[1])=uppercase('CheckListBox') then
    begin
      sl4:=StrToList(slItemInfo[2],#13);
      with TCheckListBox.Create(self) do
      begin
        Parent:=Panel[i];
        Height:=21;//最多只能为29,否则为多行
        Columns:=sl4.Count;
        width:=self.Width-50;
        top:=16;
        left:=8;
        Items.AddStrings(sl4);
      end;
      sl4.Free;
    end;
    if uppercase(slItemInfo[1])=uppercase('RadioGroup') then
    begin
      sl4:=StrToList(slItemInfo[2],#13);
      with TRadioGroup.Create(self) do
      begin
        Parent:=Panel[i];
        Height:=30;
        Columns:=sl4.Count;
        width:=self.Width-50;
        top:=16;
        left:=8;
        Items.AddStrings(sl4);
      end;
      sl4.Free;
    end;

    slItemInfo.Free;
  end;
  
  slItem.Free;

  ReadIni;

  //====================设置ScrollBox.VertScrollBar.Range=====================//
  for i :=0  to ComponentCount-1 do
  begin
    if Components[i] is TScrollBox then
    begin
      for j :=0  to TScrollBox(Components[i]).ControlCount-1 do
      begin
        if TScrollBox(Components[i]).Controls[j] is TPanel then
           TScrollBox(Components[i]).VertScrollBar.Range:=TScrollBox(Components[i]).VertScrollBar.Range+TPanel(TScrollBox(Components[i]).Controls[j]).Height;
      end;
    end;
  end;
  //==========================================================================//
end;

procedure TfrmOption.BitBtn1Click(Sender: TObject);
begin
  WriteIni();

  ModalResult:=mrOk;
end;

procedure TfrmOption.BitBtn2Click(Sender: TObject);
begin
  ModalResult:=mrCancel;
end;

procedure TfrmOption.WriteIni;
var
  ini:tinifile;
  i,k,j:integer;
  LabCap,sel:string;
begin
  INI:=TINIFILE.Create(FInifile);

  for i :=0  to ComponentCount-1 do
  begin
    if Components[i] is TEdit then
    begin
      for j :=0  to ComponentCount-1 do
        if (Components[j] is TLabel)and(Components[j].Tag=TEdit(Components[i]).Parent.Tag) then LabCap:=TLabel(Components[j]).Caption;
      if TEdit(Components[i]).PasswordChar='*' then
        INI.WriteString(TTabSheet(TEdit(Components[i]).Parent.Parent.Parent).Caption,LabCap,EnCryptStr(Pchar(TEdit(Components[i]).Text),Pchar(CryptStr)))
      else INI.WriteString(TTabSheet(TEdit(Components[i]).Parent.Parent.Parent).Caption,LabCap,TEdit(Components[i]).Text);//第1个Parent是Panel,第2个Parent是ScollBox,第3个Parent是TabSheet
    end;
    if Components[i] is TDateTimePicker then
    begin
      for j :=0  to ComponentCount-1 do
        if (Components[j] is TLabel)and(Components[j].Tag=TCombobox(Components[i]).Parent.Tag) then LabCap:=TLabel(Components[j]).Caption;
      INI.WriteString(TTabSheet(TDateTimePicker(Components[i]).Parent.Parent.Parent).Caption,LabCap,FormatDateTime('YYYY-MM-DD HH:NN:SS',TDateTimePicker(Components[i]).DateTime));
    end;
    if Components[i] is TCombobox then
    begin
      for j :=0  to ComponentCount-1 do
        if (Components[j] is TLabel)and(Components[j].Tag=TCombobox(Components[i]).Parent.Tag) then LabCap:=TLabel(Components[j]).Caption;
      INI.WriteString(TTabSheet(TCombobox(Components[i]).Parent.Parent.Parent).Caption,LabCap,TCombobox(Components[i]).Text);
    end;
    if Components[i] is TLYEdit then
    begin
      for j :=0  to ComponentCount-1 do
        if (Components[j] is TLabel)and(Components[j].Tag=TLYEdit(Components[i]).Parent.Tag) then LabCap:=TLabel(Components[j]).Caption;
      INI.WriteString(TTabSheet(TLYEdit(Components[i]).Parent.Parent.Parent).Caption,LabCap,TLYEdit(Components[i]).Text);
    end;
    if Components[i] is TRadioGroup then
    begin
      for j :=0  to ComponentCount-1 do
        if (Components[j] is TLabel)and(Components[j].Tag=TRadioGroup(Components[i]).Parent.Tag) then LabCap:=TLabel(Components[j]).Caption;
      INI.WriteInteger(TTabSheet(TRadioGroup(Components[i]).Parent.Parent.Parent).Caption,LabCap,TRadioGroup(Components[i]).ItemIndex);
    end;
    if Components[i] is TCheckListBox then
    begin
      for j :=0  to ComponentCount-1 do
        if (Components[j] is TLabel)and(Components[j].Tag=TCheckListBox(Components[i]).Parent.Tag) then LabCap:=TLabel(Components[j]).Caption;
      sel:='';
      for  k:=0  to TCheckListBox(Components[i]).Items.Count-1 do
        if TCheckListBox(Components[i]).Checked[k] then sel:=sel+'1' else sel:=sel+'0';
      INI.WriteString(TTabSheet(TCheckListBox(Components[i]).Parent.Parent.Parent).Caption,LabCap,sel);
    end;
  end;

  ini.Free;
end;

procedure TfrmOption.ReadIni();
var
  ini:tinifile;
  i,j:integer;
  LabCap,sel:string;
begin
  INI:=TINIFILE.Create(FInifile);

  for i :=0  to ComponentCount-1 do
  begin
    if Components[i] is TEdit then
    begin
      for j :=0  to ComponentCount-1 do
        if (Components[j] is TLabel)and(Components[j].Tag=TEdit(Components[i]).Parent.Tag) then LabCap:=TLabel(Components[j]).Caption;
      if (TEdit(Components[i]).PasswordChar='*')and(INI.ReadString(TTabSheet(TEdit(Components[i]).Parent.Parent.Parent).Caption,LabCap,'')<>'') then
        TEdit(Components[i]).Text:=DeCryptStr(Pchar(INI.ReadString(TTabSheet(TEdit(Components[i]).Parent.Parent.Parent).Caption,LabCap,'')),Pchar(CryptStr))
      else
        TEdit(Components[i]).Text:=INI.ReadString(TTabSheet(TEdit(Components[i]).Parent.Parent.Parent).Caption,LabCap,'');//第1个Parent是Panel,第2个Parent是ScollBox,第3个Parent是TabSheet
    end;
    if Components[i] is TDateTimePicker then
    begin
      for j :=0  to ComponentCount-1 do
        if (Components[j] is TLabel)and(Components[j].Tag=TLYEdit(Components[i]).Parent.Tag) then LabCap:=TLabel(Components[j]).Caption;
      TDateTimePicker(Components[i]).DateTime:=INI.ReadDateTime(TTabSheet(TDateTimePicker(Components[i]).Parent.Parent.Parent).Caption,LabCap,Now);
    end;
    if Components[i] is TCombobox then
    begin
      for j :=0  to ComponentCount-1 do
        if (Components[j] is TLabel)and(Components[j].Tag=TCombobox(Components[i]).Parent.Tag) then LabCap:=TLabel(Components[j]).Caption;
      TCombobox(Components[i]).Text:=INI.ReadString(TTabSheet(TCombobox(Components[i]).Parent.Parent.Parent).Caption,LabCap,'');
    end;
    if Components[i] is TLYEdit then
    begin
      for j :=0  to ComponentCount-1 do
        if (Components[j] is TLabel)and(Components[j].Tag=TLYEdit(Components[i]).Parent.Tag) then LabCap:=TLabel(Components[j]).Caption;
      TLYEdit(Components[i]).Text:=INI.ReadString(TTabSheet(TLYEdit(Components[i]).Parent.Parent.Parent).Caption,LabCap,'');
    end;
    if Components[i] is TRadioGroup then
    begin
      for j :=0  to ComponentCount-1 do
        if (Components[j] is TLabel)and(Components[j].Tag=TRadioGroup(Components[i]).Parent.Tag) then LabCap:=TLabel(Components[j]).Caption;
      TRadioGroup(Components[i]).ItemIndex:=INI.ReadInteger(TTabSheet(TRadioGroup(Components[i]).Parent.Parent.Parent).Caption,LabCap,0);
    end;
    if Components[i] is TCheckListBox then
    begin
      for j :=0  to ComponentCount-1 do
        if (Components[j] is TLabel)and(Components[j].Tag=TCheckListBox(Components[i]).Parent.Tag) then LabCap:=TLabel(Components[j]).Caption;
      sel:=INI.ReadString(TTabSheet(TCheckListBox(Components[i]).Parent.Parent.Parent).Caption,LabCap,'');
      sel:=sel+StringOfChar('0',TCheckListBox(Components[i]).Items.Count);
      for  j:=0  to TCheckListBox(Components[i]).Items.Count-1 do
        TCheckListBox(Components[i]).Checked[j]:=sel[j+1]='1';
    end;
  end;

  ini.Free;
end;

end.
