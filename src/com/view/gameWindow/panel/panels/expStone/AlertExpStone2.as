package com.view.gameWindow.panel.panels.expStone
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.ExpYuAwardCfgData;
	import com.model.consts.StringConst;
	import com.view.gameWindow.flyEffect.FlyEffectMediator;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.panel.panels.bag.cell.BagCell;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.Cover;
	import com.view.gameWindow.util.UtilItemParse;
	import com.view.gameWindow.util.cell.ThingsData;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class AlertExpStone2 extends PanelBase
	{
		private var isCanGet:Boolean;
		private var _layer:Sprite;
		private var _cells:Vector.<BagCell>;
		/**列数*/
		private const COUNT_LINE:int = 4;
		
		public function AlertExpStone2()
		{
			super();
		}
		
		override protected function initSkin():void
		{
			var cover:Cover = new Cover(0x000000,0.6);
			addChild(cover);
			_skin = new McExpPanelGet();
			addChild(_skin);
		}	
		
		override protected function initData():void
		{
			var skin:McExpPanelGet = _skin as McExpPanelGet;
			skin.txt.mouseEnabled = false;
			skin.txt.text = StringConst.EXP_STONE_TIP14;
			skin.addEventListener(MouseEvent.CLICK,onClick);
			//
			initIcons();
		}
		
		private function initIcons():void
		{
			_layer = new Sprite();
			_layer.visible = false;
			addChild(_layer);
			_cells = new Vector.<BagCell>();
			var cfgDt:ExpYuAwardCfgData = ConfigDataManager.instance.expYuAwardCfgData(1);
			var dts:Vector.<ThingsData> = UtilItemParse.getThingsDatas(cfgDt.reward);
			var i:int,l:int = dts.length;
			var startX:int;
			for (i=0;i<l;i++) 
			{
				var cell:BagCell = new BagCell();
				cell.initView();
				cell.refreshLockState(false);
				cell.refreshData(dts[i]);
				if(!startX && int(i/COUNT_LINE) && int(i/COUNT_LINE) == int(dts.length/COUNT_LINE))//最后一行
				{
					startX = (_layer.width - (dts.length - i)*cell.width)*.5;
				}
				cell.x = startX + (i%COUNT_LINE)*cell.width;
				cell.y = int(i/COUNT_LINE)*cell.height;
				_layer.addChild(cell);
				ToolTipManager.getInstance().attach(cell);
				_cells.push(cell);
			}
			var skin:McExpPanelGet = _skin as McExpPanelGet;
			_layer.x = (skin.mcLayer.width - _layer.width)*.5;
			_layer.y = (skin.mcLayer.height - _layer.height)*.5;
		}
		
		protected function onClick(event:MouseEvent):void
		{
			var skin:McExpPanelGet = _skin as McExpPanelGet;
			if(event.target == skin.btnGet)
			{
				if(!isCanGet)
				{
					isCanGet = true;
					_layer.visible = true;
					skin.txt.text = StringConst.EXP_STONE_TIP15;
					skin.mcLayer.visible = false;
				}
				else
				{
					ExpStoneDataManager.instance.getExpYuPanel();
					FlyEffectMediator.instance.doFlyReceiveThings2(cellsBitmap());
					PanelMediator.instance.closePanel(PanelConst.TYPE_ALERT_EXP_STONE2);
				}
			}
		}
		
		private function cellsBitmap():Array
		{
			var cell:BagCell;
			var data:Array = [];
			for each(cell in _cells) 
			{
				if(cell && !cell.isEmpty())
				{
					cell.bmp.name = cell.id+'';
					data.push(cell.bmp);
				}
			}
			return data;
		}
		
		override public function destroy():void
		{
			var cell:BagCell;
			for each(cell in _cells)
			{
				if(cell)
				{
					if(cell.parent)
					{
						cell.parent.removeChild(cell);
					}
					ToolTipManager.getInstance().detach(cell);
				}
			}
			_cells = null;
			skin.removeEventListener(MouseEvent.CLICK,onClick);
			super.destroy();
		}
	}
}