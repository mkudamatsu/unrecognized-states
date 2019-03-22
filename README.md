This GitHub repository replicates the data analysis in 
> Masayuki Kudamatsu. 2019. "Observing Economic Growth in Unrecognized States with Nighttime Light." OSIPP Discussion Paper, DP-2019-E-002.

which estimates economic growth rates in Nagorno-Karabakh, Abkhazia, South Ossetia, and Transnistria from the satellite images of nighttime light.

For references, see the above paper.

# Setting up
Install the following applications:
- ArcGIS Desktop Advanced and its Spatial Analyst extension (on Windows) which comes with Python 2.7
- R and R Studio (either on MacOS or Windows)

Clone/download this GitHub repository
- If you're familiar with Git, clone this repository to download scripts and data files for replication
- Otherwise, click the green button "Clone or Download" above right to download the zip file. Unzip it, and you'll have a directory called `/unrecognized-states-master`. Rename it to `/unrecognized-states`.

Set the default directory in R Studio
- Set the `/unrecognized-states` as the default directory.
- Otherwise, R scripts won't be run because the file paths are set relative to the root directory of this repository.

# Preparing input datasets
Some datasets are already included in this repository (the `/input` folder). But others need to be downloaded from the web and then processed in ArcGIS. 

On Windows, run the following Python scripts in the `/code_build` folder:
1. `setup_folders.py` (create additional folders in the repository)
2. `download_pwt.py` (download Penn World Table 9.0 for GDP per capita data)
3. `download_gadm.py` (download GADM (2018) for country polygons)
4. `create_transnistria.py` (create Transnistria and Moldova proper polygons from GADM (2018))
5. `create_karabakh.py` (create Nagorno-Karabakh and Azerbaijan proper polygons from ACASIAN (2014) and Armenian Ministry of Foreign Affairs (2018))
6. `create_georgia.py` (create Abkhazia, South Ossetia, and Georgia proper polygons from ACASIAN (2014))
7. `download_light.py` (download nighttime light data from National Geophysical Data Center 2015; this script takes more than an hour to run.)

# Transforming the input datasets to get them ready for analysis
On Windoes, run the following Python scripts in the `/code_build` folder:
1. `country_light.py` (calculate the mean nighttime light intensity at the country level)
2. `countryname_light.py` (create a correspondence of three-letter country code and country names from GADM (2018))
3. `territory_light.py` (calculate the mean nighttime light intensity for unrecognized states and their parent countries)

Run the following R scripts in the `/code_build` folder in the following order:
1. `country_year_rgdpe.R` (create annual cross-country panel of real GDP)
2. `country_year_income_light.R` (merge real GDP data with the mean nighttime light data)
3. `territory_year_light.R` (collect the mean nighttime light intensity for unrecognized states and their parent countries)

# Analyzing the data
Run the following R scripts in the `/code_analysis` folder in the following order:
1. `income_light_cfe_yfe.R` (regress real GDP on light, country and year fixed effects)
2. `territory_year_growth_hat.R` (predict real GDP growth for unrecognized states and their parent countries)
3. `plot_growth_hat_bar_predicted.R` (create Figures 2-8 to visualize the predicted real GDP growth rates)
