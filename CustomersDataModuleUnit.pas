unit CustomersDataModuleUnit;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB, System.JSON,
  MainDataModuleUnit;

type
  TCustomersDataModule = class(TDataModule)
    function GetCustomers: TJSONArray;
    function CreateCustomer(JSONData: TJSONObject): Boolean;
    function ValidateCustomerData(JSONData: TJSONObject; ValidationErrors: TJSONObject): Boolean;
  end;

var
  CustomersDataModule: TCustomersDataModule;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

function TCustomersDataModule.GetCustomers: TJSONArray;
var
  DBQuery: TADOQuery;
  QueryString: string;
  JSONData: TJSONArray;
  JSONObject: TJSONObject;
begin
  QueryString := 'SELECT * from customers';
  DBQuery := MainDataModule.CreateDbQuery;
  DBQuery.SQL.Text := QueryString;
  DBQuery.Open;

  JSONData := TJSONArray.Create;

  while not DBQuery.Eof do
  begin
    JSONObject := TJSONObject.Create;
    JSONObject.AddPair('id', DBQuery.FieldByName('id').AsInteger);
    JSONObject.AddPair('first_name', DBQuery.FieldByName('first_name')
      .AsString);
    JSONObject.AddPair('last_name', DBQuery.FieldByName('last_name').AsString);
    JSONObject.AddPair('address', DBQuery.FieldByName('address').AsString);
    JSONObject.AddPair('phone', DBQuery.FieldByName('phone').AsString);

    JSONData.Add(JSONObject);
    DBQuery.Next;
  end;
  Result := JSONData;
end;

function TCustomersDataModule.CreateCustomer(JSONData: TJSONObject): Boolean;
var
  DBQuery: TADOQuery;
begin
   DBQuery := MainDataModule.CreateDbQuery;
   DBQuery.SQL.Text := 'INSERT INTO customers ' +
   '(first_name, last_name, address, phone)' +
   ' VALUES (:firstName, :lastName, :address, :phone)';
   DBQuery.Parameters.ParamByName('firstName').Value := JSONData.GetValue<string>('first_name');
   DBQuery.Parameters.ParamByName('lastName').Value := JSONData.GetValue<string>('last_name');
   DBQuery.Parameters.ParamByName('address').Value := JSONData.GetValue<string>('address');
   DBQuery.Parameters.ParamByName('phone').Value := JSONData.GetValue<string>('phone');

   try
      DBQuery.ExecSQL;
      Result := True;
   except
     on E: Exception do
     begin
       Writeln(E.Message);
       Result := False;
     end;
   end;
end;

function TCustomersDataModule.ValidateCustomerData(JSONData: TJSONObject; ValidationErrors: TJSONObject): Boolean;
var
  FirstName, LastName, Address, Phone: string;
begin
  Result := True;

  if not JSONData.TryGetValue<string>('first_name', FirstName) or (FirstName.Trim = '') then
  begin
    ValidationErrors.AddPair('first_name', 'First name is required');
    Result := False
  end;

  if not JSONData.TryGetValue<string>('last_name', LastName) or (LastName.Trim = '') then
  begin
    ValidationErrors.AddPair('last_name', 'Last name is required');
    Result := False
  end;

  if not JSONData.TryGetValue<string>('address', Address) or (Address.Trim = '') then
  begin
    ValidationErrors.AddPair('address', 'Address is required');
    Result := False
  end;

  if not JSONData.TryGetValue<string>('phone', Phone) or (Phone.Trim = '') then
  begin
    ValidationErrors.AddPair('phone', 'Phone is required');
    Result := False
  end;

end;

end.
