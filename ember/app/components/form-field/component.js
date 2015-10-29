import Ember from 'ember';

export default Ember.Component.extend({
  tagName: 'li',
  classNameBindings: ['hasErrors:error'],
  hasErrors: false,

  setValues: function() {
    var label = this.get('for');

    if(label){
      this.setProperties({
        label: label,
        labelText: label.split(/(?=[A-Z])/).join(' ').capitalize(),
        value: Ember.computed.alias('model.' + label),
        errors: Ember.computed.alias('model.errors.' + label),
        hasErrors: Ember.computed.notEmpty('errors')
      });

    }

  }.on("init")

});
