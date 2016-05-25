package com.view.gameWindow.util
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	/**
	 * 游戏通用容器类
	 * @author jhj
	 */ 	
	public class Container extends Sprite
	{
		private var _containerWidth:Number;
		
		private var _containerHeight:Number;
		
		public function Container()
		{
			super();
		}
		
		public function get containerHeight():Number
		{
			return _containerHeight;
		}

		public function set containerHeight(value:Number):void
		{
			_containerHeight = value;
		}

		public function get containerWidth():Number
		{
			return _containerWidth;
		}

		public function set containerWidth(value:Number):void
		{
			_containerWidth = value;
		}

		/**
		 * 显示对象 
		 * @param obj
		 */		
		public function show(obj:DisplayObject):void
		{
			if(!obj)
			{
				return;
			}
			
			if(contains(obj)&&getChildIndex(obj)!=numChildren-1)
			{
				setChildIndex(obj,numChildren-1);
			}else
			{
				addChild(obj);
			}
			
			obj.visible=true;
		}
		
		/**
		 * 隐藏对象 
		 * @param obj
		 */		
		public function hide(obj:DisplayObject):void
		{
			if(!obj)
			{
				return
			}
			
			if(contains(obj))
			{
				removeChild(obj);
			}
				
			obj.visible=false;
		}
		
		/**
		 * 设置显示/隐藏 
		 * @param isVisible
		 */		
		public function setVisible(obj:DisplayObject,isVisible:Boolean):void
		{
			if(isVisible)
			{
				show(obj);
			}
			else
			{
				hide(obj);
			}
		}
		
		/**
		 * 是否显示 
		 * @param obj
		 */		
		public function isVisible(obj:DisplayObject):Boolean
		{
			return contains(obj)&&obj.visible
		}
		
		/**
		 * 显示/隐藏 
		 * @param obj
		 */		
		public function changeVisible(obj:DisplayObject):void
		{
			if(isVisible(obj))
			{
				hide(obj);
			}
			else
			{
				show(obj);
			}
		}
		
		/**
		 * 从显示列表移除 
		 */		
		public function removeFromDisplayList():void
		{
			if(parent)
			{
				parent.removeChild(this);
			}
		}
		
		/**
		 * 删除所有子对象 
		 */		
		public function removeAllChild():void
		{
			while(numChildren>0)
			{
				removeChildAt(0);
			}
		}
	}
}