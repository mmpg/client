class MMPG.Buffer
  constructor: (@size) ->
    @clear()

  clear: ->
    @items = []
    @first_item = 0
    @last_item = 0

  isEmpty: ->
    @items.length == 0

  isReady: ->
    (@last_item - @first_item) >= @size

  length: ->
    @items.length

  add: (item, time) ->
    diff = if @last_item then time - @last_item else 0
    @first_item = time unless @first_item
    @last_item = time

    @items.push([item, diff])
