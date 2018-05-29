class @MessagesPoolBase
  #@resumeSelector = undefined  # variables globales para la clase para poder tener un valor
  #@path = undefined            # default o saber lo que hay que llenar al llamar al constructor
  #@el = undefined
  selector: undefined
  type: undefined
  chatRoomControllerClass: undefined

  constructor: (chat, poller)->
    @chat = chat
    @el = $(@selector)
    @path = "/#{@type}_messages.json"
    @render(poller)

  render: (poller)->
    @chatRooms = []
    @startLoadingIcon() if !poller
    $.get
      url: @path
      datatype: "JSON"
      success: (data, textStatus, jqXHR) =>
        html = []
        $.each data, (index, el) =>
          chatRoom = new @chatRoomControllerClass(el, @chat, @)
          @chatRooms.push(chatRoom)
          html.push chatRoom.renderRow()
        if @chat.current == @chat
          @stopLoadingIcon()
          if html.length
            @el.html(html)
          else
            @el.html(@blankDescription())

  blankDescription: ->
    return "<div class=\"row h-100 align-items-center\"><div class=\"col\"><h3 class=\"p-3 text-center\">No hay ninguna converzación</h3><h4 class=\"p-3 text-center text-secondary\">De click en el buscador y escriba el nombre de un usuario, casilla, municipio o entidad</h4></div></div>"

  startLoadingIcon: ->
    @el.html('<div class="m-t5 row justify-content-center align-items-center h-100"><div class="col-auto"><div class="loader"></div></div></div>')

  stopLoadingIcon: ->
    @el.html("")

  renderMessages: (messages) ->
    html = []
    $.each messages, (index, message) ->
      html.push(message.render())
    @el.html(html)

  openNewChatFor: (id)->
    @chat.clearPoller() # stop the poller to open a new chat
    $.get
      url: "/#{@type}_messages/new.json"
      data: { "#{@type}_id": id }
      datatype: "JSON"
      success: (data, textStatus, jqXHR) =>
        chatRoom = new @chatRoomControllerClass(data, @chat, @)
        @chatRooms.push(chatRoom)
        @chat.current = chatRoom
        chatRoom.render()


  

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