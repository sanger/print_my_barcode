import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('header-partial', 'Integration | Component | header partial', {
  integration: true
});

test('it renders', function(assert) {
  assert.expect(1);

  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });

  // Template block usage:
  this.render(hbs`
    {{#header-partial}}
      template block text
    {{/header-partial}}
  `);

  assert.ok('header:contains("template block text")');
});
