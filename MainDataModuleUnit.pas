unit MainDataModuleUnit;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB, IniFiles;

type
  TMainDataModule = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);
    function CreateDbQuery: TADOQuery;
  private
    FDBConnection: TADOConnection;
  public
    property DBConnection: TADOConnection read FDBConnection;
  end;

var
  MainDataModule: TMainDataModule;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}

procedure TMainDataModule.DataModuleCreate(Sender: TObject);
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.create(ExtractFilePath(ParamStr(0)) + '..\..\settings.ini');
  FDBConnection := TADOConnection.Create(Self);
  var conn: string := 'Provider=MSOLEDBSQL.1;'
    + 'User ID=' + IniFile.ReadString('DB', 'User', '') + ';'
    + 'Password=' + IniFile.ReadString('DB', 'Password', '') + ';'
    + 'Initial Catalog=' + IniFile.ReadString('DB', 'Database', '') + ';'
    + 'Data Source=' + IniFile.ReadString('DB', 'Host', '') + ';';

  FDBConnection.ConnectionString := conn;

  FDBConnection.LoginPrompt := False;
  FDBConnection.Connected := True;
end;

function TMainDataModule.CreateDbQuery: TADOQuery;
var
  DBQuery: TADOQuery;
begin
  Result := TADOQuery.Create(nil);
  Result.Connection := DBConnection;
end;

end.
