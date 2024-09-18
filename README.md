
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ducksf

<!-- badges: start -->
<!-- badges: end -->

`ducksf` extends the `sf` package to work with `duckdb` databases.

## Example

This is a basic example which shows reading an simple feature collection
from duckdb

``` r
library(ducksf)
library(DBI)
library(duckdb)
library(sf)
#> Linking to GEOS 3.11.0, GDAL 3.5.3, PROJ 9.1.0; sf_use_s2() is TRUE

# create database and create table with geometry
conn <- dbConnect(duckdb())

dbSendQuery(conn, "install spatial")
#> <duckdb_result 469d0 connection=39b20 statement='install spatial'>
dbSendQuery(conn, "load spatial")
#> <duckdb_result 3c700 connection=39b20 statement='load spatial'>
dbSendQuery(conn, "create table x (id int, geom geometry)")
#> <duckdb_result 5b950 connection=39b20 statement='create table x (id int, geom geometry)'>
dbSendQuery(conn, "insert into x values (1, st_point(1,1))")
#> <duckdb_result 3cc20 connection=39b20 statement='insert into x values (1, st_point(1,1))'>
```

``` r
# read rthe table into R
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
the CRS into the geometry column.
