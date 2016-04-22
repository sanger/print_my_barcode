import Mirage from 'ember-cli-mirage';

export default function() {
  this.namespace = 'v1';

  // Label Types
  this.get('/label_types');
  this.get('/label_types/:label_type_id');
  this.get('/label_types/:label_type_id/edit');

  this.post('/label_types', function(db, request) {
    var params = JSON.parse(request.requestBody);
    if (params.label_type.name === null) {
      return new Mirage.Response(422, {}, { errors:{ name:["can't be blank"]}});
    }
    var label_type = db.label_types.insert(params);
    return {label_type: label_type};
  });

  this.put('/label_types/:label_type_id', function(db, request) {
    var label_type_id = request.params.label_type_id;
    var params = JSON.parse(request.requestBody);
   if (params.label_type.name === null) {
      return { errors:{ name:["can't be blank"]}};
    }
    var label_type = db.label_types.update(label_type_id, params.label_type);
    return {label_type: label_type};
  });

  // Label Templates
  this.get('label_templates');
  this.get('label_templates/:label_template_id');

  // These comments are here to help you get started. Feel free to delete them.

  /*
    Config (with defaults).

    Note: these only affect routes defined *after* them!
  */
  // this.urlPrefix = '';    // make this `http://localhost:8080`, for example, if your API is on a different server
  // this.namespace = '';    // make this `api`, for example, if your API is namespaced
  // this.timing = 400;      // delay for each request, automatically set to 0 during testing

  /*
    Route shorthand cheatsheet
  */
  /*
    GET shorthands

    // Collections
    this.get('/contacts');
    this.get('/contacts', 'users');
    this.get('/contacts', ['contacts', 'addresses']);

    // Single objects
    this.get('/contacts/:id');
    this.get('/contacts/:id', 'user');
    this.get('/contacts/:id', ['contact', 'addresses']);
  */

  /*
    POST shorthands

    this.post('/contacts');
    this.post('/contacts', 'user'); // specify the type of resource to be created
  */

  /*
    PUT shorthands

    this.put('/contacts/:id');
    this.put('/contacts/:id', 'user'); // specify the type of resource to be updated
  */

  /*
    DELETE shorthands

    this.del('/contacts/:id');
    this.del('/contacts/:id', 'user'); // specify the type of resource to be deleted

    // Single object + related resources. Make sure parent resource is first.
    this.del('/contacts/:id', ['contact', 'addresses']);
  */

  /*
    Function fallback. Manipulate data in the db via

      - db.{collection}
      - db.{collection}.find(id)
      - db.{collection}.where(query)
      - db.{collection}.update(target, attrs)
      - db.{collection}.remove(target)

    // Example: return a single object with related models
    this.get('/contacts/:id', function(db, request) {
      var contactId = +request.params.id;

      return {
        contact: db.contacts.find(contactId),
        addresses: db.addresses.where({contact_id: contactId});
      };
    });

  */
}

/*
You can optionally export a config that is only loaded during tests
export function testConfig() {

}
*/
