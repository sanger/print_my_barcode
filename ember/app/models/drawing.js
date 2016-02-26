import DS from 'ember-data';

export default DS.Model.extend({
  fieldName: DS.attr('string'),
  xOrigin: DS.attr('string'),
  yOrigin: DS.attr('string')
});
