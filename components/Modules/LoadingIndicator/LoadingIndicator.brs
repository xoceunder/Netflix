Sub Init()
	m.image=m.top.findNode("image")
	m.image.observeField("loadStatus","omImageLoadStatusChange")
	m.text=m.top.findNode("text")
	m.rotationAnimation=m.top.findNode("rotationAnimation")
	m.rotationAnimationInterpolator=m.top.findNode("rotationAnimationInterpolator")
	m.fadeAnimation=m.top.findNode("fadeAnimation")
	m.loadingIndicatorGroup=m.top.findNode("loadingIndicatorGroup")
	m.loadingGroup=m.top.findNode("loadingGroup")
	m.background=m.top.findNode("background")
	
	m.textHeight=0
	m.textPadding=0
	
	'image could've been loaded by this time
	omImageLoadStatusChange()
	
	startAnimation()
End Sub

Sub updateLayout()
	'check for parent node and set observers
	If m.top.getParent()<>invalid
		m.top.getParent().observeField("width","updateLayout")
		m.top.getParent().observeField("height","updateLayout")
	End If
	componentWidth=getComponentWidth()
	componentHeight=getComponentHeight()
	
	m.text.width=componentWidth-m.textPadding*2
	m.background.width=componentWidth
	m.background.height=componentHeight
	
	If m.top.centered
		m.top.translation=[(getParentWidth()-componentWidth)/2,(getParentHeight()-componentHeight)/2]
	End If
	
	loadingGroupWidth=max(m.image.width,m.text.width)
	loadingGroupHeight=m.image.height+m.textHeight
	
	'check whether image and text fit into component,if they don't - downscale image
	If m.imageAspectRatio<>invalid
		loadingGroupAspectRatio=loadingGroupWidth/loadingGroupHeight
		If loadingGroupWidth>componentWidth
			m.image.width=m.image.width-(loadingGroupWidth-componentWidth)
			m.image.height=m.image.width/m.imageAspectRatio
			loadingGroupWidth=max(m.image.width,m.text.width)
			loadingGroupHeight=loadingGroupWidth/loadingGroupAspectRatio
		End If
		If loadingGroupHeight>componentHeight
			m.image.height=m.image.height-(loadingGroupHeight-componentHeight)
			m.image.width=m.image.height*m.imageAspectRatio
			loadingGroupHeight=m.image.height+m.textHeight
			loadingGroupWidth=loadingGroupHeight*loadingGroupAspectRatio
		End If
	End If
	
	m.image.scaleRotateCenter=[m.image.width/2,m.image.height/2]
	
	'position loading group, image and text at the center
	m.loadingGroup.translation=[(componentWidth-loadingGroupWidth)/2,(componentHeight-loadingGroupHeight)/2]
	m.image.translation=[(loadingGroupWidth-m.image.width)/2,0]
	m.text.translation=[0, m.image.height+m.top.spacing]
End Sub

Sub changeRotationDirection()
	If m.top.clockwise
		m.rotationAnimationInterpolator.key=[1,0]
	Else
		m.rotationAnimationInterpolator.key=[0,1]
	End If
End Sub

Sub omImageLoadStatusChange()
	If m.image.loadStatus="ready"
		m.imageAspectRatio=m.image.bitmapWidth/m.image.bitmapHeight
		
		If m.top.imageWidth>0 And m.top.imageHeight<=0
			m.image.height=m.image.width/m.imageAspectRatio
		Else If m.top.imageHeight>0 And m.top.imageWidth<=0
			m.image.width=m.image.height*m.imageAspectRatio
		Else If m.top.imageHeight<=0 And m.top.imageWidth<=0
			m.image.height=m.image.bitmapHeight
			m.image.width=m.image.bitmapWidth
		End If
		updateLayout()
	End If
End Sub

Sub onImageWidthChange()
	If m.top.imageWidth>0
		m.image.width=m.top.imageWidth
		If m.top.imageHeight<=0 And m.imageAspectRatio<>invalid
			m.image.height=m.image.width/m.imageAspectRatio
		End If
		updateLayout()
	End If
End Sub

Sub onImageHeightChange()
	If m.top.imageHeight>0
		m.image.height=m.top.imageHeight
		If m.top.imageWidth<=0 And m.imageAspectRatio<>invalid
			m.image.width=m.image.height*m.imageAspectRatio
		End If
		updateLayout()
	End If
End Sub

Sub onTextChange()
	prevTextHeight=m.textHeight
	If m.top.text=""
		m.textHeight=0
	Else
		m.textHeight=m.text.localBoundingRect().height+m.top.spacing
	End If
	If m.textHeight<>prevTextHeight
		updatelayout()
	End If
End Sub

Sub onBackgroundImageChange()
	If m.top.backgroundUri<>""
		previousBackground=m.background
		m.background=m.top.findNode("backgroundImage")
		m.background.opacity=previousBackground.opacity
		m.background.translation=previousBackground.translation
		m.background.width=previousBackground.width
		m.background.height=previousBackground.height
		m.background.uri=m.top.backgroundUri
		previousBackground.visible=FALSE
	End If
End Sub

Sub onBackgroundOpacityChange()
	If m.background<>invalid
		m.background.opacity=m.top.backgroundOpacity
	End If
End Sub

Sub onTextPaddingChange()
	If m.top.textPadding>0
		m.textPadding=m.top.textPadding
	Else
		m.textPadding=0
	End If
	updateLayout()
End Sub

Sub onControlChange()
	If m.top.control="start"
		'opacity could be set to 0 by fade animation so restore it
		m.loadingIndicatorGroup.opacity=1
		startAnimation()
	Else If m.top.control="stop"
		'if there is fadeInterval set, fully dispose component before stopping spinning animation
		If m.top.fadeInterval>0
			m.fadeAnimation.duration=m.top.fadeInterval
			m.fadeAnimation.observeField("state","onFadeAnimationStateChange")
			m.fadeAnimation.control="start"
		Else
			stopAnimation()
		End If
	End If
End Sub

Sub onFadeAnimationStateChange()
	If m.fadeAnimation.state="stopped" stopAnimation()
End Sub

Function getComponentWidth() As Float
	If m.top.width=0
		'use parent's width
		Return getParentWidth()
	Else
		Return m.top.width
	End If
End Function

Function getComponentHeight() As Float
	If m.top.height=0
		'use parent's height
		Return getParentHeight()
	Else
		Return m.top.height
	End If
End Function

Function getParentWidth() As Float
	If m.top.getParent()<>invalid And m.top.getParent().width<>invalid
		Return m.top.getParent().width
	Else
		Return 1280
	End If
End Function

Function getParentHeight() As Float
	If m.top.getParent()<>invalid And m.top.getParent().height<>invalid
		Return m.top.getParent().height
	Else
		Return 720
	End If
End Function

Sub startAnimation()
	'don't start animation on devices that don't support it
	m.model=createObject("roDeviceInfo").getModel()
	'Get the first character of the model number. Anything less than a 4 corresponds to a device not suited to animations.
	first=Left(m.model,1).trim()
	If first<>invalid And first.Len()=1
		firstAsInt=val(first,10)
		If firstAsInt>3
			m.rotationAnimation.control="start"
			m.top.state="running"
		End If
	End If
End Sub

Sub stopAnimation()
	m.rotationAnimation.control="stop"
	m.top.state="stopped"
End Sub

Function max(a As Float, b As Float) As Float
	If a>b
		Return a
	Else
		Return b
	End If
End Function
