# Remove all the objects in the memory
rm(list = ls())

# Install the pacman package if not installed yet
if (!require("pacman")) install.packages("pacman")

### The packman package allows us to
### (1) automatically install a package if not installed yet
### (2) load a package
### with just one line of code: pacman::p_load(package_name)
### (where package_name should be replaced with the name of a package)
### See https://cran.r-project.org/web/packages/pacman/vignettes/Introduction_to_pacman.html
### Consequently, running a R script in a different computer won't cause an error due to the lack of required packages

# Load the tidyverse package
pacman::p_load(tidyverse)

# Start your script from here
