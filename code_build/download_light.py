print "Setting the working directory"
import os
work_dir = os.path.dirname(os.path.realpath(__file__)) # This method returns the directry path of this script.
os.chdir(work_dir)
print work_dir

### Define the main function ###
def main():
    try:
        ### Inputs and outputs ######################################
        print "Setting the output directory"
        outdir = "../input/light/"
        if not os.path.isdir(outdir): # Create the output directory if it doesn't exist
            os.makedirs(outdir)

        print "Setting the directory to save downloaded files"
        # To skip the downloading process once done: it takes quite a bit of time to download the data
        download_dir = "../input/light/orig/"
        if not os.path.isdir(download_dir): # Create the output directory if it doesn't exist
            os.makedirs(download_dir)

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

            ### Processing ######################################
            print "Download the tar file"
            # Setting input and output
            filename = satellite_year + ".v4.tar"
            url = "https://ngdc.noaa.gov/eog/data/web_data/v4composites/" + filename #linked from https://ngdc.noaa.gov/eog/dmsp/downloadV4composites.html
            downloaded_tar = download_dir + filename
            # Process
            download_data(url, downloaded_tar)

            print "Extract stable light files" # Extracting only necessary files (the .extract() function) does not work. So we extract all and then delete those unnecessary.
            # Setting input and output
            input_tar = downloaded_tar
            output_dir = outdir
            files_to_delete = ['web.avg_vis', 'web.cf_cvg', 'README']
            uncompress_tar(input_tar, output_dir, files_to_delete)

            print "Extract gzip file for stable light data"
            input_gzip = outdir + satellite_year + version + "_web.stable_lights.avg_vis.tif.gz"
            # Process
            uncompress_gzip(input_gzip)

        print "All done."

    # Return any other type of error
    except:
        print "There is an error."

### Define the subfunctions ###
def download_data(url, output):
    print "...downloading and saving the file"
    import urllib
    urllib.urlretrieve(url, output)

def uncompress_tar(in_tar, outdir, files_to_delete):
    print "...importing the tarfile module"
    import tarfile
    print "...creating a TarFile object"
    tar = tarfile.open(in_tar) ## create a TarFile Object, which allows us to use special functions for interacting with the tar file.
    print "...extracting all files"
    tar.extractall(path = outdir)
    print "...deleting unnecessary files"
    delete_files(outdir, files_to_delete)

def delete_files(indir, wildcards):
    print "...importing glob module"
    import glob
    print "...looping over wildcards"
    for wildcard in wildcards:
        print "...looping over files satisfying the wildcard"
        # https://stackoverflow.com/questions/5532498/delete-files-with-python-through-os-shell
        for file in glob.glob(indir + "*" + wildcard + "*"):
            print "...deleting file"
            os.remove(file)

def uncompress_gzip(input):
    print "...importing gzip/shutil modules"
    import gzip
    import shutil
    print "...opening " + input
    with gzip.open(input, 'rb') as f_in:
        print "...saving the unzipped file 1/2"
        with open(input.rstrip('.gz'), 'wb') as f_out:
            print "...saving the unzipped file 2/2"
            shutil.copyfileobj(f_in, f_out)
    print "...deleting gzip file"
    os.remove(input)






### Execute the main function ###
if __name__ == "__main__":
    main()
