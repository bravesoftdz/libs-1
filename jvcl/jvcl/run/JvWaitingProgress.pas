{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvWaitingProgress.PAS, released on 2001-02-28.

The Initial Developer of the Original Code is S�bastien Buysse [sbuysse att buypin dott com]
Portions created by S�bastien Buysse are Copyright (C) 2001 S�bastien Buysse.
All Rights Reserved.

Contributor(s): Michael Beck [mbeck att bigfoot dott com].

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.delphi-jedi.org

Known Issues:
-----------------------------------------------------------------------------}
// $Id: JvWaitingProgress.pas 12461 2009-08-14 17:21:33Z obones $

unit JvWaitingProgress;

{$I jvcl.inc}

interface

uses
  {$IFDEF UNITVERSIONING}
  JclUnitVersioning,
  {$ENDIF UNITVERSIONING}
  SysUtils, Classes,
  Messages, Graphics, Controls, Forms,
  JvSpecialProgress, JvImageDrawThread, JvComponent;

type
  TJvWaitingProgress = class(TJvWinControl)
  private
    FActive: Boolean;
    FRefreshInterval: Cardinal;
    FLength: Cardinal;
    FOnEnded: TNotifyEvent;
    FWait: TJvImageDrawThread;
    FProgress: TJvSpecialProgress;
    function GetProgressColor: TColor;
    procedure InternalActivate;
    procedure SetActive(const Value: Boolean);
    procedure SetLength(const Value: Cardinal);
    procedure SetRefreshInterval(const Value: Cardinal);
    procedure SetProgressColor(const Value: TColor);
    procedure OnScroll(Sender: TObject);
    //function GetBColor: TColor;
    //procedure SetBColor(const Value: TColor);
  protected
    procedure BoundsChanged; override;
    procedure ColorChanged; override;
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Active: Boolean read FActive write SetActive default False;
    property Length: Cardinal read FLength write SetLength default 30000;
    property RefreshInterval: Cardinal read FRefreshInterval write SetRefreshInterval default 500;
    property ProgressColor: TColor read GetProgressColor write SetProgressColor default clBlack;
    {(rb) no need to override Color property }
    //property Color: TColor read GetBColor write SetBColor;
    property Color;
    property ParentColor;
    property Height default 10;
    property Width default 100;
    property OnEnded: TNotifyEvent read FOnEnded write FOnEnded;
  end;

{$IFDEF UNITVERSIONING}
const
  UnitVersioning: TUnitVersionInfo = (
    RCSfile: '$URL: https://jvcl.svn.sourceforge.net/svnroot/jvcl/trunk/jvcl/run/JvWaitingProgress.pas $';
    Revision: '$Revision: 12461 $';
    Date: '$Date: 2009-08-14 19:21:33 +0200 (ven., 14 août 2009) $';
    LogPath: 'JVCL\run'
  );
{$ENDIF UNITVERSIONING}

implementation


constructor TJvWaitingProgress.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FActive := False;
  FLength := 30000;
  FRefreshInterval := 500;
  // (rom) always set default values also
  Height := 10;
  Width := 100;

  FWait := TJvImageDrawThread.Create(True);
  FWait.FreeOnTerminate := False;
  FWait.Delay := FRefreshInterval;
  FWait.OnDraw := OnScroll;

  FProgress := TJvSpecialProgress.Create(Self);
  FProgress.Parent := Self;
  FProgress.Maximum := FLength;
  FProgress.Position := 0;
  FProgress.StartColor := clBlack;
  FProgress.EndColor := clBlack;
  FProgress.Solid := True;

  FProgress.Left := 0;
  FProgress.Top := 0;
  FProgress.Width := Width;
  FProgress.Height := Height;

  //inherited Color := FProgress.Color;
end;

destructor TJvWaitingProgress.Destroy;
begin
  FWait.OnDraw := nil;
  FWait.Terminate;
  //  FWait.WaitFor;
  FreeAndNil(FWait);
  FProgress.Free;
  inherited Destroy;
end;

procedure TJvWaitingProgress.Loaded;
begin
  inherited Loaded;
  if FActive then
    InternalActivate;
end;

{function TJvWaitingProgress.GetBColor: TColor;
begin
  Result := FProgress.Color;
end;}

function TJvWaitingProgress.GetProgressColor: TColor;
begin
  Result := FProgress.StartColor;
end;

procedure TJvWaitingProgress.OnScroll(Sender: TObject);
begin
  // Must exit because we are "Synchronized" and our parent is already
  // partly destroyed. If we did not exit, we would get an AV.
  if csDestroying in ComponentState then
    Exit;

  //Step
  if Integer(FProgress.Position) + Integer(FRefreshInterval) > Integer(FLength) then
  begin
    FProgress.Position := FLength;
    SetActive(False);
    if Assigned(FOnEnded) then
      FOnEnded(Self);
  end
  else
    FProgress.Position := FProgress.Position + Integer(FRefreshInterval);
  Application.ProcessMessages;
end;

procedure TJvWaitingProgress.InternalActivate;
begin
  if FActive then
  begin
    FProgress.Position := 0;
    FWait.Paused := False;
  end
  else
    FWait.Paused := True;
end;

procedure TJvWaitingProgress.SetActive(const Value: Boolean);
begin
  if FActive <> Value then
  begin
    FActive := Value;
    if not (csLoading in ComponentState) then
      InternalActivate;
  end;
end;

{procedure TJvWaitingProgress.SetBColor(const Value: TColor);
begin
  if FProgress.Color <> Value then
  begin
    FProgress.Color := Value;
    inherited Color := Value;
  end;
end;}

procedure TJvWaitingProgress.SetProgressColor(const Value: TColor);
begin
  FProgress.StartColor := Value;
  FProgress.EndColor := Value;
end;

procedure TJvWaitingProgress.SetLength(const Value: Cardinal);
begin
  FLength := Value;
  FProgress.Position := 0;
  FProgress.Maximum := FLength;
end;

procedure TJvWaitingProgress.SetRefreshInterval(const Value: Cardinal);
begin
  FRefreshInterval := Value;
  FWait.Delay := FRefreshInterval;
end;

procedure TJvWaitingProgress.BoundsChanged;
begin
  inherited BoundsChanged;
  FProgress.Width := Width;
  FProgress.Height := Height;
end;

procedure TJvWaitingProgress.ColorChanged;
begin
  inherited ColorChanged;
  FProgress.Color := Color;
end;

{$IFDEF UNITVERSIONING}
initialization
  RegisterUnitVersion(HInstance, UnitVersioning);

finalization
  UnregisterUnitVersion(HInstance);
{$ENDIF UNITVERSIONING}

end.
