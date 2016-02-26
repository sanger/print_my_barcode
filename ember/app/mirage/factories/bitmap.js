// app/mirage/factories/bitmap.js
import Mirage/*, {faker}*/ from 'ember-cli-mirage';

export default Mirage.Factory.extend({
  field_name(i) { return `bitmap_${i}`;},
  x_origin: "0030", 
  y_origin: "0035", 
  horizontal_magnification: "05", 
  vertical_magnification: "1", 
  font: "G", 
  space_adjustment: "00", 
  rotational_angles: "00"
});