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

public class ReasonPedParser {

	// private static final String INPUT_FILE = "ped_test.csv";
	// private static final String INPUT_FILE = "ped_test.csv";
	private static final String INPUT_FILE = "pedestrianData.csv";
	private static final String OUTPUT_FILE = "out-pedestrian-reason.csv";
	private static final String ERROR_FILE = "out-pedestrian-reason-error.csv";
	private static final String SQL_FILE = "reasonPed.sql";
	private static final int NUM_ELEMENTS = 10;
	private static HashSet<String> reasonPed = new HashSet<>();
	private static HashSet<String> errorreasonPed = new HashSet<>();
	
	private static void parse(File inFile, File outFile, File errorFile) throws IOException {
		BufferedWriter writer = new BufferedWriter(new FileWriter(outFile));
		BufferedWriter errorWriter = new BufferedWriter(new FileWriter(errorFile));
		BufferedWriter sqlWriter = new BufferedWriter(new FileWriter(SQL_FILE, true));

		ArrayList<ReasonPed> tupleList = new ArrayList<>();
		tupleSeparator(tupleList, inFile, outFile);
		sqlWriter.write("Drop TABLE IF EXISTS ReasonPed;\n");
		sqlWriter.write("CREATE TABLE ReasonPed(\n");
		sqlWriter.write("PedCrashID INTEGER NOT NULL \n");
		sqlWriter.write("    ,crashalcoh      VARCHAR(60) NOT NULL\n");
		sqlWriter.write("    ,excsspdind     VARCHAR(30) NOT NULL\n");
		sqlWriter.write("    ,ped_pos   VARCHAR(60) NOT NULL\n");
		sqlWriter.write("    ,drvr_injur      VARCHAR(30) NOT NULL\n");
		sqlWriter.write("    ,hit_run   VARCHAR(5) NOT NULL \n");
		sqlWriter.write("    ,drvr_estsp      VARCHAR(30) NOT NULL\n");
		sqlWriter.write("    ,exceedSpeed      VARCHAR(30) NOT NULL\n");
		sqlWriter.write("    ,speed_limi      INTEGER NOT NULL\n");
		sqlWriter.write("   ,PRIMARY KEY(PedCrashID)\n");
		sqlWriter.write(");\n");

		writer.write(" PedCrashID,crashalcoh,excsspdind,ped_pos,drvr_injur,hit_run,drvr_estsp,exceedSpeed, speed_limi\n");
		errorWriter.write(" PedCrashID,crashalcoh,excsspdind,ped_pos,drvr_injur,hit_run,drvr_estsp,exceedSpeed, speed_limi\n");


		//Write the result in a csv file
		for (int i = 0; i < tupleList.size(); i++) {
			ReasonPed oneEntry = tupleList.get(i);
			// if (!oneEntry.containsError() && isNumeric(oneEntry.year)) {
			if (!oneEntry.containsError()) {
				String key = oneEntry.PedCrashID + "";
				if (!reasonPed.contains(key)) {
					reasonPed.add(key);
					writer.write(oneEntry.toString() + "\n");
					sqlWriter.write(oneEntry.toSqlStatement() + "\n");
				}
			} else {
				String key = oneEntry.PedCrashID + "";
				if (!errorreasonPed.contains(key)) {
					errorreasonPed.add(key);
					errorWriter.write(oneEntry.toString() + "\n");
				}
			}
		}
		sqlWriter.close();
	    System.out.println("done......");
	}
	
	private static void tupleSeparator(ArrayList<ReasonPed> tupleList, File inFile, File outFile) throws IOException, 
			StringIndexOutOfBoundsException {

		BufferedReader br = new BufferedReader(new FileReader(INPUT_FILE));
		String line;
		String headers;
		int crashId = 1;

		// find index of needed data
		headers = br.readLine().trim();
		ArrayList<String> header = new ArrayList<String>(Arrays.asList(headers.split(",")));

		// System.out.println("header is: "+ header);

		int crashalcoh = header.indexOf("crashalcoh");
		int excsspdind = header.indexOf("excsspdind");
		int ped_pos = header.indexOf("ped_pos");
		int drvr_injur = header.indexOf("drvr_injur");
		int hit_run = header.indexOf("hit_run");
		int drvr_estsp = header.indexOf("drvr_estsp");
		int speed_limi = header.indexOf("speed_limi");
		
		//System.out.println("ped_race index is: "+ pedRaceInd);


		while ((line = br.readLine()) != null) {
			//Get one tuple. A tuple may possibly have several artists in it.

			ArrayList<String> data = new ArrayList<String>(Arrays.asList(line.split(",(?=(?:[^\"]*\"[^\"]*\")*[^\"]*$)")));

			ReasonPed reasonPedAdd = new ReasonPed();


			reasonPedAdd.crashalcoh = data.get(crashalcoh);
			reasonPedAdd.excsspdind = data.get(excsspdind);
			reasonPedAdd.ped_pos = data.get(ped_pos).trim();
			reasonPedAdd.drvr_injur = data.get(drvr_injur);
			reasonPedAdd.hit_run = data.get(hit_run);
			reasonPedAdd.drvr_estsp = data.get(drvr_estsp);
			reasonPedAdd.speed_limi = data.get(speed_limi);

			reasonPedAdd.PedCrashID = crashId;


			String speedLimiTmp = data.get(speed_limi).trim();
			String speedLimir = speedLimiTmp.substring(0, speedLimiTmp.length()-3).trim();

			String driverSpeedTmp = data.get(drvr_estsp).trim();
			String driverSpeed = driverSpeedTmp.substring(0, driverSpeedTmp.length()-3).trim();

			int exceedSpeed = 0;

			if (speedLimir.equals("Unkn") || driverSpeed.equals("Unkn")) {
				exceedSpeed = -1;
			} else{
				// parse these two and calculate
				ArrayList<String> limit = new ArrayList<String>(Arrays.asList(speedLimir.split("-")));
				ArrayList<String> driverSp = new ArrayList<String>(Arrays.asList(driverSpeed.split("-")));
				exceedSpeed = Integer.parseInt(driverSp.get(1).trim()) - Integer.parseInt(limit.get(1).trim());
			}

			reasonPedAdd.exceedSpeed = exceedSpeed;
			tupleList.add(reasonPedAdd);
			//System.out.println("the pedinjure add is: " + reasonPedAdd.toString());
			System.out.println("the crash id is: " + reasonPedAdd.PedCrashID);

			crashId += 1;
		}
		br.close();
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
