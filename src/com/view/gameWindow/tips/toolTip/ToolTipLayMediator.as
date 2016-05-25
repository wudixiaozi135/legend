package com.view.gameWindow.tips.toolTip
{
	import com.view.gameWindow.tips.toolTip.interfaces.IToolTipLayMediator;
	
	/**
	 * tip层
	 * @author jhj
	 */
	public class ToolTipLayMediator implements IToolTipLayMediator
	{
		private static var _instance:ToolTipLayMediator;
		
		private var _view:ToolTipLayer;
		
		public function ToolTipLayMediator(cls:PrivateClass)
		{
			
		}
		
		public static function getInstance():ToolTipLayMediator
		{
			return _instance||= new ToolTipLayMediator(new PrivateClass());
		}
		
		public function initView(view:ToolTipLayer):void
		{
			_view = view;
		}
		
		/**
		 * 设置对应tip面板的可视性 
		 * @param tipType
		 */		
		public function setVisible(tip:BaseTip, isVisible:Boolean):void
		{
			_view.setVisible(tip,isVisible);
		}
		
		/**
		 * 移除当前tip面板
		 */		
		public function removeAllTip():void
		{
			_view.removeAllTip();
		}
		
		/**
		 * 释放某个tip面板内存 
		 * @param tipType
		 */		
		public function remove(tipType:int):void
		{
			_view.removeTip(tipType);
		}
		
		/**
		 * 获取对应tip类型的tip 
		 * @param tipType
		 * @return 
		 */		
		public function getToolTip(tipType:int):BaseTip
		{
			return _view.getToolTip(tipType) as BaseTip;
		}
	}
}

class PrivateClass
{
	
}