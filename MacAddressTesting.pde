import processing.data.*;

Table data;
Table cleanedData;
Table SmartIDs;

// Create an array of macaddress strings to compare against
ArrayList<String> macaddresses = new ArrayList<String>();

void setup() {
  size(500, 500);
 
  java.io.File folder = new java.io.File(dataPath(""));
  // list the files in the data folder, passing the filter as parameter
  String[] filenames = folder.list();
  
  // display the filenames
  for (int i = 0; i < filenames.length; i++) {
    println(filenames[i]);
  }

  data = loadTable("2013-10-11+00.35.38.csv");
  // load the data and parse the logged MAC Address CSV
  SmartIDs  = loadTable("macIDs.csv");


  // create a new Table object with Labeled Headers
  cleanedData=new Table();
  cleanedData.addColumn("Date");
  cleanedData.addColumn("Time");
  cleanedData.addColumn("IP");
  cleanedData.addColumn("MACADDRESS"); 

  // Iterate through the data in the generated csv cleaning 
  // out the ";" and " " for ","
  // then adding the cleaned data to the clean data table
  for (TableRow row : data.rows()) { 
    String csvRow = row.getString(0);
    String cleaned = csvRow.replaceAll(";", ",");
    cleaned = cleaned.replaceAll(",,,", ",");
    cleaned = cleaned.replaceAll(" ", ",");
    String[] list=split(cleaned, ",");
    TableRow newRow = cleanedData.addRow();
    newRow.setString("Date", list[0]);
    newRow.setString("Time", list[1]);
    newRow.setString("IP", list[3]);
    newRow.setString("MACADDRESS", list[4]);
  }
  //  println(cleanedData.getStringColumn("IP"));// Check to see if Data is in Cleanly
  for (TableRow row:cleanedData.rows()) {
    macaddresses.add(row.getString(3));
  }
}

void draw() {
  background(0, 0, 0);
  //Iterate over each and compare mac address if the mac Address is present printout user
  int i=10;  
  for (String macIDs:macaddresses) {
    for (TableRow row:SmartIDs.rows()) { 
      if (row.getString(1).equals(macIDs)) {
        //        println(row.getString(0)); 
        text(row.getString(0), 10, 10+i);
        i+=20;
      }
    }
    if (i>height/2) {
      i=0;
    }
  }
}

