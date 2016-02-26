import DS from 'ember-data';

export default DS.Model.extend({
  name: DS.attr('string'),
  labelType: DS.belongsTo('label-type'),
  labels: DS.hasMany('label')
});
