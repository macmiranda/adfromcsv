# adfromcsv
Powershell script to create users on the AD from a CSV file

CVS file must include headers and columns must be in the following order:

    firstname,lastname,username,group,description,password,validity

Groups must be already created before you run the script.
