import Ember from 'ember';

export default Ember.Route.extend({
  model: function(params) {
    return this.store.find('label-type', params.label_type_id);
  },

  actions: {
    update: function(){
      var label_type = this.get('currentModel');
      label_type.save().then(() => {
        console.log('label type created');
      }, function() {
        console.log('there was an error');
      });
    }
  }
});
