#' Startup hook
#' @noRd
.onAttach <- function(...) {
    if (wcvp_is_loading_for_tests()) {
        return(invisible())
    }

    attached <- wcvp_attach()
    wcvp_inform_startup(wcvp_attach_message(attached))
}

wcvp_is_attached <- function(x) {
    paste0("package:", x) %in% search()
}

wcvp_is_loading_for_tests <- function() {
    !interactive() && identical(Sys.getenv("DEVTOOLS_LOAD"), "wcvpdata")
}

wcvp_inform_startup <- function(msg) {
    if (is.null(msg)) {
        return()
    }
    if (wcvp_is_attached("conflicted")) {
        return()
    }
    packageStartupMessage(msg)
}

utils::globalVariables("metadata")
