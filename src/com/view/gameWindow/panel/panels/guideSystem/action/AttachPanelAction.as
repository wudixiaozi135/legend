package com.view.gameWindow.panel.panels.guideSystem.action
{
	import com.view.gameWindow.panel.panels.guideSystem.UICenter;
	import com.view.gameWindow.panel.panels.guideSystem.completeCond.ICheckCondition;
	import com.view.gameWindow.panel.panels.guideSystem.view.CircleHitArea;
	import com.view.gameWindow.panel.panels.guideSystem.view.GuideArrow;
	import com.view.gameWindow.panel.panels.guideSystem.view.GuideArrow2;
	import com.view.gameWindow.panel.panels.guideSystem.view.GuideArrow3;
	import com.view.gameWindow.panel.panels.guideSystem.view.GuideArrowTalk;
	import com.view.gameWindow.panel.panels.guideSystem.view.GuideHitArea;
	import com.view.gameWindow.panel.panels.guideSystem.view.HightlightHitArea;
	import com.view.gameWindow.panel.panels.guideSystem.view.RectHitArea;
	import com.view.gameWindow.scene.effect.item.EffectBase;
	import com.view.gameWindow.scene.entity.effect.EntityPermanentEffect;
	import com.view.gameWindow.util.HtmlUtils;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	/**
	 * @author wqhk
	 * 2014-10-24
	 */
	public class AttachPanelAction extends GuideAction
	{
		public var panelName:String;
		public var tabIndex:int = -1;
		//箭头
		public var arrowRotation:int;
		
		public var hitAreaType:int = 0; //1 rect 2 circle
		public var hitAreaShow:int = 0; //0 显示 1不显示
		//响应点击的区域
		public var hitArea:Rectangle;
		
		protected var hitView:GuideHitArea;
		protected var arrow:GuideArrow;
		protected var uiCenter:UICenter;
		protected var tip:String;
		protected var effect:EffectBase;
		
		public var effectUrl:String = "";
		public var effectX:int;
		public var effectY:int;
		
		public function AttachPanelAction(panelName:String="",tabIndex:int = -1,
										  hitAreaType:int = 0,hitArea:Rectangle = null,
										  arrowRotation:int = 0,hitAreaShow:int = 0, 
										  tip:String = "", effectUrl:String = "",
										  effectX:int=0,effectY:int=0)
		{
			this.panelName = panelName;
			this.tabIndex = tabIndex;
			this.hitAreaType = hitAreaType;
			this.hitArea = hitArea ? hitArea.clone() : null;
			this.hitAreaShow = hitAreaShow;
			this.arrowRotation = arrowRotation;
			this.effectUrl = effectUrl;
			this.effectX = effectX;
			this.effectY = effectY;
			
			uiCenter = new UICenter();
			this.tip = tip;
			super();
		}
		
		private var _executed:Boolean = false;
		override public function executeAfterTimeOut():void
		{
//			var ui:UICenter = new UICenter();
//			ui.closeUI(panelName);
			
			if(hitView)
			{
				if(!_executed)
				{
					if(hitView.executeAuto() == 0)
					{
						//关闭界面
						_isBreak = true;
						var ui:UICenter = new UICenter();
						ui.closeUI(panelName);
					}
					_executed = true;
				}
			}
		}
		
		protected function createArrow():GuideArrow
		{
			var arrow:GuideArrow;
			
			if(arrowRotation == 5)
			{
				arrow = new GuideArrow3();
			}
			else if(arrowRotation == 6)
			{
				arrow = new GuideArrowTalk(false,200,0);
			}
			else
			{
				arrow = new GuideArrow2();
			}
			
			return arrow;
		}
		
		override public function init():void
		{
			destroy();
			
			time = getTimer();//重新计时
			
			if(!UICenter.getUI(panelName))
			{
				_isBreak = true;
				return;
			}
			
			if(hitArea)
			{
				if(hitAreaType == 1)
				{
					if(!hitView)
					{
						hitView = new RectHitArea(panelName,tabIndex,hitArea,hitAreaShow == 0);
						hitView.addEventListener(GuideHitArea.EVENT_CLICK,guideHitAreaClickHandler,false,0,true);
						hitView.addEventListener(GuideHitArea.EVENT_DESTROY,guideHitAreaDestroyHandler,false,0,true);
						
						if(effectUrl && effectUrl != "0")
						{
							effect = new EntityPermanentEffect(effectUrl);
							hitView.attachEffect(effect,effectX,effectY);
						}
						
						if(arrowRotation != 0)
						{
							arrow = createArrow();
							hitView.attachArrow(arrow,arrowRotation);
						}
					}
				}
				else if(hitAreaType == 2)
				{
					if(!hitView)
					{
						hitView = new CircleHitArea(panelName,tabIndex,hitArea,hitAreaShow == 0);
						hitView.addEventListener(GuideHitArea.EVENT_CLICK,guideHitAreaClickHandler,false,0,true);
						hitView.addEventListener(GuideHitArea.EVENT_DESTROY,guideHitAreaDestroyHandler,false,0,true);
						
						if(effectUrl && effectUrl != "0")
						{
							effect = new EntityPermanentEffect(effectUrl);
							hitView.attachEffect(effect,effectX,effectY);
						}
						
						if(arrowRotation != 0)
						{
							arrow = createArrow();
							hitView.attachArrow(arrow,arrowRotation);
						}
					}
				}
				else if(hitAreaType == 3)
				{
					if(!hitView)
					{
						hitView = new HightlightHitArea(panelName,tabIndex,hitArea,hitAreaShow == 0);
						hitView.addEventListener(GuideHitArea.EVENT_CLICK,guideHitAreaClickHandler,false,0,true);
						hitView.addEventListener(GuideHitArea.EVENT_DESTROY,guideHitAreaDestroyHandler,false,0,true);
						
						if(effectUrl && effectUrl != "0")
						{
							effect = new EntityPermanentEffect(effectUrl);
							hitView.attachEffect(effect,effectX,effectY);
						}
						
						if(arrowRotation != 0)
						{
							arrow = createArrow();
							
							hitView.attachArrow(arrow,arrowRotation);
						}
					}
				}
				else if(hitAreaType == 0)
				{
					_isComplete = true;
				}
				
				if(arrow)
				{
					arrow.label = HtmlUtils.createHtmlStr(0xffcc00, tip, 14, arrowRotation == 5 || arrowRotation == 6 ? false : true,4);
				}
			}
			else
			{
				_isComplete = true;
			}
		}
		
		private function guideHitAreaClickHandler(e:Event):void
		{
			_isComplete = true;
			
			if(_cond && _cond.length)
			{
				for each(var cond:ICheckCondition in _cond)
				{
					cond.toDo();
				}
			}
		}
		
		private function guideHitAreaDestroyHandler(e:Event):void
		{
			_isBreak = true;
		}
		
		override public function destroy():void
		{
			_executed = false;
			if(hitView)
			{
				hitView.removeEventListener(GuideHitArea.EVENT_CLICK,guideHitAreaClickHandler);
				hitView.removeEventListener(GuideHitArea.EVENT_DESTROY,guideHitAreaDestroyHandler);
				
				if(hitView.parent)
				{
					hitView.parent.removeChild(hitView);
				}
				else
				{
					hitView.destroy();
				}
				
				hitView = null;
			}
			
			if(effect)
			{
				if(effect.parent)
				{
					effect.parent.removeChild(effect);
				}
				effect.destory();
				effect = null;
			}
			
			if(arrow)
			{
				if(arrow.parent)
				{
					arrow.parent.removeChild(arrow);
				}
				arrow.destroy();
				arrow = null;
			}
		}
		
		override public function act():void
		{
			if(panelName && hitView)
			{
				var panel:DisplayObjectContainer = null;
				
				panel = UICenter.getUI(panelName);
				
				if(panel)
				{
					if(/*!hitView.parent || */hitView.parent != panel)
					{
						panel.addChild(hitView);
						
						_isComplete = false;
						_isBreak = false;
					}
				}
				else
				{
					_isBreak = true;
				}
			}
			
			super.act();
		}
	}
}