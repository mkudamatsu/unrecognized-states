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
        outdir = "../input/gadm/"
        if not os.path.isdir(outdir): # Create the output directory if it doesn't exist
            os.makedirs(outdir)

        print "Setting the directory to save downloaded files"
        # To skip the downloading process once done: it takes quite a bit of time to download the data
        download_dir = "../input/gadm/orig/"
        if not os.path.isdir(download_dir): # Create the output directory if it doesn't exist
            os.makedirs(download_dir)

        print "Download the GADM data"
        # Setting input and output
        filename = "gadm36_levels_shp.zip"
        url = "https://biogeo.ucdavis.edu/data/gadm3.6/" + filename # The link from https://gadm.org/download_world.html
        downloaded_zip = download_dir + filename
        # Process
        download_data(url, downloaded_zip)

        print "Extract the downloaded data"
        # Setting input and output
        input_zip = downloaded_zip
        output_dir = outdir
        file_to_keep = "gadm36_0"
        # Process
        uncompress_zip(input_zip, file_to_keep, output_dir)

        print "All done."

    # Return any other type of error
    except:
        print "There is an error."

### Define the subfunctions ###
def download_data(url, output):
    print "...downloading and saving the file"
    import urllib
    urllib.urlretrieve(url, output)

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
                 

### Execute the main function ###
if __name__ == "__main__":
    main()
