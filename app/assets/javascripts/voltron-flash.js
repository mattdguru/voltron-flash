//= require voltron

Voltron.addModule('Flash', function(){
  var _initialized = false;

  var _defaults = {
    class: '',
    bind: 'body',
    id: 'flashes',
    containerClass: '',
    addMethod: 'prepend',
    revealMethod: 'slideDown',
    revealTime: 200,
    concealMethod: 'slideUp',
    concealTime: 200,
    autoClose: false,
    autoCloseAfter: 5000,
    autoAdd: true
  };

  return {
    initialize: function(){
      if(!_initialized){
        _initialized = true;
        Voltron('Dispatch/addEventWatcher', 'click');
        this.addListener();
      }
    },

    onClickCloseFlash: function(o){
      this.clear(o, $(o.element).data('flash-options') || {});
    },

    setConfig: function(options){
      _defaults = $.extend(_defaults, options);
      this.afterConfigChange();
      return this;
    },

    addListener: function(){
      var self = this;
      $(document).ajaxComplete(function(event, request){
        var flashes = request.getResponseHeader(Voltron.getConfig('flash/header', 'X-Flash'));
        var flash = $.parseJSON(flashes);
        Voltron.dispatch('flash:received', { event: event, request: request, flash: self, flashes: flash });
        if(_defaults.autoAdd && flash){
          Voltron('Flash/new', flash);
        }
      });
    },

    new: function(flashes, options){
      options = $.extend(_defaults, options);
      var flash;

      this.getContainer(options).addClass(options.containerClass);

      $.each(flashes, $.proxy(function(type, messages){
        flash = this.addFlash(type, messages, options);

        flash.addClass(options.class);

        if(flash.find('.flash-message').length == 1){
          // If this is the first flash message, reveal the whole container
          flash.find('.flash-message').show();
          flash[options.revealMethod](options.revealTime);
        }else{
          // Otherwise reveal just the newest message(s)
          flash.find('.flash-message')[options.revealMethod](options.revealTime);
        }

        if(options.autoClose){
          setTimeout(function(){
            V('Flash/clear', { element: flash });
          }, options.autoCloseAfter);
        }
      }, this));

      return this;
    },

    addFlash: function(type, messages, options){
      var flash = this.getFlash(type, options);

      flash.append($.map($.makeArray(messages), function(message){
        return $('<p />', { class: 'flash-message' }).html(message).hide();
      }));

      if(!Voltron.getConfig('flash/group') || !flash.find('.flash-close').length){
        flash.append($('<button />', { class: 'flash-close', type: 'button', id: 'close-' + type, 'data-dispatch': 'flash:click/close_flash' }));
      }

      if(!this.getContainer(options).length){
        Voltron.debug('warn', 'Element with which to bind flash messages to could not be found. The bind selector given was %o. Please ensure an element matching the given selector exists.', options.bind);
      }

      this.getContainer(options).append(flash);
      return flash;
    },

    getFlash: function(type, options){
      if(Voltron.getConfig('flash/group') && $('.flash.' + type).length){
        return $('.flash.' + type).first();
      }
      return $('<div />', { class: ['flash', type].join(' ') }).hide();
    },

    getContainer: function(options){
      if(options.addMethod == 'after'){
        if(!$(options.bind).next('#' + options.id).length){
          $(options.bind)[options.addMethod]($('<div />', { id: options.id, class: options.containerClass }));
        }
        return $(options.bind).next('#' + options.id);
      }else if(options.addMethod == 'before'){
        if(!$(options.bind).prev('#' + options.id).length){
          $(options.bind)[options.addMethod]($('<div />', { id: options.id, class: options.containerClass }));
        }
        return $(options.bind).prev('#' + options.id);
      }else{
        if(!$(options.bind).find('#' + options.id).length){
          $(options.bind)[options.addMethod]($('<div />', { id: options.id, class: options.containerClass }));
        }
        return $(options.bind).find('#' + options.id);
      }
    },

    clear: function(o, options){
      if(o && o.element){
        // If o.element exists, it's the button that was clicked,
        // in which case, remove the closest flash message
        o.options = $.extend(_defaults, options);
        $(o.element).closest('.flash')[o.options.concealMethod](o.options.concealTime, function(){
          $(this).remove();
          // If we removed the last flash message, also remove the container
          if($('#' + o.options.id).find('.flash').length == 0){
            $('#' + o.options.id).remove();
          }
        });
      }else{
        // .clear() was called presumably with no arguments,
        // in which case hide and remove the entire flashes container element
        options = $.extend(_defaults, options);
        $('#' + options.id)[options.concealMethod](options.concealTime, function(){
          $(this).remove();
        });
      }
    },

    afterConfigChange: function(){
      if(_defaults.autoClose && $('#' + _defaults.id + ' .flash').length){
        var elements = $('#' + _defaults.id + ' .flash');
        setTimeout(function(){
          Voltron('Flash/clear', { element: elements });
        }, _defaults.autoCloseAfter);
      }
    }
  };
}, true);
