unit RequestsDataModuleUnit;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB, System.JSON,
  MainDataModuleUnit;

type
  TRequestsDataModule = class(TDataModule)
    function GetRequests: TJSONArray;
    function CreateRequest(JSONData: TJSONObject): Boolean;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  RequestsDataModule: TRequestsDataModule;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

function TRequestsDataModule.GetRequests: TJSONArray;
var
  DBQuery: TADOQuery;
  QueryString: string;
  JSONData: TJSONArray;
  JSONObject: TJSONObject;
begin
  QueryString := 'SELECT * from requests';
  DBQuery := MainDataModule.CreateDbQuery;
  DBQuery.SQL.Text := QueryString;
  DBQuery.Open;

  JSONData := TJSONArray.Create;

  while not DBQuery.Eof do
  begin
    JSONObject := TJSONObject.Create;
    JSONObject.AddPair('id', DBQuery.FieldByName('id').AsInteger);
    JSONObject.AddPair('number', DBQuery.FieldByName('number').AsString);
    JSONObject.AddPair('date', DBQuery.FieldByName('date').AsString);

    JSONData.Add(JSONObject);
    DBQuery.Next;
  end;
  Result := JSONData;
end;

function TRequestsDataModule.CreateRequest(JSONData: TJSONObject): Boolean;
var
  DBQuery: TADOQuery;
begin
  DBQuery := MainDataModule.CreateDbQuery;
  Result := False;
end;

end.
