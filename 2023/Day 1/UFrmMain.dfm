object FrmMain: TFrmMain
  Left = 0
  Top = 0
  Caption = 'FrmMain'
  ClientHeight = 154
  ClientWidth = 151
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object Edt1: TEdit
    Left = 8
    Top = 39
    Width = 121
    Height = 23
    TabOrder = 0
  end
  object BtnTraitement1: TButton
    Left = 24
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Traitement 1'
    TabOrder = 1
    OnClick = BtnTraitement1Click
  end
  object BtnTraitement2: TButton
    Left = 24
    Top = 68
    Width = 75
    Height = 25
    Caption = 'Traitement 2'
    TabOrder = 2
    OnClick = BtnTraitement2Click
  end
  object Edt2: TEdit
    Left = 8
    Top = 99
    Width = 121
    Height = 23
    TabOrder = 3
  end
end
