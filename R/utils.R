#' Utility functions for checking the WCVP data

#' Get the latest upload date of WCVP from the SFTP server.
#'
#' @return A character string (YYYY-MM-DD) or NULL if request fails.
#' @noRd
wcvp_get_upload_date <- function() {
  if (!curl::has_internet()) {
    return(NULL)
  }

  tryCatch(
    {
      r <- httr::GET("http://sftp.kew.org/pub/data-repositories/WCVP/", httr::timeout(10))
      httr::stop_for_status(r)
      page <- httr::content(r)

      table_node <- rvest::html_node(page, "pre")
      table_text <- rvest::html_text(table_node)

      table_lines <- stringr::str_split(table_text, "\n")[[1]]

      wcvp_line <- table_lines[stringr::str_detect(table_lines, "wcvp.zip")]
      stringr::str_extract(wcvp_line, "\\d{4}-\\d{2}-\\d{2}")
    },
    error = function(e) {
      NULL
    }
  )
}
