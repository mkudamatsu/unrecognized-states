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

### Geoprocessing starts here ###
try:
    territory_names = ["georgia", "karabakh", "transnistria"]
    for territory_name in territory_names:
        print "Working on "+territory_name+""
        if territory_name == "georgia":
            YYY = "GEO"
        elif territory_name == "karabakh":
            YYY = "NKR"
        else:
            YYY = "TRA"

        print "Setting the input file name prefixes"
        satellite_years = [
            'F101992','F101993','F101994',
            'F121994','F121995','F121996','F121997','F121998','F121999',
            'F141997','F141998','F141999','F142000','F142001','F142002','F142003',
            'F152000','F152001','F152002','F152003','F152004','F152005','F152006','F152007',
            'F162004','F162005','F162006','F162007','F162008','F162009',
            'F182010','F182011','F182012','F182013'
            ]

        print "Starting the loop over satellite-year"
        for satellite_year in satellite_years:
            print "working on "+ satellite_year

            print "Set the file version number"
            if satellite_year == 'F182010':
                version = ".v4d"
            elif satellite_year == 'F182011' or satellite_year == 'F182012' or satellite_year == 'F182013':
                version = ".v4c"
            else:
                version = ".v4b"

            print "Intermediate files being set"
            territory_shp = "input\\unrecognized\\"+territory_name+".shp"
            light_tif = "input\\light\\"+satellite_year+version+"_web.stable_lights.avg_vis.tif"
            territory_light_dbf = "b_temp\\territory_light_"+satellite_year+"_"+YYY+".dbf"

            print "Outputs being set"
            territory_light_xls = "b_temp\\territory_light_"+satellite_year+"_"+YYY+".xls"

            # Process: Zonal Statistics as Table
            print "Obtaining the average of nighttime light within each country"
            arcpy.gp.ZonalStatisticsAsTable_sa(territory_shp, "territory", light_tif, territory_light_dbf, "DATA", "ALL")

            # Process: Table To Excel
            print "Exporting to Excel"
            arcpy.TableToExcel_conversion(territory_light_dbf, territory_light_xls, "NAME", "CODE")

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
