$path = "c:\inetpub\wwwroot\01-ClassicDeploy";

# create a new IIS directory
mkdir $path

# copy the php files
copy ./app $path

#deploy the database
$username = "s2admin"
$password = "S2@dmins2@dmin"
$server = "localhost"
$database = "ContosoCoffee"

mysql -h $server -u $username $database < "$path/database/schema.sql"