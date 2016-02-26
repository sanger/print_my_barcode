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
  });
});

test('Should list all label types', function(assert) {
  var label_types = server.createList('label_type', 5);
  visit('/label_types');

  andThen(function() {
    assert.equal(find('tr').length, label_types.length+1);

    label_types.forEach(function(label_type){
      andThen(function() {
        assert.ok(find('td:contains("' + label_type.name + '")'));
      });
    });
  });

});

test("Should be able to navigate to a label type page", function(assert) {
  var label_type = server.create('label_type');
  visit('/label_types/' + label_type.id);

  andThen(function() {
    assert.ok(find('div:contains("pitch length: ' + label_type.pitchLength + '")'));
    assert.ok(find('div:contains("print width: ' + label_type.printWidth + '")'));
    assert.ok(find('div:contains("print length: ' + label_type.printLength + '")'));
    assert.ok(find('div:contains("feed value: ' + label_type.feedValue + '")'));
    assert.ok(find('div:contains("fine adjustment: ' + label_type.fineAdjustment + '")'));
  });
});

test('Should be able to visit a label type page', function(assert) {
  var label_type = server.create('label_type');
  visit('/label_types/' + label_type.id);

  andThen(function() {
    assert.equal(find('h4').text(), label_type.name);
  });
});

test('Should be able to create a new label type', function(assert){
  visit('label_types');
  click('button:contains("+")');

  andThen(function() {
    fillIn(find('input#name'), 'Label Type 1');
    fillIn(find('input#pitchLength'), "0110");
    fillIn(find('input#printWidth'), "0920");
    fillIn(find('input#printLength'), "0080");
    fillIn(find('input#feedValue'), "08");
    fillIn(find('input#fineAdjustment'), "004");
    click('button[type=submit]');

    andThen(function() {
      visit('label_types/1');

      andThen(function() {
        assert.equal(find('h4').text(), 'Label Type 1');
        assert.ok(find('div:contains("pitch length: 0110")'));
        assert.ok(find('div:contains("print width: 0920")'));
        assert.ok(find('div:contains("print length: 0080")'));
        assert.ok(find('div:contains("feed value: 08")'));
        assert.ok(find('div:contains("fine adjustment: 004")'));
      });
    });
  });
});

test('Should return an error if the label type has incorrect attributes', function(assert){

  visit('label_types/new');

  andThen(function() {
    fillIn(find('input#pitchLength'), "0110");
    fillIn(find('input#printWidth'), "0920");
    fillIn(find('input#printLength'), "0080");
    fillIn(find('input#feedValue'), "08");
    fillIn(find('input#fineAdjustment'), "004");
    click('button[type=submit]');

    andThen(function() {
      assert.notEqual(find(".error").html().search('can\'t be blank'), -1);
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
        assert.equal(find("td:contains('Updated label type')").length, 1);
     });
  });
  
});
