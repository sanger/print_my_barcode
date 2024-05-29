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
docker build . -t print_my_barcode && docker run --rm -p 9292:3000 print_my_barcode
```

Then browse to http://localhost:9292/v2

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

In addition, V2 uses exactly the same `PrintersController` and `LabelTemplatesController` as in V1. However, the print job has been simplified so that the client can select a printer without needing to know if it is a Toshiba or a Squix, as they operate quite differently.
If the printer is Squix it will create a squix specific print job and forward it on to SPrint.

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

Prints directly to Toshiba printers. No other printer types (or brands) are supported.

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

For more details, see the built-in API 1 documentation at http://localhost:9292/v1

## Notes

### Concepts

<dl>
  <dt>Printer</dt>
  <dd>A printer is a physical device that can print labels. It is represented in the database by a record in the `printers` table.</dd>

  <dt>Label Type</dt>
  <dd>The "paper" used by the printer. It defines the size of the physical label, the pitch between labels on a roll, and other physical properties. It is represented in the database by a record in the `label_types` table.</dd>

  <dt>Label Template</dt>
  <dd>A label template defines the layout of the data on the physical label.</dd>

  <dt>Label</dt>
  <dd>A collection of fields that are printed on a label. Includes bitmaps, barcodes, and text. Ideally, there should be one label template for each Label type (384/96/tube etc). It is represented in the database by a record in the `labels` table.</dd>

  <dt>Print Job</dt>
  <dd>A print job is a request to a printer to print the provided data using a specified label template.</dd>
</dl>

### Testing

On UAT, there is a printer called `stub`, defined in SPrint which uses a print protocol adapter to send the received print commands to logging. The logs can be viewed on the SPrint host using journalctl. This is useful for testing the print commands without wasting labels.
