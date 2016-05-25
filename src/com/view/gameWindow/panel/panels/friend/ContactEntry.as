package com.view.gameWindow.panel.panels.friend
{
	import com.model.consts.JobConst;
	
	/**
	 * @author wqhk
	 * 2014-11-5
	 */
	public class ContactEntry
	{
		public var name:String;
		public var serverId:int;
		public var roleId:int;
		public var job:int;
		public var reincarn:int;
		public var lv:int;
		public var online:int;
		public var mood:String;
		
		public var type:int;
		public var vip:int;
		
		public function toDes():String
		{
			return "玩家名："+name+"\n 职业："+JobConst.jobName(job)+" "+" 等级："+(reincarn>0?reincarn+"转":"")+lv+"级";
		}
		
		public function toHeadDes():String
		{
			return  /*"["+entry.serverId+"区]"+*/name + "（"+JobConst.jobName2(job)+"）";
		}
		
		public function toLvDes():String
		{
			return (reincarn ? reincarn+"转":"") + lv + "级";
		}
		
		public function toVipDes():String
		{
			return vip ? "VIP:"+vip : "";
		}
		
		public function toTipDes():String
		{
			var txt:String = name + "\n职业："+JobConst.jobName(job)+"\n等级："+(reincarn ? reincarn+"转" : "")+lv + "级\n";
			
			txt += mood ? mood : "对方没有填写心情";
			
			return txt;
		}
		
		/**
		 * 1：申请者 2：被申请者
		 */
		public var messageType:int;
		
//		public function isSame(data:ContactEntry):Boolean
//		{
//			return  	name == data.name
//						&&serverId == data.serverId
//						&&roleId == data.roleId
//						&&job == data.job
//						&&reincarn == data.reincarn
//						&&lv == data.lv
//						&&online == data.online
//						&&mood == data.mood;
//		}
		
	}
}