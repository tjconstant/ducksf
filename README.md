
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ducksf

<!-- badges: start -->
<!-- badges: end -->

`ducksf` extends the `sf` package to work with `duckdb` databases.

So far only `st_read()` is implemented partially, but future work will
include using the `st_write()`. By writing methods for the `st_write`
and `st_read` generics, hopefully much functionality of `sf` will be
unlocked (such as using `sf`’s own `read_sf()` generic as below.)

Database-side evaluation for other `st_*` functions and `dbplyr` SQL
generators for spaital queries is also an ambition of the project.

## Example

This is a basic example which shows reading an simple feature collection
from duckdb. So far this is the only function implemented, and currently
does not identify the geometry column(s) automatically.

``` r
library(ducksf)

library(DBI)
library(duckdb)
library(sf)
```

``` r
# create database and create table with geometry
conn <- dbConnect(duckdb())

dbSendQuery(conn, "install spatial")
dbSendQuery(conn, "load spatial")
dbSendQuery(conn, "create table x (id int, geom geometry)")
dbSendQuery(conn, "insert into x values (1, st_point(1,1))")
```

``` r
# read the table into R
read_sf(dsn = conn, query = "select * from x")
#> Simple feature collection with 1 feature and 1 field
#> Geometry type: POINT
#> Dimension:     XY
#> Bounding box:  xmin: 1 ymin: 1 xmax: 1 ymax: 1
#> CRS:           NA
#> # A tibble: 1 × 2
#>      id    geom
#>   <int> <POINT>
#> 1     1   (1 1)
```

Note `duckdb`’s spatial extension currently does not supoort encoding
the CRS into the geometry. This may come in the future, but in the
meantime we may wish to explore ways of storing a metadata table in the
duckdb database when writing `sf` objects.
