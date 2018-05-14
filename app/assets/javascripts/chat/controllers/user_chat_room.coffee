class @UserChatRoom extends @ChatRoomBase
  constructor: (data, chat, pool) ->
    @template = window.JST["chat/templates/user_messages_pool_item"]
    @chatRoomModelClass = window.User
    @messageClass = window.UserMessage
    super(data, chat, pool)

  chatRoomPath: ->
    "/user_messages/#{ @model.id }.json"

  fetchId: ->
    base_string = super()
    if @params
      base_string += "?user_id=#{@params.id}"
    base_string