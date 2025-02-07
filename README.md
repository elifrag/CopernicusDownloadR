<!-- README.md is generated from README.Rmd. Please edit that file -->

# CopernicusDownloadR

<!-- badges: start -->
<!-- badges: end -->

The goal of **CopernicusDownloadR** package is to facilitate the easy
downloading and management of marine data from the Copernicus Marine
Service using R. This package provides functions to set up the
environment, authenticate users, and retrieve data based on user-defined
parameters from two marine products: the Global Ocean Physics Reanalysis
(<https://doi.org/10.48670/moi-00021>) and the Global Ocean
Biogeochemistry Hindcast (<https://doi.org/10.48670/moi-00019>).

### Installation

You can install the development version of CopernicusDownloadR like so:

``` r
devtools::install_github("elifrag/CopernicusDownloadR")
```

``` r
library(CopernicusDownloadR)
```

### Usage

The package provides an interface between R and the Copernicus Marine
services. Note that in order to access these services you need an
account. Register for your account here:
<https://data.marine.copernicus.eu/register>

Package function contents

- **setupCopernicusEnvironment**: Configures the Python environment
  required for the package and logs in to the Copernicus Marine Service.
- **listVariables**: Lists available variables and general information
  of the datasets.
- **extractData**: Downloads marine data based on the request parameters
  specified in the function. It also provides a metadata text file with
  information on the downloaded dataset.

### Setting up the Python environment in R

This is a basic example that shows how to use the
`setupCopernicusEnvironment` function to configure your environment and
authenticate with the Copernicus Marine Service:

``` r
# Note: you have to define the cm object in order to call it in the extractData function
# Use your user name and password to access the Copernicus Marine Service

cm <- setupCopernicusEnvironment("your_username", "your_password")
```

You now can subset and download environmental data from the Copernicus
Marine Service.

### Listing available variables and dataset information

This is a basic example that shows how to use the `listVariables`
function to list available variables and dataset information:

``` r

listVariables (show="completeList")
```

``` r
# Note: if you do NOT define  show="completeList", the function returns the available variables names

listVariables ()
```

You can now choose which variables you want to download from the
Copernicus Marine Service.

### Subsetting and downloading data

The example below demonstrates how to use the `extractData` function to
subset and download data from the Copernicus Marine Service. The data
request is defined by the `variables`, the location specified by the
longitude `lon` and latitude `lat`, the time interval `startDate`,
`endDate`, the `depth` and the data `frequency`, being daily or monthly.
The path to the downloaded data and metadata information file can be
defined at `data_output`.

``` r
# Download data based on specified parameters

# This example will download data daily, for oxygen concentration, at a given point from 01/01/2021 to 20/01/2021

copernicusData <- extractData(
  cm = cm,  # Copernicus Marine object from setup function
  variables = "oxygen",
  lon = -9.64671906997131, lat = 36.7143279919028,
  startDate = "2021-01-01", endDate = "2021-01-20",   # select between "1993-01-01" and "2024-10-22"
  depth = c(0,11),   # select between 0 and 5728 m depth 
  frequency = "daily",   # select between daily or monthly 
  data_output = "path_to_download_folder" )
  
```

The `extractData` function permits to subset and download multiple
variables at once.

``` r

copernicusData <- extractData(
  cm = cm,  # Copernicus Marine object from setup function
  variables = c("oceanTemperature", "oxygen"),
  lon =c(-30,10),
  lat = c(30,45),
  startDate = "2020-03-01", endDate = "2020-06-20",
  depth = c(1,30), 
  frequency = "monthly",
  data_output = "path_to_download_folder" )
  
```

Users are not requested to define the Copernicus dataset_id_name. The
`extractData` function automatically request the data from the
appropriate dataset.

#### Author

Eliza Fragkopoulou  
[<https://github.com/elifrag>\]

#### License

This package is licensed under the MIT License. See the
[LICENSE](LICENSE) file for more information.
