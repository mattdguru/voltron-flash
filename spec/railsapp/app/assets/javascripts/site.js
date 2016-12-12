Voltron.addModule('Site', function(){
  return {
    initialize: function(){
      Voltron('Flash/setConfig', {
        bind: '.container',
      });

      setTimeout(function(){
        $.ajax({ url: '/ajax' })
      }, 3000);
    }
  };
}, true);