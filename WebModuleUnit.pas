unit WebModuleUnit;

interface

uses
  System.SysUtils, System.Classes, System.JSON, Web.HTTPApp,
  System.Net.URLClient, RequestsDataModuleUnit, CustomersDataModuleUnit;

type
  TMainWebModule = class(TWebModule)
    procedure DefaultHandlerAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure GetRequestsAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure GetCustomersAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure CreateCustomerAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
  private
    procedure MakeJSONResponse(Response: TWebResponse);
    procedure MakeErrorJSONResponse(Response: TWebResponse; Message: string);
    procedure MakeSuccessJSONResponse(Response: TWebResponse; Message: string;
      StatusCode: Integer = 200);
  end;

var
  WebModuleClass: TComponentClass = TMainWebModule;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}

procedure TMainWebModule.DefaultHandlerAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  Response.Content := '<html>' +
    '<head><title>Web Server Application</title></head>' +
    '<body>Web Server Application</body>' + '</html>';
end;

procedure TMainWebModule.GetCustomersAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  MakeJSONResponse(Response);
  Response.Content := CustomersDataModule.GetCustomers().ToString;
end;

procedure TMainWebModule.GetRequestsAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  MakeJSONResponse(Response);
  Response.Content := RequestsDataModule.GetRequests().ToString;
end;

procedure TMainWebModule.CreateCustomerAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  JSONObject: TJSONObject;
  ValidationErrors: TJSONObject;
begin
  JSONObject := TJSONObject.ParseJSONValue(Request.Content) as TJSONObject;
  var content: string := Request.Content;

  if not Assigned(JSONObject) then
  begin
    MakeErrorJSONResponse(Response, 'Invalid JSON data');
    Exit;
  end;
  var FirstName: string;
  var rres: Boolean := JSONObject.TryGetValue<string>('first_name', FirstName);

  ValidationErrors := TJSONObject.Create;
  if not CustomersDataModule.ValidateCustomerData(JSONObject, ValidationErrors)
  then
  begin
    MakeJSONResponse(Response);

    Response.Content := '{"message": "Data is invalid", "errors":' +
      ValidationErrors.ToString + '}';
    Response.StatusCode := 412;
    ValidationErrors.Free;
    Exit;
  end;

  if not CustomersDataModule.CreateCustomer(JSONObject) then
  begin
    MakeErrorJSONResponse(Response, 'Database query failed');
    Exit;
  end;

  MakeSuccessJSONResponse(Response, 'Customer created!');
end;

procedure TMainWebModule.MakeJSONResponse(Response: TWebResponse);
begin
  Response.ContentType := 'application/json;charset=utf-8';
end;

procedure TMainWebModule.MakeErrorJSONResponse(Response: TWebResponse;
  Message: string);
begin
  MakeJSONResponse(Response);
  Response.StatusCode := 400;
  Response.Content := '{"message": "' + Message + '"}';
end;

procedure TMainWebModule.MakeSuccessJSONResponse(Response: TWebResponse;
  Message: string; StatusCode: Integer = 200);
begin
  MakeJSONResponse(Response);
  Response.StatusCode := StatusCode;
  Response.Content := '{"message": "' + Message + '"}';
end;

end.
