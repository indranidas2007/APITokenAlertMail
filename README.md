# APITokenAlertMail
APIcomma.csv contains sample API details from multiple servers.
APItoken script.sql contains table creation and APIcomma.csv import
NotifyTokenExpiry1.sql contains stored procedure for sending mail alerts for tokens what will expire in a week.
SQL Job to be scheduled on weekly basis with command exec NotifyTokenExpiry1;
