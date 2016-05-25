package com.view.gameWindow.panel.panels.boss.dungeonindividualboss
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.DgnRewardEvaluateCfgData;
	import com.model.configData.cfgdata.DungeonCfgData;
	import com.model.configData.cfgdata.NpcShopCfgData;
	import com.model.consts.ItemType;
	import com.model.consts.SlotType;
	import com.model.consts.StringConst;
	import com.model.frame.FrameManager;
	import com.model.frame.IFrame;
	import com.pattern.Observer.IObserver;
	import com.view.gameWindow.flyEffect.FlyEffectMediator;
	import com.view.gameWindow.mainUi.subuis.bottombar.ExpRecorder;
	import com.view.gameWindow.panel.panels.boss.BossDataManager;
	import com.view.gameWindow.panel.panels.boss.MCIndividualBossDgn;
	import com.view.gameWindow.panel.panels.dungeon.DgnDataManager;
	import com.view.gameWindow.panel.panels.dungeon.DgnGoalsDataManager;
	import com.view.gameWindow.panel.panels.dungeon.DungeonData;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.TimeUtils;
	import com.view.gameWindow.util.UtilItemParse;
	import com.view.gameWindow.util.cell.IconCellEx;
	import com.view.gameWindow.util.cell.ThingsData;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;

	public class PanelIndividualBossViewHandle implements IFrame,IObserver
	{
		private var _skin:MCIndividualBossDgn;
		private var _panel:PanelIndividualBoss;
		private var _awards:Array = [];
		public var cellDatas:Array = [];
		private var _leftTimes:int;
		private var npcId:int = 70101;
		private var npcDict:Object = {701:701,702:702,703:703,704:704};

		private var _iconReward:IconCellEx;

		private var _iconEquips:Vector.<IconCellEx>;
		
		private const NUM_EQUIP:int = 6;
		
		public function PanelIndividualBossViewHandle(panel:PanelIndividualBoss)
		{
			_skin = panel.skin as MCIndividualBossDgn;
			_panel = panel;
		}
		
		public function initialize():void
		{
			DgnDataManager.instance.attach(this);
			var dungeonId:int = BossDataManager.instance.dungeonId;
			var cfgDt:DungeonCfgData = ConfigDataManager.instance.dungeonCfgDataId(dungeonId);
			
			if(npcDict[dungeonId])
			{
				npcId = npcDict[dungeonId];
			}
			else
			{
				npcId = 600;//转生
			}
			
			var dic:Dictionary = ConfigDataManager.instance.npcShopCfgDatas(npcId);
			 
			for each (var tempns:NpcShopCfgData in dic)
			{
				cellDatas.push(tempns);
			}
			
			var temp:MovieClip;
			var cellEx:IconCellEx;
			var dt:ThingsData;
			for(var i:int = 0; i < 2;i++)
			{
				temp = _skin.getChildByName("mcIcon"+i) as MovieClip;
				temp.mc.visible = false;
				temp.addEventListener(MouseEvent.ROLL_OVER,function onRollOver(e:MouseEvent):void
				{
					e.target.mc.visible = false;
				},false,0,true);
				temp.addEventListener(MouseEvent.ROLL_OUT,function onRollOut(e:MouseEvent):void
				{
					e.target.mc.visible = true;
				},false,0,true);
				cellEx = new IconCellEx(temp.parent,temp.x,temp.y,temp.width,temp.height);	
				dt = new ThingsData();
				dt.id =  cellDatas[i].base;
				dt.type = SlotType.IT_ITEM;
				IconCellEx.setItemByThingsData(cellEx,dt);
				_awards.push(cellEx);
				ToolTipManager.getInstance().attach(cellEx);
			}
			_skin.loginTxt.text = StringConst.DUNGEON_PANEL_0027;
			_skin.loginTxt.mouseEnabled = false;
			_skin.txtMstInfo.text = StringConst.BOSS_INFO_0001;
			_skin.buyTxt1.htmlText = "<u><a href='#'>"+StringConst.NPC_SHOP_PANEL_0002+"</a><u>";
			_skin.buyTxt2.htmlText = "<u><a href='#'>"+StringConst.NPC_SHOP_PANEL_0002+"</a><u>";
			
			_skin.dngNameTxt.text = cfgDt.name;
			/*var format:TextFormat = new TextFormat();
			format.leading = 7;
			_skin.txtDesc.defaultTextFormat = format;
			_skin.txtDesc.htmlText = CfgDataParse.pareseDesToStr(cfgDt.desc);*/
			
			_leftTimes = cfgDt.duration *1000;
			
			_skin.txtCountdownTime.text = TimeUtils.formatS2(TimeUtils.calcTime2(_leftTimes));
			FrameManager.instance.addObj(this);
			
			initReward();
			
			initEquips();
		}
		
		private function initReward():void
		{
			var dungeonId:int = BossDataManager.instance.dungeonId;
			var cfgDt:DgnRewardEvaluateCfgData = ConfigDataManager.instance.dungeonRewardEvaluateCfgData(dungeonId,1);
			_skin.txtReward.text = StringConst.BOSS_INFO_0002;
			_skin.txtRewardValue.htmlText = HtmlUtils.createHtmlStr(_skin.txtReward.textColor,StringConst.BOSS_INFO_0003) + cfgDt.exp;
			//
			var mcReward:MovieClip = _skin.mcReward;
			_iconReward = new IconCellEx(mcReward.parent,mcReward.x,mcReward.y,mcReward.height,mcReward.width);
			IconCellEx.setItem(_iconReward,SlotType.IT_ITEM,ItemType.IT_EXP,cfgDt.exp,true);
			ToolTipManager.getInstance().attach(_iconReward);
		}
		
		private function initEquips():void
		{
			var dungeonId:int = BossDataManager.instance.dungeonId;
			var cfgDt:DungeonCfgData = ConfigDataManager.instance.dungeonCfgDataId(dungeonId);
			var strBossDrop:String = cfgDt.mapCfgData.boss_drop;
			if(!strBossDrop)
			{
				return;
			}
			var dts:Vector.<ThingsData> = UtilItemParse.getThingsDatasByFilter(strBossDrop,function(dt:ThingsData):Boolean
			{
				if(dt.type != SlotType.IT_EQUIP)
				{
					return false;
				}
				if(!dt.equipCfgData)
				{
					return true;
				}
				var job:int = RoleDataManager.instance.job;
				if(dt.equipCfgData.job != 0 && dt.equipCfgData.job != job)
				{
					return true;
				}
				var sex:int = RoleDataManager.instance.sex;
				if(dt.equipCfgData.sex != 0 && dt.equipCfgData.sex != sex)
				{
					return true;
				}
				return false;
			});
			//
			_skin.txtEquip.text = StringConst.BOSS_INFO_0004;
			
			if(!_iconEquips)
			{
				_iconEquips = new Vector.<IconCellEx>(NUM_EQUIP,true);
			}
			var i:int,l:int = dts ? (dts.length < NUM_EQUIP ? dts.length : NUM_EQUIP) : 0;
			for (i=0;i<l;i++) 
			{
				var mcEquip:MovieClip = _skin["mcEquip"+i] as MovieClip;
				var iconEquip:IconCellEx = new IconCellEx(mcEquip.parent,mcEquip.x,mcEquip.y,mcEquip.width,mcEquip.height);
				_iconEquips[i] = iconEquip;
				IconCellEx.setItemByThingsData(iconEquip,dts[i]);
				ToolTipManager.getInstance().attach(iconEquip);
			}
		}
		
		public function updateTime(time:int):void
		{
			var delayTime:int = _leftTimes  -time;
			_leftTimes = delayTime;
			if(0>=_leftTimes)
			{
				FrameManager.instance.removeObj(this);
				//DgnGoalsDataManager.instance.requestCancel();			
				var id:uint;
				if(_skin.loginTxt.text == StringConst.BOSS_INFO_0005)
				{
					ExpRecorder.storeData();
					var startPoint:Point = _skin.localToGlobal(new Point(_skin.mcReward.x + ((_skin.mcReward.width) >> 1), _skin.mcReward.y + 20));
					FlyEffectMediator.instance.deExpStoneEffect(startPoint);
					id = setInterval(leaveFun,1200);
				}
				else
				{
					DgnGoalsDataManager.instance.requestCancel();
				}
				function leaveFun():void
				{
					clearInterval(id);
					DgnGoalsDataManager.instance.requestCancel();
				}
			}
			var min:int = delayTime/60000;
			var sec:int = delayTime/1000%60;
			var htmlStr:String = HtmlUtils.createHtmlStr(0xff0000,StringConst.SURPLUS+min+StringConst.MINIUTE+sec+StringConst.SECOND);
			 
			_skin.txtCountdownTime.htmlText = htmlStr;  
		}
		
		public function update(proc:int=0):void
		{
			if(proc == GameServiceConstants.SM_CHR_DUNGEON_INFO)
			{
				var dungeonId:int = BossDataManager.instance.dungeonId;
				var dt:DungeonData = DgnDataManager.instance.datas[dungeonId] as DungeonData;
				if(dt.daily_complete_count > 0)
				{
					_skin.loginTxt.text = StringConst.BOSS_INFO_0005;
				}
			}
		}
		
		public function destroy():void
		{
			DgnDataManager.instance.detach(this);
			var iconEquip:IconCellEx;
			for each(iconEquip in _iconEquips)
			{
				if(iconEquip)
				{
					ToolTipManager.getInstance().detach(iconEquip);
					iconEquip.destroy();
				}
			}
			_iconEquips = null;
			if(_iconReward)
			{
				ToolTipManager.getInstance().detach(_iconReward);
				_iconReward.destroy();
				_iconReward = null;
			}
			ToolTipManager.getInstance().detach(_awards[0]);
			ToolTipManager.getInstance().detach(_awards[1]);
			FrameManager.instance.removeObj(this);
			cellDatas.length = 0;
			_awards.length = 0;
			_awards = null;
			cellDatas = null;
		}
	}
}