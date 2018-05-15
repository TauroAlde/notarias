class @Chat
  selector: "#chat"

  constructor: () ->
    @el = $(@selector)
    @render()
    @bindSearch()
    #@startPoller()

  render: (skipBinds)->
    @current = @
    if !skipBinds
      @bindClose()                # bind event to close the chat
      @bindOpen()                 # bind event to open the chat in all buttons
    @loadCurrentUser()
    @loadSegmentMessages()
    @loadUserMessages()
    @chatForm = new window.ChatForm(@) if !@chatForm
    @startPoller()

  loadSegmentMessages: (poller)->
    @segmentMessagesPool = new SegmentMessagesPool(@, poller)

  loadUserMessages: (poller)->
    @userMessagesPool = new UserMessagesPool(@, poller)

  currentIsChatRoom: ->
    @currentIsUsersChatRoom() || @currentIsSegmentsChatRoom()

  currentIsUsersChatRoom: ->
    @current instanceof window.UserChatRoom

  currentIsSegmentsChatRoom: ->
    @current instanceof window.SegmentChatRoom

  currentIsHome: ->
    @current instanceof window.Chat

  currentIsPool: ->
    @currentIsSegmentMessagesPool() || @currentIsUserMessagesPool()

  currentIsSegmentMessagesPool: ->
    @current instanceof window.SegmentMessagesPool

  currentIsUserMessagesPool: ->
    @current instanceof window.UserMessagesPool

  loadCurrentUser: ->
    $.get
      url: "/users/load_current_user.json"
      datatype: "JSON"
      success: (data, textStatus, jqXHR) =>
        @currentUser = new window.User(data)

  reload: ->
    @loadSegmentMessages(true)
    @loadUserMessages(true)
    @chatForm.render()

  startPoller: ->
    @before = @current
    clearInterval(chat.poller) if chat.poller
    @poller = setInterval(@pollerFunction, 9000, @)

  pollerFunction: (chat) ->
    chat.updateNewMessagesKPI() # Update the count of unread messages in the chat buttons
    if chat.before == chat.current
      chat.current.reload()
    chat.startPoller()

  pollerRender: ->
    @current == @before

  triggerCustomChatSelect: (params)->
    if params.data.type == "user"
      @userMessagesPool.startNewChat(params.data)
    else
      @segmentMessagesPool.startNewChat(params.data)

  bindSearch: ->
    @el.find("#chat-search").select2
      width: "80%"
      placeholder: 'Buscar por usuario o casilla'
      minimumInputLength: 3
      ajax:
        dataType: 'json'
        url: '/chat_searches'
        processResults: (data) ->
          items = []
          $.each data[0].segments, (index, el)->
            items.push({ id: el.id, text: el.name, type: "segment" })
          $.each data[0].users, (index, el)->
            items.push({ id: el.id, text: el.full_name, type: "user" })
          { results: items }
      templateResult: (d) ->
        html = ""
        if d.id
          icon_type = ""
          if d.type == "user"
            icon_type = "users"
          else if d.type == "segment"
            icon_type = "compass"
          html = "<span class=\"badge-pill badge-info select2-badges\"><i class=\"fa fa-#{icon_type}\"></i></span> <span>#{d.text}</span>"
        else
          html = "<span>#{d.text}</span>"
        $(html)
        #$(html)
      templateSelection: (d) ->
        html = ""
        icon_type = ""
        if d.type == "user"
          icon_type = "users"
        else if d.type == "segment"
          icon_type = "compass"
        html = "<span class=\"badge-pill badge-info select2-badges\"><i class=\"fa fa-#{icon_type}\"></i></span> <span>#{d.text}</span>"
        $(html)
    .on "select2:select", (e) =>
      @startNewChatFor(e.params)
        #window.location = "/segments/#{$(e.params.data.element).attr("data-id")}/users"

  startNewChatFor: (params) ->
    if params.data.type == "user"
      @userMessagesPool.openNewChatFor(params.data.id)
    else
      @segmentMessagesPool.openNewChatFor(params.data.id)

  hide: ->
    @el.removeClass("show") if @el.hasClass("show")
    @el.addClass("hide")
    @el.css("z-index", -1000)

  show: ->
    @el.removeClass("hide") if @el.hasClass("hide")
    @el.addClass("show")
    @el.css("z-index", 10)
    @reload()

  bindClose: ->
    @el.find(".close").off("click").on "click", (e)=>
      if @currentIsHome()
        @hide()
      else
        @back()

  back: ->
    if @currentIsUsersChatRoom()
      @selectUsersTab()
    else if @currentIsSegmentsChatRoom()
      @selectSegmentsTab()

    if !@currentIsHome()
      @render()
      @current = @

  selectSegmentsTab: ->
    @el.find("#segment-messages-list-tab").tab("show")

  selectUsersTab: ->
    @el.find("#user-messages-list-tab").tab("show")

  isHidden: ->
    !@el.hasClass("show")

  bindOpen: ->
    $("#open-messages-button").click (e) =>
      if @isHidden()
        @show()
    
    $("#open-messages-button-mobile").click (e) =>
      if @isHidden()
        @show()

  replaceMessagesKPI: (count)->
    $(".messages_count").html(count)
    buttons = $("#open-messages-button, #open-messages-button-mobile")
    if count > 0
      buttons.addClass("bg-warning")
      buttons.removeClass("bg-primary")
    

  updateNewMessagesKPI: ->
    $.getScript("/messages_kpis")

  #startPoller: ->
  #  setTimeout(@pollerCallback, 5000, @)
  #
  #pollerCallback: (chat)->
  #  if chat.currentIsHome()
  #    chat.reload(true)
  #  else
  #    chat.current().render(true)
  #  chat.startPoller()