object frmOption: TfrmOption
  Left = 213
  Top = 115
  BorderStyle = bsDialog
  ClientHeight = 341
  ClientWidth = 423
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 423
    Height = 300
    Align = alClient
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 300
    Width = 423
    Height = 41
    Align = alBottom
    TabOrder = 1
    object BitBtn1: TBitBtn
      Left = 104
      Top = 8
      Width = 75
      Height = 25
      Caption = #30830#23450
      Default = True
      TabOrder = 0
      OnClick = BitBtn1Click
    end
    object BitBtn2: TBitBtn
      Left = 248
      Top = 8
      Width = 75
      Height = 25
      Cancel = True
      Caption = #21462#28040
      TabOrder = 1
      OnClick = BitBtn2Click
    end
  end
end
