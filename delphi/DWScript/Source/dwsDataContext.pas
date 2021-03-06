{**********************************************************************}
{                                                                      }
{    "The contents of this file are subject to the Mozilla Public      }
{    License Version 1.1 (the "License"); you may not use this         }
{    file except in compliance with the License. You may obtain        }
{    a copy of the License at http://www.mozilla.org/MPL/              }
{                                                                      }
{    Software distributed under the License is distributed on an       }
{    "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express       }
{    or implied. See the License for the specific language             }
{    governing rights and limitations under the License.               }
{                                                                      }
{    Copyright Creative IT.                                            }
{    Current maintainer: Eric Grange                                   }
{                                                                      }
{**********************************************************************}
unit dwsDataContext;

{$I dws.inc}

interface

uses
   dwsXPlatform, dwsUtils;

type

   TData = array of Variant;
   PData = ^TData;
   TDataArray = array [0..MaxInt shr 5] of Variant;
   PDataArray = ^TDataArray;
   TVarDataArray = array [0..MaxInt shr 5] of TVarData;
   PVarDataArray = ^TVarDataArray;
   PIUnknown = ^IUnknown;

   IDataContext = interface (IGetSelf)
      function GetAsVariant(addr : Integer) : Variant;
      procedure SetAsVariant(addr : Integer; const value : Variant);
      function GetAsInteger(addr : Integer) : Int64;
      procedure SetAsInteger(addr : Integer; const value : Int64);
      function GetAsFloat(addr : Integer) : Double;
      procedure SetAsFloat(addr : Integer; const value : Double);
      function GetAsBoolean(addr : Integer) : Boolean;
      procedure SetAsBoolean(addr : Integer; const value : Boolean);
      function GetAsString(addr : Integer) : UnicodeString;
      procedure SetAsString(addr : Integer; const value : UnicodeString);
      function GetAsInterface(addr : Integer) : IUnknown;
      procedure SetAsInterface(addr : Integer; const value : IUnknown);

      function Addr : Integer;
      function DataLength : Integer;

      property AsVariant[addr : Integer] : Variant read GetAsVariant write SetAsVariant; default;

      function AsPVarDataArray : PVarDataArray;
      function AsPData : PData;
      function AsData : TData;
      function AsPVariant(addr : Integer) : PVariant;

      procedure CreateOffset(offset : Integer; var result : IDataContext);

      property  AsInteger[addr : Integer] : Int64 read GetAsInteger write SetAsInteger;
      property  AsBoolean[addr : Integer] : Boolean read GetAsBoolean write SetAsBoolean;
      property  AsFloat[addr : Integer] : Double read GetAsFloat write SetAsFloat;
      property  AsString[addr : Integer] : UnicodeString read GetAsString write SetAsString;
      property  AsInterface[addr : Integer] : IUnknown read GetAsInterface write SetAsInterface;

      procedure EvalAsVariant(addr : Integer; var result : Variant);
      procedure EvalAsString(addr : Integer; var result : UnicodeString);
      procedure EvalAsInterface(addr : Integer; var result : IUnknown);

      procedure CopyData(const destData : TData; destAddr, size : Integer);
      procedure WriteData(const src : IDataContext; size : Integer); overload;
      procedure WriteData(const srcData : TData; srcAddr, size : Integer); overload;
      function SameData(addr : Integer; const otherData : TData; otherAddr, size : Integer) : Boolean; overload;
   end;

   TDataContext = class;

   IDataContextPool = interface
      function Create(const aData : TData; anAddr : Integer) : TDataContext;
      procedure Cleanup;
   end;

   TDataContextPool = class (TInterfacedObject, IDataContextPool)
      private
         FHead : TDataContext;
         FAll : TDataContext;

      protected
         function CreateEmpty : TDataContext;
         function Pop : TDataContext; inline;
         procedure Push(ref : TDataContext); inline;
         procedure Cleanup;

         function CreateData(const aData : TData; anAddr : Integer) : TDataContext;
         function CreateOffset(offset : Integer; ref : TDataContext) : TDataContext;

         function IDataContextPool.Create = CreateData;
   end;
   PDataPtrPool= ^TDataContextPool;

   TDataContext = class(TInterfacedObject, IDataContext, IGetSelf)
      private
         FAddr : Integer;
         FData : TData;
         FNext : TDataContext;
         FPool : TDataContextPool;
         FAllNext : TDataContext;
{$IFDEF DELPHI_2010_MINUS}
      protected // D2009 needs protected here to "see" these methods in inherited classes
{$ENDIF}
         function GetAsVariant(addr : Integer) : Variant; inline;
         procedure SetAsVariant(addr : Integer; const value : Variant); inline;
         function GetAsInteger(addr : Integer) : Int64; inline;
         procedure SetAsInteger(addr : Integer; const value : Int64); inline;
         function GetAsFloat(addr : Integer) : Double; inline;
         procedure SetAsFloat(addr : Integer; const value : Double); inline;
         function GetAsBoolean(addr : Integer) : Boolean; inline;
         procedure SetAsBoolean(addr : Integer; const value : Boolean); inline;
         function GetAsString(addr : Integer) : UnicodeString; inline;
         procedure SetAsString(addr : Integer; const value : UnicodeString); inline;
         function GetAsInterface(addr : Integer) : IUnknown; inline;
         procedure SetAsInterface(addr : Integer; const value : IUnknown); inline;

         function _AddRef: Integer; stdcall;
         function _Release: Integer; stdcall;

      protected
         property DirectData : TData read FData;

      public
         function GetSelf : TObject;

         property AsVariant[addr : Integer] : Variant read GetAsVariant write SetAsVariant; default;
         function AsPVarDataArray : PVarDataArray; inline;
         function AsPData : PData; inline;
         function AsData : TData;
         function AsPVariant(addr : Integer) : PVariant; inline;
         function Addr : Integer;
         function DataLength : Integer; inline;
         procedure Offset(delta : Integer); inline;

         procedure CreateOffset(offset : Integer; var result : IDataContext);

         procedure EvalAsVariant(addr : Integer; var result : Variant); inline;
         procedure EvalAsString(addr : Integer; var result : UnicodeString); inline;
         procedure EvalAsInterface(addr : Integer; var result : IUnknown);

         property  AsInteger[addr : Integer] : Int64 read GetAsInteger write SetAsInteger;
         property  AsBoolean[addr : Integer] : Boolean read GetAsBoolean write SetAsBoolean;
         property  AsFloat[addr : Integer] : Double read GetAsFloat write SetAsFloat;
         property  AsString[addr : Integer] : UnicodeString read GetAsString write SetAsString;
         property  AsInterface[addr : Integer] : IUnknown read GetAsInterface write SetAsInterface;

         procedure CopyData(const destData : TData; destAddr, size : Integer); inline;
         procedure WriteData(const src : IDataContext; size : Integer); overload; inline;
         procedure WriteData(const srcData : TData; srcAddr, size : Integer); overload; inline;
         function  SameData(addr : Integer; const otherData : TData; otherAddr, size : Integer) : Boolean; overload; inline;

         procedure ReplaceData(const newData : TData); virtual;
         procedure ClearData; virtual;
         procedure SetDataLength(n : Integer);
   end;

procedure DWSCopyData(const sourceData : TData; sourceAddr : Integer;
                      const destData : TData; destAddr : Integer; size : Integer);
function DWSSameData(const data1, data2 : TData; offset1, offset2, size : Integer) : Boolean; overload;
function DWSSameData(const data1, data2 : TData) : Boolean; overload;
function DWSSameVariant(const v1, v2 : Variant) : Boolean;

// ------------------------------------------------------------------
// ------------------------------------------------------------------
// ------------------------------------------------------------------
implementation
// ------------------------------------------------------------------
// ------------------------------------------------------------------
// ------------------------------------------------------------------

// DWSCopyData
//
procedure DWSCopyData(const sourceData: TData; sourceAddr: Integer;
                      const destData: TData; destAddr: Integer; size: Integer);
var
   src, dest : PVariant;
begin
   src:=@sourceData[sourceAddr];
   dest:=@destData[destAddr];
   while size > 0 do begin
      VarCopySafe(dest^, src^);
      Inc(src);
      Inc(dest);
      Dec(size);
   end;
end;

// DWSSameData
//
function DWSSameData(const data1, data2 : TData; offset1, offset2, size : Integer) : Boolean;
var
   i : Integer;
begin
   for i:=0 to size-1 do
      if not DWSSameVariant(data1[offset1+i], data2[offset2+i]) then
         Exit(False);
   Result:=True;
end;

// DWSSameData
//
function DWSSameData(const data1, data2 : TData) : Boolean;
var
   s : Integer;
begin
   s:=Length(data1);
   Result:=(s=Length(data2)) and DWSSameData(data1, data2, 0, 0, s);
end;

// DWSSameVariant
//
function DWSSameVariant(const v1, v2 : Variant) : Boolean;
var
   vt : Integer;
begin
   vt:=TVarData(v1).VType;
   if vt<>TVarData(v2).VType then
      Result:=False
   else begin
      case vt of
         varInt64 :
            Result:=TVarData(v1).VInt64=TVarData(v2).VInt64;
         varBoolean :
            Result:=TVarData(v1).VBoolean=TVarData(v2).VBoolean;
         varDouble :
            Result:=TVarData(v1).VDouble=TVarData(v2).VDouble;
         varUString :
            Result:=UnicodeString(TVarData(v1).VString)=UnicodeString(TVarData(v2).VString);
         varUnknown :
            Result:=TVarData(v1).VUnknown=TVarData(v2).VUnknown;
      else
         Result:=(v1=v2);
      end;
   end;
end;

// ------------------
// ------------------ TDataContextPool ------------------
// ------------------

// CreateEmpty
//
function TDataContextPool.CreateEmpty : TDataContext;
begin
   Result:=TDataContext.Create;
   Result.FPool:=Self;
   Result.FAllNext:=FAll;
   FAll:=Result;
end;

// Pop
//
function TDataContextPool.Pop : TDataContext;
begin
   if FHead=nil then
      Result:=CreateEmpty
   else begin
      Result:=FHead;
      FHead:=FHead.FNext;
   end;
end;

// Push
//
procedure TDataContextPool.Push(ref : TDataContext);
begin
   if Self=nil then
      ref.Free
   else begin
      ref.FNext:=FHead;
      FHead:=ref;
      ref.FData:=nil;
      ref.FAddr:=0;
   end;
end;

// Cleanup
//
procedure TDataContextPool.Cleanup;
var
   iter : TDataContext;
begin
   // detach all from the pool
   iter:=FAll;
   while iter<>nil do begin
      iter.FPool:=nil;
      iter:=iter.FAllNext;
   end;
   FAll:=nil;
   // free all the pooled ones.
   while FHead<>nil do begin
      iter:=FHead;
      FHead:=iter.FNext;
      iter.Destroy;
   end;
end;

// CreateData
//
function TDataContextPool.CreateData(const aData : TData; anAddr : Integer) : TDataContext;
begin
   Result:=Pop;
   Result.FAddr:=anAddr;
   Result.FData:=aData;
end;

// CreateOffset
//
function TDataContextPool.CreateOffset(offset : Integer; ref : TDataContext) : TDataContext;
begin
   Result:=Pop;
   Result.FAddr:=ref.FAddr+offset;
   Result.FData:=ref.FData;
end;

// ------------------
// ------------------ TDataContext ------------------
// ------------------

// _AddRef
//
function TDataContext._AddRef: Integer;
begin
   Result := InterlockedIncrement(FRefCount);
end;

// _Release
//
function TDataContext._Release: Integer;
begin
   Result := InterlockedDecrement(FRefCount);
   if Result = 0 then
      FPool.Push(Self);
end;

// GetSelf
//
function TDataContext.GetSelf : TObject;
begin
   Result:=Self;
end;

// GetAsVariant
//
function TDataContext.GetAsVariant(addr : Integer) : Variant;
begin
   Result:=FData[FAddr+addr];
end;

// SetAsVariant
//
procedure TDataContext.SetAsVariant(addr : Integer; const value : Variant);
begin
   VarCopySafe(FData[FAddr+addr], value);
end;

// GetAsInteger
//
function TDataContext.GetAsInteger(addr : Integer) : Int64;
var
   p : PVarData;
begin
   p:=@FData[FAddr+addr];
   if p^.VType=varInt64 then
      Result:=p^.VInt64
   else Result:=PVariant(p)^;
end;

// SetAsInteger
//
procedure TDataContext.SetAsInteger(addr : Integer; const value : Int64);
var
   p : PVarData;
begin
   p:=@FData[FAddr+addr];
   if p^.VType=varInt64 then
      p^.VInt64:=value
   else PVariant(p)^:=value;
end;

// GetAsFloat
//
function TDataContext.GetAsFloat(addr : Integer) : Double;
var
   p : PVarData;
begin
   p:=@FData[FAddr+addr];
   if p^.VType=varDouble then
      Result:=p^.VDouble
   else Result:=PVariant(p)^;
end;

// SetAsFloat
//
procedure TDataContext.SetAsFloat(addr : Integer; const value : Double);
var
   p : PVarData;
begin
   p:=@FData[FAddr+addr];
   if p^.VType=varDouble then
      p^.VDouble:=value
   else PVariant(p)^:=value;
end;

// GetAsBoolean
//
function TDataContext.GetAsBoolean(addr : Integer) : Boolean;
var
   p : PVarData;
begin
   p:=@FData[FAddr+addr];
   if p^.VType=varBoolean then
      Result:=p^.VBoolean
   else Result:=PVariant(p)^;
end;

// SetAsBoolean
//
procedure TDataContext.SetAsBoolean(addr : Integer; const value : Boolean);
var
   p : PVarData;
begin
   p:=@FData[FAddr+addr];
   if p^.VType=varBoolean then
      p^.VBoolean:=value
   else PVariant(p)^:=value;
end;

// GetAsString
//
function TDataContext.GetAsString(addr : Integer) : UnicodeString;
begin
   EvalAsString(addr, Result);
end;

// SetAsString
//
procedure TDataContext.SetAsString(addr : Integer; const value : UnicodeString);
var
   p : PVarData;
begin
   p:=@FData[FAddr+addr];
   {$ifdef FPC}
   if p.VType=varString then
      UnicodeString(p.VString):=value
   {$else}
   if p.VType=varUString then
      UnicodeString(p.VUString):=value
   {$endif}
   else PVariant(p)^:=value;
end;

// GetAsInterface
//
function TDataContext.GetAsInterface(addr : Integer) : IUnknown;
var
   p : PVarData;
begin
   p:=@FData[FAddr+addr];
   if p^.VType=varUnknown then
      Result:=IUnknown(p^.VUnknown)
   else Result:=PVariant(p)^;
end;

// SetAsInterface
//
procedure TDataContext.SetAsInterface(addr : Integer; const value : IUnknown);
var
   p : PVarData;
begin
   p:=@FData[FAddr+addr];
   if p^.VType=varUnknown then
      IUnknown(p^.VUnknown):=value
   else PVariant(p)^:=value;
end;

// AsPVarDataArray
//
function TDataContext.AsPVarDataArray : PVarDataArray;
begin
   Result:=@FData[FAddr];
end;

// AsPData
//
function TDataContext.AsPData : PData;
begin
   Result:=@FData;
end;

// AsData
//
function TDataContext.AsData : TData;
begin
   Result:=FData;
end;

// AsPVariant
//
function TDataContext.AsPVariant(addr : Integer) : PVariant;
begin
   Result:=@FData[FAddr+addr];
end;

// Addr
//
function TDataContext.Addr : Integer;
begin
   Result:=FAddr;
end;

// DataLength
//
function TDataContext.DataLength : Integer;
begin
   Result:=System.Length(FData);
end;

// Offset
//
procedure TDataContext.Offset(delta : Integer);
begin
   Inc(FAddr, delta);
end;

// CreateOffset
//
procedure TDataContext.CreateOffset(offset : Integer; var result : IDataContext);

   function CreateData(context : TDataContext; addr : Integer) : TDataContext;
   begin
      Result:=TDataContext.Create;
      Result.FData:=context.FData;
      Result.FAddr:=addr;
   end;

begin
   if FPool<>nil then
      Result:=FPool.CreateOffset(offset, Self)
   else Result:=CreateData(Self, FAddr+offset);
end;

// EvalAsVariant
//
procedure TDataContext.EvalAsVariant(addr : Integer; var result : Variant);
begin
   VarCopySafe(result, FData[FAddr+addr]);
end;

// EvalAsString
//
procedure TDataContext.EvalAsString(addr : Integer; var result : UnicodeString);
var
   p : PVarData;
begin
   p:=@FData[FAddr+addr];
   if p.VType=varUString then
      result:=UnicodeString(p.VString)
   else result:=PVariant(p)^;
end;

// EvalAsInterface
//
procedure TDataContext.EvalAsInterface(addr : Integer; var result : IUnknown);
var
   p : PVarData;
begin
   p:=@FData[FAddr+addr];
   if p^.VType=varUnknown then
      result:=IUnknown(p^.VUnknown)
   else result:=PVariant(p)^;
end;

// CopyData
//
procedure TDataContext.CopyData(const destData : TData; destAddr, size : Integer);
begin
   DWSCopyData(FData, FAddr, destData, destAddr, size);
end;

// WriteData
//
procedure TDataContext.WriteData(const src : IDataContext; size : Integer);
var
   implem : TDataContext;
begin
   implem:=TDataContext(src.GetSelf);
   DWSCopyData(implem.FData, implem.FAddr, FData, FAddr, size);
end;

// WriteData
//
procedure TDataContext.WriteData(const srcData : TData; srcAddr, size : Integer);
begin
   DWSCopyData(srcData, srcAddr, FData, FAddr, size);
end;

// SameData
//
function TDataContext.SameData(addr : Integer; const otherData : TData; otherAddr, size : Integer) : Boolean;
begin
   Result:=DWSSameData(FData, otherData, FAddr+addr, otherAddr, size);
end;

// ReplaceData
//
procedure TDataContext.ReplaceData(const newData : TData);
begin
   FData:=newData;
end;

// ClearData
//
procedure TDataContext.ClearData;
begin
   FData:=nil;
   FAddr:=0;
end;

// SetDataLength
//
procedure TDataContext.SetDataLength(n : Integer);
begin
   SetLength(FData, n);
end;

end.
