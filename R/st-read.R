#' Read simple features or layers from a duckdb connection
#' @aliases st_read
#' @aliases st_read.duckdb_connection
#' @usage st_read(dsn, layer, ...)
#' @importFrom sf st_read
#' @export
st_read.duckdb_connection <-
  function(
      dsn = NULL,
      layer = NULL,
      query = NULL,
      #EWKB = TRUE,
      quiet = TRUE,
      as_tibble = FALSE,
      geometry_column = NULL,
      ...
    ) {
    #TODO: Need to work out how to determine which column from table
    #or query is the geometry column.
    geometry_column <- "geom"

    if (is.null(dsn)) {
      stop("no connection provided")
    }

    if (as_tibble && !requireNamespace("tibble", quietly = TRUE)) {
      stop("package tibble not available: install first?")
    }

    if (!is.null(layer)) {
      if (!is.null(query)) {
        warning("You provided both `layer` and `query` arguments,",
          " will only use `layer`.",
          call. = FALSE
        )
      }
      q <-
        glue::glue(
          "with _t1 as (select * from {layer})
          select * exclude({geometry_column}), ST_AsText({geometry_column}) as {geometry_column}
          from _t1"
        )
      tbl <- DBI::dbGetQuery(dsn, q)
    } else if (is.null(query)) {
      stop("Provide either a `layer` or a `query`", call. = FALSE)
    } else {
      q <-
        glue::glue(
          "with _t1 as ({query})
        select * exclude({geometry_column}), ST_AsText({geometry_column}) as {geometry_column}
        from _t1"
        )
      tbl <- DBI::dbGetQuery(dsn, q)
    }

    x <- 
      tbl |>
      sf::st_as_sf(wkt = geometry_column)

    if (!quiet) 
        print(x, n = 0)
    if (as_tibble) {
        x <- tibble::new_tibble(x, nrow = nrow(x), class = "sf")
    }
    return(x)
  }
