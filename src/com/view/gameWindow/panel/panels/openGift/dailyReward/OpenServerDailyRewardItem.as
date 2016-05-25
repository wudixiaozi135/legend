package com.view.gameWindow.panel.panels.openGift.dailyReward
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.ItemCfgData;
	import com.model.configData.cfgdata.OpenServerDailyRewardCfgData;
	import com.model.consts.EffectConst;
	import com.model.consts.SlotType;
	import com.model.consts.StringConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.common.Alert;
	import com.view.gameWindow.flyEffect.FlyEffectMediator;
	import com.view.gameWindow.panel.panels.openActivity.McOpenDailyRewardItem;
	import com.view.gameWindow.panel.panels.openGift.data.OpenDailyData;
	import com.view.gameWindow.panel.panels.openGift.data.OpenServiceActivityDatamanager;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.welfare.WelfareDataMannager;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.UIEffectLoader;
	import com.view.gameWindow.util.UtilItemParse;
	import com.view.gameWindow.util.cell.IconCellEx;
	import com.view.gameWindow.util.cell.ThingsData;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	
	import mx.utils.StringUtil;
	
	public class OpenServerDailyRewardItem extends Sprite
	{
		private var skin:McOpenDailyRewardItem;
		private var _vec:Vector.<IconCellEx>;
		private var _flyDatas:Array = [];
		private var _effect:UIEffectLoader;
		private var _index:int;
		private var rsr:RsrLoader;
		private var cfg:OpenServerDailyRewardCfgData;
		private var btnOk:Boolean;
		private var awardsNum:int;
		private var _grayFilter:ColorMatrixFilter;
		public function OpenServerDailyRewardItem()
		{
			initSkin();
			initData();
			super();
		}
		
		private function initData():void
		{
			// TODO Auto Generated method stub
			_vec = new Vector.<IconCellEx>();
			for(var i:int = 0;i<2;i++)
			{
				var icon:IconCellEx = new IconCellEx(skin["icon"+(i+1)],0,0,37,37);
				_vec[i] = icon;
				skin["icon"+(i+1)].mouseEnabled = false;
			}
			_flyDatas = new Array;
			skin.txtGet.text = StringConst.LOONG_WAR_0033;
			_grayFilter = new ColorMatrixFilter();
			_grayFilter.matrix = [0.3,0.3,0.3,0,0,
				0.3,0.3,0.3,0,0,
				0.3,0.3,0.3,0,0,
				0,0,0,1,0];
		}
		
		private function initSkin():void
		{
			// TODO Auto Generated method stub
			skin  = new McOpenDailyRewardItem;
			skin.txtGet.mouseEnabled = false;
			skin.txtInfo.mouseEnabled = false;
			skin.txtTime.mouseEnabled = false;
			addChild(skin);
			rsr = new RsrLoader();
			addCallback(rsr);
			rsr.load(skin,ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD,true);
			skin.addEventListener(MouseEvent.CLICK,onClick);
			skin.txtGet.visible = skin.btnGet.visible = skin.mcGet.visible = skin.btnGet.visible= skin.mcUnget.visible =false;
		}
		
		protected function onClick(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			if(event.target == skin.btnGet)
			{
				var day:int = OpenServiceActivityDatamanager.instance.curDay;
				var openday:int = WelfareDataMannager.instance.openDay+1;
				if(day!=openday&&cfg.type!=OpenDailyData.TOTAL_RECHARGE)
				{
					Alert.message(StringConst.PANEL_OPEN_GIFT_021);
				}
				else
				{
					OpenServiceActivityDatamanager.instance.getDailyReward(_index);
					storeBitmaps();
				}
			}
		}
		
		private function addCallback(_rsr:RsrLoader):void
		{
			// TODO Auto Generated method stub
			_rsr.addCallBack(skin.btnGet,function (mc:MovieClip):void
			{
				btnOk = true;
				refreshBtnState();
			}
			);
		}
		
		public function setData(index:int):void
		{
			// TODO Auto Generated method stub
			var day:int = OpenServiceActivityDatamanager.instance.curDay;
			_index = index+(day-1)*OpenServerDailyRewardViewHandler.ITEM_NUM;
			cfg = ConfigDataManager.instance.openServerDailyRewardData(day,_index);
			var reward:String = getItems(cfg.reward);
			var awards:Vector.<ThingsData> =UtilItemParse.getThingsDatas(reward);
			awardsNum = awards.length;
			for(var i:int = 0;i<_vec.length;i++)
			{
				if(awards.length&&i<awards.length)
				{
					IconCellEx.setItemByThingsData(_vec[i],awards[i]);
					ToolTipManager.getInstance().attach(_vec[i]);
					_vec[i].visible = true;
					skin["icon"+(i+1)].visible = true;
					skin["grid"+(i+1)].visible = true;
				}
				else
				{
					_vec[i].visible = false;
					skin["icon"+(i+1)].visible = false;
					skin["grid"+(i+1)].visible = false;
				}
			}
			skin.txtInfo.text = StringUtil.substitute(StringConst["PANEL_OPEN_SERVER_00"+cfg.type],cfg.param);
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
			var openDay:int = WelfareDataMannager.instance.openDay+1;
			var dailyData:OpenDailyData = OpenServiceActivityDatamanager.instance.dailyData[day];
			var isget:Boolean = Boolean(dailyData.data[_index].state);
			var param:int = dailyData.data[_index].param;
			if(cfg.type == OpenDailyData.ONLINE_TIME)
				param = param/60;
			if(param>=cfg.param)
			{
				skin.txtTime.htmlText = StringUtil.substitute(StringConst.PANEL_OPEN_GIFT_018,cfg.param+"/"+cfg.param);
			}
			else
			{
				skin.txtTime.htmlText = StringUtil.substitute(StringConst.PANEL_OPEN_GIFT_019,param,cfg.param);
			}
			skin.mcGet.visible = isget;
			if(!isget)
			{
				skin.txtGet.visible = skin.btnGet.visible = Boolean(param>=cfg.param);
				skin.mcUnget.visible = !skin.txtGet.visible;
				
			}
			else
			{
				skin.txtGet.visible = skin.btnGet.visible = skin.mcUnget.visible = false;
			}
			if(day != openDay&&cfg.type!=OpenDailyData.TOTAL_RECHARGE)
			{
				skin.txtTime.htmlText = "";
				skin.txtGet.visible = skin.btnGet.visible =false;
				skin.mcUnget.visible = !isget;
			}
			refreshBtnState();
		}
		
		private function refreshBtnState():void
		{
			// TODO Auto Generated method stub
			if(!btnOk)return;
//			if(day != openDay&&cfg.type!=3)
//			{
//				skin.btnGet.filters = [_grayFilter];
//				return;
//			}
//			skin.btnGet.filters = null;
			if(_effect)
			{
				_effect.destroy();
				_effect = null;
			}
			if(skin.btnGet.visible)
			{
				_effect = new UIEffectLoader(this,skin.btnGet.x,skin.btnGet.y,1,1,EffectConst.RES_BTN_LEVEL_MATCH,function():void
				{
					if(_effect.effect)
					{
						_effect.effect.mouseChildren = false;
						_effect.effect.mouseEnabled = false;
						_effect.effect.x = skin.btnGet.x - skin.btnGet.width/2+18;
						_effect.effect.y = skin.btnGet.y - skin.btnGet.height-1;
					}
				});
			}
		}
		
		public function handlerSuccess():void
		{
			if (_flyDatas.length)
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
			destroyTips();
			if(_effect)
			{
				_effect.destroy();
				_effect = null;
			}
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
			skin.removeEventListener(MouseEvent.CLICK,onClick);
			removeChild(skin);
		}
		
	}
}