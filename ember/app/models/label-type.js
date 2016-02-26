import DS from 'ember-data';

export default DS.Model.extend({
  name: DS.attr('string'),
  pitchLength: DS.attr('string'),
  printWidth: DS.attr('string'),
  printLength: DS.attr('string'),
  feedValue: DS.attr('string'),
  fineAdjustment: DS.attr('string'),
  labelTemplates: DS.hasMany('label-template')
});
