$sourcePath = "c:\labfiles\microsoft-mysql-developer-guide\sample-php-app";
$targetPath = "c:\inetpub\wwwroot\contosostore";

# create a new IIS directory
mkdir $targetPath;

# copy the php files
copy-item -Path "$sourcepath/*" "$targetpath" -Recurse

#deploy the database
$username = "root";
$password = "";
$server = "localhost";
$database = "contosostore";

cd "C:\Program Files\MySQL\MySQL Workbench 8.0 CE"

#create the database
.\mysql -h $server -u $username -e "create database $database"

#setup the schema
#.\mysql -h $server -u $username $database -e "source $sourcePath/database/schema.sql"

#add the data
#TODO

#open the website
Start-Process "http://localhost:8080"