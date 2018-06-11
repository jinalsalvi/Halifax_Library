select CONCAT('db.author.insert({ aid: ',_id,',name:"',LOWER(fname),' ',LOWER(lname),'",','email:"',email,'"})') as line from AUTHOR;
