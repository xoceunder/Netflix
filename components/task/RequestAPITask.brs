Function init()
    m.app = App()
End Function

Function GetDataMovies()

	categoryList = getCategoryList("movies")
	content=[]
	CategoryNames=[]
	numofcategories=categoryList.Count()-1
	For c=0 To numofcategories
		CategoryNames.Push(categoryList[c].title)
		items = getMoviesByCategory(categoryList[c].id,"movies")
		temparray=[]
		if items <> invalid
		  For x=0 To items.Count()-1
			itemAA=items[x]
		   	item={}
		    item=itemAA
			temparray.Push(item)
		  Next
		end if
		content.Push(temparray)
	Next
	
	RowItems=createObject("RoSGNode","ContentNode")
	
	For x=0 To CategoryNames.Count()-1
		row=createObject("RoSGNode","ContentNode")
		row.Title=CategoryNames[x]
		if content[x] <> invalid
		For Each itemAA In content[x]
		    'print itemAA
			item=createObject("RoSGNode","ContentNode")
			item.Title=itemAA.Title
			item.ContentType=itemAA.ContentType
			item.ContentId=itemAA.MoviesId
			item.Id=itemAA.MoviesId
			item.description=itemAA.description
			item.url=itemAA.StreamUrls
			item.Rating=itemAA.Rating
			item.SubtitleUrl=itemAA.SubtitleUrl
			item.Length=itemAA.Length
			item.streamFormat=itemAA.StreamFormat
			item.releasedate=itemAA.ReleaseDate
			item.SDPosterUrl=itemaa.SDPosterUrl
			item.HDPosterURL=itemaa.HDPosterURL
			row.AppendChild(item) 'Add each individual item
		Next
		end if
		RowItems.AppendChild(row) 'Add each individual category of items
	Next
	m.top.content=RowItems 'set top content field to the entire screen's content which will cause the content observer to notice
End Function

Function getCategoryList(tipo) as object
    url = m.app.api.base_url + "api2.php?cmd=category&type="+tipo
	readInternet=createObject("roUrlTransfer")
	readInternet.setUrl(url)
	source=readInternet.GetToString()
	responseJSON = ParseJSON(source)
    if responseJSON <> invalid then
      return responseJSON.content
    else
      return []
    end if
End Function

Function getMoviesByCategory(category,tipo) as object
    url = m.app.api.base_url + "api2.php?cmd=content&type="+tipo+"&category="+category
	readInternet=createObject("roUrlTransfer")
	readInternet.setUrl(url)
	source=readInternet.GetToString()
	responseJSON = ParseJSON(source)
    if responseJSON <> invalid then
      return responseJSON.content
    else
      return []
    end if
End Function