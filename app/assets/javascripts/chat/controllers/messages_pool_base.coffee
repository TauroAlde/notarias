class @MessagesPoolBase
  #@resumeSelector = undefined  # variables globales para la clase para poder tener un valor
  #@path = undefined            # default o saber lo que hay que llenar al llamar al constructor
  #@el = undefined
  selector: undefined
  type: undefined
  chatRoomControllerClass: undefined

  constructor: (chat)->
    @chat = chat
    @el = $(@selector)
    @path = "/#{@type}_messages.json"
    @render()

  render: (poller)->
    @chatRooms = []
    @startLoadingIcon() 
    $.get
      url: @path
      datatype: "JSON"
      success: (data, textStatus, jqXHR) =>
        @stopLoadingIcon()
        $.each data, (index, el) =>
          chatRoom = new @chatRoomControllerClass(el, @chat, @)
          @chatRooms.push(chatRoom)
          @el.append chatRoom.renderRow()

  startLoadingIcon: ->
    @el.html('<div class="m-t5 row justify-content-center align-items-center h-100"><div class="col-auto"><div class="loader"></div></div></div>')

  stopLoadingIcon: ->
    @el.html("")

  renderMessages: (messages) ->
    html = []
    $.each messages, (index, message) ->
      html.push(message.render())
    @el.html(html.join(""))

  #startNewChat: (messageClass, params)->
  #  new_message_list = new messageClass("", @chat, @, params)
  #  @resumes.push(new_message_list)
  #  new_message_list.render()
  #
  #newResumesList: ->
  #  newResumes = []
  #  $.each @resumes, (index, messageResume) ->
  #    if messageResume.id.split("?")[0] == "new" then newResumes.push(messageResume)
  #  newResumes