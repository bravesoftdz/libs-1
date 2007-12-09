unit VDTButton;
{$D-}
interface

uses
  Windows, Forms, Controls, Classes, Buttons, ComCtrls, Graphics, RoundButton;

type
  TVDTButton = class(TSpeedButton)
  private
    { D�clarations priv�es }
  protected
    { D�clarations prot�g�es }
  public
    { D�clarations publiques }
    constructor Create(AOwner: TComponent); override;
  published
    { D�clarations publi�es }
  end;

  TVDTListView = class(TListView)
  private
    { D�clarations priv�es }
  protected
    { D�clarations prot�g�es }
  public
    { D�clarations publiques }
    constructor Create(AOwner: TComponent); override;
  published
    { D�clarations publi�es }
    property SortType default stText;
    property Cursor default crHandPoint;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Tetram', [TVDTButton, TVDTListView]);
end;

constructor TVDTButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Flat := True;
  Cursor := crHandPoint;
end;

constructor TVDTListView.Create(AOwner: TComponent);
begin
  Anchors := [akLeft, akTop, akRight, akBottom];
  BorderStyle := bsNone;
  ColumnClick := False;
  HideSelection := False;
  ReadOnly := True;
  RowSelect := False;
  ShowColumnHeaders := False;
  SortType := stText;
  ViewStyle := vsReport;
  // si on le place au d�but, les "personnalisations" prennent le pas sur ce qu'on peut mettre dans l'EDI
  inherited Create(AOwner);
  Cursor := crHandPoint;
end;

end.
