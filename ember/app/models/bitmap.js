import Drawing from './drawing';
import DS from 'ember-data';

export default Drawing.extend({
  horizontalMagnification: DS.attr('string'), 
  verticalMagnification: DS.attr('string'), 
  font: DS.attr('string'), 
  spaceAdjustment: DS.attr('string'), 
  rotationalAngles: DS.attr('string')
});
