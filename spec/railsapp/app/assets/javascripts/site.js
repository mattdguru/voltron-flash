Voltron.addModule('Site', function(){
  return {
    initialize: function(){
      Voltron('Flash/setConfig', {
        bind: 'body'
      });

      setTimeout(function(){
        $.ajax({ url: '/ajax' })
      }, 3000);
    }
  };
}, true);