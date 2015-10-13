import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

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

test('it should output the label and input', function(assert) {

  this.render(hbs`{{form-field label='myLabel' type='text' value="some text"}}`);

  assert.equal(this.$('label').text().trim(), "myLabel");

  var input = this.$('input');
  assert.equal(input.attr('type'), "text");
  assert.equal(input.attr('id'), "myLabel");
  
});

test('it should output the errors', function(assert) {

  var errors = [ { message: "cant be blank" } ];
  this.set('errors', errors);
  this.render(hbs`{{form-field label='myLabel' type='text' value="some text" errors=errors}}`);

  console.log(this.$('li').html());
  
  assert.equal(this.$('.error').length, 1);
});

