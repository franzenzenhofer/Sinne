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

Sinne.getUserVideo = (success, error) ->
  video_element = document.createElement('video')
  video_element.autoplay = true
  video_element.play?()
  success_ = (stream) ->
    if MediaStream? and stream instanceof MediaStream #FF
      video_element.src = stream
      video_element.play()
    else
      vendorURL = window.URL ? window.webkitURL
      video_element.src = if vendorURL then vendorURL.createObjectURL(stream) else stream
    success(video_element, stream)
  Sinne.getUserMedia({video:true}, success_, error)

#success(audio_element, stream)
#error(error_object)  
Sinne.getUserAudio = (success, error) ->
  audio_element = document.createElement('audio')
  audio_element.autoplay = true
  audio_element.play?()
  success_ = (stream) ->
    if MediaStream? and stream instanceof MediaStream #FF
      audio_element.src = stream
      audio_element.play()
    else
      vendorURL = window.URL ? window.webkitURL
      audio_element.src = if vendorURL then vendorURL.createObjectURL(stream) else stream
    success(audio_element, stream)
  Sinne.getUserMedia({audio:true}, success_, error)
  
  
