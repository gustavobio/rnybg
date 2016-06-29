#' Utility tools to get specimen description and images from NYBG's virtual herbarium
#'
#' @param ny_id The NYBG specimen ID. It is equivalent to the field catalogNumber
#' in GBIF.
#' @param path Where to save downloaded images. Defaults to getwd().
#' @param ... Other parameters passed on to rgbif::occ_search.
#'
#' @import rvest magrittr
#' @examples
#' \dontrun{
#' get_description(1889108)
#' specimen_page(1889108)
#' fill_description(1889108)
#' get_image_url(1889108)
#' open_image(1889108)
#' download_image(1889108)
#' }

#' @export
get_description <- function(ny_id) {
  description <- read_html(specimen_page(ny_id)) %>%
    html_nodes("tr:nth-child(5) .emuDisplayTableValue") %>%
    html_text()
  description <- trimws(description)
  return(description)
}

#' @export
get_gbif_response <- function(ny_id, datasetKey = "d415c253-4d61-4459-9d25-4015b9084fb0", ...) {
  rgbif::occ_search(catalogNumber = ny_id, datasetKey = datasetKey, ...)
}

#' @export
specimen_page <- function(ny_id) {
  gbif_response <- get_gbif_response(ny_id = ny_id, return = 'data')
  gbif_response[, grep("occurrenceDetails", names(gbif_response))]
}

#' @export
fill_description <- function(ny_id, ...) {
  if (!is.numeric(ny_id)) stop("The ID must be numeric.")
  dot_args <- eval(substitute(alist(...)))
  return_all <- !('return' %in% names(dot_args)) | isTRUE(dot_args$return == 'all')
  gbif_response <- get_gbif_respose(ny_id = ny_id, ...)
  description <- get_description(ny_id)
  if (return_all) {
    names(gbif_response$data)[grep("occurrenceDetails", names(gbif_response$data))] <- "occurrenceDetails"
    gbif_response$data$occurrenceDetails <- description
  } else {
    names(gbif_response)[grep("occurrenceDetails", names(gbif_response))] <- "occurrenceDetails"
    gbif_response$occurrenceDetails <- description
  }
  return(gbif_response)
}

#' @export
get_image_url <- function(ny_id) {
  image_url <- read_html(specimen_page(ny_id)) %>%
    html_nodes("#columns tr+ tr a") %>%
    html_attr("href")
  return(paste0("http://sweetgum.nybg.org", image_url))
}

#' @export
open_image <- function(ny_id) {
  browseURL(get_image_url(ny_id))
}

#' @export
download_image <- function(ny_id, path = getwd()) {
  image_url <- get_image_url(ny_id)
  filename <- basename(image_url)
  message("Downloading image to", path)
  download.file(image_url, destfile = filename)
}
