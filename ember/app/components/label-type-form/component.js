import Ember from 'ember';

export default Ember.Component.extend({
  tagName: 'section',

  actions: {

    submit: function(){
      this.sendAction('action');
    },

    close: function(){
      this.sendAction('close');
    }
  }
});
