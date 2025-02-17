program Project1;
{$APPTYPE GUI}

uses
  Vcl.Forms,
  Web.WebReq,
  IdHTTPWebBrokerBridge,
  FormUnit in 'FormUnit.pas' {MainForm},
  WebModuleUnit in 'WebModuleUnit.pas' {MainWebModule: TWebModule},
  MainDataModuleUnit in 'MainDataModuleUnit.pas' {MainDataModule: TDataModule},
  RequestsDataModuleUnit in 'RequestsDataModuleUnit.pas' {DataModule1: TDataModule},
  CustomersDataModuleUnit in 'CustomersDataModuleUnit.pas' {DataModule2: TDataModule};

{$R *.res}

begin
  if WebRequestHandler <> nil then
    WebRequestHandler.WebModuleClass := WebModuleClass;
  Application.Initialize;
  Application.CreateForm(TMainDataModule, MainDataModule);
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
