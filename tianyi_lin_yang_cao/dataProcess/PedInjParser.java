import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Scanner;
import java.util.Arrays;
import java.util.*;

public class PedInjParser {

	// private static final String INPUT_FILE = "ped_test.csv";
	private static final String INPUT_FILE = "pedestrianData.csv";
	private static final String OUTPUT_FILE = "out-pedestrian-injured.csv";
	private static final String ERROR_FILE = "out-pedestrian-injured-error.csv";
	private static final String SQL_FILE = "pedInjure.sql";
	private static final int NUM_ELEMENTS = 10;
	private static HashSet<String> pedInjure = new HashSet<>();
	private static HashSet<String> errorpedInjure = new HashSet<>();
	
	private static void parse(File inFile, File outFile, File errorFile) throws IOException {
		BufferedWriter writer = new BufferedWriter(new FileWriter(outFile));
		BufferedWriter errorWriter = new BufferedWriter(new FileWriter(errorFile));
		BufferedWriter sqlWriter = new BufferedWriter(new FileWriter(SQL_FILE, true));

		ArrayList<PedInjure> tupleList = new ArrayList<>();
		tupleSeparator(tupleList, inFile, outFile);
		sqlWriter.write("Drop TABLE IF EXISTS PedInjure;\n");
		sqlWriter.write("CREATE TABLE PedInjure(\n");
		sqlWriter.write("PedCrashID INTEGER NOT NULL \n");
		sqlWriter.write("    ,ped_pos      VARCHAR(46) NOT NULL\n");
		sqlWriter.write("    ,ped_race     VARCHAR(15) NOT NULL\n");
		sqlWriter.write("    ,pedage_grp   VARCHAR(7) NOT NULL\n");
		sqlWriter.write("    ,ped_age      VARCHAR(7) NOT NULL\n");
		sqlWriter.write("    ,ped_injury   VARCHAR(19) NOT NULL \n");
		sqlWriter.write("    ,ped_sex      VARCHAR(7) NOT NULL\n");
		sqlWriter.write("   ,PRIMARY KEY(PedCrashID)\n");
		sqlWriter.write(");\n");

		writer.write(" PedCrashID,ped_pos, ped_race,  pedage_grp,  ped_age,  ped_injury,  ped_sex\n");
		errorWriter.write(" PedCrashID,ped_pos,  ped_race,  pedage_grp,  ped_age,  ped_injury,  ped_sex\n");


		//Write the result in a csv file
		for (int i = 0; i < tupleList.size(); i++) {
			PedInjure oneEntry = tupleList.get(i);
			// if (!oneEntry.containsError() && isNumeric(oneEntry.year)) {
			if (!oneEntry.containsError()) {
				String key = oneEntry.PedCrashID + "";
				if (!pedInjure.contains(key)) {
					pedInjure.add(key);
					writer.write(oneEntry.toString() + "\n");
					sqlWriter.write(oneEntry.toSqlStatement() + "\n");
				}
			} else {
				String key = oneEntry.PedCrashID + "";
				if (!errorpedInjure.contains(key)) {
					errorpedInjure.add(key);
					errorWriter.write(oneEntry.toString() + "\n");
				}
			}
		}
		sqlWriter.close();
	    System.out.println("done......");
	}
	
	private static void tupleSeparator(ArrayList<PedInjure> tupleList, File inFile, File outFile) throws IOException, 
			StringIndexOutOfBoundsException {

		BufferedReader br = new BufferedReader(new FileReader(INPUT_FILE));
		String line;
		String headers;
		int crashId = 1;

		// find index of needed data
		headers = br.readLine().trim();
		ArrayList<String> header = new ArrayList<String>(Arrays.asList(headers.split(",")));

		System.out.println("header is: "+ header);

		int pedPosInd = header.indexOf("ped_pos");
		int pedRaceInd = header.indexOf("ped_race");
		int pedAgeInd = header.indexOf("ped_age");
		int pedInjuInd = header.indexOf("ped_injury");
		int pedSexInd = header.indexOf("ped_sex");
		
		// System.out.println("ped_race index is: "+ pedRaceInd);


		while ((line = br.readLine()) != null) {
			//Get one tuple. A tuple may possibly have several artists in it.

		// categorize age into age group
			ArrayList<String> data = new ArrayList<String>(Arrays.asList(line.split(",(?=(?:[^\"]*\"[^\"]*\")*[^\"]*$)")));

			PedInjure pedInjureAdd = new PedInjure();

			// System.out.println("entire list "+ data);

			pedInjureAdd.ped_pos = data.get(pedPosInd);
			pedInjureAdd.ped_race = data.get(pedRaceInd);
			pedInjureAdd.ped_age = data.get(pedAgeInd).trim();
			pedInjureAdd.ped_injury = data.get(pedInjuInd);
			pedInjureAdd.ped_sex = data.get(pedSexInd);
			pedInjureAdd.PedCrashID = crashId;

			System.out.println("ped_age is: "+ data.get(pedAgeInd));
			System.out.println("ped_race is: "+ data.get(pedRaceInd));
			// System.out.println("at 19 is: "+ data.get(21));
			// System.out.println("at 20 is: "+ data.get(22));
			// System.out.println("the line : " + data);

			String ageStr = data.get(pedAgeInd);
			String ageGroup = "";
			double ageDouble = 0.0;

			if (ageStr.equals("Unknown") || ageStr.equals("0")) {
				ageGroup = "Unknown";
			} else if (ageStr.equals("70+")) {
				ageGroup = "70+";
				System.out.println("got here "+ ageGroup);
			} else {
				ageDouble = Double.parseDouble(ageStr);
			}

			if (isBetween(ageDouble, 1, 10)) {
				ageGroup = "6-10";
			} else if (isBetween(ageDouble, 11, 15)) {
				ageGroup = "11-15";
			}else if (isBetween(ageDouble, 16, 19)) {
				ageGroup = "16-19";
			}else if (isBetween(ageDouble, 20, 24)) {
				ageGroup = "20-24";
			}else if (isBetween(ageDouble, 25, 29)) {
				ageGroup = "25-29";
			}else if (isBetween(ageDouble, 30, 39)) {
				ageGroup = "30-39";
			}else if (isBetween(ageDouble, 40, 49)) {
				ageGroup = "40-49";
			}else if (isBetween(ageDouble, 50, 59)) {
				ageGroup = "50-59";
			}else if (isBetween(ageDouble, 60, 69)) {
				ageGroup = "60-69";
			}

			pedInjureAdd.pedage_grp = ageGroup;
			tupleList.add(pedInjureAdd);
			//System.out.println("the pedinjure add is: " + pedInjureAdd.toString());
			System.out.println("the crash id is: " + pedInjureAdd.PedCrashID);

			crashId += 1;
		}
		br.close();
	}
	
	private static boolean isNumeric(String str) {  
	  try {  
	    @SuppressWarnings("unused")
		double d = Double.parseDouble(str);
	  } catch(NumberFormatException nfe) {  
	    return false;  
	  }  
	  return true; 
	}
	
	public static boolean isBetween(double x, double lower, double upper) {
  		return lower <= x && x <= upper;
	}


	
	public static void main(String args[]) throws IOException {
		System.out.println("Program started...");
		File inFile = new File(INPUT_FILE);
		File outFile = new File(OUTPUT_FILE);
		File errorFile = new File(ERROR_FILE);
		parse(inFile, outFile, errorFile);
		System.out.println("Parsing successful!");
	}
	
}
