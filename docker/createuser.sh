mysql -h 127.0.0.1 -P 53306 -u root -pmysqlvotmdnjem <<MYSQL_SCRIPT
GRANT ALL PRIVILEGES ON $1.* TO "$2"@'%' IDENTIFIED BY "$3";
FLUSH PRIVILEGES;
MYSQL_SCRIPT

echo "Username: $2 on $1"
echo "Password: [$3]"
