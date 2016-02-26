import { test } from 'qunit';
import moduleForAcceptance from 'print-my-barcode/tests/helpers/module-for-acceptance';

moduleForAcceptance('Acceptance | label templates');

test('visiting /label-templates', function(assert) {
  visit('/label_templates');

  andThen(function() {
    assert.equal(currentURL(), '/label_templates');
  });
});

test('Should list all label templates', function(assert) {
  let labelTemplates = server.createList('label_template', 5);
  visit('/label_templates');

  andThen(function() {
    assert.equal(find('tr').length, labelTemplates.length+1);

    labelTemplates.forEach(function(labelTemplate){
      andThen(function() {
        assert.equal(find('#label_template_' + labelTemplate.id + ' td:first').text(),labelTemplate.name);
      });
    });
  });

});
