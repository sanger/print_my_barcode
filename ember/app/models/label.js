import DS from 'ember-data';

export default DS.Model.extend({
  name: DS.attr('string'),
  bitmaps: DS.hasMany('bitmap'),
  barcodes: DS.hasMany('barcodes')
});
