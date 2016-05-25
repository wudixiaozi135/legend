package com.view.gameWindow.panel.panels.smartLoad
{
	import com.model.business.flashVars.FlashVarsManager;
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.KeepRewardCfgData;
	import com.view.gameWindow.flyEffect.FlyEffectMediator;
	import com.view.gameWindow.mainUi.MainUiMediator;
	import com.view.gameWindow.mainUi.subuis.actvEnter.ActvEnter;
	import com.view.gameWindow.mainUi.subuis.actvEnter.McActvEnter;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.FileUtil;
	import com.view.gameWindow.util.UtilItemParse;
	import com.view.gameWindow.util.cell.IconCellEx;
	import com.view.gameWindow.util.cell.ThingsData;
	
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class PanelSmartLoad extends PanelBase
	{
		private var _vec:Vector.<IconCellEx>;
		private var _flyDatas:Array = [];
		public function PanelSmartLoad()
		{
			super();
			SmartLoadDatamanager.instance.attach(this);
		}
		
		override protected function initSkin():void
		{
			var skin:McSmartLoad = new McSmartLoad();
			_skin = skin;
			addChild(skin);
			skin.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		
		override protected function initData():void
		{
			var skin:McSmartLoad = _skin as McSmartLoad;
			_vec = new Vector.<IconCellEx>();
			for(var i:int = 0;i<4;i++)
			{
				_vec[i] = new IconCellEx(skin["icon"+(i+1)],0,0,60,60);
			}
			showItem();
			showBtn();
		}
		
		private function showBtn():void
		{
			// TODO Auto Generated method stub
			var mini:int = FlashVarsManager.getInstance().isMini;
			skin.btnLoad.visible = (mini != 1);
			skin.btnGet.visible = ((mini == 1)&&SmartLoadDatamanager.instance.count<=0);
		}
		
		private function showItem():void
		{
			// TODO Auto Generated method stub
			var cfg:KeepRewardCfgData = ConfigDataManager.instance.keepGameCfgData(1);
			var data:Vector.<ThingsData> = UtilItemParse.getThingsDatas(cfg.small_reward);
			for(var i:int = 0;i < _vec.length;i++)
			{
				IconCellEx.setItemByThingsData(_vec[i],data[i]);
				ToolTipManager.getInstance().attach(_vec[i]);
				_vec[i].visible = true;
			}
		}
		
		protected function onClick(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			var skin:McSmartLoad = _skin as McSmartLoad;
			if(event.target == skin.btnGet)
			{
				SmartLoadDatamanager.instance.getSmartReward();
				storeBitmaps();
			}
			else if(event.target == skin.btnLoad)
			{
				FileUtil.getInst().loadSmart();
			}
			else if(event.target == skin.closeBtn)
			{
				PanelMediator.instance.closePanel(PanelConst.TYPE_SMART_LOAD);
			}
		}
		
		override public function setPostion():void
		{
			var mc:McActvEnter = (MainUiMediator.getInstance().actvEnter as ActvEnter).skin as McActvEnter;
			if (mc)
			{
				var popPoint:Point = mc.localToGlobal(new Point(mc.mcBtns.mcLayer.btnSmart.x + 15, mc.mcBtns.mcLayer.btnSmart.y + 15));
				isMount(true, popPoint.x, popPoint.y);
			} else
			{
				isMount(true);
			}
		}
		override public function update(proc:int= 0):void
		{
			if(proc == GameServiceConstants.CM_MICRO_REWARD)
			{
				showGetEffect();
				showBtn();
				PanelMediator.instance.closePanel(PanelConst.TYPE_SMART_LOAD);
			}
		}
		
		/**飘物品数据*/
		public function storeBitmaps():void
		{
			destroyFlyDatas();
			for(var i:int = 0;i<4;i++)
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
		
		public function showGetEffect():void
		{
			if (_flyDatas)
			{
				FlyEffectMediator.instance.doFlyReceiveThings2(_flyDatas);
				destroyFlyDatas();
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
		
		override public function destroy():void
		{
			destroyFlyDatas();
			destroyTips();
			clearItems();
			SmartLoadDatamanager.instance.detach(this);
			skin.removeEventListener(MouseEvent.CLICK,onClick);
			super.destroy();
		}
	}
}