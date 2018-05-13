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
    @el.click (e) =>
      e.preventDefault()
      e.stopPropagation()
      @render()

  message_path: ->
    console.log("implement")

  render: ->
    @startLoadingIcon()
    @chat.loading = true
    $.getScript @message_path(), ()=>
      @chat.loading = false
      @chat.historyFunnel.push(@) if @chat.historiable()
      @chat.chatForm.render()
      console.log(@pool.el.height())
      @chat.el.find("#chat-viewport-scroll")[0].scrollTop = @pool.el.height()

  startLoadingIcon: ->
    @pool.startLoadingIcon() if @chat.currentIsHome()

  id: ->
    @el.attr("data-message-id")

class SegmentMessageResume extends MessageResume
  message_path: ->
    "/segment_messages/#{ @id() }"

class UserMessageResume extends MessageResume
  message_path: ->
    "/user_messages/#{ @id() }"

class ChatForm
  constructor: (chat)->
    @el = $("#chat-form")
    @chat = chat
    @bindOnSubmit()
    @render()

  bindMessagesFileUploader: ->
    chat = @chat
    if @el.hasClass("jquery-fileupload-initialized")
      @el.fileupload('destroy')
      @el.removeClass("jquery-fileupload-initialized")
    if @chat.currentIsSegmentMessage() || @chat.currentIsUserMessage()
      current_path = @currentChatPath()
      @el.addClass("jquery-fileupload-initialized")
      @el.fileupload
        dataType: 'json',
        fileInput: $('#fileupload-evidence'),
        limitMultiFileUploads: 1,
        #autoUpload: true,
        url: current_path.split(".")[0] + ".json"
        done: (e, data)->
          console.log "done"
          chat.historyFunnelLast().render()
          #formData: { segment_message: { message: $("#step-one-textarea") } },
        fail: (e, data) ->
          console.log "form fail"
        submit: (e, data) ->
          console.log "form submit"
        send: (e, data)->
          console.log "form send"

  render: ->
    @el.attr("action", @currentChatPath())
    @bindMessagesFileUploader()

  currentChatPath: ->
    if @chat.currentIsSegmentMessage()
      "/segment_messages/#{@chat.historyFunnelLast().id()}/responses.js"
    else if @chat.currentIsUserMessage()
      "/user_messages/#{@chat.historyFunnelLast().id()}/responses.js"
    else
      "#"

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
    @messageClass = undefined
    @render()

  render: ->
    @startLoadingIcon() if @chat.currentIsHome()
    @chat.loading = true
    $.getScript @path, () =>
      @chat.loading = false
      @buildResumes()

  startLoadingIcon: ->
    @el.html('<div class="m-t5 row justify-content-center align-items-center h-100"><div class="col-auto"><div class="loader"></div></div></div>')

  buildResumes: (messageClass)->
    resumes = []
    chat = @chat
    pool = @
    @el.find(@resumeSelector).each (i)->
      resumes.push(new messageClass(@, chat, pool))
    @resumes = resumes

class SegmentMessagesPool extends MessagesPool
  constructor: (chat)->
    @el = $("#segment-messages-list")
    @path =  "/segment_messages"
    @resumeSelector = ".segment-message-resume-list-item"
    super(chat)

  buildResumes: ->
    super(SegmentMessageResume)

class UserMessagesPool extends MessagesPool
  constructor: (chat)->
    @el = $("#user-messages-list")
    @path = "/user_messages"
    @resumeSelector = ".user-message-resume-list-item"
    super(chat)

  buildResumes: ->
    super(UserMessageResume)

class Chat
  constructor: () ->
    @el = $("#chat")
    @render()
    @loading = true
    #@startPoller()

  currentIsHome: ->
    @historyFunnelLast() instanceof Chat

  currentIsSegmentMessage: ->
    @historyFunnelLast() instanceof SegmentMessageResume

  currentIsUserMessage: ->
    @historyFunnelLast() instanceof UserMessageResume

  historyFunnelLast: ->
    @historyFunnel[@historyFunnel.length - 1]

  historiable: ->
    @currentIsHome()

  render: ->
    @historyFunnel = [@]
    @bindClose()                # bind event to close the chat
    @bindOpen()                 # bind event to open the chat in all buttons
    @loadSegmentMessages()
    @loadUserMessages()
    @chatForm = new ChatForm(@)

  loadSegmentMessages: ->
    @segmentMessagesPool = new SegmentMessagesPool(@)

  loadUserMessages: ->
    @userMessagesPool = new UserMessagesPool(@)

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
    @el.find(".close").off("click").on "click", (e)=>
      if @currentIsHome()
        @hide()
      else
        @back()

  back: ->
    return if @loading == true
    previous = @historyFunnel.pop() if !@currentIsHome()
    @historyFunnel[@historyFunnel.length - 1].render()

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
  