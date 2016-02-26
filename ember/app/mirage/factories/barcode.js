// app/mirage/factories/bitmap.js
import Mirage/*, {faker}*/ from 'ember-cli-mirage';

export default Mirage.Factory.extend({
  field_name(i) { return `barcode_${i}`;},
  x_origin: "0300", 
  y_origin: "0000", 
  barcode_type: "9", 
  one_module_width: "02", 
  height: "0070"
});