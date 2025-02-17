% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/function_SetUpPythonEnvironment.R
\name{setupCopernicusEnvironment}
\alias{setupCopernicusEnvironment}
\title{Setup Copernicus Marine Virtual Environment}
\usage{
setupCopernicusEnvironment(username, password)
}
\arguments{
\item{username}{A character string containing your Copernicus Marine account username.}

\item{password}{A character string containing your Copernicus Marine account password.}
}
\value{
A Python object from the \code{copernicusmarine} package, which allows further
interaction with the Copernicus Marine data service.
}
\description{
This function sets up a Python virtual environment for Copernicus Marine data access in R.
It installs Python (if not already installed), creates a virtual environment, installs the
\code{copernicusmarine} Python package, and saves user login credentials for future access.
}
\details{
The function checks if Python is installed on the system and prompts the user to install it using \code{reticulate} if it is not found.
It also creates a virtual environment and installs the \code{copernicusmarine} Python package in that environment.
After setting up the environment, the function logs the user in with the provided credentials.
}
\examples{
\dontrun{
cm <- setupCopernicusEnvironment("your_username", "your_password")
}
}
