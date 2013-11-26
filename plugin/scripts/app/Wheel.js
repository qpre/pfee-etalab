// Generated by CoffeeScript 1.6.3
(function() {
  define(['jquery'], function($) {
    var Wheel;
    return Wheel = (function() {
      Wheel.prototype.parent = null;

      function Wheel(parent) {
        this.parent = parent;
      }

      Wheel.prototype.display = function() {
        return this.parent.append("<img id='leaftr-wheel' src='assets/img/loading.gif'>");
      };

      Wheel.prototype.hide = function() {
        return $('#leaftr-wheel').remove();
      };

      return Wheel;

    })();
  });

}).call(this);
