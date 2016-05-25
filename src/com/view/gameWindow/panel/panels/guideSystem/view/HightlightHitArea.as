package com.view.gameWindow.panel.panels.guideSystem.view
{
	import com.view.gameWindow.common.HighlightEffectManager;
	import com.view.gameWindow.panel.panels.guideSystem.InterObjCollector;
	import com.view.gameWindow.panel.panels.guideSystem.UICenter;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	
	/**
	 * @author wqhk
	 * 2014-12-17
	 */
	public class HightlightHitArea extends GuideHitArea
	{
		private var lastUnderUI:InteractiveObject;
		protected var hl:HighlightEffectManager;
		public function HightlightHitArea(panelName:String,tabIndex:int, rect:Rectangle, hitAreaShow:Boolean)
		{
			super(panelName, rect, hitAreaShow);
			
			hl = new HighlightEffectManager();
			
			if(tabIndex > -1)
			{
				setUICheck(new CheckTabIndex(panelName,tabIndex));
			}
		}
		
		override public function isInArea(x:int, y:int):Boolean
		{
			return x>=0 && x<=areaRect.width && y>=0 && y <= areaRect.height;
		}
		
		//诶 好像还是避免不了……
		private function checkUnderUI():void
		{
			if(areaRect)
			{
				var ui:DisplayObjectContainer = UICenter.getUI(panelName);
				
				if(ui)
				{
					if(ui.scaleX != 1)//ui有可能还在飞行中，这个时候如果添加位置会不对
					{
						return;
					}
//					var center:Point = new Point(areaRect.x + areaRect.width/2,areaRect.y + areaRect.height/2);
					var newObj:InteractiveObject = null;
					
					newObj = getUnderUIForHightlight();
					
//					var list:Vector.<InteractiveObject> = InterObjCollector.instance.list;
//					
//					for each(var item:InteractiveObject in list)
//					{
//						if(isValidateUI(item))
//						{
////							var rect:Rectangle = item.getBounds(ui);
//							var rect:Rectangle = item.getRect(parent);
//							if(rect.containsPoint(center))
//							{
//								newObj = item;
//								break;
//							}
//						}
//					}
//					
					if(newObj != lastUnderUI)
					{
						onChangeUnderUI(lastUnderUI,newObj);
						lastUnderUI = newObj;
					}
				}
				else
				{
					if(lastUnderUI)
					{
						onChangeUnderUI(lastUnderUI,null);
					}
				}
			}
		}
		
		private function getUnderUIForHightlight():InteractiveObject
		{
			var re:InteractiveObject = null;
			if(areaRect)
			{
				var ui:DisplayObjectContainer = UICenter.getUI(panelName);
				
				if(ui)
				{
					var center:Point = new Point(areaRect.x + areaRect.width/2,areaRect.y + areaRect.height/2);
					var list:Vector.<InteractiveObject> = InterObjCollector.instance.list;
					
					for each(var item:InteractiveObject in list)
					{
						if(isValidateUI(item))
						{
							//							var rect:Rectangle = item.getBounds(ui);
							var rect:Rectangle = item.getRect(parent);
							if(rect.containsPoint(center))
							{
								re = item;
								break;
							}
						}
					}
				}
			}
			
			return re;
		}
		
		protected function onChangeUnderUI(oldU:DisplayObject,newU:DisplayObject):void
		{
			if(oldU)
			{
				hl.hide(oldU);
			}
			
			if(newU)
			{
				var pos:Point = InterObjCollector.instance.getPlusPos(newU as InteractiveObject);
				hl.show(newU.parent,newU,pos.x,pos.y);
			}
		}
		
		override public function destroy():void
		{
			onChangeUnderUI(lastUnderUI,null);
			lastUnderUI = null;
			super.destroy();
		}
		
		override public function checkState(isStage:Boolean = true):void
		{
			super.checkState(isStage);
			
			if(!visible)
			{
				if(lastUnderUI)
				{
					onChangeUnderUI(lastUnderUI,null);
					lastUnderUI = null;
				}
			}
			else
			{
				if(!lastUnderUI || !isValidateUI(lastUnderUI))//lastUnderUI.parent.visible 坑爹的感觉 以后会不会 parent.parent... 
				{
					checkUnderUI();
				}
			}
		}
		
//		private function isValidateUI(ui:InteractiveObject):Boolean
//		{
//			if(!ui.mouseEnabled || !ui.stage || !ui.visible || !ui.parent.visible)
//			{
//				return false;
//			}
//			
//			return true;
//		}
	}
}