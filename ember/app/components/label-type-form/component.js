import Ember from 'ember';

export default Ember.Component.extend({
  actions: {
    create: function(){
      this.sendAction();
    },

    update: function(){
      this.sendAction();
    }
  }
});
