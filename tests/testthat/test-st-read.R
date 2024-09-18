# setup test database
library(DBI)
library(duckdb)
library(sf)

conn <- dbConnect(duckdb())

dbSendQuery(conn, "install spatial")
dbSendQuery(conn, "load spatial")
dbSendQuery(conn, "create table x (id int, geom geometry)")
dbSendQuery(conn, "insert into x values (1, st_point(1,1))")

test_that("reading query from duckdb works", {
  y <- read_sf(dsn = conn, query = "select * from x")
  expect_s3_class(y, c("sf", "data.frame"))
})

test_that("reading layer from duckdb works", {
  y <- read_sf(dsn = conn, layer = "x")
  expect_s3_class(y, c("sf", "data.frame"))
})

test_that("warning with query & layer works", {
  expect_warning(
    y <- read_sf(dsn = conn, layer = "x", query = "select * from x")
  )
  expect_s3_class(y, c("sf", "data.frame"))
})
