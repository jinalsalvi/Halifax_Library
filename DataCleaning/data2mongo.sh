#!/bin/bash

# reads each ".txt" file in the given folder, where the 1st line of 
# each file is the title; for each file, it makes a json object with 
# three fields: "file_name", "title", "content", where it replaces 
# any double quotes and \n's in the title/content with spaces

if [ $# -ne 3 ]
then
    printf "\nUsage: \n\$ $0 <database> <user> <pass> \n\n"
    exit 1
fi

coll="dummy";
db="$1";
user="$2";
pass="$3";


mongo -u "$user" -p "$pass" "$db" --eval "db.$coll.drop()"

mongo -u "$user" -p "$pass" "$db" --eval "db.author.drop()"

mongo -u "$user" -p "$pass" "$db" --eval "db.article.drop()"

mongoimport -u "$user" -p "$pass" -d "$db" -c "$coll" --file "articles.json"

mysql -u "$user" --password="$pass" -D "$db" < 'existing_tables.sql'

mysql -u "$user" --password="$pass" -D "$db" < 'new_tables.sql'

mysql -u "$user" --password="$pass" -D "$db" < 'get_author.sql' > 'mongo_author_insert.txt'

mysql -u "$user" --password="$pass" -D "$db" -e "SET FOREIGN_KEY_CHECKS = 0;TRUNCATE TABLE AUTHOR;SET FOREIGN_KEY_CHECKS = 1;"

mongo "$db" -u "$user" -p "$pass" < 'mongo_author_insert.txt'

python ./create_article.py $user $pass $db 

