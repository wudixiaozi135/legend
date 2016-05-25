package com.view.gameWindow.panel.panels.taskStar.handle
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.MapRegionCfgData;
	import com.model.configData.cfgdata.MonsterCfgData;
	import com.model.configData.cfgdata.TaskCfgData;
	import com.model.configData.cfgdata.TaskStarRateCfgData;
	import com.model.configData.cfgdata.TaskStarRewardCfgData;
	import com.model.consts.EffectConst;
	import com.model.consts.ItemType;
	import com.model.consts.SlotType;
	import com.model.consts.StringConst;
	import com.model.consts.ToolTipConst;
	import com.view.gameWindow.panel.panels.bag.BagData;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.task.constants.TaskStates;
	import com.view.gameWindow.panel.panels.task.constants.TaskTypes;
	import com.view.gameWindow.panel.panels.taskStar.McTaskStar;
	import com.view.gameWindow.panel.panels.taskStar.PanelTaskStar;
	import com.view.gameWindow.panel.panels.taskStar.data.PanelTaskStarDataManager;
	import com.view.gameWindow.tips.toolTip.TipVO;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.UIEffectLoader;
	import com.view.gameWindow.util.UtilItemParse;
	import com.view.gameWindow.util.UtilNumChange;
	import com.view.gameWindow.util.cell.IconCellEx;
	import com.view.gameWindow.util.cell.ThingsData;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.utils.Dictionary;

	/**
	 * 星级任务面板刷新处理类
	 * @author Administrator
	 */	
	public class PanelTaskStarRefreshHandle
	{
		private var _panel:PanelTaskStar;
		private var _mc:McTaskStar;
		private var _lastBtn:MovieClip;
		private var _iconEx1:IconCellEx;
		private var _iconEx2:IconCellEx;
		private var _dt1:ThingsData;
		private var _dt2:ThingsData;

		public function PanelTaskStarRefreshHandle(panel:PanelTaskStar)
		{
			_panel = panel;
			_mc = _panel.skin as McTaskStar;
			_iconEx1 = new IconCellEx(_mc.rewardContainer.iconContainer1, 0, 0, 48, 48);
			_iconEx2 = new IconCellEx(_mc.rewardContainer.iconContainer2, 0, 0, 48, 48);
			_dt1 = new ThingsData();
			_dt2 = new ThingsData();
			
			_mc.mcReceiveLayer.txtToday.visible = true;
			_mc.mcReceiveLayer.txtTodayCount.visible = true;
			_mc.mcReceiveLayer.txtVip.visible = false;
		}

		public function refresh():void
		{
			var newTid:int,oldStar:int,num:int,sprite:Sprite,uiEffectLoader:UIEffectLoader,newStar:int;
			newTid = PanelTaskStarDataManager.instance.newTid;
			newStar = PanelTaskStarDataManager.instance.newStar;
			oldStar = PanelTaskStarDataManager.instance.oldStar;

			_mc.mcReceiveLayer.mcStar.gotoAndStop(newStar);
			_mc.mcReceiveLayer.mcStarNum.gotoAndStop(newStar + 1);
			_mc.mcName.gotoAndStop(PanelTaskStarDataManager.getFrameIndex(newTid));
			if(oldStar != PanelTaskStarDataManager.FULL_STAR)
			{
				if(oldStar < newStar)
				{
					num = newStar - oldStar;
					for (var i:int = 0;i<num;i++)
					{
						sprite = new Sprite();
						sprite.x = 42+21*(i+oldStar+1);
						sprite.y = 330;
						sprite.mouseChildren = false;
						sprite.mouseEnabled = false;
						_mc.addChild(sprite);
						uiEffectLoader = new UIEffectLoader(sprite,0,0,1,1,EffectConst.RES_TASKSTAR_SUCCESS,null,true);
					}
					
				}
				else if(oldStar > newStar)
				{
					num = oldStar - newStar;
					for (var j:int = 0;j<num;j++)
					{
						sprite = new Sprite();
						sprite.x = 42+21*(j+newStar+1);
						sprite.y = 330;
						sprite.mouseChildren = false;
						sprite.mouseEnabled = false;
						_mc.addChild(sprite);
						uiEffectLoader = new UIEffectLoader(sprite,0,0,1,1,EffectConst.RES_TASKSTAR_FAIL,null,true);
					}
				}
			}
			refreshInfos(newTid);
			//
//			var count:int = PanelTaskStarDataManager.instance.count;
//			var totalCount:int = PanelTaskStarDataManager.instance.totalCount;
//			var numAdd:int = PanelTaskStarDataManager.instance.numAdded;
//			
//			if(count >= totalCount)
//			{
//				_mc.mcReceiveLayer.txtToday.text = StringConst.TASK_STAR_PANEL_0069;
//				_mc.mcReceiveLayer.txtTodayCount.text = (totalCount + numAdd - count) + "/" + numAdd;
//			}
//			else
//			{
//				_mc.mcReceiveLayer.txtToday.text = StringConst.TASK_STAR_PANEL_0008;
//				_mc.mcReceiveLayer.txtTodayCount.text = (totalCount - count) + "/" + totalCount;
//			}
			

			refreshReceivedTask();
			resetState();
			
			if(_mc.mcReceiveLayer.protectSingleBtn.hasOwnProperty("selected"))
			{
				_mc.mcReceiveLayer.protectSingleBtn.selected = PanelTaskStarDataManager.instance.setting != 0;
			}
		}
		
		private var _isFree:int = -1;
		public function setCostType(isFree:int):void
		{
			if(_isFree == isFree)
			{
				return;
			}
			
			_isFree = isFree;
			if(!_mc.mcReceiveLayer.txtGold.text)
			{
				_mc.mcReceiveLayer.txtGold.text = StringConst.TASK_STAR_PANEL_0071;
			}
			
			_mc.mcReceiveLayer.txtGold.visible = !isFree;
		}

		private function refreshInfos(tid:int):void
		{
			var taskCfgData:TaskCfgData;
			taskCfgData = ConfigDataManager.instance.taskCfgData(tid);
			if(taskCfgData)
			{
				var split:Array = taskCfgData.request.split(":");
				var star:int, progress:int, color:int = 0xffe1aa;

				star = PanelTaskStarDataManager.instance.getStar(taskCfgData.type);

				var name:String = getName(taskCfgData.type,int(split[0]));
				var createHtmlStr:String = HtmlUtils.createHtmlStr(color,name,12,false,2,"SimSun",false);

				var tid2:int = PanelTaskStarDataManager.instance.tid;
				var taskCfgData2:TaskCfgData = ConfigDataManager.instance.taskCfgData(tid2);
				if(taskCfgData2 && taskCfgData2.type == taskCfgData.type)
				{
					progress = PanelTaskStarDataManager.instance.progress;
				}
				else
				{
					progress = 0;
				}

				if(progress < int(split[1]))
				{
					color = 0xff0000
				}
				if (progress <= split[1])
				{
					createHtmlStr += HtmlUtils.createHtmlStr(color, "(" + progress + "/" + split[1] + ")");
				} else
				{
					createHtmlStr += HtmlUtils.createHtmlStr(color, "(" + split[1] + "/" + split[1] + ")");
				}
				_mc.taskTargetValue.htmlText = createHtmlStr;

				var lv:int = RoleDataManager.instance.lv;
				var taskStarRewardCfgData:TaskStarRewardCfgData = ConfigDataManager.instance.taskStarRewardCfgData(lv,taskCfgData.type);
				var taskStarRateCfgData:TaskStarRateCfgData = ConfigDataManager.instance.taskStarRateCfgData(star);

				var utilNumChange:UtilNumChange = new UtilNumChange();
				var num:Number = taskStarRewardCfgData.exp * (taskStarRateCfgData ? taskStarRateCfgData.rate : 1);
				_mc.rewardContainer.rewardValue1.text = StringConst.TASK_STAR_PANEL_0004 + "*" + utilNumChange.changeNum(num);//经验

				var itemString:Array = UtilItemParse.getItemString(taskStarRewardCfgData.reward_item);
				_mc.rewardContainer.rewardValue2.text = itemString[1] + "*" + itemString[2];//道具

				ToolTipManager.getInstance().detach(_iconEx1);
				_dt1.id = ItemType.IT_EXP;
				_dt1.type = SlotType.IT_ITEM;
				IconCellEx.setItemByThingsData(_iconEx1, _dt1);
				ToolTipManager.getInstance().attach(_iconEx1);

				ToolTipManager.getInstance().detach(_iconEx2);
				_dt2.id = itemString[3];
				_dt2.type = itemString[4];
				IconCellEx.setItemByThingsData(_iconEx2, _dt2);
				ToolTipManager.getInstance().attach(_iconEx2);
				
				
				var count:int = PanelTaskStarDataManager.instance.count;
				var totalCount:int = PanelTaskStarDataManager.instance.totalCount;
				
//				if(count >= totalCount)
//				{
//					_mc.mcReceiveLayer.txtToday.text = StringConst.TASK_STAR_PANEL_0008;
//					_mc.mcReceiveLayer.txtTodayCount.text = (totalCount + numAdd - count) + "/" + numAdd;
//				}
//				else
//				{
//					_mc.mcReceiveLayer.txtToday.text = StringConst.TASK_STAR_PANEL_0008;
//					_mc.mcReceiveLayer.txtTodayCount.text = (totalCount - count) + "/" + totalCount;
//				}
				
				_mc.mcReceiveLayer.txtToday.text = StringConst.TASK_STAR_PANEL_0008;
				
				
				if(!PanelTaskStarDataManager.instance.isFree)
				{
					_mc.mcReceiveLayer.txtTodayCount.textColor = 0xff0000;
					_mc.mcReceiveLayer.txtTodayCount.text = "0"/*+totalCount*/;
				}
				else
				{
					var n:int = 0;
					if(PanelTaskStarDataManager.instance.isReal == 1)
					{
						n = totalCount - count;
					}
					else
					{
						n = 5 - count;
					}
					if(n < 0)
					{
						n = 0;
					}
					if(n == 0)
					{
						_mc.mcReceiveLayer.txtTodayCount.textColor = 0x00ff00;
					}
					_mc.mcReceiveLayer.txtTodayCount.text =  n.toString()/*+ "/" + totalCount*/;
				}
				
			}
		}
		
		private function getName(type:int,configId:int):String
		{
			if(type == TaskTypes.TT_EXORCISM)//除魔
			{
				var monsterCfgDatas:Dictionary,data:MonsterCfgData;
				monsterCfgDatas = ConfigDataManager.instance.monsterCfgDatas(configId);
				for each(data in monsterCfgDatas)
				{
					break;
				}
				return data ? data.name : "";
			}
			else if(type == TaskTypes.TT_MINING)//采矿
			{
				var mapRegionCfgData:MapRegionCfgData = ConfigDataManager.instance.mapRegionCfgData(configId);
				return mapRegionCfgData ? mapRegionCfgData.name : "";
			}
			else if(type == TaskTypes.TT_ROOTLE)//挖掘
			{
				monsterCfgDatas = ConfigDataManager.instance.monsterCfgDatas(configId);
				for each(data in monsterCfgDatas)
				{
					if (data)
					{
						return data.name;
					}
				}
				return "";
			}
			else
			{
				return "";
			}
		}

		/**判断任务是否完成切换状态*/
		private function resetState():void
		{
			var tidState:int = PanelTaskStarDataManager.instance.state;
			var isFree:int = PanelTaskStarDataManager.instance.isFree;
			if (tidState == TaskStates.TS_DOING)
			{
				_mc.mcReceiveLayer.txtBtnReceive.text = StringConst.TASK_STAR_PANEL_0064;//继续任务
			} else
			{
				_mc.mcReceiveLayer.txtBtnReceive.text = isFree ? StringConst.TASK_STAR_PANEL_0006 : StringConst.TASK_STAR_PANEL_0070;//接受任务
			}

			var isComplete:Boolean = PanelTaskStarDataManager.instance.isComplete;
			if (isComplete)
			{
				_mc.mcRewardLayer.visible = true;
				_mc.mcReceiveLayer.visible = false;
			}
			else
			{
				_mc.mcRewardLayer.visible = false;
				_mc.mcReceiveLayer.visible = true;
			}
			
			setCostType(isFree);
		}

		private function refreshReceivedTask():void
		{
			var tid:int = PanelTaskStarDataManager.instance.tid;
			var taskCfgData:TaskCfgData = ConfigDataManager.instance.taskCfgData(tid);
			if(!taskCfgData)
			{
				return;
			}
			var state:int = PanelTaskStarDataManager.instance.state;
			if(state != TaskStates.TS_DOING)
			{
				return;
			}

			//
			var lv:int = PanelTaskStarDataManager.instance.level;
			var taskStarRewardCfgData:TaskStarRewardCfgData = ConfigDataManager.instance.taskStarRewardCfgData(lv,taskCfgData.type);
			var star:int = PanelTaskStarDataManager.instance.getStar(taskCfgData.type);
			var taskStarRateCfgData:TaskStarRateCfgData = ConfigDataManager.instance.taskStarRateCfgData(star);
			var utilNumChange:UtilNumChange = new UtilNumChange();
			_mc.rewardContainer.rewardValue1.text = StringConst.TASK_STAR_PANEL_0004 + "*" + utilNumChange.changeNum(taskStarRewardCfgData.exp * taskStarRateCfgData.rate);//经验

			var itemString:Array = UtilItemParse.getItemString(taskStarRewardCfgData.reward_item);
			_mc.rewardContainer.rewardValue2.text = itemString[1] + "*" + itemString[2];
		}
		
		private function removeItemTxtTip(txt:TextField):void
		{
			ToolTipManager.getInstance().detach(txt);
		}
		
		private function addItemTxtTip(txt:TextField,itemId:int):void
		{
			var tipVO:TipVO = new TipVO();
			tipVO.tipType = ToolTipConst.ITEM_BASE_TIP;
			var bagData:BagData = new BagData();
			bagData.id = itemId;
			bagData.type = SlotType.IT_ITEM;
			tipVO.tipData = bagData;
			ToolTipManager.getInstance().hashTipInfo(txt,tipVO);
			ToolTipManager.getInstance().attach(txt);
		}

		/**元宝完成*/
		private function addGetBtnTip(movieClip:MovieClip):void
		{
			var tipVO:TipVO = new TipVO();
			tipVO.tipType = ToolTipConst.TEXT_TIP;
			tipVO.tipData = HtmlUtils.createHtmlStr(0xffe1aa,StringConst.TASK_STAR_PANEL_0025);
			ToolTipManager.getInstance().hashTipInfo(movieClip,tipVO);
			ToolTipManager.getInstance().attach(movieClip);
		}
		
		private function removeGetBtnTip(movieClip:MovieClip):void
		{
			ToolTipManager.getInstance().detach(movieClip);
		}

		public function set lastBtn(value:MovieClip):void
		{
			_lastBtn = value;
		}

		public function destroy():void
		{
			if (_iconEx1)
			{
				ToolTipManager.getInstance().detach(_iconEx1);
				if (_iconEx1.parent)
				{
					_iconEx1.parent.removeChild(_iconEx1);
					_iconEx1 = null;
				}
			}
			if (_iconEx2)
			{
				ToolTipManager.getInstance().detach(_iconEx2);
				if (_iconEx2.parent)
				{
					_iconEx2.parent.removeChild(_iconEx2);
					_iconEx2 = null;
				}
			}
			if (_dt1)
				_dt1 = null;
			if (_dt2)
				_dt2 = null;

			if (_lastBtn)
			{
				removeGetBtnTip(_lastBtn);
				_lastBtn = null;
			}
			_mc = null;
			_panel = null;
		}
	}
}