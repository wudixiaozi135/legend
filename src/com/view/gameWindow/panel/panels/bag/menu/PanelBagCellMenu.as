package com.view.gameWindow.panel.panels.bag.menu
{
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.scene.GameSceneManager;
	
	import flash.display.Stage;
	import flash.events.MouseEvent;
	
	/**
	 * 包裹单元格菜单面板类
	 * @author Administrator
	 */	
	public class PanelBagCellMenu extends PanelBase
	{
		private var _items:Vector.<BagCellMenuItem>;
		
		public function PanelBagCellMenu()
		{
			super();
		}
		
		override protected function initSkin():void
		{
			var mc:McBagCellMenu = new McBagCellMenu();
			_skin = mc;
			addChild(_skin);
		}
		
		override protected function initData():void
		{
			initItems();
			_skin.addEventListener(MouseEvent.CLICK,onClick);
			_skin.addEventListener(MouseEvent.ROLL_OUT,onRollOut);
			_skin.addEventListener(MouseEvent.ROLL_OVER,onRollOver,true);
		}
		
		private function initItems():void
		{
			var list:Vector.<int> = BagCellMenuDataManager.instance.list;
			var i:int,l:int = list.length;
			_items = new Vector.<BagCellMenuItem>(l,true);
			for(i=0;i<l;i++)
			{
				/*var txt:TextField = cloneTxt();*/
				var type:int = list[i];
				var item:BagCellMenuItem = new BagCellMenuItem(/*txt,*/type);
				item.x = 5;
				item.y = 5+i*18;
				_skin.addChild(item);
				_items[i] = item;
			}
			var mc:McBagCellMenu = _skin as McBagCellMenu;
			mc.__id0_.height = item.y + item.height + 5;
		}
		
		/*private function cloneTxt():TextField
		{
			var mc:McBagCellMenu = _skin as McBagCellMenu;
			var qClassName:String = getQualifiedClassName(mc.txt);  
			var objectType:Class = getDefinitionByName(qClassName) as Class;  
			registerClassAlias(qClassName, objectType);//这里
			var byteArray:ByteArray = new ByteArray();
			byteArray.writeObject(mc.txt);
			byteArray.position = 0;
			return byteArray.readObject() as TextField;
		}*/
		
		protected function onRollOver(event:MouseEvent):void
		{
			var mc:McBagCellMenu = _skin as McBagCellMenu;
			var item:BagCellMenuItem = event.target as BagCellMenuItem;
			if(item)
			{
				mc.mcSelect.y = item.y - 1;
			}
		}
		
		protected function onRollOut(event:MouseEvent):void
		{
			if(event.target == _skin)
			{
				PanelMediator.instance.closePanel(PanelConst.TYPE_BAGCELL_MENU);
			}
		}
		
		protected function onClick(event:MouseEvent):void
		{
			var mc:McBagCellMenu = _skin as McBagCellMenu;
			var item:BagCellMenuItem = event.target as BagCellMenuItem;
			if(item)
			{
				//调用对应的方法
				/*trace(item.type);*/
				BagCellMenuDataManager.instance.notify(item.type);
				PanelMediator.instance.closePanel(PanelConst.TYPE_BAGCELL_MENU);
			}
		}
		
		override public function setPostion():void
		{
			var stage:Stage = GameSceneManager.getInstance().stage;
			x = stage.mouseX-5;
			y = stage.mouseY-5;
		}
		
		override public function destroy():void
		{
			var i:int,l:int = _items.length;
			for(i=0;i<l;i++)
			{
				var item:BagCellMenuItem = _items[i];
				if(item)
				{
					item.parent.removeChild(item);
				}
				_items[i] = null;
			}
			_items = null;
			_skin.removeEventListener(MouseEvent.ROLL_OVER,onRollOver,true);
			_skin.removeEventListener(MouseEvent.ROLL_OUT,onRollOut);
			_skin.removeEventListener(MouseEvent.CLICK,onClick);
			super.destroy();
		}
	}
}