var NAVD = {
  config: {},

  init: function(settings) {
    $.extend(NAVD.config, settings);
    NAVD.setup();
  },

  setup: function() {
    NAVD.enableControls();
    NAVD.enableqTips();
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
    

   $('.menu_tip').delegate('a.menu', 'mouseover', function(event) {
      var self = $(this),
         qtip = '.qtip.ui-tooltip',
         container = $(event.liveFired),
         submenu = self.next('ul');

      if(!submenu.length) { return false; }
      
      position = { my: 'top center', at: 'bottom center' } ;
   
      // Create the tooltip
      self.qtip({
         overwrite: false, // Make sure we only render one tooltip
         content: {
            text: self.next('ul')// Use the submenu as the qTip content
         },
         position: $.extend(true, position, {
            // Append the nav tooltips to the #navigation element (see show.solo below)
            container: container,
 
            // We'll make sure the menus stay visible by shifting/flipping them back into the viewport
            viewport: $(window), adjust: { method: 'shift flip' }
         }),
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
            tip: true // We don't want a tip... it's a menu duh!
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


};