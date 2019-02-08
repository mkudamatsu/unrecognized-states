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
        in_azer_adm0 = "input/acasian/azerbaijan_adm0.shp"
        in_azer_adm1 = "input/acasian/azerbaijan_adm1.shp"
        in_border = "input/karabakh_border/karabakh-line-of-contact-wgs1984.shp"

        print "Setting the output directory"
        outdir = "../input/unrecognized/"
        if not os.path.isdir(outdir): # Create the output directory if it doesn't exist
            os.makedirs(outdir)

        print "Setting outputs"
        out_karabakh = "karabakh.shp"

        # Process
        print "Assigning WGS 1984" # As described in http://acasian.com/price.html#former, the Acasian spatial data is in WGS84.
        in_azer_adm0_wgs1984 = "b_temp/temp0.shp"
        set_wgs1984(in_azer_adm0, in_azer_adm0_wgs1984)
        in_azer_adm1_wgs1984 = "b_temp/temp1.shp"
        set_wgs1984(in_azer_adm1, in_azer_adm1_wgs1984)

        print "Creating the polygon of Nagorno-Karabaku after 1994"
        create_karabakh(in_azer_adm1_wgs1984, in_border, in_azer_adm0_wgs1984, outdir+out_karabakh)
        # This function deletes 1st and 3rd inputs

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

def create_karabakh(in_polygon1, in_line, in_polygon0, out_shp): # Arcpy doesn't have a method for cutting polygons with polylines. We use a solution suggested by https://gis.stackexchange.com/a/24757
  print "...Removing Nakhichevan"
  select_shp = "b_temp/select_shp.shp"
  arcpy.Select_analysis(in_polygon1, select_shp, '"ADM2" = \'az3100\'')
  print "...Creating the buffer on the north-east side of the Line of Contact" # This covers the whole of Azerbaijan proper. Thus, it can be used to erase this part of Azerbaijan to extract Nagorno-Karabakh.
  buffer_shp = "b_temp/temp_buffer.shp"
  arcpy.Buffer_analysis(in_line, buffer_shp, "10 DecimalDegrees", "LEFT", "ROUND", "NONE", "", "GEODESIC") # see http://desktop.arcgis.com/en/arcmap/10.3/tools/analysis-toolbox/buffer.htm
  print "...Removing Azerbaijan proper"
  erase_shp = "b_temp/temp_erase.shp"
  arcpy.Erase_analysis(select_shp, buffer_shp, erase_shp)
  print "...Merging Karabakh polygon with the rest of Azerbaijan"
  inFeatures = [in_polygon0, erase_shp]
  outFeatures = out_shp
  arcpy.Union_analysis (inFeatures, outFeatures, "ONLY_FID")
  print "...Creating the Karabakh indicator"
  create_new_field(out_shp, "karabakh", "SHORT", "!FID_temp_e!+1")  # FID_temp_e comes from Erase tool's output (erase_shp), taking the value of 0 for Karabakh and -1 for the rest
  print "Deleting intermediate files"
  files_to_delete = [in_polygon1, in_polygon0, select_shp, buffer_shp, erase_shp]
  for file in files_to_delete:
    delete_if_exists(file)

# internal subfunctions
def create_new_field(input_features, field_name, data_type, expression):
  print "Creating a blank field"
  arcpy.AddField_management(input_features, field_name, data_type)
  print "Calculating the field"
  arcpy.CalculateField_management(input_features, field_name, expression, "PYTHON_9.3")

def delete_if_exists(file):
  if arcpy.Exists(file):
    arcpy.Delete_management(file)


### Execute the main function ###
if __name__ == "__main__":
    main()
