class MMPG.Buffer
  constructor: (@size) ->
    @clear()

  clear: ->
    @items = []
    @last_item = 0

  isEmpty: ->
    @items.length == 0

  isReady: ->
    @items.length >= @size

  length: ->
    @items.length

  add: (item, time) ->
    diff = if @last_item then time - @last_item else 0
    @last_item = time

    @items.push([item, diff])
