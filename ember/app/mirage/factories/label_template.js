// app/mirage/factories/label_template.js
// import Mirage/*, {faker}*/ from 'ember-cli-mirage';
import Mirage/*, {faker}*/ from 'ember-cli-mirage';

export default Mirage.Factory.extend({
  name(i) { return `Label Template ${i}`;}
});