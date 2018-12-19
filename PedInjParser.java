import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Scanner;

public class PedInjParser {

	private static final String INPUT_FILE = "pedestrian-crashes-chapel-hill-region.csv";
	private static final String OUTPUT_FILE = "out-pedestrian-injured.csv";
	private static final String ERROR_FILE = "out-pedestrian-injured-error.csv";
	private static final String SQL_FILE = "pedInjure.sql";
	private static final int NUM_ELEMENTS = 10;
	private static HashSet<String> pedInjure = new HashSet<>();
	private static HashSet<String> errorpedInjure = new HashSet<>();
	
	private static void parse(File inFile, File outFile, File errorFile) throws IOException {
		BufferedWriter writer = new BufferedWriter(new Fi leWriter(outFile));
		BufferedWriter errorWriter = new BufferedWriter(new FileWriter(errorFile));
		BufferedWriter sqlWriter = new BufferedWriter(new FileWriter(SQL_FILE, true));
		ArrayList<PedInjure> tupleList = new ArrayList<>();
		tupleSeparator(tupleList, inFile, outFile);
		
		//This part should be commented out after executing this program
		//for the first time for the first horizontally fragmented table.
		//It won't matter with running the program though.
		sqlWriter.write("Drop TABLE IF EXISTS PedInjure;\n");
		sqlWriter.write("CREATE TABLE PedInjure(\n");
		sqlWriter.write("pedCrashId INT NOT NULL AUTO_INCREMENT");
		sqlWriter.write("    ,ped_pos      VARCHAR(46) NOT NULL\n");
		sqlWriter.write("    ,ped_race     VARCHAR(15) NOT NULL\n");
		sqlWriter.write("    ,pedage_grp   VARCHAR(7) NOT NULL\n");
		sqlWriter.write("    ,ped_age      VARCHAR(7) NOT NULL\n");
		sqlWriter.write("    ,ped_injury   VARCHAR(19) NOT NULL \n");
		sqlWriter.write("    ,ped_sex      VARCHAR(7) NOT NULL\n");
		sqlWriter.write("   ,CreditLine         VARCHAR(70)\n");
		sqlWriter.write("   ,Classification         VARCHAR(30)\n");
		sqlWriter.write("   ,Department         VARCHAR(30)\n");
		sqlWriter.write("   ,YearAcquired         INTEGER\n");
		sqlWriter.write("   ,CuratorApproved         VARCHAR(2)\n");
		sqlWriter.write("   ,ObjectId         INTEGER NOT NULL\n");
		sqlWriter.write("   ,PRIMARY KEY(pedCrashId)\n");
		sqlWriter.write(");\n");

		writer.write(" pedCrashId,ped_pos,  ped_race,  pedage_grp,  ped_age,  ped_injury,  ped_sex\n");
		errorWriter.write(" pedCrashId,ped_pos,  ped_race,  pedage_grp,  ped_age,  ped_injury,  ped_sex\n");


		//Write the result in a csv file
		for (int i = 0; i < tupleList.size(); i++) {
			PedInjure oneEntry = tupleList.get(i);
			// if (!oneEntry.containsError() && isNumeric(oneEntry.year)) {
			if (!oneEntry.containsError()) {
				String key = oneEntry.pedCrashId + "";
				if (!pedInjure.contains(key)) {
					pedInjure.add(key);
					writer.write(oneEntry.toString() + "\n");
					sqlWriter.write(oneEntry.toSqlStatement() + "\n");
				}
			} else {
				String key = oneEntry.objectId + "";
				if (!errorpedInjure.contains(key)) {
					errorpedInjure.add(key);
					errorpedInjure.write(oneEntry.toString() + "\n");
				}
			}
		}
		writer.close();
		errorWriter.close();
		sqlWriter.close();
	}
	
	private static void tupleSeparator(ArrayList<Artwork> tupleList, File inFile, File outFile) 
																			throws IOException, StringIndexOutOfBoundsException {

		BufferedReader br = new BufferedReader(new FileReader(INPUT_FILE));
		String line;
		while ((line = br.readLine()) != null) {
			//Get one tuple. A tuple may possibly have several artists in it.
			int lineLen = line.length();
			int positionStart = 0;
			int positionEnd = 0;
			int index = 0;
			String item = "";
			Artwork artworkToAdd = new Artwork();
			
			while (positionStart < lineLen && index != NUM_ELEMENTS) {
				positionEnd = line.indexOf(',', positionStart);
				if (positionEnd == -1) {
					item = line.substring(positionStart);
				} else {
					item = line.substring(positionStart, positionEnd);
				}
				
				switch(index) {
				case 0: //title
					artworkToAdd.title = item.trim();
					break;
					
				case 1: //year
					
					boolean flag = false;
					int count = 0;
					for (int i = 0; i < item.length(); i++) {
						if (item.charAt(i) == '/') {
							count++;
						}
					}
					if (count == 2) {
						flag = true;
					}
					
					//Error handling with the year attribute
					if (item.contains("c. ")) {
						item = item.substring(3, 7);
					} else if (item.contains("c.")) {
						item = item.substring(2, 6);
					} else if (item.contains("Unknown") || item.length() == 0 || item.contains("n.d")) {
						item = "-1";
					} else if (item.contains("after") || item.contains("After")) {
						item = item.substring(6, 10) + "";
					} else if (item.contains("early") || item.contains("Early")) {
						item = item.substring(6, 10) + "";
					} else if (item.contains("before") || item.contains("Before")) {
						item = item.substring(7, 11) + "";
					} else if (flag) {
						int lastIndex = item.lastIndexOf('/');
						item = item.substring(lastIndex + 1, lastIndex + 5); 
					} else if (item.contains("newspaper")) {
						item = item.substring(item.length() - 5, item.length() - 1);
					} else if (item.charAt(0) == '-') {
						item = item.substring(1, 5);
					} else {
						Scanner sc = new Scanner(item);
						boolean matchFound = false;
						while (sc.hasNext()) {
							String temp = sc.next();
							if (temp.length() < 4) {
								continue;
							}
							if (temp.contains("(") && temp.length() >= 5) {
								temp = temp.substring(1, 5);
							} else {
								temp = temp.substring(0, 4);
							}
							if (isNumeric(temp) && Integer.parseInt(temp) < 2016) {
								matchFound = true;
								item = temp;
								break;
							}
						}
						if (!matchFound) {
							item = "-1";
						}
						sc.close();
					}
					artworkToAdd.year = item.trim();
					break;
					
				case 2: //medium
					artworkToAdd.medium = item.trim();
					break;
					
				case 3: //dimensions
					if (item.contains("(") && item.contains(")")) {
						int leftParenIndex = item.indexOf('(');
						int rightParenIndex = item.indexOf(')');
						item = item.substring(leftParenIndex + 1, rightParenIndex);
						int countMult = 0;
						int[] multIndices = new int[2];
						for (int i = 0; i < item.length(); i++) {
							if (item.charAt(i) == 'x') {
								if (countMult == 2) {
									break;
								}
								multIndices[countMult++] = i;
							}
						}
						try {
							if (countMult == 1) {
								String w = item.substring(0, multIndices[0]).trim();
								if (w.contains("w. ") || w.contains("l. ") || w.contains("h. ")) {
									w = w.substring(3);
								}
								artworkToAdd.width = w.trim();
								String h = item.substring(multIndices[0] + 2, item.length() - 2).trim();
								if (h.contains("w. ") || h.contains("l. ") || h.contains("h. ")) {
									h = h.substring(3);
								}
								artworkToAdd.height = h.trim();
							} else if (countMult == 2) {
								String w = item.substring(0, multIndices[0]).trim();
								if (w.contains("w. ") || w.contains("l. ") || w.contains("h. ")) {
									w = w.substring(3);
								}
								artworkToAdd.width = w.trim();
								String h = item.substring(multIndices[0] + 2, multIndices[1]).trim();
								if (h.contains("w. ") || h.contains("l. ") || h.contains("h. ")) {
									h = h.substring(3);
								}
								artworkToAdd.height = h.trim();
								String d = item.substring(multIndices[1] + 2, item.length() - 2).trim();
								if (d.contains("w. ") || d.contains("l. ") || d.contains("h. ")) {
									d = d.substring(3);
								}
								artworkToAdd.depth = d.trim();
							}
						} catch(NumberFormatException e) {
							artworkToAdd.width = "error";
							artworkToAdd.height = "error";
							artworkToAdd.depth = "error";
						} catch(StringIndexOutOfBoundsException se) {
							artworkToAdd.width = "error";
							artworkToAdd.height = "error";
							artworkToAdd.depth = "error";
						}

					}
					break;
					
				case 4: //creditLine
					artworkToAdd.creditLine = item.trim();
					break;
					
				case 5: //classification
					artworkToAdd.classification = item.trim();
					break;
					
				case 6: //department
					artworkToAdd.department = item.trim();
					break;
					
				case 7: //yearAcquired
					item = item.trim();
					try {
						artworkToAdd.yearAcquired = item.substring(item.length() - 4);
					} catch(NumberFormatException e) {
						artworkToAdd.yearAcquired = "-1";
					} catch(StringIndexOutOfBoundsException se) {
						artworkToAdd.yearAcquired = "-1";
					}
					break;
					
				case 8: //curatorApproved
					artworkToAdd.curatorApproved = item.trim();
					break;
					
				case 9: //objectId
					try {
						artworkToAdd.objectId = Integer.parseInt(item);
					} catch(NumberFormatException e) {
						artworkToAdd.objectId = -1;
					} catch(StringIndexOutOfBoundsException se) {
						artworkToAdd.objectId = -1;
					}
					break;
					default:
						break;
				}
				
				positionStart = positionEnd + 1;
				index++;
			}
			tupleList.add(artworkToAdd);
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
	
	
	public static void main(String args[]) throws IOException {
		System.out.println("Program started...");
		File inFile = new File(INPUT_FILE);
		File outFile = new File(OUTPUT_FILE);
		File errorFile = new File(ERROR_FILE);
		parse(inFile, outFile, errorFile);
		System.out.println("Parsing successful!");
	}
	
}
