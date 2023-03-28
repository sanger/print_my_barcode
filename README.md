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

Test the connectivity with the Cups server using lpstat -r

Test that printers are detected using lpstat -v

## Using the APIs

### V2 API

Support for both Toshiba and Squix printers. When it receives a request, PMB looks at the printer name it is passed in the request, and determines whether it's a Toshiba or a Squix (`printers` database table, `printer_type` column). It then handles the printing itself for Toshibas, or sends a request to SPrint (https://github.com/sanger/sprint) for Squixes.
The same templates (`label_templates` and `label_types` tables) can be used with both types of printer.

Print job POST request bodies will look something like this:

```
{
  "print_job": {
    "printer_name": "stub",
    "label_template_name": "traction_tube_label_template",
    "labels": [{
      "barcode": "TRAC-2-4-N1",
      "first_line": "15-Sep-22",
      "second_line": "TRAC-2-4-N1",
      "third_line": "",
      "label_name": "main_label"
    }],
    "copies": "1"
  }
}
```

#### Headers

Content-Type: application/vnd.api+json

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
