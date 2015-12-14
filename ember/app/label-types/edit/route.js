import Ember from 'ember';

export default Ember.Route.extend({
  renderTemplate: function() {
    this.render({ 
      outlet: 'form'
    });
  },

  model: function(params) {
    return this.store.find('label-type', params.label_type_id);
  },

  deactivate: function(){
    this.get('currentModel').rollback();
  },

  actions: {
    update: function(){
      var label_type = this.get('currentModel');
      label_type.save().then(() => {
        console.log('label type updated');
        this.transitionTo('label_types');
      }, function() {
        console.log('there was an error');
      });
    }

  }
});
