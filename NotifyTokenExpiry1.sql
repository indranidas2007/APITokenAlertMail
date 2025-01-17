CREATE or alter PROCEDURE NotifyTokenExpiry1
AS
BEGIN
    -- Declare the necessary variables
    DECLARE @Today DATE = GETDATE();
    DECLARE @ExpiryDate DATE;
    DECLARE @ServerName NVARCHAR(255);
    DECLARE @ClientID NVARCHAR(255);
    DECLARE @ValidFrom DATE;
    DECLARE @ValidTo DATE;
    DECLARE @EmailBody NVARCHAR(MAX);
    
    -- Initialize the email body
    SET @EmailBody = 'The following servers have expiring API tokens within the next 7 days and will need to be updated:' + CHAR(13) + CHAR(10);
    
    -- Query for records with expiring tokens (expiring within 7 days)
    DECLARE @Cursor CURSOR;
    
    SET @Cursor = CURSOR FOR
        SELECT ServerName, ClientID, ValidFrom, ValidTo
        FROM ApiTokensEXP
        WHERE ValidTo BETWEEN @Today AND DATEADD(DAY, 7, @Today);
    
    OPEN @Cursor;
    
    FETCH NEXT FROM @Cursor INTO @ServerName, @ClientID, @ValidFrom, @ValidTo;
    
    -- Loop through the records
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Append each record with token details to the email body
        SET @EmailBody = @EmailBody + 
            'Server: ' + @ServerName + CHAR(13) + CHAR(10) + 
            'ClientID: ' + @ClientID + CHAR(13) + CHAR(10) + 
            'Valid From: ' + CAST(@ValidFrom AS NVARCHAR(10)) + CHAR(13) + CHAR(10) +
            'Expiry Date: ' + CAST(@ValidTo AS NVARCHAR(10)) + CHAR(13) + CHAR(10) +
            '---------------------------------' + CHAR(13) + CHAR(10);
        
        FETCH NEXT FROM @Cursor INTO @ServerName, @ClientID, @ValidFrom, @ValidTo;
    END
    
    CLOSE @Cursor;
    DEALLOCATE @Cursor;
    
    -- Send the email if there are records
    IF LEN(@EmailBody) > 0
    BEGIN
      EXEC msdb.dbo.sp_send_dbmail
            @profile_name = 'Process Support', -- Set your mail profile here
            @recipients = 'ProcessSupport@ramco.com', -- Set the email recipient(s)
            @subject = 'API Token Expiry Notification- Local Servers',
            @body = @EmailBody;
    END
    ELSE
    BEGIN
        PRINT 'No tokens are expiring within the next 7 days.';
    END
END;


