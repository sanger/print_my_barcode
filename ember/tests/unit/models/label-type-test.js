import { moduleForModel, test } from 'ember-qunit';

moduleForModel('label-type', 'Unit | Model | label type', {
  // Specify the other units that are required for this test.
  needs: ['model:label-template']
});

test('it exists', function(assert) {
  var model = this.subject();
  // var store = this.store();
  assert.ok(!!model);
});
