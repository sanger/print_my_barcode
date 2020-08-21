# print_my_barcode
Barcode printing service

## Set up a development environment

1. Create an empty database

```rake db:create```

1. Load the schema

```rake db:schema:load```

1. Run migrations

```rake db:migrate```

## Running in Docker

Print my barcode requires a CUPS server to send the printing jobs, that can be
 specified with the environment variable CUPSD_SERVER_NAME for the Docker container context:

Eg:
 
CUPSD_SERVER_NAME=localhost:631 docker run pmb

If not specified, it will use the default value will localhost:631.