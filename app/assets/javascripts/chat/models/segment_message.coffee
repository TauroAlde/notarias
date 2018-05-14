class @SegmentMessage extends window.Message
  constructor: (data) ->
    @template = window.JST["chat/templates/user_message"]
    super(data)