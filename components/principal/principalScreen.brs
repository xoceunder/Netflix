sub init()
    m.app = App()
	
    m.collapsedMenu = m.top.findNode("collapsedMenu")
	m.collapsedMenu.observeField("itemSelected", "MenuSelection")
	
    m.RowList  =  m.top.findNode("RowList")
    m.RowList.observeField("rowItemSelected","onSelection")
    m.RowList.observeField("rowItemFocused","onFocus")
	
	m.backdrop =  m.top.findNode("backdrop")
	
	'loading indicator starts at initializatio of channel
	m.loadingIndicator=m.top.findNode("loadingIndicator")
	m.loadingIndicator.opacity=0
	
	m.requestApiTask = createObject("roSGNode", "RequestAPITask")
	
	
end sub

' Append child corresponding to the selected menu item
sub MenuSelection()

  Print m.collapsedMenu.itemSelected
  if m.collapsedMenu.itemSelected=5
	m.loadingIndicator.SetFocus(TRUE)
	m.loadingIndicator.control="start"
	m.loadingindicator.opacity=1
    m.requestApiTask.FunctionName="GetDataMovies"
	m.requestApiTask.observefield("content","onContentReady")
	m.requestApiTask.control="RUN"
		
  end if
  
end sub

sub onFocus(event)
    movie = findMovieDetails(event.getData())
    if invalid <> movie
        if invalid <> movie.title then m.backdrop.title = movie.title
        if invalid <> movie.releaseDate then m.backdrop.releaseDate = movie.releaseDate
        if invalid <> movie.rating then m.backdrop.scoreText = movie.rating + "/10"
        if invalid <> movie.description then m.backdrop.description = movie.description
        if invalid <> movie.SDPosterURL then  m.backdrop.imageUri = movie.SDPosterURL
    end if
end sub

sub onSelection(event)
    movie = findMovieDetails(event.getData())
end sub

function findMovieDetails(coords)
    movie = invalid
    if invalid <> coords and invalid <> coords[0] and invalid <> coords[1]
        if invalid <> m.RowList and invalid <> m.RowList.content then row = m.RowList.content.getChildren(-1,0)
        if invalid <> row then movies = row[coords[0]].getChildren(-1,0)
        if invalid <> movies then movie = movies[coords[1]]
    end if
    return movie
end function

sub onContentReady()
    content = m.requestApiTask.content
	m.collapsedMenu.callFunc("collapseMenu")
	m.loadingIndicator.control="stop"
	m.loadingIndicator.opacity=0
    m.RowList.setFocus(true)
	m.RowList.content=content
    'm.backdrop.visible = true
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    handled = false
    if press then
        if key = "left" and not m.collapsedMenu.hasFocus() then
            m.collapsedMenu.callFunc("expandMenu")
			m.RowList.setFocus(false)
            handled = true
        else if key = "right" and not m.RowList.hasFocus() then
            m.collapsedMenu.callFunc("collapseMenu")
            m.RowList.setFocus(true)
            handled = true
        end if
    end if

    return handled
end function