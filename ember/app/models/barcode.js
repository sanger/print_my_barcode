import Drawing from './drawing';
import DS from 'ember-data';

export default Drawing.extend({
  barcodeType: DS.attr('string'), 
  oneModuleWidth: DS.attr('string'), 
  height: DS.attr('string'), 
  rotationalAngle: DS.attr('string'), 
  oneCellWidth: DS.attr('string'), 
  typeOfCheckDigit: DS.attr('string')
});
