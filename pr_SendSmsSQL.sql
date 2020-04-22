Alter procedure pr_SendSmsSQL
    @MobileNo varchar(12), 
    @smstext as varchar(300), 
    @sResponse varchar(1000) OUT 
as 
BEGIN 
   Declare @iReq int,@hr int 
   Declare @sUrl as varchar(500) 
   DECLARE @errorSource VARCHAR(8000)
   DECLARE @errorDescription VARCHAR(8000) 

   -- Create Object for XMLHTTP 
   EXEC @hr = sp_OACreate 'Microsoft.XMLHTTP', @iReq OUT 

   print @hr 

   if @hr <> 0 
      Raiserror('sp_OACreate Microsoft.XMLHTTP FAILED!', 16, 1) 

   set @sUrl='https://api.textlocal.in/send/?'

   set @sUrl=REPLACE(@sUrl,'#MobNo#',@MobileNo) 
   set @sUrl=REPLACE(@sUrl,'#Msg#',@smstext) 

   print @sUrl 

   -- sms code start 
   EXEC @hr = sp_OAMethod @iReq, 'Open', NULL, 'GET', @sUrl, true 
   print @hr 

   if @hr <> 0 
      Raiserror('sp_OAMethod Open FAILED!', 16, 1) 

   EXEC @hr = sp_OAMethod @iReq, 'send' 
   select @iReq
   print @hr 

   if @hr <> 0 
   Begin 
       EXEC sp_OAGetErrorInfo @iReq, @errorSource OUTPUT, @errorDescription OUTPUT

       SELECT [Error Source] = @errorSource, [Description] = @errorDescription

       Raiserror('sp_OAMethod Send FAILED!', 16, 1) 
   end 
else 
Begin
    EXEC @hr = sp_OAGetProperty @iReq,'responseText', @sResponse OUT 
    print @hr

    insert into send_log (Id, mobile, sendtext, response, created_date, created_by) 
    values(NEXT VALUE FOR send_log_id_seq, @MobileNo, @smstext, @sResponse, GETDATE(),'System')
end
end