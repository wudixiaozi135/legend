package com.view.gameWindow.panel.panels.everydayOnlineReward.item
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.OnlineWelfareCfgData;
	import com.model.consts.EffectConst;
	import com.model.consts.StringConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.flyEffect.FlyEffectMediator;
	import com.view.gameWindow.panel.panels.everydayOnlineReward.EverydayOnlineRewardDatamanager;
	import com.view.gameWindow.panel.panels.onlineTime.McOnlineTimeItem;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.roleProperty.UserDataManager;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.ServerTime;
	import com.view.gameWindow.util.TimeUtils;
	import com.view.gameWindow.util.UIEffectLoader;
	import com.view.gameWindow.util.UtilItemParse;
	import com.view.gameWindow.util.cell.IconCellEx;
	import com.view.gameWindow.util.cell.ThingsData;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	public class EverydayOnlineRewardItem extends Sprite
	{
		private var _skin:McOnlineTimeItem
		private var _vec:Vector.<IconCellEx>;
		private var _flyDatas:Array = [];
		private var _effect:UIEffectLoader;
		private var _rsrLoader:RsrLoader;
		private var btnOk:Boolean = false;
		private var _totalOnlineTime:int;
		private var cfg:OnlineWelfareCfgData;
		private var index:int;
		public function EverydayOnlineRewardItem(_index:int)
		{
			index = _index;
			initSkin();
			initData();
			super();
		}
		
		private function initSkin():void
		{
			// TODO Auto Generated method stub
			_skin = new McOnlineTimeItem();
			addChild(_skin);
			_rsrLoader = new RsrLoader();
			_rsrLoader.load(_skin,ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD,true);
			addCallBack(_rsrLoader);
			addEventListener(MouseEvent.CLICK,onClickHandler);
			_skin.txtGet.mouseEnabled= false;
			_skin.txtOnline.mouseEnabled = false;
			_skin.txtTime.mouseEnabled = false;
			_skin.txtLeftTime.mouseEnabled = false;
		}
		
		private function addCallBack(rsrLoader:RsrLoader):void
		{
			// TODO Auto Generated method stub
			rsrLoader.addCallBack(_skin.btnGet,function (mc:MovieClip):void
			{
				btnOk = true;
				refreshBtnState();
			});
		}
		
		private function refreshBtnState():void
		{
			// TODO Auto Generated method stub
			var arr:Array = EverydayOnlineRewardDatamanager.instance.getArr;
			var b:Boolean = Boolean(arr[index-1]);
			_skin.btnGet.visible = false;
			_skin.txtGet.visible = false;
			_skin.mcProgress.visible = false;
			_skin.mcGet.visible = false;
			if(_effect)
			{
				_effect.destroy();
			}
			_skin.txtLeftTime.text = "";
			if(b)
			{
				_skin.mcGet.visible = true;
			}else
			{
				var serverDate:Date = ServerTime.date;
				var totalSeconds:int = serverDate.hours * 3600 + serverDate.minutes * 60 + serverDate.seconds;
				var time:int = _totalOnlineTime - totalSeconds;
				if(time<=0)
				{
					_skin.btnGet.visible = true;
					_skin.txtGet.visible = true;
				}
				else
				{
					_skin.mcProgress.visible = true;
					_skin.mcProgress.mcMask.scaleX = (cfg.seconds-time)/(cfg.seconds);
					_skin.txtLeftTime.text = TimeUtils.formatClock1(time);
				}
				if(_skin.btnGet.visible)
				{
					_effect = new UIEffectLoader(this,_skin.btnGet.x,_skin.btnGet.y,1,1,EffectConst.RES_BTN_LEVEL_MATCH,function():void
					{
						if(_effect.effect)
						{
							_effect.effect.mouseChildren = false;
							_effect.effect.mouseEnabled = false;
							_effect.effect.x = _skin.btnGet.x - _skin.btnGet.width/2+18;
							_effect.effect.y = _skin.btnGet.y - _skin.btnGet.height-1;
						}
					});
				}
			}
		}
		
		private function initData():void
		{
			cfg = ConfigDataManager.instance.onlineWelfareData(index);
			_skin.txtGet.text = StringConst.LOONG_WAR_0033;
			_skin.txtOnline.text = StringConst.EVERYDAY_ONLINE_REWARD_002;
			_skin.txtTime.text = cfg.seconds/60+StringConst.DUNGEON_PANEL_0003;
			_vec = new Vector.<IconCellEx>();
			for(var i:int = 0;i<1;i++)
			{
				var item:IconCellEx = new IconCellEx(_skin["icon"+(i+1)],0,0,37,37);
				_vec.push(item);
			}
		}
		
		public function setTime():void
		{
			var serverDate:Date = ServerTime.date;
			var totalSeconds:int = serverDate.hours * 3600 + serverDate.minutes * 60 + serverDate.seconds;
			_totalOnlineTime = totalSeconds +cfg.seconds - EverydayOnlineRewardDatamanager.instance.onlineTime;
			refreshTime();
			refreshBtnState();
		}
		
		public function refreshTime():void
		{
			// TODO Auto-generated method stub
			var serverDate:Date = ServerTime.date;
			var totalSeconds:int = serverDate.hours * 3600 + serverDate.minutes * 60 + serverDate.seconds;
			var time:int = _totalOnlineTime - totalSeconds;
			if(time<0)return;
			refreshBtnState();
		}
		
		public function showData():void
		{
			var awards:Vector.<ThingsData> =UtilItemParse.getThingsDatas(getItems(cfg.reward));
			for(var i:int = 0;i < _vec.length;i++)
			{
				if(awards.length > i && awards[i])
				{
					IconCellEx.setItemByThingsData(_vec[i],awards[i]);
					ToolTipManager.getInstance().attach(_vec[i]);
				}
			}
			refreshBtnState();
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
		
		private function onClickHandler(e:MouseEvent):void
		{
			// TODO Auto Generated method stub
			
			if(e.target == _skin.btnGet)
			{
				EverydayOnlineRewardDatamanager.instance.getReward(index);
				storeBitmaps();
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
		
		
		public function storeBitmaps():void
		{
			destroyFlyDatas();
			if (_vec)
			{
				_vec.forEach(function (element:IconCellEx, index:int, vec:Vector.<IconCellEx>):void
				{
					var bmp:Bitmap = element.getBitmap();
					if (bmp)
					{
						bmp.width = bmp.height = 37;
						element.addChild(bmp);
						bmp.name = element.id.toString();
						_flyDatas.push(bmp);
					}
				});
			}
		}
		
		public function destroyFlyDatas():void
		{
			if (_flyDatas)
			{
				_flyDatas.forEach(function (element:Bitmap, index:int, arr:Array):void
				{
					if (element && element.parent)
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
		private function destroyTips():void
		{
			if (_vec)
			{
				_vec.forEach(function (element:IconCellEx, index:int, vec:Vector.<IconCellEx>):void
				{
					ToolTipManager.getInstance().detach(element);
				});
			}
		}
		
		public function destroy():void
		{
			removeEventListener(MouseEvent.CLICK, onClickHandler);
			destroyFlyDatas();
			if (_flyDatas)
			{
				_flyDatas = null;
			}
			destroyTips();
			if (_effect)
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
			removeChild(_skin);
			_skin = null;
			if (_rsrLoader)
			{
				_rsrLoader.destroy();
				_rsrLoader = null;
			}
		}
		
	}
}