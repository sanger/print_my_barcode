import Ember from 'ember';

export default Ember.Component.extend({
  tagName: 'canvas',
  width: 200,
  height: 200,
  attributeBindings: ['width','height'],

  didInsertElement: function() {
    var ctx = this.get('element').getContext('2d');
    ctx.fillStyle = "#000";
    ctx.fillRect(0, 0, this.get('width'), this.get('height'));
  }
});
