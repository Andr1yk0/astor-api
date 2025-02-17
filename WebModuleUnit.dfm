object MainWebModule: TMainWebModule
  Actions = <
    item
      MethodType = mtGet
      Name = 'GetCustomers'
      PathInfo = '/customers'
      OnAction = GetCustomersAction
    end
    item
      MethodType = mtGet
      Name = 'GetRequests'
      PathInfo = '/requests'
      OnAction = GetRequestsAction
    end
    item
      Default = True
      Name = 'DefaultAction'
      PathInfo = '/'
      OnAction = DefaultHandlerAction
    end
    item
      MethodType = mtPost
      Name = 'CreateRequest'
      PathInfo = '/requests'
    end
    item
      MethodType = mtPost
      Name = 'CreateCustomer'
      PathInfo = '/customers'
      OnAction = CreateCustomerAction
    end>
  Height = 230
  Width = 415
end
