{******************************************************************************}
{                                                                              }
{  ϵͳ���öԻ���:OptionSetForm        Version 04.10.27                        }
{                                                                              }
{  ���ߣ���ӥ                                                                  }
{                                                                              }
{                                                                              }
{  ���ܣ�1.ϵͳ���öԻ���                                                      }
{                                                                              }
{  ����:                                                                       }
{  �޸���ʷ��                                                                  }
{  ���÷�����                                                                  }
{  ����                                                                        }
{funtion ShowOptionForm(const pCaption,pTabSheetCaption,pItemInfo,pInifile:Pchar):boolean;stdcall;external 'OptionSetForm.dll';
{                                                                              }
{procedure TForm1.Button3Click(Sender: TObject);                               }
{var                                                                           }
{  ss:string;                                                                  }
{begin                                                                         }
{  ss:='Item1'+#2+'Combobox'+#2+'Default1'+#13+'aaa'+#13+'bbb'+#2+'1'+#2+#2+#3+}
{      'Item2'+#2+'Edit'+#2+'Default2'+#2+'2'+#2+#2+'1'+#3+                    }
{      'Item3'+#2+'RadioGroup'+#2+'Default2'+#13+'aaa'+#2+'0'+#2+'˵��'+#13+'dddd'+#2+#3+
{      'Item4'+#2+'CheckListBox'+#2+#2+'0'+#2+'˵��'+#13+'dddd'+#2;            }
{  if ShowOptionForm('���ڱ���','����1'+#2+'����2',Pchar(ss),'C:\Documents and Settings\new\����\���ô���\aa.ini') then
{    //do something                                                            }
{end;                                                                          }
{                                                                              }
{                                                                              }
{  ����һ��������,������޸�����,ϣ���������ҿ�����Ľ���                    }
{                                                                              }
{  �ҵ� Email: Liuying1129@163.com                                             }
{                                                                              }
{  ��Ȩ����,��������ҵ��;,��������ϵ!!!                                       }
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
//����˵��:
//Caption:���ڱ���
//TabSheetCaption:����TabSheet�ı���,��#2�ָ�
//ItemInfo:����Ϣ.������#3�ָ�.
//����Ϣ:��Ŀ��#2���������#2����Ϣ#2�ý�����TabSheet#2˵��#2�Ƿ���ܱ���.���ڿ���û��ֵ,��λ�ñ������(����Ӧ��#2�������)
//���������:Edit--�༭��;Combobox--������;CheckListBox--������;Dir--Ŀ¼ѡ���;DBConn--���ݿ����Ӵ���;RadioGroup--��ѡ��;File--�ļ�ѡ���
//����Ϣ:����Combobox��ֵΪһ��ѡ��.������#13�ָ�.���������ΪFileʱ,����Ϣ��ʾ�ļ���������,��*.bak|*.bak|�����ļ�|*.*
//�ý�����TabSheet:0��ʾ��1��TabSheet,1��ʾ��2��TabSheet,��������
//˵��:֧�ֶ���˵����������#13�ָ�
//�Ƿ�DES���ܱ���(�Ǻ�����):��1���ַ�Ϊ1,��ʾ���øù���,��1����ַ�Ϊ��Կ,��1�����ַ�,��Ĭ����ԿΪlc.
//Inifile:ini�ļ���·�����ļ���

//��ini�ļ���֪:RadioGroup��������,�������Ϊ�ַ���

implementation

var
  ffrmOption:TfrmOption;
  CryptStr:string;

{$R *.dfm}


function DeCryptStr(aStr: Pchar; aKey: Pchar): Pchar;stdcall;external 'LYFunction.dll';//����
function EnCryptStr(aStr: Pchar; aKey: Pchar): Pchar;stdcall;external 'LYFunction.dll';//����
function ManyStr(const pSS, pSourStr: Pchar): integer;stdcall;external 'LYFunction.dll';//����pSourStr���ж��ٸ�pSS


function StrToList(const SourStr:string;const Separator:string):TStrings;
//����ָ���ķָ��ַ���(Separator)���ַ���(SourStr)���뵽�ַ����б���
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

  slItem:=StrToList(fItemInfo,#3);//ÿ����#3�ֿ�
  setlength(Panel,slItem.Count);
  for i :=0  to slItem.Count-1 do
  begin
    if slItem[i]='' then continue;//�ý���ϢΪ��
    
    slItemInfo:=StrToList(slItem[i],#2);
    Panel[i]:=TPanel.Create(self);
    Panel[i].Parent:=ScrollBox[ifthen(strtointdef(slItemInfo[3],0)<=TabSheetCount-1,strtointdef(slItemInfo[3],0))];
    Panel[i].Top:=maxint;//ʹ����Panel������˳������
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

    if slItemInfo[4]<>'' then//����"˵��"��ǩ
    begin
      with TLabel.Create(self) do
      begin
        Parent:=Panel[i];
        autosize:=true;
        top:=38;
        left:=8;
        Caption:=slItemInfo[4];
        Font.Color:=clBlue;
        Panel[i].Height:=Panel[i].Height+(manystr(#13,Pchar(slItemInfo[4]))+1)*13;//����Panel�ĸ߶�
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
        Height:=21;//���ֻ��Ϊ29,����Ϊ����
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

  //====================����ScrollBox.VertScrollBar.Range=====================//
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
      else INI.WriteString(TTabSheet(TEdit(Components[i]).Parent.Parent.Parent).Caption,LabCap,TEdit(Components[i]).Text);//��1��Parent��Panel,��2��Parent��ScollBox,��3��Parent��TabSheet
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
        TEdit(Components[i]).Text:=INI.ReadString(TTabSheet(TEdit(Components[i]).Parent.Parent.Parent).Caption,LabCap,'');//��1��Parent��Panel,��2��Parent��ScollBox,��3��Parent��TabSheet
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
