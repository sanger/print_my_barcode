// app/mirage/factories/label.js
import Mirage/*, {faker}*/ from 'ember-cli-mirage';

export default Mirage.Factory.extend({
  name(i) { return `label_${i}`;}
});