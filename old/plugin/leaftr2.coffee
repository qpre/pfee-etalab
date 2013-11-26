require.config({
    baseUrl: 'js/lib',
    paths: {
        jquery: 'jquery'
    }
});

require(['tile'], (Tile) ->
  jquery.fn.extend
      leaftr: (options) ->
         Tile.display()
);
