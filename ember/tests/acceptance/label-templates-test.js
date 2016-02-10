import { test } from 'qunit';
import moduleForAcceptance from 'print-my-barcode/tests/helpers/module-for-acceptance';

moduleForAcceptance('Acceptance | label templates');

test('visiting /label-templates', function(assert) {
  visit('/label_templates');

  andThen(function() {
    assert.equal(currentURL(), '/label_templates');
  });
});
