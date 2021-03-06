{*******************************************************}
{                                                       }
{         基于HCView的电子病历程序  作者：荆通          }
{                                                       }
{ 此代码仅做学习交流使用，不可用于商业目的，由此引发的  }
{ 后果请使用者承担，加入QQ群 649023932 来获取更多的技术 }
{ 交流。                                                }
{                                                       }
{*******************************************************}

unit EmrGroupItem;

interface

uses
  Windows, Classes, Graphics, SysUtils, HCStyle, HCCommon, HCItem, HCRectItem;

type
  TDeGroup = class(THCDomainItem)
  private
    FPropertys: TStrings;
  protected
    procedure Assign(Source: THCCustomItem); override;
    procedure SaveToStream(const AStream: TStream; const AStart, AEnd: Integer); override;
    procedure LoadFromStream(const AStream: TStream; const AStyle: THCStyle;
      const AFileVersion: Word); override;
    //
    function GetValue(const Name: string): string;
    procedure SetValue(const Name, Value: string);
  public
    constructor Create; override;
    destructor Destroy; override;
    property Propertys: TStrings read FPropertys;
    property Values[const Name: string]: string read GetValue write SetValue; default;
  end;

implementation

{ TDeGroup }

procedure TDeGroup.Assign(Source: THCCustomItem);
begin
  inherited Assign(Source);
  Self.FPropertys.Assign((Source as TDeGroup).Propertys);
end;

constructor TDeGroup.Create;
begin
  inherited Create;
  FPropertys := TStringList.Create;
end;

destructor TDeGroup.Destroy;
begin
  if FPropertys <> nil then
    FPropertys.Free;
  inherited Destroy;
end;

function TDeGroup.GetValue(const Name: string): string;
begin
  if FPropertys <> nil then
    Result := FPropertys.Values[Name]
  else
    Result := '';
end;

procedure TDeGroup.LoadFromStream(const AStream: TStream;
  const AStyle: THCStyle; const AFileVersion: Word);
var
  vSize: Word;
  vBuffer: TBytes;
begin
  inherited LoadFromStream(AStream, AStyle, AFileVersion);
  AStream.ReadBuffer(vSize, SizeOf(vSize));
  if vSize > 0 then
  begin
    SetLength(vBuffer, vSize);
    AStream.Read(vBuffer[0], vSize);
    Propertys.Text := StringOf(vBuffer);
  end;
end;

procedure TDeGroup.SaveToStream(const AStream: TStream; const AStart, AEnd: Integer);
var
  vBuffer: TBytes;
  vSize: Word;
begin
  inherited SaveToStream(AStream, AStart, AEnd);;
  if FPropertys <> nil then
  begin
    vBuffer := BytesOf(FPropertys.Text);
    vSize := System.Length(vBuffer);
  end
  else
    vSize := 0;
  AStream.WriteBuffer(vSize, SizeOf(vSize));
  if vSize > 0 then
    AStream.WriteBuffer(vBuffer[0], vSize);
end;

procedure TDeGroup.SetValue(const Name, Value: string);
begin
  if FPropertys = nil then
    FPropertys := TStringList.Create;
  FPropertys.Values[Name] := Value;
end;

end.
