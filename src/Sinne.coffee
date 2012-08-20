Sinne = {}
window.Sinne = Sinne

Sinne.getUserMedia = (options, success, error) ->
  navigator.getUserMedia_ = (navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia || navigator.msGetUserMedia);
  if !!navigator.getUserMedia_
    config_object = {}
    config_string = ''
    if options.video is true 
      config_object.video = true; config_string='video'
    if options.audio is true
      config_object.audio = true
      if config_string isnt '' then config_string = config_string+', '
      config_string = config_string+'audio'
    
    try 
      r = navigator.getUserMedia_(config_object, success, error)
    catch e
      try
        r = navigator.getUserMedia_(config_string, success, error)
      catch e2 #neither of the config approchrs worked
        error({
          name:'configuration_syntax_not_supported'
          message:'could not configure getUserMedia'
          sinne_error_id: 1
          })
        return false
    return r
      
    
  else #no support for getUserMedia
    error({
      name:'getUsereMedia_not_supported'
      message:'getUsereMedia is not supported'
      sinne_error_id: 0
      })

#a helper method to get audio and/or video      
#Sinne.get(options, success, error) ->
  
# options take valid getUserMedia options object
# success(video_element, stream)
# error(error_object)

default_options = {
  autoplay: true
  init: (element) -> element.play()
}

getUserX = (video_support=false, audio_support=false, success, error, options={}) ->
  if video_support is true
    element = document.createElement('video')
  else if audio_support is true
    element = document.createElement('audio')
  else
    error({
      name:'neither_audio_nor_video'
      message:'neither audio nor video support is requested'
      sinne_error_id: 3
      })
    return false
  success_ = (stream) ->
    if MediaStream? and stream instanceof MediaStream #FF
      element.src = stream
    else
      vendorURL = window.URL ? window.webkitURL
      element.src = if vendorURL then vendorURL.createObjectURL(stream) else stream
    success(element, stream)
    
  #merge options with default options
  options_ = {}
  options_[key] = val for key, val of default_options
  options_[key] = val for key, val of options
    
  
  #loop through the options and assign to the element
  element[key] = value for key,value of options_
  #console.log(options_)
  #console.log(element)
  
  #init
  options_.init(element)

  #enable the audio support in the video via the options
  #if options_.audio is true then audio_support = true #moved into getUserVideo
  
  Sinne.getUserMedia({video:video_support, audio:audio_support}, success_, error)

Sinne.getUserVideo = (success, error, options) ->
  audio_support = false
  if options?.audio is true then audio_support = true
  getUserX(true, audio_support, success, error, options)
  
Sinne.getUserAudio = (success, error, options) ->
  video_support = false
  if options?.video is true then video_support = true
  getUserX(video_support, true, success, error, options)  
  
#Sinne.getUserVideo = (success, error, options) ->
#  video_element = document.createElement('video')
#  #video_element.autoplay = true
#  #video_element.play?()
#  success_ = (stream) ->
#    if MediaStream? and stream instanceof MediaStream #FF
#      video_element.src = stream
#      #video_element.play()
#    else
#      vendorURL = window.URL ? window.webkitURL
#      video_element.src = if vendorURL then vendorURL.createObjectURL(stream) else stream
#    #cycle through 
#    success(video_element, stream)
#  Sinne.getUserMedia({video:true}, success_, error)

#success(audio_element, stream)
#error(error_object)  
#DOES NOT CURRENTLY WORK DUE TO A BUG IN CHROME
#http://code.google.com/p/chromium/issues/detail?id=112367
#Sinne.getUserAudio = (success, error, options) ->
#  audio_element = document.createElement('audio')
#  audio_element.autoplay = true
#  audio_element.play?()
#  success_ = (stream) ->
#    if MediaStream? and stream instanceof MediaStream #FF
#      audio_element.src = stream
#      audio_element.play()
#    else
#      vendorURL = window.URL ? window.webkitURL
#      audio_element.src = if vendorURL then vendorURL.createObjectURL(stream) else stream
#    success(audio_element, stream)
#  Sinne.getUserMedia({audio:true}, success_, error)
  
  
