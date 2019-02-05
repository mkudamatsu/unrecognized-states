print "Setting the working directory"
import os
work_dir = os.path.dirname(os.path.realpath(__file__)) # This method returns the directry path of this script.
os.chdir(work_dir)
print work_dir

### Define the main function ###
def main():
    try:
        print "Download the PWT data in Excel file"
        # Setting input and output
        filename = "pwt90.xlsx"
        url = "https://www.rug.nl/ggdc/docs/" + filename # The link from the Excel button on https://www.rug.nl/ggdc/productivity/pwt/
        downloaded_xls = "../input/" + filename
        # Process
        download_data(url, downloaded_xls)

        print "All done."

    # Return any other type of error
    except:
        print "There is an error."

### Define the subfunctions ###
def download_data(url, output):
    print "...downloading and saving the file"
    import urllib
    urllib.urlretrieve(url, output)

### Execute the main function ###
if __name__ == "__main__":
    main()
