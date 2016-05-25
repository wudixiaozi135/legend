package com.view.gameWindow.panel.panels.activitys.nightFight
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.business.gameService.serverMessageManager.dataManager.IDataManager;
	import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
	import com.model.consts.StringConst;
	import com.pattern.Observer.Observe;
	import com.view.gameWindow.common.ModelEvents;
	import com.view.gameWindow.mainUi.subuis.activityTrace.ActivityDataManager;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	import com.view.gameWindow.util.HtmlUtils;
	
	import flash.utils.ByteArray;
	
	/**
	 * 夜战比奇数据类
	 * @author Administrator
	 */	
	public class NightFightDataManager extends Observe implements IDataManager
	{
		public var scoreMine:int;
		public var rankMine:int;
		public var dtsRank:Vector.<DataNightFightRank>;
		public const TOTAL_DTS:int = 10;
		public var totalExp:int;
		
		private var killingColors:Vector.<int> = new <int>[0xffffff,0x00ff00,0x00a2ff,0xac00ff,0xac00ff,0xff0000,0xff0000,0xffcc00];
		
		public function get strRankMine():String
		{
			if(rankMine > 100)
			{
				return 100+StringConst.NIGHT_FIGHT_TRACE_0006;
			}
			else
			{
				return rankMine+"";
			}
		}
		
		public function NightFightDataManager()
		{
			super();
			DistributionManager.getInstance().register(GameServiceConstants.SM_ACTIVITY_BIQI_NIGHT_SCORE_AND_RANK,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_ACTIVITY_BIQI_NIGHT_SCORE_RANK_LIST,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_ACTIVITY_BIQI_NIGHT_KILL_CONTINUOUS,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_ACTIVITY_BIQI_NIGHT_RESULT,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_ACTIVITY_BIQI_NIGHT_TIME_COUNT,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_ACTIVITY_BIQI_NIGHT_TOTAL_EXP,this);
			//
			dtsRank = new Vector.<DataNightFightRank>(TOTAL_DTS,true);
			var i:int;
			for (i=0;i<TOTAL_DTS;i++) 
			{
				var dt:DataNightFightRank = new DataNightFightRank();
				dt.rank = i+1;
				dtsRank[i] = dt;
			}
		}
		
		public function resolveData(proc:int, data:ByteArray):void
		{
			switch (proc)
			{
				case GameServiceConstants.SM_ACTIVITY_BIQI_NIGHT_TOTAL_EXP:
					dealSmActivityBiqiNightTotalExp(data);
					break;
				case GameServiceConstants.SM_ACTIVITY_BIQI_NIGHT_TIME_COUNT:
					dealSmActivityBiqiNightTimeCount();
					break;
				case GameServiceConstants.SM_ACTIVITY_BIQI_NIGHT_RESULT:
					dealSmActivityBiqiNightResult(data);
					break;
				case GameServiceConstants.SM_ACTIVITY_BIQI_NIGHT_KILL_CONTINUOUS:
					dealSmActivityBiqiNightKillContinuous(data);
					break;
				case GameServiceConstants.SM_ACTIVITY_BIQI_NIGHT_SCORE_AND_RANK:
					dealSmActivityBiqiNightScoreAndRank(data);
					break;
				case GameServiceConstants.SM_ACTIVITY_BIQI_NIGHT_SCORE_RANK_LIST:
					dealSmActivityBiqiNightScoreRankList(data);
					break;
				default:
					break;
			}
			notify(proc);
		}
		
		private function dealSmActivityBiqiNightTotalExp(data:ByteArray):void
		{
			totalExp = data.readInt();
		}
		
		private function dealSmActivityBiqiNightTimeCount():void
		{
			PanelMediator.instance.openPanel(PanelConst.TYPE_NIGHT_CHANGE);
		}
		
		private function dealSmActivityBiqiNightResult(data:ByteArray):void
		{
			var count:int = data.readByte();//1字节有符号整形，排行数量，最大为10
			while(count--)//下面缩进部分为按照count循环，包含榜单数据
			{
				var dt:DataNightFightRank = new DataNightFightRank();
				dt.rank = data.readByte();
				dt.sid = data.readInt();
				dt.cid = data.readInt();
				dt.name = data.readUTF();
				dt.reincarn = data.readByte();
				dt.level = data.readShort();
				dt.job = data.readByte();
				dt.score = data.readInt();
				dtsRank[dt.rank-1] = dt;
			}
			PanelMediator.instance.openPanel(PanelConst.TYPE_NIGHT_FIGHT_RANK);
		}
		
		private function dealSmActivityBiqiNightKillContinuous(data:ByteArray):void
		{
			var cid:int = data.readInt();//4字节有符号整形，角色id
			var sid:int = data.readInt();//4字节有符号整形，角色的服务器id
			var name:String = data.readUTF();//utf-8格式，角色名
			var killCount:int = data.readShort();//2字节有符号整形,连续击杀数量
			if(killCount < 3)
			{
				trace("NightFightDataManager.dealSmActivityBiqiNightKillContinuous(data) 错误的连杀次数");
				return;
			}
			var text:String = HtmlUtils.createHtmlStr(0xffe1aa,name+"  ",14,true) + HtmlUtils.createHtmlStr(0xff6600,StringConst.NIGHT_FIGHT_KILLING_0001 + "  ",14,true) + textKilling(killCount);
			RollTipMediator.instance.showRollTip(RollTipType.NFKILLING,text);
		}
		
		private function textKilling(count:int):String
		{
			var color:int = killingColors[count > 10 ? 7 : count - 3];
			var text:String;
			switch(count)
			{
				case 3:
					text = StringConst.NIGHT_FIGHT_KILLING_0002;
					break;
				case 4:
					text = StringConst.NIGHT_FIGHT_KILLING_0003;
					break;
				case 5:
					text = StringConst.NIGHT_FIGHT_KILLING_0004;
					break;
				case 6:
					text = StringConst.NIGHT_FIGHT_KILLING_0005;
					break;
				case 7:
					text = StringConst.NIGHT_FIGHT_KILLING_0006;
					break;
				case 8:
					text = StringConst.NIGHT_FIGHT_KILLING_0007;
					break;
				case 9:
					text = StringConst.NIGHT_FIGHT_KILLING_0008;
					break;
				case 10:
					text = StringConst.NIGHT_FIGHT_KILLING_0009;
					break;
				default:
					text = StringConst.NIGHT_FIGHT_KILLING_0009;
					break;
			}
			return HtmlUtils.createHtmlStr(color,text,14,true);
		}
		
		private function dealSmActivityBiqiNightScoreAndRank(data:ByteArray):void
		{
			scoreMine = data.readInt();//4字节有符号整形，当前积分
			rankMine = data.readShort();//2字节有符号整形,当前排名，从1开始，大于100的数值应显示为100名以外
			ActivityDataManager.instance.notify(ModelEvents.UPDATE_MAP_ACTIVITY);
		}
		
		private function dealSmActivityBiqiNightScoreRankList(data:ByteArray):void
		{
			var count:int = data.readByte();//1字节有符号整形，排行数量，最大为10
			while (count--)//下面缩进部分为按照count循环，包含榜单数据
			{
				var dt:DataNightFightRank = new DataNightFightRank();
				dt.rank = data.readByte();
				dt.sid = data.readInt();
				dt.cid = data.readInt();
				dt.name = data.readUTF();
				dt.score = data.readInt();
				dtsRank[dt.rank-1] = dt;
			}
			ActivityDataManager.instance.notify(ModelEvents.UPDATE_MAP_ACTIVITY);
		}
	}
}