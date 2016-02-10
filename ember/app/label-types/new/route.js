import Ember from 'ember';

export default Ember.Route.extend({

  renderTemplate: function() {
    this.render({ outlet: 'form' });
  },


  model: function() {
    return this.store.createRecord('label-type');
  },

  deactivate: function(){
    this.get('currentModel').rollback();
  },

  actions: {
    create: function(){
      var label_type = this.get('currentModel');
      label_type.save().then(() => {
        console.log('label type created');
        this.transitionTo('label_types');
      }, function() {
        console.log('there was an error');
      });
    }

  }
});
