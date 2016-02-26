// app/mirage/factories/label_type.js
import Mirage/*, {faker}*/ from 'ember-cli-mirage';

export default Mirage.Factory.extend({
  name(i) { return `Label Type ${i}`; },
  pitch_length: "0110",
  print_width: "0920",
  print_length: "0080",
  feed_value: "08",
  fine_adjustment: "004"
});
