## code to download the latest WCVP name and distribution tables and record version
## re-run this to update the WCVP data when there is a new release
## REMEMBER TO UPDATE THE DOCS IF THE DATA STRUCTURE HAS CHANGED

library(httr)
library(rvest)
library(stringr)
library(readr)
library(readxl)
library(lubridate)
library(glue)
library(cli)

# download save wcvp data ----
base_url <- "https://sftp.kew.org/pub/data-repositories/WCVP/"
zip_url  <- paste0(base_url, "wcvp.zip")

# download to temporary place and extract
temp <- tempfile(fileext = ".zip")

cli_alert_info("Downloading latest WCVP data from {base_url}...")

# aumentar timeout (descarga ~85 MB)
old_timeout <- getOption("timeout")
options(timeout = max(600, old_timeout))

# método más estable (evita .rs.downloadFile cuando sea posible)
method <- if (.Platform$OS.type == "windows") "wininet" else "curl"

download.file(zip_url, destfile = temp, method = method, mode = "wb", quiet = TRUE)

# crear carpeta destino y extraer
exdir <- "wcvp-files"
dir.create(exdir, showWarnings = FALSE, recursive = TRUE)

# verificar zip antes de extraer (evita errores por descarga incompleta)
ok <- tryCatch({
  utils::unzip(temp, list = TRUE)
  TRUE
}, error = function(e) FALSE)

if (!ok) {
  stop("The ZIP download appears incomplete/corrupted. Re-run the download or try a different network.")
}

cli_alert_success("Zip file downloaded and verified.")

utils::unzip(temp, exdir = exdir)

# load and save the names file
cli_alert_info("Processing names data...")
ruta <- "D:\\wcvp_data\\wcvp_15\\wcvp\\wcvp_names.csv"
wcvp_checklist_names <- read_delim(ruta, #"wcvp-files/wcvp_names.csv",
                                   delim="|",
                                   quote="",
                                   show_col_types = FALSE)
wcvp_checklist_names

usethis::use_data(wcvp_checklist_names,
                  compress = "xz",
                  overwrite = TRUE)

# load and save the distributions file
cli_alert_info("Processing distribution data...")
ruta <- "D:\\wcvp_data\\wcvp_15\\wcvp\\wcvp_distribution.csv"
wcvp_checklist_distribution <- read_delim(ruta, #"wcvp-files/wcvp_distribution.csv",
                                          delim = "|",
                                          quote = "",
                                          show_col_types = FALSE)
wcvp_checklist_distribution
usethis::use_data(wcvp_checklist_distribution,
                  compress = "xz",
                  overwrite = TRUE)

# extract metadata ----
cli_alert_info("Extracting metadata...")
# get info from README spreadsheet
readme_path <- "D:\\wcvp_data\\wcvp_15\\wcvp\\README_WCVP.xlsx"#"wcvp-files/README_WCVP.xlsx"
version <- read_xlsx(readme_path, range="A7", col_names="version")$version
version <- str_extract(version, "\\d+")
version

citation_full <- read_xlsx(readme_path,
                           range="A4",
                           col_names="cite")$cite
citation_full
cite_date <- str_extract(citation_full,
                         "(?<=accessed )\\d+ [A-Z][a-z]+ \\d{4}")
cite_date
# Parse upload date from SFPT server site
r <- GET(base_url)
page <- httr::content(r)
table_node <- html_node(page, "pre")
table_text <- html_text(table_node)
table_lines <- str_split(table_text, "\n")[[1]]
wcvp_line <- table_lines[str_detect(table_lines, "wcvp.zip")]
upload_date <- str_extract(wcvp_line, "\\d{4}-\\d{2}-\\d{2}")
upload_date
# save to internal data file
# Using actual nrow/ncol for absolute accuracy in data package
metadata <- list(
  version = as.numeric(version),
  version_date = cite_date,
  name_rows = nrow(wcvp_checklist_names),
  name_col = ncol(wcvp_checklist_names),
  dist_rows = nrow(wcvp_checklist_distribution),
  dist_col = ncol(wcvp_checklist_distribution),
  upload_date = upload_date,
  citation = citation_full
)
metadata
usethis::use_data(metadata,
                  internal = TRUE,
                  overwrite = TRUE)
cli_alert_success("Metadata updated: Version {version} ({upload_date})")

# update citation file ----
cli_alert_info("Updating citation file hooks...")
citation_file <- "inst/CITATION"
citation_text <- readLines(citation_file)

# Robust anchor-based update for bibentry format
# snapshot_date <- '...'
i_date <- which(str_detect(citation_text, "^snapshot_date <-"))
citation_text[i_date] <- paste0("snapshot_date <- '", cite_date, "'")

# snapshot_version <- ...
i_ver <- which(str_detect(citation_text, "^snapshot_version <-"))
citation_text[i_ver] <- paste0("snapshot_version <- ", version)

writeLines(citation_text, citation_file)
cli_alert_success("Citation file successfully updated.")

# clean up directory ----
cli_alert_info("Cleaning up temporary files...")
unlink(temp)
unlink("wcvp-files", recursive=TRUE)

cli_alert_success("Data update process completed successfully!")
