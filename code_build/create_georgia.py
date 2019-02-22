print "Setting the working directory"
import os
work_dir = os.path.dirname(os.path.realpath(__file__)) # This method returns the directry path of this script.
os.chdir(work_dir)
print work_dir

print "Launching ArcGIS"
import arcpy

print "Enabling the Spatial Analyst extension"
from arcpy.sa import *
arcpy.CheckOutExtension("Spatial")

print "Setting the environment"
arcpy.env.overwriteOutput = True # Allow the overwriting of the output files
arcpy.env.workspace = "../" # Set the working directory. Some geoprocessing tools (e.g. Extract By Mask) cannot save the output unless the workspace is a geodatabase.

### Define the main function ###
def main():
    try:
        ### Inputs and outputs ######################################
        print "Setting input shapefiles"
        in_georgia = "input/acasian/georgia_adm1-1.shp"

        print "Setting the output directory"
        outdir = "../input/unrecognized/"
        if not os.path.isdir(outdir): # Create the output directory if it doesn't exist
            os.makedirs(outdir)

        print "Setting outputs"
        out_georgia = "georgia.shp"

        # Process
        print "Assigning WGS 1984" # As described in http://acasian.com/price.html#former, the Acasian spatial data is in WGS84.
        in_georgia_wgs1984 = "b_temp/tempfile1.shp"
        set_wgs1984(in_georgia, in_georgia_wgs1984)

        print "Creating the polygon of Nagorno-Karabaku after 1994"
        create_georgia(in_georgia_wgs1984, outdir+out_georgia)

        print "All done."

    # Return geoprocessing specific errors
    except arcpy.ExecuteError:
        print arcpy.GetMessages()

    # Return any other type of error
    except:
        print "There is an error."

    print "All done."

# subfunctions
def set_wgs1984(in_shp, out_shp):
  print "...Copying the input" # To avoid the Define Projectio method from overwriting the input
  arcpy.CopyFeatures_management(in_shp, out_shp)
  print "...Assigning the projection"
  wgs1984 = arcpy.SpatialReference(4326)
  arcpy.DefineProjection_management(out_shp, wgs1984)

def create_georgia(in_polygon, out_shp):
  print "...creating the territory indicator 1/2"
  arcpy.AddField_management(in_polygon, "territory", "TEXT")
  print "...creating the territory indicator 2/2"
  arcpy.CalculateField_management(in_polygon, "territory", "Reclass(!ADM2_1_ID!)", "PYTHON_9.3", "def Reclass(name):\\n    if (name == 141):\\n        return \"ABK\"\\n    if (name == 146):\\n        return \"SOS\"\\n    else:\\n        return \"GEO\"")
  print "...dissolving Georgia proper"
  arcpy.Dissolve_management(in_polygon, out_shp, "territory")
  print "Deleting intermediate files"
  files_to_delete = [in_polygon]
  for file in files_to_delete:
    delete_if_exists(file)

# internal subfunctions
def delete_if_exists(file):
  if arcpy.Exists(file):
    arcpy.Delete_management(file)
### Execute the main function ###
if __name__ == "__main__":
    main()
