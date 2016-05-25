package com.view.gameWindow.panel.panels.guideSystem.action
{
	import com.view.gameWindow.panel.panels.guideSystem.completeCond.ICheckCondition;
	
	import flash.utils.getTimer;
	
	/**
	 * override function act()
	 * @author wqhk
	 * 2014-10-24
	 */
	public class GuideAction
	{
		/**
		 * 记录生成时间
		 */
		public var time:int;
		protected var _isComplete:Boolean = false;
		protected var _isBreak:Boolean = false;//
		protected var _isIgnore:Boolean = false;
		protected var _cond:Array;
		
		public function GuideAction()
		{
			time = getTimer();
		}
		
		public function set cond(value:Array/*ICheckCondtion*/):void
		{
			_cond = value.concat();
		}
		
		public function check():void
		{
			
		}
		
		public function init():void
		{
			
		}
		
		public function act():void
		{
			
		}
		
		public function executeAfterTimeOut():void
		{
			
		}
		
		public function isComplete():Boolean
		{
			return _isComplete;
		}
		
		public function isBreak():Boolean
		{
			return _isBreak;
		}
		
		public function isIgnore():Boolean
		{
			return _isIgnore;
		}
		
		public function destroy():void
		{
			
		}
	}
}