import numpy as np  
import pandas as pd 
import sys
from pymongo import MongoClient  


connectionStr = 'mongodb://'+sys.argv[1]+':'+sys.argv[2]+'@localhost:27017/'+sys.argv[1]
client = MongoClient(connectionStr)
print "Process Start."
db = client[sys.argv[3]]
cursor = db.article.find()	
cursorAuthor = db.author.find()

dfa = np.asarray(list(cursor))  
dfat = np.asarray(list(cursorAuthor))  

magazine_dir = "magazine.csv"
magazineCsv = open(magazine_dir , "w") 

volume_dir = "volume.csv"  
volumeCsv = open(volume_dir , "w") 

article_dir = "article.csv" 
articleCsv = open(article_dir , "w")

author_dir = "author.csv"  
authorCsv = open(author_dir , "w") 

aamap_dir = "aamap.csv"  
aamapCsv = open(aamap_dir , "w") 

magazineDic= {}
volumeDic = {}

magazineCounter=4;
volumeCounter=1;
articleCounter=1;

def rindex1(iterable, value):
	try:
		return len(iterable) - next(i for i, val in enumerate(reversed(iterable)) if val == value) - 1
	except StopIteration:
		return len(iterable)

for document in dfa:
	mname = document['magazine_name'][0:49]
	vid = ''
	mid = ''
	aid = ''

	if mname in magazineDic:
		mid = magazineDic[mname]
		
	else:
		mid = magazineCounter
		magazineDic[mname] = mid
		magazineCsv.write(str(mid)+','+mname.encode('ascii','ignore').replace(","," ")+'\n')
		magazineCounter += 1
	
	vnum = document['volume_number']
	uvnum = mname + ' ' +document['volume_number']+' ' +document['volume_year']

	if uvnum in volumeDic:
		vid = volumeDic[uvnum]		
	else:
		vid = volumeCounter
		volumeDic[uvnum] = vid
		volumeCsv.write(str(mid)+','+str(vid)+','+document['volume_year']+','+vnum+'\n')
		volumeCounter += 1
	
	aid = str(articleCounter)
	try:
		articleCsv.write(str(aid)+','+  document['article_title'].encode('ascii','ignore').replace(","," ")+','+document['article_pages'].replace(",",";")+','+str(vid)+'\n')
	except:
		print document['article_title'].encode('ascii','ignore').replace(","," ")
	articleCounter+=1;
	
	try:
		if type(document['author']) == list:
			for au in document['author']:
				aamapCsv.write(str(aid)+','+str(au)+'\n')
		else:
			aamapCsv.write(str(aid)+','+str(au)+'\n')
	except:
		a=1
   
for adoc in dfat:
	fullname = adoc['name']
	email = adoc['email']
	try:
		firstname = fullname[0:rindex1(fullname ,' ')]
		lastname = fullname[rindex1(fullname ,' ')+1:]
		if email == '':
			email = firstname.replace(".","").replace(" ","")+'.'+lastname.replace(".","").replace(" ","")+"@smu.ca"
	except:
		firstname = fullname
		lastname = ''	
		if email == '':
			email = firstname.replace(".","").replace(" ","")+'.'+lastname.replace(".","").replace(" ","")+"@smu.ca"
		email = firstname.replace(".","").replace(" ","")+'.'+lastname.replace(".","").replace(" ","")+"@smu.ca"
	authorCsv.write(str(adoc['aid'])+','+lastname.encode('ascii','ignore').capitalize()+','+firstname.encode('ascii','ignore').capitalize()+','+email.encode('ascii','ignore')+'\n')
print("complete.")

