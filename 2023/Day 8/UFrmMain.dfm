object FrmMain: TFrmMain
  Left = 0
  Top = 0
  Caption = 'FrmMain'
  ClientHeight = 190
  ClientWidth = 216
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object Edt1: TEdit
    Left = 56
    Top = 71
    Width = 121
    Height = 23
    TabOrder = 0
  end
  object BtnExercice1: TButton
    Left = 72
    Top = 40
    Width = 75
    Height = 25
    Caption = 'Exercice 1'
    TabOrder = 1
    OnClick = BtnExercice1Click
  end
  object Edt2: TEdit
    Left = 56
    Top = 131
    Width = 121
    Height = 23
    TabOrder = 2
  end
  object BtnExercice2: TButton
    Left = 72
    Top = 100
    Width = 75
    Height = 25
    Caption = 'Exercice 2'
    TabOrder = 3
    OnClick = BtnExercice2Click
  end
  object ChkTests: TCheckBox
    Left = 8
    Top = 8
    Width = 97
    Height = 17
    Caption = 'Fichier tests'
    Checked = True
    State = cbChecked
    TabOrder = 4
  end
end
