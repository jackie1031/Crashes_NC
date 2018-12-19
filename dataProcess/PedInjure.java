public class PedInjure{


	public String ped_pos;
	public String ped_race;
	public String pedage_grp;
	public String ped_age;
	public String ped_injury;
	public String ped_sex;
	public int PedCrashID;


	public PedInjure(){}

	public PedInjure(String ped_pos, String ped_race, String pedage_grp, String ped_age, 
		String ped_injury, String ped_sex, int PedCrashID) {
		this.PedCrashID = PedCrashID;
		this.ped_pos = ped_pos;
		this.ped_race = ped_race;
		this.pedage_grp = pedage_grp;
		this.ped_age = ped_age;
		this.ped_injury = ped_injury;
		this.ped_sex = ped_sex;
	}


	public String toSqlStatement() {
		
		return "INSERT INTO PedInjure(PedCrashID,ped_pos,ped_race,pedage_grp,ped_age,ped_injury,ped_sex) VALUES (" 
				 + this.PedCrashID + ", '" + this.ped_pos + "','" + this.ped_race + "','" + pedage_grp + "','" + this.ped_age + "','"
				+ this.ped_injury + "','" + this.ped_sex + "');";
	}
	
	public boolean containsError() {
		if (this.PedCrashID == -1) {
			return true;
		}
		if (this.ped_age.equals("error") || this.ped_sex.equals("error")) {
			return true;
		}
		return false;
	}


	@Override
	public String toString() {
		return "pedInjure{" +
				"ped_pos='" + ped_pos + '\'' +
				", ped_race='" + ped_race + '\'' +
				", pedage_grp='" + pedage_grp + '\'' +
				", ped_age='" + ped_age + '\'' +
				", ped_injury='" + ped_injury + '\'' +
				", ped_sex='" + ped_sex + '\'' +
				", PedCrashID='" + PedCrashID + '\'' +
				'}';
	}
}
