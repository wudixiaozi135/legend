package com.view.gameWindow.panel.panels.openGift.cheapGift
{
	import com.model.business.fileService.UrlBitmapDataLoader;
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.business.fileService.interf.IUrlBitmapDataLoaderReceiver;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.SpecialPreferenceRewordCfgData;
	import com.model.consts.SlotType;
	import com.model.consts.StringConst;
	import com.view.gameWindow.common.HighlightEffectManager;
	import com.view.gameWindow.common.MouseOverEffectManager;
	import com.view.gameWindow.flyEffect.FlyEffectMediator;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.openActivity.McCheapGift;
	import com.view.gameWindow.panel.panels.openGift.data.OpenServiceActivityDatamanager;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.UIEffectLoader;
	import com.view.gameWindow.util.UtilItemParse;
	import com.view.gameWindow.util.cell.IconCellEx;
	import com.view.gameWindow.util.cell.ThingsData;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	
	import mx.utils.StringUtil;

	public class CheapGiftViewHandle implements IUrlBitmapDataLoaderReceiver
	{
		private var _panel:CheapGift;
		private var skin:McCheapGift;
		private var _mouseOver:MouseOverEffectManager;
		private var _effectLoader:UIEffectLoader;
		private var _effectLoader1:UIEffectLoader;
		private var bmp:Bitmap;
		private var _vec:Vector.<IconCellEx>;
		private var _flyDatas:Array = [];
		private var curIndex:int = -1;
		private var _last:MovieClip;
		private var awardsNum:int = 0;
		private var tabList:Array;
		public function CheapGiftViewHandle(panel:CheapGift)
		{
			_panel = panel;
			skin = panel.skin as McCheapGift;
			_mouseOver = new MouseOverEffectManager(1,131,139);
			tabList = [skin.btnEquip,skin.btnCloth,skin.btnHead,skin.btnRing];
			for(var i:int = 0;i<tabList.length;i++)
			{
				_mouseOver.add(tabList[i]);
			}
			_vec = new Vector.<IconCellEx>();
			for(i = 0;i<7;i++)
			{
				var item:IconCellEx = new IconCellEx(skin["icons"+(i+1)],0,0,60,60);
				_vec.push(item);
			}
		}
		
		
		public function dealSelectTab():void
		{
			// TODO Auto Generated method stub
			var arr:Array = OpenServiceActivityDatamanager.instance.specialReward;
			var b:Boolean = arr.every( function(item :Number, index :int, arr :Array):Boolean
			{
				return item == 1;
			});
			if(b)
			{
				deal(skin.btnEquip,1);
				_panel.mouseHandler.setCur(1);
			}
			else
			{
				for(var i:int = 0;i<arr.length;i++)
				{
					if(arr[i] == 0)
					{
						deal(tabList[i],i+1);
						_panel.mouseHandler.setCur(i+1);
						return;
					}
				}
			}
		}
		
		
		public function deal(mc:MovieClip, index:int):void
		{
			// TODO Auto Generated method stub
			if(!_last||_last!=mc)
			{
				if(_last)
					_mouseOver.setSelected(_last,false);
				_mouseOver.setSelected(mc,true);
				_last = mc;
				curIndex = index;
				showInfo(index);
			}
		}
		
		
		private function showInfo(index:int):void
		{
			var cfg:SpecialPreferenceRewordCfgData = ConfigDataManager.instance.cheapReward(index);
			skin.txtInfo.htmlText = StringUtil.substitute(StringConst.PANEL_OPEN_GIFT_007,cfg.cost_unbind.toString(),cfg.name);
			var arr:Array = OpenServiceActivityDatamanager.instance.specialReward;
			skin.btnGet.visible =  arr[index-1]== 0;
			clearEffect();
			showEffect(index);
			showItems(cfg);
			showgetInfo();
		}
		
		private function showgetInfo():void
		{
			// TODO Auto Generated method stub
			var arr:Array = OpenServiceActivityDatamanager.instance.specialReward;
			for(var i:int = 0;i<arr.length;i++)
			{
				skin["mcGet"+(i+1)].visible = arr[i] == 1;
			}
		}
		
		private function showEffect(index:int):void
		{
			// TODO Auto Generated method stub
			var cfg:SpecialPreferenceRewordCfgData = ConfigDataManager.instance.cheapReward(index);
			var url:String;
			if(index<2)
			{
				var load:UrlBitmapDataLoader = new UrlBitmapDataLoader(this);
				url = cfg.icon_show+ResourcePathConstants.POSTFIX_JPG;
				load.loadBitmap(ResourcePathConstants.IMAGE_SPECIAL_PREFERENCE_REWARD_LOAD+url);
			}
			else
			{
				skin.effect.x = 140;
				skin.effect.y = 280;
				if(index == 3){
					var url1:String =  StringConst.PANEL_OPEN_GIFT_008+cfg.swf_show+ResourcePathConstants.POSTFIX_SWF;
					_effectLoader1 = new UIEffectLoader(skin,skin.effect1.x,skin.effect1.y,1,1,url1,function():void
					{
						if(_effectLoader1.effect)
						{
							_effectLoader1.effect.mouseEnabled = false;
						}
					});
					skin.effect.x = 100;
					skin.effect.y = 280;
				}
				url = StringConst.PANEL_OPEN_GIFT_008+cfg.icon_show+ResourcePathConstants.POSTFIX_SWF;
				_effectLoader = new UIEffectLoader(skin,skin.effect.x,skin.effect.y,1,1,url,function():void
				{
					if(_effectLoader.effect)
					{
						_effectLoader.effect.mouseEnabled = false;
					}
					if(_effectLoader1&&_effectLoader1.effect)
					{
						skin.addChild(_effectLoader1.effect);
					}
				});
				
			}
		}
		
		private function showItems(cfg:SpecialPreferenceRewordCfgData):void
		{
			// TODO Auto Generated method stub
			var arr:Array = cfg.gift_reward.split("|");
			var str:String;
			var role:RoleDataManager = RoleDataManager.instance;
			for(var i:int = 0;i<arr.length;i++)
			{
				var arr1:Array = (arr[i] as String).split(":"); 
				if(arr[1]==SlotType.IT_ITEM||((arr1[3]==0||arr1[3] == role.job)&&(arr1[4]==0||arr1[4] == role.sex)))
				{
					if(str==null)
						str=arr[i];
					else
						str+="|"+arr[i];
				}
			}
			addItems(str);
			
		}
		
		private function addItems(str:String):void
		{
			// TODO Auto Generated method stub
			var awards:Vector.<ThingsData> =UtilItemParse.getThingsDatas(str);	
			awardsNum = awards.length;
			for(var i:int = 0;i < _vec.length;i++)
			{
				if(awards.length > i && awards[i])
				{
					IconCellEx.setItemByThingsData(_vec[i],awards[i]);
					ToolTipManager.getInstance().attach(_vec[i]);
					_vec[i].visible = true;
					skin["icon"+(i+1)].visible = true;
					skin["icons"+(i+1)].visible = true;
				}
				else
				{
					skin["icon"+(i+1)].visible = false;
					skin["icons"+(i+1)].visible = false;
					_vec[i].visible = false;
				}
			}
			refreshPosition(awards.length);
		}
		
		private function refreshPosition(length:int):void
		{
			// TODO Auto Generated method stub
			if(length==1)
			{
				skin.icon1.x = 346;
				skin.icon1.y = 250;
				skin.icons1.x = 353;
				skin.icons1.y = 256;
			}
			else
			{
				for(var i:int = 0;i<2;i++)
				{
					if(length==2)
					{
						skin["icon"+(i+1)].x = 306+i*77;
						skin["icon"+(i+1)].y = 250;
						skin["icons"+(i+1)].x = 313+i*77;
						skin["icons"+(i+1)].y = 255;
					}
					else
					{
						skin["icon"+(i+1)].x = 267+i*77;
						skin["icon"+(i+1)].y = 212;
						skin["icons"+(i+1)].x = 274+i*77;
						skin["icons"+(i+1)].y = 217;
					}	
				}
			}
			
		}
		
		private function clearItems():void
		{
			// TODO Auto Generated method stub
			if (_vec)
			{
				destroyTips();
				_vec.forEach(function (element:IconCellEx, index:int, vec:Vector.<IconCellEx>):void
				{
					element.destroy();
					element = null;
				});
				_vec.length = 0;
				_vec = null;
			}
		}
		
		private function clearEffect():void
		{
			// TODO Auto Generated method stub
			if(_effectLoader)
			{
				_effectLoader.destroy();
				_effectLoader = null;
			}
			if(_effectLoader1)
			{
				_effectLoader1.destroy();
				_effectLoader1 = null;
			}
			if(bmp)
			{
				bmp.parent.removeChild(bmp);
				bmp = null;
			}
		}
		
		public function urlBitmapDataReceive(url:String, bitmapData:BitmapData, info:Object):void
		{
			if(curIndex>2)return;
			if(!bmp)
			{
				bmp = new Bitmap(bitmapData,"auto",true);
			}
			_panel.addChild(bmp);
			bmp.x = 0;
			bmp.y = 205;
		}
		
		public function urlBitmapDataProgress(url:String, progress:Number, info:Object):void
		{
			
		}
		
		public function urlBitmapDataError(url:String, info:Object):void
		{
			
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
		
		public function refresh():void
		{
			var arr:Array = OpenServiceActivityDatamanager.instance.specialReward;
			skin.btnGet.visible =  arr[curIndex-1]== 0;
			var cfg:SpecialPreferenceRewordCfgData = ConfigDataManager.instance.cheapReward(curIndex);
			showgetInfo();
		}
		
		public function showGetEffect():void
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
		
		public function destroy():void
		{
			clearEffect();
			destroyTips();
			destroyFlyDatas();
			clearItems();
			_mouseOver.remove(skin.btnCloth);
			_mouseOver.remove(skin.btnEquip);
			_mouseOver.remove(skin.btnHead);
			_mouseOver.remove(skin.btnRing);
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
		}
	}
}