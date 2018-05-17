class @UserMessage extends window.Message
  constructor: (data, chat, pool, chatRoom)->
    @template = window.JST["chat/templates/user_message"]
    super(data, chat, pool, chatRoom)