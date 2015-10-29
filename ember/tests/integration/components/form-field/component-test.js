import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';
import Ember from 'ember';

moduleForComponent('form-field', 'Integration | Component | form field', {
  integration: true,

});

test('it renders', function(assert) {
  assert.expect(2);

  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });

  this.render(hbs`{{form-field}}`);

  assert.equal(this.$().text().trim(), '');

  // Template block usage:
  this.render(hbs`
    {{#form-field}}
      template block text
    {{/form-field}}
  `);

  assert.equal(this.$().text().trim(), 'template block text');
});

test("it should output the correct attributes", function(assert) {

  var model = Ember.Object.create({
    attrA: "a",
    attrB: "b",
    attrC: "c",
    errors: Ember.Object.create({
      attrC: [ { message: "cant be blank" } ]
    })
  });

  this.set('model', model);

  this.set('for', 'attrA');
  this.render(hbs`{{form-field for=for type='text' model=model}}`);
  assert.equal(this.$('label').text().trim(), "Attr A");

  var input = this.$('input');
  assert.equal(input.attr('type'), "text");
  assert.equal(input.attr('id'), "attrA");

  this.set('for', 'attrC');
  this.render(hbs`{{form-field for=for type='text' model=model}}`);
  assert.equal(this.$('label').text().trim(), "Attr C");

  assert.equal(this.$('.error').length, 1);

});