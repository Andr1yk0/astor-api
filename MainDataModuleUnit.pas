unit MainDataModuleUnit;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB;

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
begin
  FDBConnection := TADOConnection.Create(Self);
  FDBConnection.ConnectionString := 'Provider=MSOLEDBSQL.1;' +
    'Password=VeryStr0ngP@ssw0rd;' + 'Persist Security Info=True;' +
    'User ID=sa;' + 'Initial Catalog=REQUESTS;' +
    'Data Source=10.211.55.4,1433;' + 'Initial File Name="";' +
    'Trust Server Certificate=True;' + 'Server SPN="";' + 'Authentication="";' +
    'Access Token=""';
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
