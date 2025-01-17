create database APItokenExpiry
use APItokenExpiry
CREATE TABLE ApiTokensEXP (
    ServerName NVARCHAR(100) NOT NULL,     -- The name of the server where the token is used
    ClientID NVARCHAR(200) NOT NULL,       -- The unique identifier for the client
    ValidFrom DATETIME ,           -- The start date and time when the token is valid (in UTC)
    ValidTo DATETIME ,             -- The expiration date and time for the token (in UTC)

    CONSTRAINT PK_ApiTokensEXP PRIMARY KEY (ServerName, ClientID)  -- Ensure uniqueness for each ServerName and ClientID pair
);

BULK INSERT ApiTokensEXP
FROM 'D:\temp\APIcomma.csv'
WITH
(
        FORMAT='CSV',
        FIRSTROW=2
)
GO

select * from ApiTokensEXP 