#' List Variable Names and Dataset Information from Copernicus Marine
#'
#' This function lists "user-friendly" variable names, which have been developed to substitute the original variable names from the Copernicus Marine service.
#' It also retrieves additional information about each variable, including metrics, dataset name, resolution, and time and depth coverage.
#' The function requires a `.csv` file containing variable and dataset information, which should be located in the package's data folder.
#'
#' @param csv_path A character string specifying the path to the CSV file containing variable and dataset information.
#' If `NULL`, the default CSV file included in the package will be used.
#' @param show A character string specifying the type of information to display. If `NULL`, only the names of available variables will be shown.
#' If "completeList", a full list of dataset details will be shown.
#'
#' @importFrom utils read.csv
#'
#' @export
#'
#' @examples
#' \dontrun{
#' listVariables(show = "completeList")
#' }
listVariables <- function(csv_path = NULL, show = NULL) {

  # Set default CSV path if none is provided
  if (is.null(csv_path)) {
    csv_path <- system.file("extdata", "CopernicusVariables&Datasets.csv", package = "CopernicusDownloadR")
  }

  # Check if the file exists at the specified path
  if (!file.exists(csv_path)) {
    stop("The CSV file containing variable and dataset information was not found.")
  }

  # Read the CSV containing the variables and datasets
  data <- read.csv(csv_path)

  if (is.null(show)) {
    cat("Available Variables:\n")
    print(unique(data$variable))
  } else if (show == "completeList") {
    cat("Available Data:\n")
    print(data[, c("variable", "metric", "datasetName", "startDate", "endDate", "resolution", "depths")])
  }

}
