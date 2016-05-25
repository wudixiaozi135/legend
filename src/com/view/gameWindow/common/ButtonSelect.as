package com.view.gameWindow.common
{
	import flash.display.MovieClip;
	
	/**
	 * 按钮都在flash中，这里只是管理下
	 * @author wqhk
	 * 2014-8-28
	 */
	public class ButtonSelect
	{
		protected var btns:Array;
		protected var _selectedIndex:int;
		/**
		 * resetHandler(mc)
		 */
		public var resetHandler:Function;
		/**
		 * selectHandler(mc)
		 */
		public var selectHandler:Function;
		
		/**
		 * changeHandler(selectedIndex)
		 */
		public var changeHandler:Function;
		
		public function ButtonSelect()
		{
			clear();
		}
		
		public function getBtnIndex(btn:*):int
		{
			return btns.indexOf(btn);
		}
		
		public function clear():void
		{
			resetHandler = null;
			selectHandler = null;
			changeHandler = null;
			btns = [];
			_selectedIndex = -1;
		}
		
		
		public function init(list:Array):void
		{
			btns = list.concat();
			
			updateButtonState();
		}
		
		private function updateButtonState():void
		{
			for each(var btn:MovieClip in btns)
			{
				btn.selected = false;
				if(resetHandler != null)
				{
					resetHandler(btn);
				}
			}
			
			if(_selectedIndex>=0 && _selectedIndex<btns.length)
			{
				btns[_selectedIndex].selected = true;
				if(selectHandler != null)
				{
					selectHandler(btns[_selectedIndex]);
				}
			}
		}
		
		
		public function push(btn:MovieClip):void
		{
			btns.push(btn);
		}
		
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}
		
		public function set selectedIndex(index:int):void
		{
			if(_selectedIndex != index)//加了这判断有可能会对其他有影响
			{
				_selectedIndex = index;
				updateButtonState();
				
				if(changeHandler != null)
				{
					changeHandler(_selectedIndex);
				}
			}
		}
		
		public function setSelected(button:MovieClip):void
		{
			if(btns)
			{
				_selectedIndex = btns.indexOf(button);
			}
			else
			{
				_selectedIndex = -1;
			}
			updateButtonState();
		}
	}
}