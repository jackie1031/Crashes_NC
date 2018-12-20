public class ReasonPed{

	public String crashalcoh;
	public String excsspdind;
	public String ped_pos;
	public String drvr_injur;
	public String hit_run;
	public String drvr_estsp;
	public String speed_limi;
	public int PedCrashID;
	public int exceedSpeed;

	public ReasonPed(){}
	

	public ReasonPed(String speed_limi,String crashalcoh, String excsspdind, String ped_pos, String drvr_injur, String hit_run, String drvr_estsp, int pedCrashID, int exceedSpeed) {
		this.speed_limi = speed_limi;
		this.PedCrashID = pedCrashID;
		this.crashalcoh = crashalcoh;
		this.excsspdind = excsspdind;
		this.ped_pos = ped_pos;
		this.drvr_injur = drvr_injur;
		this.hit_run = hit_run;
		this.drvr_estsp = drvr_estsp;
		this.exceedSpeed = exceedSpeed;
	}


	public String toSqlStatement() {
		
		return "INSERT INTO ReasonPed(PedCrashID,crashalcoh,excsspdind,ped_pos,drvr_injur,hit_run,drvr_estsp,exceedSpeed, speed_limi) VALUES (" 
				 + this.PedCrashID + ", '" + this.crashalcoh + "','" + this.excsspdind + "','" + ped_pos + "','" + this.drvr_injur + "','"
				+ this.hit_run + "','" +this.drvr_estsp + "'," +this.exceedSpeed + ",'" + this.speed_limi + "');";
	}
	
	public boolean containsError() {
		if (this.PedCrashID == -1) {
			return true;
		}
		if (this.speed_limi.equals(null) || this.drvr_estsp.equals("0")) {
			return true;
		}
		return false;
	}


	@Override
	public String toString() {
		return "ReasonPed{" +
				"crashalcoh='" + crashalcoh + '\'' +
				", excsspdind='" + excsspdind + '\'' +
				", ped_pos='" + ped_pos + '\'' +
				", drvr_injur='" + drvr_injur + '\'' +
				", hit_run='" + hit_run + '\'' +
				", drvr_estsp='" + drvr_estsp + '\'' +
				", PedCrashID=" + PedCrashID +
				", exceedSpeed=" + exceedSpeed +
				", speed_limi=" + speed_limi +
				'}';
	}
}
