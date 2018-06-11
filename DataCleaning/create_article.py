import pymongo
import six
import json
import sys
from pymongo import MongoClient


connectionStr = 'mongodb://'+sys.argv[1]+':'+sys.argv[2]+'@localhost:27017/'+sys.argv[1]


client = MongoClient(connectionStr)

db = client[sys.argv[3]]

cursor = db.dummy.find()
existingAuthor = db.author.find()

print "Cleaning JSON object and creating new mongo collection."

articlefinal = []
authorfinal = []
articleObject = {}
authorObject = {}
authorList = []
authorIDList = []

author = {}

cursorAuthorCount = db.author.count()

counterTotal = 0

counter = 0

authorCounter = 1 
#+ cursorAuthorCount ;

authorNewDisc = {}

authorNewDisc[0] = ''

authorList = 	[]

for aa in existingAuthor: 
	author = {}
	author['name'] = aa['name'].lower()
	author['aid'] = aa['_id']
	authorNewDisc[authorCounter] = author
	authorCounter +=1
	
for document in cursor: 
	counterTotal += 1
	#print(counterTotal)
	authorList = 	[]
	authorIDList = []
	
	
	articleObject = {}
	authorObject = {}
	
	articleObject['key'] = counterTotal
	authorObject['key'] =counterTotal
	
	try:
		articleObject['magazine_name'] =  document['journal']['ftext'].replace("'"," \\'")
	except(KeyError):
		articleObject['magazine_name'] = (document['booktitle']['ftext'].replace("'"," \\'") )
		counter += 1
	except:
		print("Oops!", sys.exc_info()[0],"occured.")

	try:
		articleObject['volume_number']= document['volume']['ftext'].replace("'"," \\'")
		articleObject['volume_year'] = document['year']['ftext'].replace("'"," \\'")
	except(KeyError):
		counter += 1
	except:
		print("Oops!", sys.exc_info()[0],"occured.")
	
	articleObject['article_title']  = '';
	
	try:
		
		try:
			articleObject['article_title'] = document['title']['ftext'].replace("'"," \\'")
		except:
			a=1
		
		try:
			if type(document['title']['i']) == list:
				for tit in document['title']['i']:
					try:
						try:
							articleObject['article_title'] = articleObject['article_title'] +" " + tit['ftext']
						except:
							a = 1
						try:
							articleObject['article_title'] = articleObject['article_title'] +" " + tit['ftail']
						except:
							a = 1
					except:
						a= 1
			elif type(document['title']['i']) == dict:
				try:
					try:
						articleObject['article_title'] = articleObject['article_title'] +" " + document['title']['i']['ftext']		
					except:
						a = 1
						
					try:
						articleObject['article_title'] = articleObject['article_title'] +" " + document['title']['i']['ftail']		
					except:
						a = 1
						
				except:
					a= 1
			elif type(document['title']['i']) == str:
					try:
						articleObject['article_title'] = articleObject['article_title'] +" " + document['title']['i']	
					except:	
						a = 1
											
				
		except:
			a=1
		



		try:
			if type(document['title']['sub']) == list:
				for tit in document['title']['sub']:
					try:
						try:
							articleObject['article_title'] = articleObject['article_title'] +" " + tit['ftext']
						except:
							a = 1;
						try:
							articleObject['article_title'] = articleObject['article_title'] +" " + tit['ftail']
						except:
							a = 1;
					except:
						a= 1
			elif type(document['title']['sub']) == dict:
				try:
					try:
						articleObject['article_title'] = articleObject['article_title']+" " + document['title']['sub']['ftext']		
					except:
						a = 1;
				
					try:
						articleObject['article_title'] = articleObject['article_title'] +" " + document['title']['sub']['ftail']
					except:
						a = 1;
						
				except:
					a= 1
			elif type(document['title']['sub']) == str:
					articleObject['article_title'] = articleObject['article_title'] +" " + document['title']['sub']		
				
		except:
			a=1
		




		try:
			if type(document['title']['sup']) == list:
				for tit in document['title']['sub']:
					try:
						try:
							articleObject['article_title'] = articleObject['article_title'] +" " + tit['ftext']
						except:
							a = 1;
						try:
							articleObject['article_title'] = articleObject['article_title'] +" " + tit['ftail']
						except:
							a = 1;
						
					except:
						a= 1
			elif type(document['title']['sup']) == dict:
				try:
					try:
						articleObject['article_title'] = articleObject['article_title']+" " + document['title']['sup']['ftext']
					except:
						a = 1;
					
					try:
						articleObject['article_title'] = articleObject['article_title'] +" " + document['title']['sup']['ftail']	
					except:
						a = 1;
					
				except:
					a= 1
			elif type(document['title']['sup']) == str:
					articleObject['article_title'] = articleObject['article_title'] +" " + document['title']['sup']		
				
		except:
			a=1
		
		
		articleObject['article_title'] = articleObject['article_title'].replace("'"," \\'").replace("\n","").replace('"','')
		
		counter += 1
	except:
		print("Oops!", sys.exc_info()[0],"occured.")
	
	
	try:
		articleObject['article_pages'] = document['pages']['ftext'].replace("'"," \\'")
	except(KeyError):
		counter += 1
		articleObject['article_pages'] = ''
	except:
		print("Oops!", sys.exc_info()[0],"occured.")
	
	
		
	try:
		if type(document['author']) == list:
			for au in document['author']:
				author = {}
				fullname = au['ftext'].replace("'"," \\'").lower()
				if fullname != '':
					if fullname in authorNewDisc:
						id = authorNewDisc[fullname]
						author['aid'] = id
						author['name'] = fullname
						author['email'] = ''
					else:
						id = authorCounter
						authorNewDisc[fullname] = id
						author['aid'] = id
						author['name'] = fullname
						author['email'] = ''
						authorfinal.append(author)
						authorCounter += 1
						
					authorIDList.append(id)
					
				
		else:
			author = {}
			fullname = document['author']['ftext'].replace("'"," \\'").lower()
			if fullname != '':
				if fullname in authorNewDisc:
					id = authorNewDisc[fullname]
					author['aid'] = id
					author['name'] = fullname
					author['email'] = ''
				else:
					id = authorCounter
					authorCounter += 1
					author['aid'] = id
					author['name'] = fullname
					author['email'] = ''
					authorNewDisc[fullname] = id
					authorfinal.append(author)
				authorIDList.append(id)
				
			
		articleObject['author'] = authorIDList
	except:
		try:
			if type(document['editor']) == list:
				for au in document['editor']:
					author = {}
					fullname = au['ftext'].replace("'"," \\'").lower()
					if fullname != '':
						if fullname in authorNewDisc:
							id = authorNewDisc[fullname]
							author['aid'] = id
							author['name'] = fullname
							author['email'] = ''
						else:
							id = authorCounter
							authorNewDisc[fullname] = id
							author['aid'] = id
							author['name'] = fullname
							author['email'] = ''
							authorfinal.append(author)
							authorCounter += 1
							
						authorIDList.append(id)
						
					
			else:
				author = {}
				fullname = document['editor']['ftext'].replace("'"," \\'").lower()
				if fullname != '':
					if fullname in authorNewDisc:
						id = authorNewDisc[fullname]
						author['aid'] = id
						author['name'] = fullname
						author['email'] = ''
					else:
						id = authorCounter
						authorCounter += 1
						author['aid'] = id
						author['name'] = fullname
						author['email'] = ''
						authorNewDisc[fullname] = id
						authorfinal.append(author)
					authorIDList.append(id)
					
				
			articleObject['author'] = authorIDList
		
		except:
			a=1
		
	articlefinal.append (articleObject)

db.article.insert(articlefinal)
db.author.insert(authorfinal)
print("complete.")
	