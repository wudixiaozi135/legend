package com.view.gameWindow.panel.panels.guideSystem.view
{
	import com.view.gameWindow.common.UIEffectManager;
	import com.view.gameWindow.panel.panels.guideSystem.InterObjCollector;
	import com.view.gameWindow.panel.panels.guideSystem.UICenter;
	import com.view.gameWindow.scene.effect.item.EffectBase;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	/**
	 * @author wqhk
	 * 2014-10-24
	 */
	public class GuideHitArea extends Sprite
	{
		public static const EVENT_CLICK:String = "guideHitAreaClick";
		public static const EVENT_DESTROY:String = "guideHitAreaDestroy";
		
		protected var panelName:String;
		private var timeId:int = 0;
		
		protected var areaRect:Rectangle;
		
		protected var check:ICheckUIState;
		protected var hitAreaShow:Boolean;
		protected var arrow:GuideArrow;
		protected var effect:EffectBase;
		
		public function GuideHitArea(panelName:String,rect:Rectangle,hitAreaShow:Boolean)
		{
			mouseChildren = false;
			mouseEnabled = false;
			
			super();
			this.panelName = panelName;
			this.hitAreaShow = hitAreaShow;
			
			areaRect = rect.clone();
			
			x = areaRect.x;
			y = areaRect.y;
			
			reset();
		}
		
		public function attachEffect(effect:EffectBase,x:int,y:int):void
		{
			if(this.effect)
			{
				return;
			}
			
			this.effect = effect;
			effect.x = x;
			effect.y = y;
			addChild(effect);
			
			UIEffectManager.instance.add(effect);
		}
		
		/**
		 * @param rotation 1 up 2 down 3 left 4 right
		 */
		public function attachArrow(arrow:GuideArrow,rotation:int):void
		{
			this.arrow = arrow;
			if(rotation == 1)
			{
				arrow.rotation = 90;
				arrow.x = int(areaRect.width/2);
				arrow.y = 0;
			}
			else if(rotation == 2)
			{
				arrow.rotation = 270;
				arrow.x = int(areaRect.width/2);
				arrow.y = areaRect.height;
			}
			else if(rotation == 3)
			{
				arrow.rotation = 0
				arrow.x = 0;
				arrow.y = int(areaRect.height/2);
			}
			else if(rotation == 4)
			{
				arrow.rotation = 180;
				arrow.x = areaRect.width;
				arrow.y = int(areaRect.height/2);
			}
			else if(rotation == 5)
			{
				arrow.x = int(areaRect.width/2);
				arrow.y = areaRect.height;
			}
			
			addChild(arrow);
		}
		
		override public function set visible(value:Boolean):void
		{
			if(super.visible != value)
			{
				super.visible = value;
			}
			
			if(arrow && arrow.visible != value)
			{
				arrow.visible = value;
			}
			
			if(effect && effect.visible != value)
			{
				effect.visible = value;
			}
		}
		
		public function isInArea(x:int,y:int):Boolean
		{
			return false;
		}
		
		public function setUICheck(check:ICheckUIState):void
		{
			this.check = check;
		}
		
		public function reset():void
		{
			if(hitAreaShow)
			{	
				draw();
			}
			
			if(!hasEventListener(Event.ADDED_TO_STAGE))
			{
				addEventListener(Event.ADDED_TO_STAGE,addedHandler,false,0,true);
				addEventListener(Event.REMOVED_FROM_STAGE,removedHandler,false,0,true);
			}
			
			if(parent)
			{
				setTime();
			}
		}
		
		public function destroy():void
		{
			if(arrow)
			{
				if(arrow.parent)
				{
					arrow.parent.removeChild(arrow);
				}
				arrow.destroy();
				arrow = null;
			}
			
			if(effect)
			{
				UIEffectManager.instance.remove(effect);
				if(effect.parent)
				{
					effect.parent.removeChild(effect)
				}
				
				effect.destory();
				effect = null;
			}
			
			mouseLayer.removeEventListener(MouseEvent.CLICK,parentClickHandler,true);
			removeEventListener(Event.ADDED_TO_STAGE,addedHandler);
			removeEventListener(Event.REMOVED_FROM_STAGE,removedHandler);
			
			if(timeId>0)
			{
				clearInterval(timeId);
				timeId = 0;
			}
			
			this.dispatchEvent(new Event(EVENT_DESTROY));
		}
		
		//现在 在action中已加入检测 这边是否可以去掉。不然执行两边
		private function setTime():void
		{
			if(timeId == 0)
			{
				timeId = setInterval(timeHandler,700);
			}
			
			timeHandler();
		}
		
		private function removedHandler(e:Event):void
		{
			destroy();
		}
		
		private function addedHandler(e:Event):void
		{
			setTime();
			//之前用parent不好的地方是有的parent是mousenEnabled false的
			//注意是useCapture是true 不然在引导关闭界面类的按钮时 会先触发REMOVED_FROM_STAGE
			//removeEventListener也要useCapture是true，不然会内存泄漏
			mouseLayer.addEventListener(MouseEvent.CLICK,parentClickHandler,true,int.MAX_VALUE,true);
		}
		
		/**
		 * 取的是stage 
		 */
		private function get mouseLayer():DisplayObjectContainer
		{
			return UICenter.getTopLayer().stage;
		}
		
		private function parentClickHandler(e:MouseEvent):void
		{
			if(parent && visible)
			{
//				trace(e.localX + ":" + e.localY);
//				trace(this.x + ":" + this.y);
//				
//				var pos:Point = parent.globalToLocal(new Point(e.stageX,e.stageY));
//				trace("guide hitarea:"+pos.toString());
//				pos = new Point(mouseX,mouseY);
//				trace("guide hitarea:"+pos.toString());
				
//				var pos:Point = new Point(e.localX,e.localY);
//				if(e.target)
//				{
//					pos = e.target.localToGlobal(pos);
//				}
//				
//				pos = globalToLocal(pos);
				
				var pos:Point = globalToLocal(new Point(e.stageX,e.stageY));
				
				if(isInArea(pos.x,pos.y))
				{
					this.dispatchEvent(new Event(EVENT_CLICK));
				}
			}
		}
		
		private function timeHandler():void
		{
			checkState();
		}
		
		protected function draw():void
		{
			
		}
		
		private var _show:Boolean = true;
		public function show(value:Boolean):void
		{
			_show = value;
		}
		
		protected function isValidateUI(ui:InteractiveObject):Boolean
		{
			if(/*!ui.mouseEnabled || */!ui.stage || !ui.visible || !ui.parent.visible)
			{
				return false;
			}
			
			return true;
		}
		
		private function isInParentList(item:InteractiveObject,ctner:DisplayObjectContainer):Boolean
		{
			while(item.parent)
			{
				if(item.parent == ctner)
				{
					return true;
				}
			}
			
			return false;
		}
		
		protected function getUnderUI():InteractiveObject
		{
			var re:InteractiveObject = null;
			if(areaRect)
			{
				var ui:DisplayObjectContainer = UICenter.getUI(panelName);
				
				if(ui)
				{
					var center:Point = new Point(areaRect.x + areaRect.width/2,areaRect.y + areaRect.height/2);
					var list:Vector.<InteractiveObject> = InterObjCollector.autoCollector.list;
					
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
		
		/**
		 * @return 1 点击成功 0点击不成功 -1异常
		 */
		public function executeAuto():int
		{
			if(visible)
			{
				if(areaRect)
				{
					var o:InteractiveObject = getUnderUI();
					
					if(o && !o.mouseEnabled)
					{
						var ctner:DisplayObjectContainer = o as DisplayObjectContainer;
						
						if(ctner && ctner.numChildren)
						{
							o = ctner.getChildAt(0) as InteractiveObject;//只取 一层
						}
						else
						{
							o = null;
						}
					}
					
					if(o && !isValidateUI(o))
					{
						return -1;
					}
					
					if(o)
					{
						var e:MouseEvent = new MouseEvent(MouseEvent.CLICK,true,false,6,6);
						o.dispatchEvent(e);
						return 1;
					}
					else
					{
						return 0;
					}
				}
			}
			
			return -1
		}
		
		public function checkState(isStage:Boolean = true):void
		{
			var panel:* = UICenter.getUI(panelName);
			
			if(isStage)
			{
//				if(!parent)
				if(!stage)
				{
					destroy();
					return;
				}
				
				if(parent && panel == parent)
				{
					if(check)
					{
						visible = _show && !check.isChange();
					}
					else
					{
						visible = _show;
					}
				}
			}
			else
			{
				if(check)
				{
					visible = _show && !check.isChange();
				}
				else
				{
					visible = _show;
				}
			}
		}
	}
}