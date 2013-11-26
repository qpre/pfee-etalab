define(['jquery',
        'app/Tile',
        'app/Wheel',
        'app/Button',
        'app/States',
        'masonry'], ($, Tile, Wheel, Button, STATES) ->
  
  ###
    LEAFTR
    Handles the Leaftr plugins life cycle
  ###
  class Leaftr
    options: null
    data: null
    
    main_container: null
    tiles_container: null
    loadingWheel: null
    
    state: STATES.NORMAL
    
    # called on creation
    #
    # @param {Object} main_container : a jQuery object linked to the element
    #                 containing the plug-in
    # @param {Object} options : the plug-ins' parameters
    #
    constructor: (@main_container, @options) ->
      @initContext()
      @loadData()
      
    # function initContext
    # 
    # inits a DOM context for the magic to take place in
    #
    initContext: () ->
      @main_container.append('<div id="leaftr_tiles"></div>')
      @main_container.css({
        'width' : @options.width
        'min-height' : @options.height
        'max-height' : @options.height
      })
      @tiles_container = $('#leaftr_tiles')
      @tiles_container.css({
        'width' : '100%'
        'min-height' : '100%'
        'max-height' : '100%'
      })
      
      @loadingWheel = new Wheel(@tiles_container)
      @loadButton = new Button(@main_container, @loadMore())
      
    # function loadData
    #
    # Gets data from ETALABs' API
    #
    loadData: () ->
      @setLoading()
      url = 'http://cow.etalab2.fr/api/1/datasets/related'
      @options.city_code.forEach((city) ->
          unless city == 0 then url += '?territory=CommuneOfFrance/' + city)
      @options.department_code.forEach((department) ->
          unless department == 0 then url += '?territory=DepartmentOfFrance/' + department)
      
      self = @
      $.ajax url,
          type: 'GET'
          dataType: 'json'
          error: (jqXHR, textStatus, errorThrown) ->
              console.log "AJAX Error: #{textStatus}"
          success: (data, textStatus, jqXHR) ->
              self.loadTiles(data)
              self.unsetLoading()

    # function loadTiles
    #
    # creates an array of Tiles, based on data's content
    #
    # @param {Object} data : array of elements retrieved earlier
    #
    loadTiles: (data) ->
        @tiles = new Array()
        self = this
        for value in data.value
            do (value) ->
                for related in value.related
                    do (related) ->
                        self.tiles.push(new Tile(related, self.parent, self.tiles.length))

    # function setLoading
    #
    # sets the plugin into loading mode
    #
    setLoading: () ->
      @state = STATES.LOADING
      @loadingWheel.display()
      @loadButton.hide()
      
    # function unsetLoading
    #
    # sets the plugin into loading mode
    #
    unsetLoading: () ->
      @state = STATES.NORMAL
      @loadingWheel.hide()
      @loadButton.display()
      
    # function loadMore
    #
    # loads @max_tiles tiles from Leaftr's current offset
    #
    loadMore: () ->
      console.log 'click !'
)