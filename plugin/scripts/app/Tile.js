// Generated by CoffeeScript 1.6.3
(function() {
  define(function() {
    var Tile;
    return Tile = (function() {
      Tile.prototype.clss = '';

      function Tile(data, parent, offset) {
        this.parent = parent;
        this.offset = offset;
        this.view_count = data.view_count;
        this.img = data.image_url;
        if (this.img === void 0) {
          this.img = '../assets/img/notFound.png';
        }
        this.url = data.url;
        this.name = data.title;
        if (this.name === void 0) {
          this.name = '';
        }
      }

      Tile.prototype.display = function() {
        return parent.append("<a target='_blank' href='" + this.url + "' id='item" + this.offset + "'><div class='" + this.clss + "'><img src='" + this.img + "'><div class='item-hover'><p><strong>" + this.name + "</strong></p></div></div></a>");
      };

      return Tile;

    })();
  });

}).call(this);
