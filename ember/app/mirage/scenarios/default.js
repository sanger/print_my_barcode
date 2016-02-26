export default function(server) {

  // Seed your development database using your factories. This
  // data will not be loaded in your tests.

  // server.createList('contact', 10);
  server.createList('label_type', 10);
  server.createList('label_template', 5);
}
