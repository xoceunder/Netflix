' ********** Copyright 2016 Roku Corp.  All Rights Reserved. **********
'inits details screen
'sets all observers
'configures buttons for Details screen

Function Init()
	Print"[DetailsScreen] init"
	
	m.top.observeField("visible","onVisibleChange")
	m.top.observeField("focusedChild","OnFocusedChildChange")
	
	m.buttons=m.top.findNode("Buttons")
	m.videoPlayer=m.top.findNode("VideoPlayer")
	m.poster=m.top.findNode("Poster")
	m.description=m.top.findNode("Description")
	m.background=m.top.findNode("Background")
	
	'create buttons
	result=[]
	For Each button In ["Play","Second button"]
		result.Push({title:button})
	Next
	m.buttons.content=ContentList2SimpleNode(result)
End Function

'set proper focus to buttons if Details opened and stops Video if Details closed
Sub onVisibleChange()
	Print"[DetailsScreen] onVisibleChange"
	If m.top.visible=TRUE
		m.buttons.jumpToItem=0
		m.buttons.setFocus(TRUE)
	Else
		m.videoPlayer.visible=FALSE
		m.videoPlayer.control="stop"
		m.poster.uri=""
		m.background.uri=""
	End If
End Sub

'set proper focus to Buttons in case if return from Video Player
Sub OnFocusedChildChange()
	If m.top.isInFocusChain() And Not m.buttons.hasFocus() And Not m.videoPlayer.hasFocus()
		m.buttons.setFocus(TRUE)
	End If
End Sub

'set proper focus on buttons and stops video if return from Playback to details
Sub onVideoVisibleChange()
	If m.videoPlayer.visible=FALSE And m.top.visible=TRUE
		m.buttons.setFocus(TRUE)
		m.videoPlayer.control="stop"
	End If
End Sub

'event handler of Video player msg
Sub OnVideoPlayerStateChange()
	If m.videoPlayer.state="error"
		'error handling
		m.videoPlayer.visible=FALSE
	Else If m.videoPlayer.state="playing"
		'playback handling
	Else If m.videoPlayer.state="finished"
		m.videoPlayer.visible=FALSE
	End If
End Sub

'on Button press handler
Sub onItemSelected()
	'first button is Play
	If m.top.itemSelected=0
		m.videoPlayer.visible=TRUE
		m.videoPlayer.setFocus(TRUE)
		m.videoPlayer.control="play"
		m.videoPlayer.observeField("state","OnVideoPlayerStateChange")
	End If
End Sub

'Content change handler
Sub OnContentChange()
	m.description.content=m.top.content
	m.description.Description.width="770"
	m.videoPlayer.content=m.top.content
	'm.top.streamUrl=m.top.content.url
	m.poster.uri=m.top.content.hdBackgroundImageUrl
	m.background.uri=m.top.content.hdBackgroundImageUrl
End Sub

'///////////////////////////////////////////'
' Helper function convert AA to Node
Function ContentList2SimpleNode(contentList As Object,nodeType="ContentNode" As String) As Object
	result=createObject("roSGNode",nodeType)
	If result<>invalid
		For Each itemAA In contentList
			item=createObject("roSGNode",nodeType)
			item.setFields(itemAA)
			result.appendChild(item)
		Next
	End If
	Return result
End Function
