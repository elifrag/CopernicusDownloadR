#' Extract Data from Copernicus Marine
#'
#' This function extracts data from the Copernicus Marine service, using the user's credentials, geographic boundaries, and time ranges.
#' It requires a `.csv` file containing variable and dataset information, which should be located in the package's data folder.
#' The function will download data for the specified variables, time range, location, and depth and save metadata to a CSV file.
#'
#' @param cm Python object from the Copernicus Marine service.
#' @param variables A character vector of variable names to extract.
#' @param lon Longitude value(s) (either a single value or a range of two values).
#' @param lat Latitude value(s) (either a single value or a range of two values).
#' @param startDate Start date of the data extraction (in "YYYY-MM-DD" format).
#' @param endDate End date of the data extraction (in "YYYY-MM-DD" format).
#' @param depth Depth value(s) (either a single value or a range of two values).
#' @param frequency Frequency of the data, either "daily" or "monthly".
#' @param csv_path Path to the CSV file containing variable and dataset information. If `NULL`, the CSV file included in the package will be used.
#' @param data_output Path where the extracted data will be saved. If `NULL`, the current working directory will be used.
#'
#' @importFrom utils read.csv write.csv
#'
#' @return A list containing the result of the last downloaded dataset. Additionally, metadata about the extracted data is saved to a CSV file.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' result <- extractData(
#'   cm,
#'   variables = c("temperature", "salinity"),
#'   lon = c(-10, 10),
#'   lat = c(35, 50),
#'   startDate = "2020-01-01",
#'   endDate = "2020-01-31",
#'   depth = c(0, 100),
#'   frequency = "daily"
#' )
#' }
extractData <- function(cm, variables, lon, lat, startDate, endDate,
                        depth, frequency, csv_path = NULL, data_output = NULL) {

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

  # Check if request refers to point data or a bounding box for longitude
  if (length(lon) == 1) {
    minLon <- lon
    maxLon <- lon
  } else if (length(lon) == 2) {
    minLon <- lon[1]
    maxLon <- lon[2]
  } else {
    stop("Longitude must be either a single value or a range of length 2.")
  }

  # Check if request refers to point data or a bounding box for latitude
  if (length(lat) == 1) {
    minLat <- lat
    maxLat <- lat
  } else if (length(lat) == 2) {
    minLat <- lat[1]
    maxLat <- lat[2]
  } else {
    stop("Latitude must be either a single value or a range of length 2.")
  }

  # Check if request refers to single depth or a range of depths
  if (length(depth) == 1) {
    minDepth <- depth
    maxDepth <- depth
  } else if (length(depth) == 2) {
    minDepth <- depth[1]
    maxDepth <- depth[2]
  } else {
    stop("Depth must be either a single value or a range of length 2.")
  }

  # Initialize list to store metadata information for all variables
  metadata_list <- list()

  # Loop over each variable in the list of variables
  for (variable in variables) {

    # Check if the variable exists in the CSV file
    variable_info <- data[data$variable == variable, ]

    if (nrow(variable_info) == 0) {
      stop(paste("The variable", variable, "does not exist in the dataset."))
    }

    # Select the correct dataset based on frequency
    if (frequency == "daily") {
      dataset_id <- variable_info$dataset_id_daily
    } else if (frequency == "monthly") {
      dataset_id <- variable_info$dataset_id_monthly
    } else {
      stop("Invalid frequency. Choose 'daily' or 'monthly'.")
    }

    # Get the Copernicus variable name
    variable_name_copernicus <- variable_info$variableNameCopernicus

    # Perform the data extraction using the subset method
    cat("Downloading data for variable:", variable, "\n")
    result <- cm$subset(
      dataset_id = dataset_id,
      start_datetime = startDate,
      end_datetime = endDate,
      variables = list(variable_name_copernicus),
      minimum_longitude = minLon,
      maximum_longitude = maxLon,
      minimum_latitude = minLat,
      maximum_latitude = maxLat,
      minimum_depth = minDepth,
      maximum_depth = maxDepth,
      output_directory = data_output
    )

    # Append metadata for the current variable
    metadata_list[[variable]] <- list(
      variable = variable,
      dataset_id = dataset_id,
      variableNameCopernicus = variable_name_copernicus,
      startDate = startDate,
      endDate = endDate,
      minimum_longitude = minLon,
      maximum_longitude = maxLon,
      minimum_latitude = minLat,
      maximum_latitude = maxLat,
      minimum_depth = minDepth,
      maximum_depth = maxDepth,
      resolution = ifelse(!is.na(variable_info$resolution), variable_info$resolution, "N/A"),
      doi = ifelse(!is.na(variable_info$doi), variable_info$doi, "N/A"),
      download_date = Sys.Date()
    )
  }

  # Combine all metadata into a single data frame
  metadata_df <- do.call(rbind, lapply(metadata_list, as.data.frame))

  timestamp <- format(Sys.time(), "%Y%m%d_%H%M%S")
  metadataFileName <- paste0("copernicus_metadata_", timestamp, ".csv")

  # Set default output path for metadata if not provided
  if (is.null(data_output)) {
    metadata_output <- file.path(getwd(), metadataFileName)
  } else {
    metadata_output <- file.path(data_output, metadataFileName)
  }

  # Write the metadata to a CSV file
  write.csv(metadata_df, metadata_output, row.names = FALSE)

  cat("Data saved to:", metadata_output, "\n")

  return(result)  # Return the result of the last downloaded dataset
}
