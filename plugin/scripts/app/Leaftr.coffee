define(['jquery',
        'masonry/masonry',
        'imagesloaded/imagesloaded',
        'app/Tile',
        'app/Wheel',
        'app/Button',
        'app/States'], ($, Masonry, ImagesLoaded, Tile, Wheel, Button, STATES) ->
  
  ###
    LEAFTR
    Handles the Leaftr plugins life cycle
  ###
  class Leaftr
    options: null
    tiles: null
    
    main_container: null
    tiles_container: null
    loadingWheel: null
    
    state: STATES.NORMAL
    
    max_view: 0
    min_view: 0
    
    offset: 0
    
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
      })
      @msonry = new Masonry('#leaftr_tiles', {
          columnWidth: '.item'
          itemSelector: '.item'
          gutter: 5
        })
      self = this
      @loadingWheel = new Wheel(@tiles_container)
      @loadButton = new Button(@main_container, () ->
        self.loadMore()
      )
      
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
              self.loadMore()

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
                        self.max_view = related.view_count if related.view_count > self.max_view
                        self.min_view = related.view_count if self.min_view == 0
                        self.min_view = related.view_count if related.view_count < self.min_view
                        self.tiles.push(new Tile(related, self.tiles_container, self.tiles.length))

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
      @msonry.layout()
      @setClasses()
      @state = STATES.LOADING
      
      curoffset = @offset
      
	    # Add max_elements to the div
      for i in [curoffset..(curoffset + @options.max_element)] by 1
          @tiles[i].display()
          @msonry.appended(document.querySelector('#item'+i))
          @offset += 1
  
      self = this
	    # Let's apply some masonry when the heights are ready
      @tiles_container.imagesLoaded(() ->
        self.state = STATES.NORMAL
        self.msonry.layout()
      )
      
	    # let's listen to that scroll thingy
      @main_container.scroll(() ->
          scrollPos = (self.main_container[0].scrollHeight - self.main_container.scrollTop())
          if (scrollPos - self.main_container.height() == 0)
              if ((self.offset + 10 < self.tiles.length) && (self.state != STATES.LOADING))
                  self.loadMore()
                  self.msonry.layout()
                  self.state = STATES.LOADING
          )
      
    # function setClasses
    #
    # sets Tiles CSS classes depending on view count
    #
    setClasses: () ->
      for tile in @tiles
          if @max_view == 0
              tile.clss = 'item'
          else
              if tile.view_count < (@max_view / 2)
                  tile.clss = 'item'
              if tile.view_count >= (@max_view / 2)
                  tile.clss = 'item w2'
)