class @Message
  template: undefined
  constructor: (data)->
    @data = data
    @id = data.id
    @message = data.message
    @read_at = data.read_at
    @user = data.user
    @receiver = data.receiver
    @segment = data.segment

  render: ->
    @el = @template(@data)
    @el
