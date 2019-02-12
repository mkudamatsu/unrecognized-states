print "Setting the working directory"
import os
work_dir = os.path.dirname(os.path.realpath(__file__)) # This method returns the directry path of this script.
os.chdir(work_dir)
print work_dir

### Define the main function ###
def main():
    try:
        ### Inputs and outputs ######################################
        print "Setting folder names"
        folders_to_create = ["../code_analysis", "../b_temp", "../b_output", "../a_temp", "../a_output"]

        # Process
        print "Creating folders"
        create_folders(folders_to_create)

        print "All done."

    # Return any other type of error
    except:
        print "There is an error."

    print "All done."

# subfunctions
def create_folders(folders):
    for folder in folders:
        if not os.path.isdir(folder): # Create the output directory if it doesn't exist
            os.makedirs(folder)


### Execute the main function ###
if __name__ == "__main__":
    main()
