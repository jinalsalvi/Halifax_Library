#!/bin/bash

# reads each ".txt" file in the given folder, where the 1st line of 
# each file is the title; for each file, it makes a json object with 
# three fields: "file_name", "title", "content", where it replaces 
# any double quotes and \n's in the title/content with spaces

if [ $# -ne 3 ]
then
    printf "\nUsage: \n\$ $0 <database> <user> <pass>  \n\n"
    exit 1
fi

coll="dummy";
db="$1";
user="$2";
pass="$3";

python generate_csv.py $user $pass $db 

mysql -u $user --password="$pass" -D "$db" -e "LOAD DATA LOCAL INFILE 'author.csv' INTO TABLE AUTHOR FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'"

mysql -u $user --password="$pass" -D "$db" -e "LOAD DATA LOCAL INFILE 'magazine.csv' INTO TABLE MAGAZINE FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'"

mysql -u $user --password="$pass" -D "$db" -e "LOAD DATA LOCAL INFILE 'volume.csv' INTO TABLE VOLUME FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'"


mysql -u $user --password="$pass" -D "$db" -e "LOAD DATA LOCAL INFILE 'article.csv' INTO TABLE ARTICLE FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'"


mysql -u $user --password="$pass" -D "$db" -e "LOAD DATA LOCAL INFILE 'aamap.csv' INTO TABLE ARTICLE_AUTHOR FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'"

echo "done."
