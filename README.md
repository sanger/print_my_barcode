# Print My Barcode

Barcode printing service

## Set up a development environment

1. Create an empty database

   ```sh
   rake db:create
   ```

1. Load the schema

   ```sh
   rake db:schema:load
   ```

1. Run migrations

   ```sh
   rake db:migrate
   ```

## Running in Docker

### Application

To run the application in Docker for development, build the image and run it with the command below:

```sh
docker build . -t print_my_barcode && docker run --rm -p 3000:3000 print_my_barcode
```

### CUPS Server

Print my barcode requires a CUPS server to send the printing jobs, that can be
specified with the environment variable CUPSD_SERVER_NAME for the Docker container context:

Eg:

CUPSD_SERVER_NAME=localhost:631 docker run pmb

If not specified, it will use the default value will localhost:631.

Test the connectivity with the Cups server using lpstat -r

Test that printers are detected using lpstat -v

## Using the APIs

### V2 API

Support for both Toshiba and Squix printers. When it receives a request, PMB looks at the printer name it is passed in the request, and determines whether it's a Toshiba or a Squix (`printers` database table, `printer_type` column). It then handles the printing itself for Toshibas, or sends a request to SPrint (https://github.com/sanger/sprint) for Squixes.
The same templates (`label_templates` and `label_types` tables) can be used with both types of printer.

More complete details can be found on the [Confluence Article - Understanding Label Printing](https://ssg-confluence.internal.sanger.ac.uk/display/PSDPUB/Understanding+Label+Printing), under the heading _PMB v2_.

#### Print Job Example

To submit a print job, send a POST request to the `/v2/print_jobs` endpoint.  
The headers should include `Content-Type: application/vnd.api+json`.

The request body should be a JSON object with the following structure:

```json
{
  "print_job": {
    "printer_name": "stub",
    "label_template": "traction_tube_label_template",
    "label_template_name": "traction_tube_label_template",
    "labels": [
      {
        "barcode": "TRAC-2-4-N1",
        "first_line": "15-Sep-22",
        "second_line": "TRAC-2-4-N1",
        "third_line": "",
        "label_name": "main_label"
      }
    ],
    "copies": "1"
  }
}
```

### V1 API

This API is regarded as deprecated. Please use the V2 API instead.

Support for Toshiba printers only.

Print job POST request bodies will look something like this:

```
{
  "data": {
    "attributes": {
      "printer_name": "stub",
      "label_template_id": "1",
      "labels": {
        "body": [{
          "main_label": {
            "pipeline": "SAPHYR",
            "date": "15-Sep-22",
            "round_label_top_line": "",
            "round_label_bottom_line": "",
            "barcode_text": "TRAC-2-3",
            "barcode": "TRAC-2-3"
          }
        }]
      }
    }
  }
}
```

See documentation on port `9292`, endpoint `/v1`.
