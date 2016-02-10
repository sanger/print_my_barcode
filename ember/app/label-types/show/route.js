import Ember from 'ember';

export default Ember.Route.extend({

  renderTemplate: function() {
    this.render({ outlet: 'show' });
  },

  model: function(params) {
    return this.store.find('label-type', params.label_type_id);
  }
});
