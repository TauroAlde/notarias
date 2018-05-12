# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
class MessageResume
  @message_path = undefined
  constructor: (resumeMessageEl, chat, pool) ->
    @el = $(resumeMessageEl)
    @chat = chat
    @pool = pool
    @bindClickLoadChat()

  bindClickLoadChat: ->
    window.current_message_id = @segmentMessageId()
    @el.click (e) =>
      e.preventDefault()
      e.stopPropagation()
      @load()

  message_path: ->
    console.log("implement")

  load: ->
    $.getScript @message_path(), ()=>
      @chat.chatForm.load()
      @chat.historyFunnel.push(@)
      @chat.el.find("#chat-viewport-scroll")[0].scrollTop = @pool.el.height()

  segmentMessageId: ->
    @el.attr("data-message-id")

class SegmentMessageResume extends MessageResume

  message_path: ->
    "/segment_messages/#{ @segmentMessageId() }"

class UserMessageResume extends MessageResume

  message_path: ->
    "/user_messages/#{ @segmentMessageId() }"

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
          console.log "form fail"
        submit: (e, data) ->
          console.log "form submit"
        send: (e, data)->
          console.log "form send"

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

class MessagesPool
  #@resumeSelector = undefined  # variables globales para la clase para poder tener un valor
  #@path = undefined            # default o saber lo que hay que llenar al llamar al constructor
  #@el = undefined

  constructor: (chat)->
    @chat = chat

  load: ->
    $.getScript(@path, () => @buildResumes())

  buildResumes: ->
    resumes = []
    chat = @chat
    pool = @
    @el.find(@resumeSelector).each (i)->
      resumes.push(new SegmentMessageResume(@, chat, pool))
    @resumes = resumes

class SegmentMessagesPool extends MessagesPool
  constructor: (chat)->
    @el = $("#segment-messages-list")
    @path =  "/segment_messages"
    @resumeSelector = ".segment-message-resume-list-item"
    super(chat)

class UserMessagesPool extends MessagesPool
  constructor: (chat)->
    @el = $("#user-messages-list")
    @path = "/user_messages"
    @resumeSelector = ".user-message-resume-list-item"
    super(chat)

class Chat
  constructor: () ->
    @el = $("#chat")
    @load()
    @bindClose()                # bind event to close the chat
    @bindOpen()                 # bind event to open the chat in all buttons
    @historyFunnel = [@]
    #@startPoller()

  back: ->
    previous = @historyFunnel.pop() if @historyFunnel.length > 1 && !@currentIsHome()
    @historyFunnel[@historyFunnel.length - 1].load()

  currentIsHome: ->
    @historyFunnel[@historyFunnel.length - 1] instanceof Chat

  load: ->
    window.previous = undefined
    window.current_message_id = undefined
    @currentResume = undefined

    @chatForm = new ChatForm(@)
    @chatForm.load()
    @loadSegmentMessages()
    #@loadUserMessages()

  loadSegmentMessages: ->
    @segmentMessagesPool = new SegmentMessagesPool(@)
    @segmentMessagesPool.load()

  loadUserMessages: ->
    @userMessagesPool = new UserMessagesPool(@)
    @userMessagesPool.load()

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
      if @currentIsHome()
        @hide()
      else
        @back()

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

  #startPoller: ->
  #  setTimeout(@pollerCallback, 5000, @)
  #
  #pollerCallback: (chat)->
  #  if chat.currentResume
  #    chat.currentResume.load()
  #  else if !chat.currentResume
  #    chat.load()
  #  chat.startPoller()



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
  