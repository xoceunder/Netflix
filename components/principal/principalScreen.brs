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

  if m.collapsedMenu.itemSelected=1
  
	  m.loadingIndicator.SetFocus(TRUE)
	  m.loadingIndicator.control="start"
	  m.loadingindicator.opacity=1
      m.requestApiTask.FunctionName="GetDataMovies"
	  m.requestApiTask.observefield("content","onContentReady")
	  m.requestApiTask.control="RUN"

		
  end if
  
end sub

sub onFocus(event)
	itemFocused=event.getData()
    movie = m.RowList.content.getChild(itemFocused[0]).getChild(itemFocused[1])
    if invalid <> movie
        if invalid <> movie.title then m.backdrop.title = movie.title
        if invalid <> movie.releaseDate then m.backdrop.releaseDate = movie.releaseDate
        if invalid <> movie.rating then m.backdrop.scoreText = movie.rating + "/10"
        if invalid <> movie.description then m.backdrop.description = movie.description
        if invalid <> movie.HDPosterURL then  m.backdrop.imageUri = movie.HDPosterURL
    end if
end sub

sub onSelection(event)
	itemFocused=event.getData()
    movie = m.RowList.content.getChild(itemFocused[0]).getChild(itemFocused[1])
	
end sub

sub onContentReady()
    content = m.requestApiTask.content
	m.collapsedMenu.callFunc("collapseMenu")
	m.loadingIndicator.control="stop"
	m.loadingIndicator.opacity=0
	m.RowList.content=content
    m.RowList.setFocus(true)
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    handled = false
    if press then
        if key = "left" and not m.collapsedMenu.hasFocus() then
            m.collapsedMenu.callFunc("expandMenu")
			m.RowList.setFocus(false)
            handled = true
        else if key = "right" and not m.RowList.isInFocusChain() then
            m.collapsedMenu.callFunc("collapseMenu")
            m.RowList.setFocus(true)
            handled = true
        else if key = "back" and m.RowList.isInFocusChain() then
            m.collapsedMenu.callFunc("expandMenu")
			m.RowList.setFocus(false)
            handled = true
        end if
    end if
    return handled
end function