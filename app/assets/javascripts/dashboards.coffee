# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
class SegmentMessageResume
  constructor: (resumeMessageEl, chat) ->
    @el = $(resumeMessageEl)
    @bindClickLoadChat()
    @chat = chat

  bindClickLoadChat: ->
    window.current_message_id = @el.attr("data-segment-message-id")
    @el.click (e) =>
      window.previous = "home"
      e.preventDefault()
      e.stopPropagation()
      @chat.currentResume = @
      @load()

  load: ->
    $.getScript "/segment_messages/#{ @segmentMessageId() }", ()=>
      @chat.chatForm.load()
      @chat.el.find("#chat-viewport-scroll")[0].scrollTop = $("#segment-messages-list").height()

  segmentMessageId: ->
    @el.attr("data-segment-message-id")

class ChatForm
  constructor: (chat)->
    @el = $("#chat-form")
    @chat = chat
    @bindOnSubmit()
    @load()

  bindMessagesFileUploader: ->
    chat = @chat
    if @el.hasClass("jquery-fileupload-initialized")
      @el.fileupload('destroy')
      @el.removeClass("jquery-fileupload-initialized")
    if @chat.currentResume && @chat.currentResume.segmentMessageId()
      @el.addClass("jquery-fileupload-initialized")
      @el.fileupload
        dataType: 'json',
        fileInput: $('#fileupload-evidence'),
        limitMultiFileUploads: 1,
        #autoUpload: true,
        url: "/segment_messages/#{chat.currentResume.segmentMessageId()}/responses.json",
        done: (e, data)->
          console.log "fdsafdsafdsafdsa"
          chat.currentResume.load()
          #formData: { segment_message: { message: $("#step-one-textarea") } },
        fail: (e, data) ->
          console.log "fdsafdsafdsafdsa"
        submit: (e, data) ->
          console.log "fdsafdsafdsafdsa"
        send: (e, data)->
          console.log "fdsafdsafdsafdsa"

  load: ->
    if @chat.currentResume && @chat.currentResume.segmentMessageId()
      @el.attr("action", "/segment_messages/#{@chat.currentResume.segmentMessageId()}/responses.js")
    else
      @el.attr("action", "#")
    @bindMessagesFileUploader()

  bindOnSubmit: ->
    @el.submit (e) =>
      if @el.attr("action") == "#" || !@el.find("#message-text").val()
        e.preventDefault()
        return false

  clearText: ->
    @el.find("#message-text").val("")

  disable: ->
    $("#form-fieldset").attr("disabled", "true")
  enable: ->
    $("#form-fieldset").attr("enabled", "true")

class Chat
  constructor: () ->
    @el = $("#chat-pool")
    @bindClose()
    @bindOpen()
    @loadMessagesFullList()
    @chatForm = new ChatForm(@)
    @currentResume = undefined
    @startPoller()

  reload: ->
    window.previous = undefined
    window.current_message_id = undefined
    @currentResume = undefined
    @chatForm.load()
    @loadMessagesFullList()

  hide: ->
    @el.removeClass("show")
    @el.addClass("hide")
    @el.css("z-index", -1000)

  show: ->
    @el.removeClass("hide")
    @el.addClass("show")
    @el.css("z-index", 9999)
    @loadMessagesFullList()

  bindClose: ->
    @el.find(".close").click (e)=>
      if window.previous == "home"
        @reload()
      else
        @hide()

  isShown: ->
    @el.hasClass("show")

  isHidden: ->
    @el.hasClass("hide")

  bindOpen: ->
    $("#open-messages-button").click (e) =>
      if @isHidden()
        @show()
    
    $("#open-messages-button-mobile").click (e) =>
      if @isHidden()
        @show()

  loadMessagesFullList: ->
    window.current_message_id = undefined
    @currentResume = undefined
    $.getScript("/segment_messages", () => @buildSegmentMessageResumes() )

  buildSegmentMessageResumes: ->
    resumes = []
    chat = @
    @el.find(".segment-message-resume-list-item").each (i)->
      resumes.push(new SegmentMessageResume(@, chat))
    @resumes = resumes

  startPoller: ->
    setTimeout(@pollerCallback, 5000, @)

  pollerCallback: (chat)->
    if chat.currentResume
      chat.currentResume.load()
    else if !chat.currentResume
      chat.reload()
    chat.startPoller()



$ ->
  $(window).click (e) ->
    catchLeftClick(e)

  catchLeftClick = (event) ->
    if event.target == $('#open-hide')[0] or $('#open-hide').find(event.target).length
      $('#left-sidebar').toggleClass 'show-sidebar'
      #event.preventDefault()
    else
      $('#left-sidebar').removeClass 'show-sidebar'
    return

  catchRightClick = (event) ->
    if event.target == $('#right-sidebar-switch')[0] or $('#right-sidebar-switch').find(event.target).length
      #event.preventDefault()
      $('#right-sidebar').toggleClass 'show-right-sidebar'
    else if event.target == $('#close-sidebar')[0]
      #event.preventDefault()
      $('#right-sidebar').removeClass 'show-right-sidebar'
    else if event.target == $('#right-sidebar')[0] or $('#right-sidebar').find(event.target).length
      $('#right-sidebar').addClass 'show-right-sidebar'
    else
      $('#right-sidebar').removeClass 'show-right-sidebar'
    return

  window.chat = new Chat