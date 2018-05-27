class @PoliticalCandidacy
  constructor: (el)->
    @el = el
    @input = @el.find(".votes-field")
    @counter = @el.find(".vote-counter")
    @increaseBtn = $(@el.find(".increase-votes")[0])
    @decreaseBtn = $(@el.find(".decrease-votes")[0])
    @timeout = 0
    @interval = 70
    @pushCount = 0
    @countIncDec = 1
    @bindIncrease()
    @bindDecrease()

  bindIncrease: ->
    @increaseBtn.on "mousedown touchstart", (e) =>
      e.preventDefault()
      @startIncrease()
    .bind 'mouseup mouseleave touchend', =>
      @interval = 70
      @pushCount = 0
      @countIncDec = 1
      clearInterval(@timeout);

  bindDecrease: ->
    @decreaseBtn.on "mousedown touchstart", (e) =>
      e.preventDefault()
      @startDecrease()
    .bind 'mouseup mouseleave touchend', =>
      @interval = 70
      @pushCount = 0
      @countIncDec = 1
      clearInterval(@timeout);

  startIncrease: ->
    @timeout = setInterval =>
      @pushCount += 1
      if @pushCount >= (10 * @countIncDec) && @interval >= 10
        @interval -= 10
        @countIncDec += 1
        clearInterval(@timeout)
        @startIncrease()

      @input.val (i, oldval) =>
        oldval = parseInt(oldval)
        return (oldval + @countIncDec)
      @counter.html(@input.val())
    , @interval

  startDecrease: ->
    @timeout = setInterval =>
      @pushCount += 1
      if @pushCount >= (10 * @countIncDec) && @interval >= 10
        @interval -= 10
        @countIncDec += 1
        clearInterval(@timeout)
        @startDecrease()

      @input.val (i, oldval) =>
        oldval = parseInt(oldval)
        if oldval <= 0 
          return oldval
        else
          if oldval - @countIncDec < 0
            return 0
          else
            return (oldval - @countIncDec)
      @counter.html(@input.val())
    , @interval
