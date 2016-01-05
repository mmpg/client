class Assets
  constructor: ->
    @loader = new THREE.TextureLoader()
    @textures = {
      players: []
    }
    @materials = {
      players: []
    }

  load: (players, callback) ->
    @loadTextures {
      skydome: 'space2.png'
    }, =>
      @loadMaterials players, =>
        @skydome = new Skydome(@textures.skydome)
        callback()

  loadTextures: (urls, callback) ->
    for id, url of urls
      @loader.load url, (texture) =>
        @textures[id] = texture
        delete urls[id]
        @loadTextures(urls, callback)
      return

    callback()

  loadMaterials: (players, callback) ->
    if players.length == 0
      callback()
      return

    player = players.shift()

    identicon = new Identicon(SparkMD5.hash(player.toString()), { size: 512, backgroundColor: [0, 0, 0, 0] })

    @loader.load 'data:image/png;base64,' + identicon.toString(), (texture) =>
      @textures.players.push(texture)
      @loadMaterials(players, callback)
