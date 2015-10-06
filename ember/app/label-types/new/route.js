import Ember from 'ember';

export default Ember.Route.extend({

  model: function() {
    return this.store.createRecord('label-type');
  },

  actions: {
    create: function(){
      var label_type = this.get('currentModel');
      label_type.save().then(() => {
        console.log('label type created');
      }, function() {
        console.log('there was an error');
      });
    }
  }
});
