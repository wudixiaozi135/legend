package com.view.gameWindow.panel.panels.guideSystem.action
{
	
	import com.view.gameWindow.panel.panels.guideSystem.completeCond.ICheckCondition;
	
	import flash.geom.Rectangle;
	
	
	/**
	 * @author wqhk
	 * 2014-12-13
	 */
	public class AttachPanelCondAction extends AttachPanelAction
	{
		public function AttachPanelCondAction(panelName:String="", tabIndex:int=-1, 
											  hitAreaType:int=0, hitArea:Rectangle=null, 
											  arrowRotation:int=0, hitAreaShow:int=0, 
											  tip:String = "",effectUrl:String = "",
											  effectX:int=0,effectY:int=0)
		{
			super(panelName, tabIndex, hitAreaType, hitArea, arrowRotation, hitAreaShow, tip, effectUrl,effectX,effectY);
		}
		
//		private var _cond:ICheckCondtion;
		
//		public function set cond(value:ICheckCondtion):void
//		{
//			_cond = value;
//		}
		
		override public function check():void
		{
			super.check();
			
			if(!hitView)
			{
				return;
			}
			if(_cond && _cond.length)
			{
				var isDoing:Boolean = false;
				for each(var cond:ICheckCondition in _cond)
				{
					if(cond.isDoing())
					{
						isDoing = true;
					}
				}
				if(isDoing)
				{
					hitView.show(false);
				}
				else
				{
					hitView.show(true);
				}
			}
			else
			{
				hitView.show(true);
			}
			
			hitView.checkState(false);
		}
		
		override public function isComplete():Boolean
		{
			if(_cond && _cond.length)
			{
				var isComplete:Boolean = true;
				for each(var cond:ICheckCondition in _cond)
				{
					if(!cond.isComplete())
					{
						isComplete = false;
					}
				}
				
				return isComplete;
			}
			else
			{
				return _isComplete;
			}
		}
	}
}