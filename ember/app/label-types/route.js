import Ember from 'ember';

export default Ember.Route.extend({

  model: function() {
    return this.store.find('label-type');
  },

  actions: {
    close: function() {
      this.transitionTo('label_types');
    }
  }

});
