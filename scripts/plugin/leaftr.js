// Generated by CoffeeScript 1.6.3
(function() {
  var $, Leaftr, Tile;

  $ = jQuery;

  $.fn.extend({
    leaftr: function(options) {
      var leaftr, plugin_div, settings;
      plugin_div = this;
      settings = {
        width: '100%',
        height: '100%',
        max_element: 10,
        related_width: '100px',
        img_width: '100px',
        max_title_length: 50,
        city_code: [],
        department_code: []
      };
      settings = $.extend(settings, options);
      return leaftr = new Leaftr(plugin_div, settings);
    }
  });

  /*
      TILE CLASS
  	Delegate for the items' actions
  */


  Tile = (function() {
    Tile.prototype.clss = '';

    function Tile(data) {
      this.view_count = data.view_count;
      this.img = data.image_url;
      if (this.img === void 0) {
        this.img = 'assets/img/notFound.png';
      }
      this.url = data.url;
      this.name = data.title;
      if (this.name === void 0) {
        this.name = '';
      }
    }

    Tile.prototype.display = function(parent, offset) {
      this.offset = offset;
      return parent.append("<a target='_blank' href='" + this.url + "' id='item" + this.offset + "'><div class='" + this.clss + "'><img src='" + this.img + "'><div class='item-hover'><p><strong>" + this.name + "</strong></p></div></div></a>");
    };

    return Tile;

  })();

  /*
      LEAFTR MAIN CLASS
      Handling the containers' lifecycle
  */


  Leaftr = (function() {
    Leaftr.prototype.tiles = null;

    Leaftr.prototype.max_view = 0;

    Leaftr.prototype.min_view = 0;

    Leaftr.prototype.isLoading = false;

    function Leaftr(div, options) {
      this.div = div;
      this.options = options;
      this.div.css({
        'width': this.options.width,
        'min-height': this.options.height,
        'max-height': this.options.height
      });
      this.div.masonry({
        columnWidth: '.item',
        itemSelector: '.item',
        gutter: 5
      });
      this.setupUrl();
      this.loadData();
    }

    Leaftr.prototype.setupUrl = function() {
      this.url = 'http://cow.etalab2.fr/api/1/datasets/related';
      this.options.city_code.forEach(function(city) {
        if (city !== 0) {
          return this.url += '?territory=CommuneOfFrance/' + city;
        }
      });
      return this.options.department_code.forEach(function(department) {
        if (department !== 0) {
          return this.url += '?territory=DepartmentOfFrance/' + department;
        }
      });
    };

    Leaftr.prototype.loadData = function() {
      var self;
      this.displayLoadingWheel();
      self = this;
      return $.ajax(this.url, {
        type: 'GET',
        dataType: 'json',
        error: function(jqXHR, textStatus, errorThrown) {
          return console.log("AJAX Error: " + textStatus);
        },
        success: function(data, textStatus, jqXHR) {
          self.hideLoadingWheel();
          self.data = data;
          self.loadTiles();
          return self.displayFromOffset(0);
        }
      });
    };

    Leaftr.prototype.loadTiles = function() {
      var self, value, _i, _len, _ref, _results;
      this.tiles = new Array();
      self = this;
      _ref = this.data.value;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        value = _ref[_i];
        _results.push((function(value) {
          var related, _j, _len1, _ref1, _results1;
          _ref1 = value.related;
          _results1 = [];
          for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
            related = _ref1[_j];
            _results1.push((function(related) {
              return self.tiles.push(new Tile(related));
            })(related));
          }
          return _results1;
        })(value));
      }
      return _results;
    };

    Leaftr.prototype.setClasses = function() {
      var tile, _i, _len, _ref, _results;
      _ref = this.tiles;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        tile = _ref[_i];
        if (this.max_view === 0) {
          _results.push(tile.clss = 'item');
        } else {
          if (tile.view_count < (this.max_view / 2)) {
            tile.clss = 'item';
          }
          if (tile.view_count >= (this.max_view / 2)) {
            _results.push(tile.clss = 'item w2');
          } else {
            _results.push(void 0);
          }
        }
      }
      return _results;
    };

    Leaftr.prototype.getViewMinMax = function() {
      var self, value, _i, _len, _ref, _results;
      self = this;
      _ref = this.data.value;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        value = _ref[_i];
        _results.push((function(value) {
          var related, _j, _len1, _ref1, _results1;
          _ref1 = value.related;
          _results1 = [];
          for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
            related = _ref1[_j];
            _results1.push((function(related) {
              if (related.view_count > self.max_view) {
                self.max_view = related.view_count;
              }
              if (self.min_view === 0) {
                self.min_view = related.view_count;
              }
              if (related.view_count < self.min_view) {
                return self.min_view = related.view_count;
              }
            })(related));
          }
          return _results1;
        })(value));
      }
      return _results;
    };

    Leaftr.prototype.displayLoadingWheel = function() {
      return this.div.append("<img id='leaftr-wheel' src='assets/img/loading.gif'>");
    };

    Leaftr.prototype.hideLoadingWheel = function() {
      return $('#leaftr-wheel').remove();
    };

    Leaftr.prototype.displayFromOffset = function(offset) {
      var i, self, _i, _ref;
      this.div.masonry('layout');
      this.getViewMinMax();
      this.setClasses();
      this.offset = offset + 1;
      for (i = _i = offset, _ref = offset + this.options.max_element; _i <= _ref; i = _i += 1) {
        this.tiles[i].display(this.div, i);
        this.div.masonry('appended', $('#item' + i));
      }
      self = this;
      this.div.imagesLoaded(function() {
        console.log('images loaded');
        self.isLoading = false;
        return self.div.masonry('layout');
      });
      return this.div.scroll(function() {
        var scrollPos;
        scrollPos = self.div[0].scrollHeight - self.div.scrollTop();
        if (scrollPos - self.div.height() === 0) {
          if ((self.offset + 10 < self.tiles.length) && (self.isLoading !== true)) {
            self.displayFromOffset(self.offset + 10);
            self.div.masonry('layout');
            return self.isLoading = true;
          }
        }
      });
    };

    return Leaftr;

  })();

}).call(this);
