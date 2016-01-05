class Assets
  constructor: ->
    @loader = new THREE.TextureLoader()
    @textures = {}

  load: (callback) ->
    @loadTextures {
      skydome: 'space2.png'
    }, =>
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
