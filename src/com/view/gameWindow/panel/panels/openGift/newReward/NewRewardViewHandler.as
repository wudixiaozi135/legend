package com.view.gameWindow.panel.panels.openGift.newReward
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.OpenServerNewRewardCfgData;
	import com.model.configData.cfgdata.OpenServerRewardCfgData;
	import com.model.consts.StringConst;
	import com.view.gameWindow.flyEffect.FlyEffectMediator;
	import com.view.gameWindow.panel.panels.guideSystem.UICenter;
	import com.view.gameWindow.panel.panels.openActivity.McOpenNew;
	import com.view.gameWindow.panel.panels.openGift.data.OpenNewData;
	import com.view.gameWindow.panel.panels.openGift.data.OpenServiceActivityDatamanager;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.task.linkText.LinkText;
	import com.view.gameWindow.panel.panels.task.linkText.item.LinkTextItem;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.ServerTime;
	import com.view.gameWindow.util.TimeUtils;
	import com.view.gameWindow.util.UtilItemParse;
	import com.view.gameWindow.util.cell.IconCellEx;
	import com.view.gameWindow.util.cell.ThingsData;
	import com.view.gameWindow.util.propertyParse.CfgDataParse;
	
	import flash.display.Bitmap;
	import flash.events.TextEvent;
	
	import mx.utils.StringUtil;

	public class NewRewardViewHandler
	{
		private var skin:McOpenNew;
		private var panel:NewReward;
		private var cfg:OpenServerNewRewardCfgData;
		private var index:int;
		private var _vec:Vector.<IconCellEx>;
		private var _flyDatas:Array = [];
		private var awardsNum:int;
		internal var _linkText:LinkText;
		private var _uiCenter:UICenter;
		public function NewRewardViewHandler(p:NewReward)
		{
			panel = p;
			skin = panel.skin;
			initData();
		}
		
		private function initData():void
		{
			// TODO Auto Generated method stub
			_linkText = new LinkText();
			_uiCenter = new UICenter();
			var day:int = OpenServiceActivityDatamanager.instance.curDay;
			var time:int = ServerTime.openTime*1000+day*24*3600*1000;
			index = day;
			cfg =ConfigDataManager.instance.OpenServerNewRewardData(day,index);
			var cfg2:OpenServerRewardCfgData = ConfigDataManager.instance.openServerRewardData(1);
			var str:String = StringConst.PANEL_OPEN_GIFT_016+TimeUtils.getDateStringCh(ServerTime.openTime*1000+(day-1)*24*3600*1000)+"---"+TimeUtils.getDateStringCh(ServerTime.openTime*1000+cfg2.duration_day*24*3600*1000);
			str = str+StringConst.PANEL_OPEN_GIFT_017;
			skin.txtInfo.htmlText = str;
			_linkText.init(CfgDataParse.pareseDesToStr(cfg2.open_server_new_des));
			skin.txtDesc.htmlText = _linkText.htmlText;
			skin.txtDesc.addEventListener(TextEvent.LINK,linkHandle);
			_vec = new Vector.<IconCellEx>();
			var reward:String = getItems(cfg.reward);
			var awards:Vector.<ThingsData> =UtilItemParse.getThingsDatas(reward);
			for(var i:int = 0;i<1;i++)
			{
				var icon:IconCellEx = new IconCellEx(skin.icons,0,0,60,60);
				_vec[i] = icon;
				IconCellEx.setItemByThingsData(_vec[i],awards[i]);
				ToolTipManager.getInstance().attach(_vec[i]);
				skin.icons.mouseEnabled = false;
			}
			_flyDatas = new Array;
		}
		
		protected function linkHandle(event:TextEvent):void
		{
			var num:int = _linkText.getItemCount();
			var name:String;
			var tabIndex:int;
			var tabSubIndex:int;
			var linkItem:LinkTextItem;
			for(var i:int = 1;i<num+1;i++)
			{
				if(event.text == i.toString())
				{
					name = UICenter.getUINameFromMenu(_linkText.getItemById(i).panelId.toString());
					_uiCenter.openUI(name);
					linkItem = _linkText.getItemById(i);
					tabIndex = linkItem.panelPage;
					tabSubIndex = linkItem.subTabIndex;
					if(tabIndex>=0)
					{
						var tab:* = UICenter.getUI(name);
						if(tab)
						{
							if (tab.hasOwnProperty("setTabIndex"))
							{
								tab.setTabIndex(tabIndex);
							}
							if (tab.hasOwnProperty("setSubTabIndex"))
							{
								tab.setSubTabIndex(tabSubIndex);
							}
						}
					}
				}
			}
		}
		
		private function getItems(s:String):String
		{
			// TODO Auto Generated method stub
			var arr:Array = s.split("|");
			var str:String;
			var role:RoleDataManager = RoleDataManager.instance;
			for(var i:int = 0;i<arr.length;i++)
			{
				var arr1:Array = (arr[i] as String).split(":"); 
				if(((arr1[3]==0||arr1[3] == role.job)&&(arr1[4]==0||arr1[4] == role.sex)))
				{
					if(str==null)
						str=arr[i];
					else
						str+="|"+arr[i];
				}
			}
			return str;
		}
		
		public function refreshData():void
		{
			var day:int = OpenServiceActivityDatamanager.instance.curDay;
			var dailyData:OpenNewData = OpenServiceActivityDatamanager.instance.newData[day];
			var dayNum:int = dailyData.data[index].dailyNum;
			var sum:int = dailyData.data[index].sum;
			if(dayNum<cfg.daily_num)
			{
				skin.txtNum.htmlText = StringUtil.substitute(StringConst.PANEL_OPEN_NEW_001,dayNum,cfg.daily_num);
			}
			else
			{
				skin.txtNum.htmlText = StringUtil.substitute(StringConst.PANEL_OPEN_NEW_002,dayNum,cfg.daily_num);
			}
			if(sum<cfg.max_num)
			{
				skin.txtNumAll.htmlText = StringUtil.substitute(StringConst.PANEL_OPEN_NEW_003,sum,cfg.max_num);
			}
			else
			{
				skin.txtNumAll.htmlText = StringUtil.substitute(StringConst.PANEL_OPEN_NEW_004,sum,cfg.max_num);
			}
			
			if(dayNum<cfg.daily_num&&sum<cfg.max_num)
			{
				skin.btnGet.visible = true;
			}
			else
			{
				skin.btnGet.visible = false;
			}
		}
		
		public function handlerSuccess():void
		{
			if (_flyDatas)
			{
				FlyEffectMediator.instance.doFlyReceiveThings2(_flyDatas);
				destroyFlyDatas();
			}
		}
		
		
		/**飘物品数据*/
		public function storeBitmaps():void
		{
			destroyFlyDatas();
			for(var i:int = 0;i<awardsNum;i++)
			{
				var bmp:Bitmap = _vec[i].getBitmap();
				if (bmp)
				{
					bmp.width = bmp.height = 40;
					bmp.name = _vec[i].id.toString();
					bmp.visible = false;
					_vec[i].addChild(bmp);
					_flyDatas.push(bmp);
				}
			}
		}
		
		private function destroyTips():void
		{
			_vec.forEach(function (element:IconCellEx, index:int, vec:Vector.<IconCellEx>):void
			{
				element.setNull();
				ToolTipManager.getInstance().detach(element);
			});
		}
		
		private function destroyFlyDatas():void
		{
			if (_flyDatas)
			{
				_flyDatas.forEach(function (element:Bitmap, index:int, arr:Array):void
				{
					if (element.parent)
					{
						element.parent.removeChild(element);
						if (element.bitmapData)
						{
							element.bitmapData.dispose();
						}
						element = null;
					}
				});
				_flyDatas.length = 0;
			}
		}
		
		public function destroy():void
		{
			destroyFlyDatas();
			if (_flyDatas)
			{
				_flyDatas = null;
			}
			destroyTips();
			if (_vec)
			{
				_vec.forEach(function (element:IconCellEx, index:int, vec:Vector.<IconCellEx>):void
				{
					element.destroy();
					element = null;
				});
				_vec.length = 0;
				_vec = null;
			}
			_linkText = null;
			_uiCenter = null;
			skin.txtDesc.removeEventListener(TextEvent.LINK,linkHandle);
			panel = null;
			skin = null;

		}
	}
}