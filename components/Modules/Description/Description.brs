' ********** Copyright 2016 Roku Corp.  All Rights Reserved. **********
'setting top interfaces

Sub Init()
	m.top.Title=m.top.findNode("Title")
	m.top.Description=m.top.findNode("Description")
	m.top.ReleaseDate=m.top.findNode("ReleaseDate")
End Sub

' Content change handler
' All fields population
Sub OnContentChanged()
	item=m.top.content
	
	title=item.title.toStr()
	If title<>invalid
		m.top.Title.text=title.toStr()
	End If
	
	value=item.description
	If value<>invalid
		If value.toStr()<>""
			m.top.Description.text=value.toStr()
		Else
			m.top.Description.text="No description"
		End If
	End If
	
	value=item.ReleaseDate
	If value<>invalid
		If value<>""
			m.top.ReleaseDate.text=value.toStr()
		Else
			m.top.ReleaseDate.text="No release date"
		End If
	End If
End Sub
