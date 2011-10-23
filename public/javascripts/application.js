var NAVD = {
  config: {
    current_show: null,
    tablet: false,
    smartphone: false,
    mobile: false
  },
  mainScroller: null,
  mobileMain: null,
  
  init: function(settings) {
    $.extend(NAVD.config, settings);
    if ( NAVD.config.smartphone ) {
      NAVD.smartphoneSetup();
    } else {
      NAVD.setup();
    }
  },

  setup: function() {
    NAVD.enableControls();
    NAVD.enableSearch();
    NAVD.enableTabbedInfoMenus();
    NAVD.enableqTips();
    NAVD.setupCharts();
    NAVD.renderCharts();
    setTimeout(NAVD.asyncSetup, 200);
  },
  asyncSetup: function() {
    NAVD.enableScroller();
    NAVD.load_media(NAVD.config.current_show, false);
  },

  smartphoneSetup: function() {
    setTimeout(NAVD.asyncSmartphoneSetup, 200);
  },
  asyncSmartphoneSetup: function() {
    $(document.body).append('<div id="mobileMain" class="jsTouchPanel" style="position: absolute; left: 0px; top: 0px; border-left: 0px !important;"></div>');
    NAVD.mobileMain = jsTouch.init('mobileMain', { width: 320,  page: '/dashboard/menu' } );
    NAVD.mobile_resize();
    NAVD.enableSmartphonePageLoad();
    document.addEventListener('touchmove', function (e) { e.preventDefault(); }, false);
    document.addEventListener('orientationchange', NAVD.mobile_resize, false);
    window.addEventListener('resize', NAVD.mobile_resize, false);
  },

  mobile_resize: function() {
    var width  = parseInt(window.innerWidth);
  	var height = parseInt(window.innerHeight);
    if (width > 1000 || height > 1000) {
  		NAVD.mobileMain.width = 320;
    } else {
  		NAVD.mobileMain.width = width;
    }
  	jsTouch.resize();
  },

  enableSmartphonePageLoad: function() {
    $('.touch_load').live('click', function() {
      var url = $(this).data('url') || $(this).attr('href');
      var transition = $(this).data('transition') || 'slide-left';
      if (url != "") {
        jsTouch.loadPage(url, { transition: transition });
      }
      return false;
    });
  },

  enableScroller: function() {
    if ( NAVD.config.mobile ) {
      NAVD.mainScroller = new iScroll('container');
    }
  },

  refreshScroller: function() {
    if ( NAVD.mainScroller ) {
      setTimeout(function () {
		    NAVD.mainScroller.refresh();
	    }, 0);
    }
  },

  enableSearch: function() {
    $('#search').bind('submit', function() {
      NAVD.doSearch();
    });
    $('.search .icon').bind('click', function() {
      NAVD.doSearch();
    });
  },

  doSearch: function() {
    var search_params = $('form#search').serializeArray();
    NAVD.load_page('/notes',search_params);
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
    $('.pageload').bind('click', function() {
      var url = $(this).data('url') || $(this).attr('href');
      if (url != "") {
        NAVD.load_page(url);
      }
      return false;
    });
    $('.playmedia').bind('click', function() {
      var number = $(this).data('number');
      if (number != "") {
        NAVD.load_media(number,true);
      }
      return false;
    });
    $('.duffbutton').each(function(index) {
      $(this).parents('form').bind('onsubmit', function() {
        return false;
      });
    });
  },

  enableAjaxLoadedControls: function() {
    $('#content .playmedia').bind('click', function() {
      var number = $(this).data('number');
      if (number != "") {
        NAVD.load_media(number,true);
      }
      return false;
    });
  },

  setLoadingStatus: function() {
    $('#content').html('<div class="loading">Loading...</div>');
  },

  load_page: function(url,params) {
    NAVD.setLoadingStatus();
    NAVD.refreshScroller();
    var pdata = {}
    if(params) pdata = params;
    $.get(url, pdata, function(data) {
      $('#content').html(data);
      NAVD.refreshScroller();
    });
  },
  load_show: function(number) {
    NAVD.setLoadingStatus();
    $.get('/shows/' + number, function(data) {
      $('#content').html(data);
      NAVD.enableAjaxLoadedControls();
      NAVD.renderCharts();
      NAVD.refreshScroller();
    });
  },
  load_media: function(number,autoplay) {
    $.get('/shows/' + number + '/mediawidget', {autoplay: autoplay}, function(data) {
      $('#mediawidget').html(data);
    });
  },
  load_meme: function(id) {
    NAVD.setLoadingStatus();
    $.get('/memes/' + id, function(data) {
      $('#content').html(data);
      NAVD.renderCharts();
      NAVD.refreshScroller();
    });
  },

  enableTabbedInfoMenus: function() {
    $('ul.tabbed_info li').live('click', function () {
      var selectedSection = $(this).attr('data-section');
      $(this.parentNode).find('li').removeClass('selected');
      $(this).addClass('selected');
      var container = $(this.parentNode.parentNode);
      container.find('.section').hide();
      container.find('.section#' + selectedSection).show();
      NAVD.refreshScroller();
      return false;
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
      margins : [10, 10, 20, 40],
      defaultSeries: {
        rounded: 0.6,
        fill: false,
        plotProps: {
          "stroke-width": 4
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
        serie2 : { color : "#ff8000" },
        serie3 : { color : "#80ff80" },
        serie4 : { color : "#00B0ff" },
        serie5 : { color : "#0000ff" }
      },
      defaultAxis : {
        labels : true
      },
      features : {
        grid : {
          draw: [true,true],    // draw both x and y grids
          forceBorder: true,    // force grid for external border
          //ny: 22,             // divisions for y grid
          //nx: 1,              // divisions for x grid
          props: {
              stroke: "#505040" // color for the grid
          }
        },
        legend : {
          horizontal : true,
          x : 0,
          y : -20,
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
    $.elycharts.templates['line_basic_with_legend'] = {
      type : "line",
      margins : [10, 10, 20, 160],
      defaultSeries: {
        rounded: 0.6,
        fill: false,
        plotProps: {
          "stroke-width": 3
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
        serie2 : { color : "#ff8000" },
        serie3 : { color : "#80ff80" },
        serie4 : { color : "#00B0ff" },
        serie5 : { color : "#0000ff" }
      },
      defaultAxis : {
        labels : true
      },
      features : {
        grid : {
          draw: [true,true],    // draw both x and y grids
          forceBorder: true,    // force grid for external border
          //ny: 22,             // divisions for y grid
          //nx: 1,              // divisions for x grid
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
    $.elycharts.templates['donut_basic'] = {
      type : "line",
      margins : [10, 60, 120, 30],
      defaultAxis : {
        labels : true
      },
      axis : {
        x : {
          labelsRotate : -45,
          labelsProps : {
            font : "12px Verdana"
          }
        }
      },
      defaultSeries : {
        type : "bar",
        plotProps : {
          stroke : "black",
          "stroke-width" : 2,
          opacity : 0.6
        },
        highlight : {
          newProps : {
            opacity : 1
          }
        },
        tooltip : {
          frameProps : false,
          height : 20,
          width : 220,
          offset : [10, 30],
          contentStyle : "font-weight: bold"
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
    }
  },
  
  renderCharts: function() {
    $('.chart').each(function(index) {
      var element = $(this);
      var url = element.data('url');
      var options = {
        template: element.data('template')
      };
      $.getJSON(url, {}, function(data) {
        data = $.extend(data, options);
        $(element).chart(data);
      });
    });
  }

};