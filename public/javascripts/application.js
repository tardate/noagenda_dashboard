var NAVD = {
  config: {},

  init: function(settings) {
    $.extend(NAVD.config, settings);
    NAVD.setup();
  },

  setup: function() {
    NAVD.enableControls();
    NAVD.enableqTips();
    NAVD.setupCharts();
  },

  enableControls: function() {
    $('#switch_show_id').bind('change', function() {
      var val = $(this).val();
      if (val != "") {
        $('#switch_meme_id').val('');
        NAVD.load_show(val);
      }
      return false;
    });
    $('#switch_meme_id').bind('change', function() {
      var val = $(this).val();
      if (val != "") {
        $('#switch_show_id').val('');
        NAVD.load_meme(val);
      }
      return false;
    });
  },
  load_show: function(number) {
    $.get('/shows/' + number, function(data) {
      $('#content').html(data);
    });
  },
  load_meme: function(id) {
    $.get('/memes/' + id, function(data) {
      $('#content').html(data);
    });
  },

  enableqTips: function() {
    // match all anchors with titles
    $('a[title]').qtip();
    

   $('.menu_tip').delegate('.menu', 'mouseover', function(event) {
      var self = $(this),
         qtip = '.qtip.ui-tooltip',
         container = $(event.liveFired),
         submenu = self.next('ul');

      if(!submenu.length) { return false; }
      
      if(self.hasClass('mtc')) {
        position = { my: 'bottom center', at: 'top center', container: container } ;
      } else {
        position = { my: 'top center', at: 'bottom center', container: container } ;
      }
   
      // Create the tooltip
      self.qtip({
        overwrite: false, // Make sure we only render one tooltip
        content: {
          text: self.next('ul')// Use the submenu as the qTip content
        },
        position: position,
        show: {
          event: event.type, // Make sure to sue the same event as above
           ready: true, // Make sure it shows on first mouseover
           solo: container
        },
        hide: {
           delay: 100,
           event: 'unfocus mouseleave',
           fixed: true // Make sure we can interact with the qTip by setting it as fixed
        },
        style: {
           classes: 'ui-tooltip-youtube ui-tooltip-rounded', // Basic styles
           tip: true
        },
        events: {
          // Toggle an active class on each menus activator
          toggle: function(event, api) {
            api.elements.target.toggleClass('active', event.type === 'tooltipshow');
          }
        }
      });
    });
  },

  setupCharts: function() {
    $.elycharts.templates['line_basic'] = {
      type : "line",
      margins : [10, 10, 20, 160],
      defaultSeries: {
        rounded: 0.6,
        fill: false,
        plotProps: {
            "stroke-width": 2
        },
        dot: true,
        dotProps: {
            stroke: "white",
            "stroke-width": 2
        },
        highlight : {
          scale : 2
        }
      },
      series : {
        serie1 : { color : "#ff0000" },
        serie2 : { color : "#ff4000" },
        serie3 : { color : "#ff8000" },
        serie4 : { color : "#ffB000" },
        serie5 : { color : "#ff0080" },
        serie6 : { color : "#8000ff" },
        serie7 : { color : "#00B0ff" },
        serie8 : { color : "#0080ff" },
        serie9 : { color : "#0040ff" },
        serie10 : { color : "#0000ff" }
      },
      defaultAxis : {
        labels : true
      },
      features : {
        grid : {
          draw: [true,true],
          // draw both x and y grids
          forceBorder: true,
          // force grid for external border
          //ny: 22,
          // use 10 divisions for y grid
          //nx: 1,
          // 10 divisions for x grid
          props: {
              stroke: "#505040" // color for the grid
          }
        },
                
        legend : {
          horizontal : false,
          width : 140,
          height : 160,
          x : 0,
          y : 5,
          dotType : "circle",
          dotProps : {
            stroke : "white",
            "stroke-width" : 2
          },
          borderProps : {
            opacity : 0,
            //fill : "#c0c0c0",
            "stroke-width" : 0,
            "stroke-opacity" : 0
          }
        }
      }
    };

  },

  drawTop10: function(element) {
    $.getJSON('/memes/stats.json', {}, function(data) {
      $(element).chart(data);
    });
  }

};