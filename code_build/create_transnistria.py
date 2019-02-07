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
        print "Setting the output directory"
        outdir = "../input/unrecognized/"
        if not os.path.isdir(outdir): # Create the output directory if it doesn't exist
            os.makedirs(outdir)

        print "Extract the first-level administrative polygon data from GADM"
        # Setting input and output
        input_zip = "../input/gadm/orig/gadm36_levels_shp.zip"
        output_dir = "../b_temp/"
        file_to_keep = "gadm36_1"
        # Process
        uncompress_zip(input_zip, file_to_keep, output_dir)

        print "Keep Moldova proper and Transnistria only"
        input_shp = output_dir + file_to_keep + ".shp"
        output_shp = outdir + "transnistria.shp"
        create_transnistria(input_shp, output_shp)

        print "All done."

    # Return geoprocessing specific errors
    except arcpy.ExecuteError:
        print arcpy.GetMessages()

    # Return any other type of error
    except:
        print "There is an error."


### Define the subfunctions ###
def uncompress_zip(input_zip, file_to_keep, outdir):
    # See http://stackoverflow.com/questions/9431918/extracting-zip-file-contents-to-specific-directory-in-python-2-7
    print "...launching zipfile module"
    import zipfile
    print "...reading the zip file"
    with zipfile.ZipFile(input_zip, 'r') as z:
        print "...looping over compressed files"
        for name in z.namelist():
            print "...checking if the file is what we want to decompress"
            if name[:-4] == file_to_keep:
                print "...decompressing the file we want"
                z.extract(name, outdir)

def create_transnistria(input_shp, output_shp):
    print "...selecting Moldova"
    tempfile1 = "b_temp/tempfile1.shp"
    arcpy.Select_analysis(input_shp, tempfile1, '"NAME_0" = \'Moldova\'')
    print "...creating the indicator of Transnistria 1/2"
    arcpy.AddField_management(tempfile1, "trans", "SHORT")
    print "...creating the indicator of Transnistria 2/2"
    arcpy.CalculateField_management(tempfile1, "trans", "Reclass(!NAME_1!)", "PYTHON_9.3", "def Reclass(name):\\n    if (name == 'Transnistria'):\\n        return 1\\n    else:\\n        return 0")
    print "...dissolving Moldova proper"
    arcpy.Dissolve_management(tempfile1, output_shp, "trans")

### Execute the main function ###
if __name__ == "__main__":
    main()
