package com.view.gameWindow.panel.panels.openGift.promote
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.OpenServerJourneyRewardCfgData;
	import com.model.configData.cfgdata.OpenServerPromoteRewardCfgData;
	import com.model.consts.EffectConst;
	import com.model.consts.StringConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.flyEffect.FlyEffectMediator;
	import com.view.gameWindow.panel.panels.openActivity.McOpenJourneyItem;
	import com.view.gameWindow.panel.panels.openGift.data.OpenJourneyData;
	import com.view.gameWindow.panel.panels.openGift.data.OpenPromoteData;
	import com.view.gameWindow.panel.panels.openGift.data.OpenServiceActivityDatamanager;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.UIEffectLoader;
	import com.view.gameWindow.util.UtilItemParse;
	import com.view.gameWindow.util.cell.IconCellEx;
	import com.view.gameWindow.util.cell.ThingsData;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import mx.utils.StringUtil;
	
	public class PromoteRewardItem extends Sprite
	{
		private var skin:McOpenJourneyItem
		private var _vec:Vector.<IconCellEx>;
		private var _flyDatas:Array = [];
		private var _effect:UIEffectLoader;
		private var index:int;
		private var cfg:OpenServerPromoteRewardCfgData;
		private var rsr:RsrLoader;
		private var btnOk:Boolean = false;
		private var awardsNum:int;
		public function PromoteRewardItem()
		{
			initSkin();
			initData();
			super();
		}
		
		private function initSkin():void
		{
			// TODO Auto Generated method stub
			skin = new McOpenJourneyItem();
			skin.txtGet.mouseEnabled = false;
			skin.txtInfo.mouseEnabled = false;
			addChild(skin);
			rsr = new RsrLoader();
			addCallback(rsr);
			rsr.load(skin,ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD,true);
			skin.addEventListener(MouseEvent.CLICK,onClick);
			skin.txtGet.visible = skin.btnGet.visible = skin.mcGet.visible = skin.btnGet.visible = skin.mcUnget.visible =false;
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
		
		private function initData():void
		{
			// TODO Auto Generated method stub
			_vec = new Vector.<IconCellEx>();
			for(var i:int = 0;i<1;i++)
			{
				var icon:IconCellEx = new IconCellEx(skin.icon1,0,0,37,37);
				_vec[i] = icon;
				skin.icon1.mouseEnabled = false;
			}
			_flyDatas = new Array;
			skin.txtGet.text = StringConst.LOONG_WAR_0033;
		}
		
		public function setData(_index:int):void
		{
			// TODO Auto Generated method stub
			var day:int = OpenServiceActivityDatamanager.instance.curDay;
			index = _index;
			cfg = ConfigDataManager.instance.OpenServerPromoteRewardData(day,index);
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
		}
		
		public function refreshData():void
		{
			var day:int = OpenServiceActivityDatamanager.instance.curDay;
			var dailyData:OpenPromoteData = OpenServiceActivityDatamanager.instance.promoteData[day];
			var isget:Boolean = Boolean(dailyData.data[index].state);
			var param:int = dailyData.data[index].num;
			var num:int;
			if(cfg.type>= OpenPromoteData.ROLE_EQUIP_LV && cfg.type <= OpenPromoteData.HERO_EQUIP_SLV)
			{
				num = 10;
			}
			else if(cfg.type == OpenPromoteData.ROLE_DUNPAI||cfg.type == OpenPromoteData.ROLE_HLZX||cfg.type == OpenPromoteData.ROLE_LV)
			{
				num = 1;
			}
			else
			{
				num = cfg.num;
			}
			if(param>=num)
			{
				skin.txtInfo.htmlText = cfg.name+StringUtil.substitute(StringConst.PANEL_OPEN_GIFT_018,num+"/"+num);
			}
			else
			{
				skin.txtInfo.htmlText = cfg.name+StringUtil.substitute(StringConst.PANEL_OPEN_GIFT_019,param,num);
			}
			skin.mcGet.visible = isget;
			if(!isget)
			{
				skin.txtGet.visible = skin.btnGet.visible = Boolean(param>=num);
				skin.mcUnget.visible = !skin.txtGet.visible;
				
			}
			else
			{
				skin.txtGet.visible = skin.btnGet.visible = skin.mcUnget.visible = false;
			}
			refreshBtnState();
		}
		
		private function refreshBtnState():void
		{
			// TODO Auto Generated method stub
			if(!btnOk)return;
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
		
		protected function onClick(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			if(event.target == skin.btnGet)
			{
				OpenServiceActivityDatamanager.instance.getPromoteReward(index);
				storeBitmaps();
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
			removeEventListener(MouseEvent.CLICK, onClick);
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
			removeChild(skin);
			skin = null;
			if (rsr)
			{
				rsr.destroy();
				rsr = null;
			}
		}
	}
}