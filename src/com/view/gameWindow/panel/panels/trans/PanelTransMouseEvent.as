package com.view.gameWindow.panel.panels.trans
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.ItemCfgData;
	import com.model.configData.cfgdata.LevelCfgData;
	import com.model.configData.cfgdata.MapCfgData;
	import com.model.configData.cfgdata.MapRegionCfgData;
	import com.model.configData.cfgdata.NpcTeleportCfgData;
	import com.model.consts.SlotType;
	import com.model.consts.StringConst;
	import com.model.dataManager.TeleportDatamanager;
	import com.view.gameWindow.flyEffect.FlyEffectMediator;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.dungeon.TextFormatManager;
	import com.view.gameWindow.panel.panels.npcfunc.PanelNpcFuncData;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.vip.VipDataManager;
	import com.view.gameWindow.scene.GameFlyManager;
	import com.view.gameWindow.scene.entity.entityItem.autoJob.AutoJobManager;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	import com.view.gameWindow.tips.toolTip.TipVO;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	public class PanelTransMouseEvent
	{
		private var _mc:McPanelTrans;
		private var _npcTeleportId:int;
		private var npcId:int;
		private var tipWidth:int;
		private var tipHeight:int;
		private var txt:TextField;
		private var tipTxt:TextField;
		
		public function PanelTransMouseEvent()
		{
			
		}
		
		public function addEvent(mc:McPanelTrans):void
		{
			_mc = mc;
			npcId = PanelNpcFuncData.npcId;
			_mc.addEventListener(MouseEvent.CLICK,clickHandle);
			/*_mc.addEventListener(MouseEvent.MOUSE_MOVE,overHandle);
			_mc.addEventListener(MouseEvent.MOUSE_OUT,outHandle);*/
		}
		
		private function clickHandle(evt:MouseEvent):void
		{
			var npcTeleportCfgData:NpcTeleportCfgData;
			if(evt.target is TextField)
			{
				var panelTrans:PanelTrans = PanelMediator.instance.openedPanel(PanelConst.TYPE_TRANS) as PanelTrans;
				if(evt.target.parent.name == _mc.safe.name)
				{
					_npcTeleportId = panelTrans.dic["1"+(evt.target as TextField).text];
					TeleportDatamanager.instance.requestTeleportNpcNeedCheck1(_npcTeleportId);
					PanelMediator.instance.closePanel(PanelConst.TYPE_TRANS);
					return;
				}
				if(evt.target.parent.name == _mc.danger.name)
				{
					_npcTeleportId = panelTrans.dic["2"+(evt.target as TextField).text];
					TeleportDatamanager.instance.requestTeleportNpcNeedCheck1(_npcTeleportId);
					PanelMediator.instance.closePanel(PanelConst.TYPE_TRANS);
					return;
				}
				if(evt.target.parent.name == _mc.challenge.name)
				{
					_npcTeleportId = panelTrans.dic["3"+(evt.target as TextField).text];
					npcTeleportCfgData = ConfigDataManager.instance.npcTeleportCfgData(_npcTeleportId);
					PanelTransData.npcId = npcId;
					PanelTransData.npcTeleportId = _npcTeleportId;
					PanelTransData.name = (evt.target as TextField).text;
					/*PanelTransData.normal_monster_drop = getMapCfgData(npcId,_npcTeleportId).normal_monster_drop;
					PanelTransData.elite_monster_drop =  getMapCfgData(npcId,_npcTeleportId).elite_monster_drop;*/
					PanelTransData.boss_drop = getMapCfgData(npcId,_npcTeleportId).boss_drop;
					PanelTransData.coin = getCoin(npcTeleportCfgData);
					PanelTransData.desc = getMapCfgData(npcId,_npcTeleportId).desc;
					PanelMediator.instance.switchPanel(PanelConst.TYPE_MAP_TRANS);	
					PanelMediator.instance.closePanel(PanelConst.TYPE_TRANS);
					return;
				}
				if(evt.target.parent == _mc.onHook)
				{
					var levelCfgData:LevelCfgData = ConfigDataManager.instance.levelCfgData(RoleDataManager.instance.lv);
					if(levelCfgData)
					{
						var region:int;
						if(evt.target == _mc.onHook.txt0)
						{
							region = levelCfgData.region;
						}
						else if(evt.target == _mc.onHook.txt1)
						{
							if(!VipDataManager.instance.lv)
							{
								RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.TRANS_PANEL_0034);
								return;
							}
							region = levelCfgData.vip_region;
						}
						if(region==0)
						{
							return;
						}
						if(RoleDataManager.instance.stallStatue)
						{
							RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.STALL_PANEL_0019);
							return;
						}
						if(isFly)
						{
							GameFlyManager.getInstance().flyToMapByRegId(region);
						}
						else
						{
							var mapRegionCfgData:MapRegionCfgData = ConfigDataManager.instance.mapRegionCfgData(region);
							AutoJobManager.getInstance().setAutoFindPathPos(mapRegionCfgData.centerPoint,mapRegionCfgData.map_id,0);
						}
					}
					return;
				}
			}
			else
			{
				if(evt.target == _mc.btnClose)
				{
					PanelMediator.instance.closePanel(PanelConst.TYPE_TRANS);
				}
			}
		}
		
		private function get isFly():Boolean
		{
			return RoleDataManager.instance.isCanFly > 0 && 
				FlyEffectMediator.instance.isDoFiy == false;
		}
		
		private function overHandle(evt:MouseEvent):void
		{ 
			var tipVO:TipVO;
			if(evt.target is TextField)
			{
				switch(evt.target)
				{
					case _mc.txtNpcName:
						break;
					case _mc.txtDialog:
						break;
					default :
						txt = evt.target as TextField;
						tipTxt = new TextField();
						tipTxt.autoSize = TextFieldAutoSize.LEFT;
						TextFormatManager.instance.setTextFormat(evt.target as TextField,0xffe1aa,true,false);
						TextFormatManager.instance.setTextFormat(tipTxt,0xffffff,false,false);
						if(txt.parent.name == _mc.safe.name)
						{	
							var panelTrans:PanelTrans = PanelMediator.instance.openedPanel(PanelConst.TYPE_TRANS) as PanelTrans;
							_npcTeleportId = panelTrans.dic["1"+txt.text];
							var mapCfgData:MapCfgData = getMapCfgData(npcId,_npcTeleportId);
						}
						else if(txt.parent.name == _mc.danger.name)
						{
							var data:NpcTeleportCfgData;
							var rewardStrArr:Array = [];
							var rewardStr:String ;
							var str:String;
							var finalStr:String = "";
							var panelTrans1:PanelTrans = PanelMediator.instance.openedPanel(PanelConst.TYPE_TRANS) as PanelTrans;
							_npcTeleportId = panelTrans1.dic["2"+txt.text];
							rewardStr = getMapCfgData(npcId,_npcTeleportId).boss_drop; 
							rewardStrArr = rewardStr.split("|");
							for each(str in rewardStrArr)
							{
								var strNormalArr:Array = str.split(":");
								if(strNormalArr.length >= 2)
								{
									if(strNormalArr[1] == SlotType.IT_EQUIP)
									{
										if(ConfigDataManager.instance.equipCfgData(strNormalArr[0]).sex == 0 || RoleDataManager.instance.sex == ConfigDataManager.instance.equipCfgData(strNormalArr[0]).sex)
										{
											if(ConfigDataManager.instance.equipCfgData(strNormalArr[0]).job == 0 || RoleDataManager.instance.job == ConfigDataManager.instance.equipCfgData(strNormalArr[0]).job)
											{
												if(finalStr == "")
												{
													finalStr = ConfigDataManager.instance.equipCfgData(strNormalArr[0]).name;
												}
												else
												{
													finalStr = finalStr + "、" +  ConfigDataManager.instance.equipCfgData(strNormalArr[0]).name;	
												}
											}
										}
									}
									if(strNormalArr[1] == SlotType.IT_ITEM)
									{
										var itemCfgData:ItemCfgData = ConfigDataManager.instance.itemCfgData(strNormalArr[0]);
										if(itemCfgData!=null)
										{
											if(finalStr == "")
											{
												finalStr = itemCfgData.name;
											}
											else
											{
												finalStr = finalStr + "、" +  itemCfgData.name;	
											}
										}
									}
								}
							}
						}
						else if(txt.parent.name == _mc.challenge.name)
						{
							var panelTrans2:PanelTrans = PanelMediator.instance.openedPanel(PanelConst.TYPE_TRANS) as PanelTrans;
							_npcTeleportId = panelTrans2.dic["3"+txt.text];
							var levelStr:String = getMapCfgData(npcId,_npcTeleportId).level?"\n\n" + StringConst.TRANS_PANEL_0006 + getMapCfgData(npcId,_npcTeleportId).level + StringConst.TRANS_PANEL_0007:"";
						}
						break;
				}
			}
		}
		/**
		 * 设置tip位置
		 * @param tipTxt 
		 * @param txt
		 * @param mc
		 * @param x
		 * @param y
		 */		
		private function setTipPosition(tipTxt:TextField,txt:TextField,mc:MovieClip,x:Number,y:Number):void
		{
			_mc.tipTxt.visible = true;
			if(_mc.kong.numChildren == 0)
			{
				tipWidth = tipTxt.textWidth;
				tipHeight = tipTxt.textHeight;
				_mc.kong.addChild(tipTxt);
				_mc.kong.width = tipWidth+5;
				_mc.kong.height= tipHeight+5;
			}			
			_mc.tipTxt.x = txt.x + mc.x + x + 12;
			_mc.tipTxt.y = txt.y + mc.y + y + 18;
			_mc.tipTxt.width = tipTxt.textWidth + 25;
			_mc.tipTxt.height = tipTxt.textHeight + 15;
			_mc.kong.x = _mc.tipTxt.x + 5;
			_mc.kong.y = _mc.tipTxt.y + 5;
		}
		
		private function outHandle(evt:MouseEvent):void
		{
			if(evt.target is TextField)
			{
				var textField:TextField = evt.target as TextField;
				switch(textField)
				{
					case _mc.txtNpcName:
						break;
					case _mc.txtDialog:
						break;
					default :
						var textColor:uint = textField.parent == _mc.danger ? 0xff0000 : 0x00ff00;
						TextFormatManager.instance.setTextFormat(textField,textColor,true,false);
						break;
				}
			}
		}
		
		private function getCoin(data:NpcTeleportCfgData):String
		{
			if(data.coin != 0)
			{
				return String(data.coin) + StringConst.TRANS_PANEL_0008;
			}
			if(data.unbind_coin != 0)
			{
				return String(data.unbind_coin) + StringConst.TRANS_PANEL_0008;
			}
			if(data.bind_gold != 0)
			{
				return String(data.bind_gold) + StringConst.TRANS_PANEL_0019;
			}
			if(data.unbind_gold != 0)
			{
				return String(data.unbind_gold) + StringConst.TRANS_PANEL_0010;
			}
			return "";
		}
		
		private function getMapCfgData(npcId:int,id:int):MapCfgData
		{
			var region_to:int;
			var mapIds:int;
			var mapCfgData:MapCfgData;
			region_to = ConfigDataManager.instance.npcTeleportCfgData(id).region_to;
			mapIds = ConfigDataManager.instance.mapRegionCfgData(region_to).map_id;
			mapCfgData = ConfigDataManager.instance.mapCfgData(mapIds);
			return mapCfgData;
		}
		
		public function destoryEvent():void
		{
			_mc.removeEventListener(MouseEvent.CLICK,clickHandle);
			/*_mc.removeEventListener(MouseEvent.MOUSE_MOVE,overHandle);
			_mc.removeEventListener(MouseEvent.MOUSE_OUT,outHandle);*/
			_mc = null;
			_npcTeleportId = 0;
			npcId = 0;
			tipWidth = 0;
			tipHeight = 0;
			txt = null;
			tipTxt = null;
		}
	}
}