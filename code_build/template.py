### Set the working directory ###
import os
work_dir = os.path.dirname(os.path.realpath(__file__)) # This method returns the directry path of this script.
os.chdir(work_dir)

### Read the ArcGIS object ###
print "Launching ArcGIS 10"
import arcpy

# Check out any necessary licenses
print "Enabling Spatial Analyst extension"
arcpy.CheckOutExtension("spatial")

### Set environment ###
print "Setting the environment"
# Allow the overwriting of the output files
arcpy.env.overwriteOutput = True
# Set the working directory.
arcpy.env.workspace = "../" # NEVER USE single backslash (\).

### Local variables ###
print "Inputs being set"
////PASTE HERE////
print "Intermediate files being set"
////PASTE HERE////
print "Outputs being set"
////PASTE HERE////

### Geoprocessing starts here ###
try:
    ////PASTE HERE//// # geoprocessing commands

    print "All geoprocessing successfully done"

# Return geoprocessing specific errors
except arcpy.ExecuteError:
    print arcpy.GetMessages()

# Return any other type of error
except:
    print "There is non-geoprocessing error."

### Release the memory ###
print "Closing ArcGIS 10"
del arcpy
