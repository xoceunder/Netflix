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
    ?event.getData()
end sub

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