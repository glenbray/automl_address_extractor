# README

### Seed development DB

Json lines files will need to be provided and stored in `db/seed_files/scraped_data`. Heres an example of how a line within a file would look like.

`01832172-68c9-4064-acc3-d479e4cf2319_2019-03-13T01-28-04.jl`

```json
{"site_url": "https://somesite.com.au", "page_url": "https://abcmanufacturing.com.au", "html": "<html lang=\"en\"><body><div>this is a fake website and here is a fake address: 2/19 coopanhagen rd NSW 2320. Contact US at 1200 111 111.</div></body></html>"}

```
The seed script will load all `.jl` files within the directory.

