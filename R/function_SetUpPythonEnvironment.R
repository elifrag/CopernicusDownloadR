#' Setup Copernicus Marine Virtual Environment
#'
#' This function sets up a Python virtual environment for Copernicus Marine data access in R.
#' It installs Python (if not already installed), creates a virtual environment, installs the
#' `copernicusmarine` Python package, and saves user login credentials for future access.
#'
#' @param username A character string containing your Copernicus Marine account username.
#' @param password A character string containing your Copernicus Marine account password.
#'
#' @importFrom reticulate install_python virtualenv_create virtualenv_install use_virtualenv py_install import
#' @importFrom utils install.packages
#'
#' @details
#' The function checks if Python is installed on the system and prompts the user to install it using `reticulate` if it is not found.
#' It also creates a virtual environment and installs the `copernicusmarine` Python package in that environment.
#' After setting up the environment, the function logs the user in with the provided credentials.
#'
#' @return A Python object from the `copernicusmarine` package, which allows further
#' interaction with the Copernicus Marine data service.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' cm <- setupCopernicusEnvironment("your_username", "your_password")
#' }
setupCopernicusEnvironment <- function(username, password) {

  # Check if 'reticulate' package is installed, if not, install it
  if (!requireNamespace("reticulate", quietly = TRUE)) {
    cat("Installing 'reticulate' package...\n")
    install.packages("reticulate")
  }

  # Determine the operating system
  os <- .Platform$OS.type

  # Check if Python is installed
  if (os == "unix") {
    python_paths <- system("which -a python3", intern = TRUE)  # 'which -a' lists all Python 3 versions in PATH
  } else if (os == "windows") {
    python_paths <- system("where python", intern = TRUE)  # 'where' lists all Python versions in PATH on Windows
  } else {
    stop("Unsupported OS.")
  }

  if (length(python_paths) == 0) {
    cat("Python is not installed on your system.\n")
    # Ask user if they want to install Python using reticulate
    install_python <- readline(prompt = "Do you want to install Python now using reticulate? (y/n): ")

    if (tolower(install_python) == "y") {
      cat("Installing Python using reticulate...\n")
      reticulate::install_python()
    } else {
      cat("Python installation aborted.\n")
      return(NULL)
    }
  } else {
    cat("Version(s) of Python found:\n")
    cat("Please select one by entering the number from the following list:\n")
    # Display the Python paths with numbers
    for (i in 1:length(python_paths)) {
      cat(i, ": ", python_paths[i], "\n")
    }

    # Ask user to select by number
    selected_index <- as.integer(readline(prompt = "Which Python version would you like to use? (Enter the number): "))

    # Validate selection
    while (is.na(selected_index) || selected_index < 1 || selected_index > length(python_paths)) {
      cat("Invalid selection. Please enter a valid number from the list.\n")
      selected_index <- as.integer(readline(prompt = "Which Python version would you like to use? (Enter the number): "))
    }

    selected_python <- python_paths[selected_index]

    cat("Selected Python: ", selected_python, "\n")
    reticulate::use_python(selected_python, required = TRUE)

    # Create virtual environment and install copernicusmarine package in it
    randomName <- paste0("copernicusEnv")

    cat("Creating virtual environment...\n")
    reticulate::virtualenv_create(envname = randomName)

    cat("Installing copernicusmarine package...\n")
    reticulate::virtualenv_install(randomName, packages = c("copernicusmarine"))

    # Activate virtual environment (this automatically selects the virtual environment's Python)
    reticulate::use_virtualenv(randomName, required = TRUE)

    # Import copernicusmarine
    cm <- reticulate::import("copernicusmarine")

    # Save login credentials
    cm$login(username, password)

    return(cm)
  }
}
