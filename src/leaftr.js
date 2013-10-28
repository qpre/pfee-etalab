// Generated by CoffeeScript 1.6.3
(function() {
  var $, Leaftr;

  $ = jQuery;

  $.fn.extend({
    leaftr: function(options) {
      var plugin_div, settings, url;
      plugin_div = this;
      settings = {
        width: '600px',
        max_element: 10,
        related_width: '100px',
        img_width: '100px',
        max_title_length: 50,
        city_code: [],
        department_code: []
      };
      settings = $.extend(settings, options);
      url = 'http://cow.etalab2.fr/api/1/datasets/related';
      settings.city_code.forEach(function(city) {
        if (city !== 0) {
          return url += '?territory=CommuneOfFrance/' + city;
        }
      });
      settings.department_code.forEach(function(department) {
        if (department !== 0) {
          return url += '?territory=DepartmentOfFrance/' + department;
        }
      });
      return $.ajax(url, {
        type: 'GET',
        dataType: 'json',
        error: function(jqXHR, textStatus, errorThrown) {
          return console.log("AJAX Error: " + textStatus);
        },
        success: function(data, textStatus, jqXHR) {
          var leaftr;
          leaftr = new Leaftr(data, plugin_div, settings);
          return leaftr.display();
        }
      });
    }
  });

  Leaftr = (function() {
    Leaftr.prototype.max_view = 0;

    Leaftr.prototype.min_view = 0;

    function Leaftr(data, div, options) {
      this.data = data;
      this.div = div;
      this.options = options;
      this.div.css({
        'width': this.options.width,
        'height': this.options.height,
        'column-width': '120px',
        '-webkit-column-width': '120px',
        '-webkit-moz-width': '120px'
      });
    }

    Leaftr.prototype.display = function() {
      var nb_element, self, value, _fn, _i, _len, _ref;
      self = this;
      self.getViewMinMax();
      nb_element = 0;
      _ref = this.data.value;
      _fn = function(value) {
        var related, _j, _len1, _ref1, _results;
        _ref1 = value.related;
        _results = [];
        for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
          related = _ref1[_j];
          _results.push((function(related) {
            if (nb_element++ < self.options.max_element) {
              return self.display_div(related);
            }
          })(related));
        }
        return _results;
      };
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        value = _ref[_i];
        _fn(value);
      }
      return $('.leaftr-tile').each(function() {
        $(this).css({
          'width': self.options.related_width
        });
        return $(this).children().css({
          'width': self.options.img_width
        });
      });
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
              if (related.view_count > this.max_view) {
                this.max_view = related.view_count;
              }
              if (this.min_view === 0) {
                this.min_view = related.view_count;
              }
              if (related.view_count < this.min_view) {
                return this.min_view = related.view_count;
              }
            })(related));
          }
          return _results1;
        })(value));
      }
      return _results;
    };

    Leaftr.prototype.display_div = function(tile) {
      var img, name, url;
      img = tile.image_url;
      if (img === void 0) {
        img = 'assets/img/notFound.png';
      }
      url = tile.url;
      name = tile.title;
      if (name === void 0) {
        name = '';
      }
      /*        
      tile_coef = if tile.view_count > 0 then tile.view_count else 1
      console.log tile_coef
      tile_width =  @options.related_width * tile_coef
      */

      if (name.length > this.options.max_title_length) {
        name = name.substr(0, this.options.max_title_length) + '...';
      }
      return this.div.append("<a target='_blank' href='" + url + "'><div class='leaftr-tile'><img src='" + img + "'>" + name + "</div></a>");
    };

    return Leaftr;

  })();

}).call(this);
