import Ember from 'ember';
import { module, test } from 'qunit';
import startApp from 'print-my-barcode/tests/helpers/start-app';

module('Acceptance | label types', {

  beforeEach: function() {
    this.application = startApp();
  },

  afterEach: function() {
    Ember.run(this.application, 'destroy');
  }
});

test('visiting /label_types', function(assert) {
  visit('/label_types');

  andThen(function() {
    assert.equal(currentURL(), '/label_types');
    assert.equal(find('h3').text().trim(), "Label Types");
  });
});

test('Should list all label types', function(assert) {
  server.createList('label_type', 5);
  visit('/label_types');

  andThen(function() {
    assert.equal(find('a:contains("Label Type")').length, 5);
  });
});

test("Should be able to navigate to a label type page", function(assert) {
  var label_type = server.create('label_type');
  visit('/label_types');
  click('a:contains(' + label_type.name + ')');

  andThen(function() {
    assert.ok(find('div:contains("pitch length: ' + label_type.pitchLength + '")'));
    assert.ok(find('div:contains("print width: ' + label_type.printWidth + '")'));
    assert.ok(find('div:contains("print length: ' + label_type.printLength + '")'));
    assert.ok(find('div:contains("feed value: ' + label_type.feedValue + '")'));
    assert.ok(find('div:contains("fine adjustment: ' + label_type.fineAdjustment + '")'));
  });
});

test('Should be able visit a label type page', function(assert) {
  var label_type = server.create('label_type');
  visit('/label_types/' + label_type.id);

  andThen(function() {
    assert.equal(find('h4').text(), label_type.name);
  });
});

test('Should be able to visit a new label type', function(assert){
  visit('label_types/new');

  andThen(function() {
    assert.equal(find('h4').text(), 'New Label Type');
  });
});

test('Should be able to create a new label type', function(assert){
  visit('label_types/new');

  andThen(function() {
    fillIn(find('input#name'), 'Label Type 1');
    fillIn(find('input#pitch-length'), "0110");
    fillIn(find('input#print-width'), "0920");
    fillIn(find('input#print-length'), "0080");
    fillIn(find('input#feed-value'), "08");
    fillIn(find('input#fine-adjustment'), "004");
    click('button[type=submit]');

    andThen(function() {
      assert.equal(find("a:contains('Label Type 1')").length, 1);
      click('a:contains("Label Type 1")');

      andThen(function() {
        assert.ok(find('div:contains("pitch length: 0110")'));
        assert.ok(find('div:contains("print width: 0920")'));
        assert.ok(find('div:contains("print length: 0080")'));
        assert.ok(find('div:contains("feed value: 08")'));
        assert.ok(find('div:contains("fine adjustment: 004")'));
      });
    });
  });
});

test('Should be able to edit an existing label type', function(assert){
  var label_type = server.create('label_type');
  visit('/label_types/' + label_type.id + '/edit');

  andThen(function() {
    fillIn(find('input#name'), 'Updated label type');
    click('button[type=submit]');
     andThen(function() {
        assert.equal(find("a:contains('Updated label type')").length, 1);
     });
  });
  
});
