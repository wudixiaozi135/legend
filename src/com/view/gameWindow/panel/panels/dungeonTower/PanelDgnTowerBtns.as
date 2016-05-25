package com.view.gameWindow.panel.panels.dungeonTower
{
    import com.core.bind_t;
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.DgnShopCfgData;
    import com.model.configData.cfgdata.ItemCfgData;
    import com.model.consts.FontFamily;
    import com.model.consts.StringConst;
    import com.model.consts.ToolTipConst;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panelbase.PanelBase;
    import com.view.gameWindow.panel.panels.bag.BagDataManager;
    import com.view.gameWindow.panel.panels.guideSystem.GuideSystem;
    import com.view.gameWindow.panel.panels.guideSystem.InterObjCollector;
    import com.view.gameWindow.scene.entity.EntityLayerManager;
    import com.view.gameWindow.tips.toolTip.ToolTipManager;
    import com.view.gameWindow.util.HtmlUtils;
    import com.view.gameWindow.util.css.GameStyleSheet;
    import com.view.newMir.NewMirMediator;
    
    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import flash.text.TextField;

    /**
	 * 塔防副本按钮面板类
	 * @author Administrator
	 */	
	public class PanelDgnTowerBtns extends PanelBase
	{
		public function PanelDgnTowerBtns()
		{
			super();
            canEscExit=false;
			BagDataManager.instance.attach(this);
		}
		
		override protected function initSkin():void
		{
			var skin:McDgnTowerBtns = new McDgnTowerBtns();
			_skin = skin;
			addChild(_skin);
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var guards:Array = DgnTowerDataManger.instance.guards;
			var i:int,l:int = guards.length;
			for (i=0;i<l;i++) 
			{
				var btn:MovieClip = skin["btn"+i] as MovieClip;
				rsrLoader.addCallBack(btn,callBack(guards[i]));
			}
		}
		
		private function callBack(id:int):Function
		{
			var fun:Function = function(mc:MovieClip):void
			{
				ToolTipManager.getInstance().detach(mc);
				var itemCfgData:ItemCfgData = ConfigDataManager.instance.itemCfgData(id);
				ToolTipManager.getInstance().attachByTipVO(mc,ToolTipConst.ITEM_BASE_TIP,itemCfgData);
				
				InterObjCollector.autoCollector.add(mc,PanelConst.TYPE_DUNGEON_TOWER_BTNS);
			};
			return fun;
		}
		
		override protected function initData():void
		{
			var guards:Array = DgnTowerDataManger.instance.guards;
			var i:int,l:int = guards.length;
			for (i=0;i<l;i++) 
			{
				initGuardTip(guards[i],i);
				initGuardNum(guards[i],i);
				initCost(guards[i],i);
			}
			skin.addEventListener(MouseEvent.CLICK,onClick);
			skin.addEventListener(MouseEvent.ROLL_OVER,onOver,true);
			skin.addEventListener(MouseEvent.ROLL_OUT,onOut,true);
		}
		
		private function initGuardTip(id:int,index:int):void
		{
			var btn:MovieClip = skin["btn"+index] as MovieClip;
			var itemCfgData:ItemCfgData = ConfigDataManager.instance.itemCfgData(id);
			ToolTipManager.getInstance().attachByTipVO(btn,ToolTipConst.ITEM_BASE_TIP,itemCfgData);
		}
		
		private function initGuardNum(id:int,index:int):void
		{
			var num:int = BagDataManager.instance.getItemNumById(id);
			var txt:TextField = skin["txt"+index] as TextField;
			txt.text = num+"";
			txt.mouseEnabled = false;
		}
		
		private function initCost(id:int,index:int):void
		{
			var cfgDt:DgnShopCfgData = DgnTowerDataManger.instance.dgnShopCfgData(id);
			var txt:TextField = skin["txtCost"+index] as TextField;
			txt.htmlText = HtmlUtils.createHtmlStr(txt.textColor,cfgDt.strExp + StringConst.DGN_TOWER_BTNS_0001,12,false,2,FontFamily.FONT_NAME,true);
			txt.styleSheet = GameStyleSheet.linkStyle;
		}
		
		protected function onOver(event:MouseEvent):void
		{
			switch(event.target)
			{
				default:
					break;
				case skin.btn0:
					EntityLayerManager.getInstance().drowCircleRoundFirstPlayer(0);
					break;
				case skin.btn1:
					EntityLayerManager.getInstance().drowCircleRoundFirstPlayer(1);
					break;
				case skin.btn2:
					EntityLayerManager.getInstance().drowCircleRoundFirstPlayer(2);
					break;
				case skin.btn3:
					EntityLayerManager.getInstance().drowCircleRoundFirstPlayer(3);
					break;
			}
		}
		
		protected function onOut(event:MouseEvent):void
		{
			switch(event.target)
			{
				default:
					break;
				case skin.btn0:
				case skin.btn1:
				case skin.btn2:
				case skin.btn3:
					EntityLayerManager.getInstance().cleanCircleRoundFirstPlayer();
					break;
			}
		}
		
		protected function onClick(event:MouseEvent):void
		{
			var skin:McDgnTowerBtns = _skin as McDgnTowerBtns;
			switch(event.target)
			{
				default:
					break;
				case skin.btn0:
					dealBtn(0);
					break;
				case skin.btn1:
					dealBtn(1);
					break;
				case skin.btn2:
					dealBtn(2);
					break;
				case skin.btn3:
					dealBtn(3);
					break;
				case skin.txtCost0:
					dealTxtCost(0);
					break;
				case skin.txtCost1:
					dealTxtCost(1);
					break;
				case skin.txtCost2:
					dealTxtCost(2);
					break;
				case skin.txtCost3:
					dealTxtCost(3);
					break;
			}
		}
		
		private function dealBtn(index:int):void
		{
			if(checkGuide())
			{
				return;
			}
			var manager:DgnTowerDataManger = DgnTowerDataManger.instance;
			var guards:Array = manager.guards;
			var id:int = guards[index] as int;
			var num:int = BagDataManager.instance.getItemNumById(id);
			if(num > 0)
			{
				manager.cmItemUse(id);
			}
			else
			{
				showDgnTowerExchange(id);
			}
		}
		
		private function showDgnTowerExchange(id:int):void
		{
			var manager:DgnTowerDataManger = DgnTowerDataManger.instance;
			var cfgDt:DgnShopCfgData = manager.dgnShopCfgData(id);
			if(!cfgDt)
			{
				trace("PanelDgnTowerBtns.dealBtn(index) DgnShopCfgData配置信息不存在");
				return;
			}
			DgnTowerDataManger.instance.exchange = id;
			var mediator:PanelMediator = PanelMediator.instance;
			if(mediator.openedPanel(PanelConst.TYPE_DUNGEON_TOWER_EXCHANGE))
			{
				mediator.closePanel(PanelConst.TYPE_DUNGEON_TOWER_EXCHANGE);
			}
			mediator.openPanel(PanelConst.TYPE_DUNGEON_TOWER_EXCHANGE);
		}
		
		private function checkGuide():Boolean
		{
			var b:bind_t = GuideSystem.getPanelNameFilter(PanelConst.TYPE_DUNGEON_TOWER_BTNS);
			var re:Boolean =  GuideSystem.instance.some(b);
			b.destroy();
			return re;
		}
		
		private function dealTxtCost(index:int):void
		{
			var manager:DgnTowerDataManger = DgnTowerDataManger.instance;
			var guards:Array = manager.guards;
			var id:int = guards[index] as int;
			showDgnTowerExchange(id);
		}
		
		override public function update(proc:int=0):void
		{
			var guards:Array = DgnTowerDataManger.instance.guards;
			var i:int,l:int = guards.length;
			for (i=0;i<l;i++) 
			{
				initGuardNum(guards[i],i);
			}
		}
		
		override public function setPostion():void
		{
			x =(NewMirMediator.getInstance().width - _skin.width)*.5;
			y = NewMirMediator.getInstance().height - 190 - _skin.height;
		}
		
		override public function destroy():void
		{
			EntityLayerManager.getInstance().cleanCircleRoundFirstPlayer();
			var guards:Array = DgnTowerDataManger.instance.guards;
			var i:int,l:int = guards.length;
			for (i=0;i<l;i++) 
			{
				var btn:MovieClip = skin["btn"+i] as MovieClip;
				ToolTipManager.getInstance().detach(btn);
			}
			
			InterObjCollector.autoCollector.removeByGroupId(PanelConst.TYPE_DUNGEON_TOWER_BTNS);
			
			BagDataManager.instance.detach(this);
			super.destroy();
		}
	}
}