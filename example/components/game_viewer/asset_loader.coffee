class Assets
  @loader = new THREE.TextureLoader()
  @textures = {
    players: []
  }
  @objects = {}
  @loaded = false

  @load: (players, callback) ->
    return if @loaded

    loadPlayerIcons = =>
      @loadPlayerIcons players, loadObjects

    loadObjects = =>
      @loadObjects ->
        @loaded = true
        callback()

    @loadTextures {
      skydome: 'space2.png'
    }, loadPlayerIcons


  @loadTextures: (urls, callback) ->
    for id, url of urls
      @loader.load url, (texture) =>
        @textures[id] = texture
        delete urls[id]
        @loadTextures(urls, callback)
      return

    callback()

  @loadPlayerIcons: (players, callback) ->
    if players.length == 0
      callback()
      return

    player = players.shift()

    identicon = new Identicon(SparkMD5.hash(player.toString()), {
      size: 128, backgroundColor: [0, 0, 0, 0]
    })

    @loader.load 'data:image/png;base64,' + identicon.toString(), (texture) =>
      @textures.players.push(texture)
      @loadPlayerIcons(players, callback)

  @loadObjects: (callback) ->
    @objects.skydome = new Skydome(@textures.skydome)

    callback()
