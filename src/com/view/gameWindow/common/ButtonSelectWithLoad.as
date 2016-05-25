package com.view.gameWindow.common
{
	import com.model.gameWindow.rsr.RsrLoader;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * preventSelectHandler
	 * @author wqhk
	 * 2014-10-13
	 */
	public class ButtonSelectWithLoad extends ButtonSelect
	{
		/**
		 * preventSelectHandler(index):Boolean
		 */
		public var preventSelectHandler:Function;
		
		/**
		 * setLabelHandler(index,btn):Boolean
		 */
		public var setLabelHandler:Function;
		
		private var _ctner:DisplayObjectContainer;
		private var _btnNames:Array;
		private var _callback:CountCallback;
		
		public var cancelable:Boolean = false;
		
		public function ButtonSelectWithLoad(loader:RsrLoader,ctner:DisplayObjectContainer,btnNames:Array)
		{
			super();
			
			_ctner = ctner;
			_btnNames = btnNames.concat();
			_callback = new CountCallback(initBtns,_btnNames.length);
			for each(var name:String in _btnNames)
			{
				loader.addCallBack(ctner[name],function():void{_callback.call()});
			}
			
			initBtns();
			
			ctner.addEventListener(MouseEvent.CLICK,clickHandler,false,0,true);
		}
		
		public function destroy():void
		{
			preventSelectHandler = null;
			setLabelHandler = null;
			_callback.destroy();
			_callback = null;
			_btnNames = null;
			_ctner.removeEventListener(MouseEvent.CLICK,clickHandler);
			_ctner = null;
			clear();
		}
		
		private function clickHandler(e:MouseEvent):void
		{
			var target:Object  = e.target;
			var index:int = btns.indexOf(target);
			
			if(index>=0)//因为 clickHandler 是加在parent上的 
			{ 
				if(target.selected)
				{
					if(preventSelectHandler !=null && preventSelectHandler(index))
					{
						target.selected = false;
						return; 
					}
					
					selectedIndex = index;
				}
				else
				{
					if(cancelable)
					{
						selectedIndex = -1;
					}
					else
					{
						target.selected = true;
					}
				}
			}
			
//			if(index>=0)
//			{ 
//				if(preventSelectHandler ==null || !preventSelectHandler(index))
//				{
//					selectedIndex = index;
//				}
//				else
//				{
//					//因为flash控件已经把按钮状态转换
//					target.selected = false;
//				}
//			}
		}
		
		private function initBtns():void
		{
			var btns:Array = [];
			var index:int = 0;
			for each(var name:String in _btnNames)
			{
				if(!_ctner.hasOwnProperty(name))
				{
					trace("error:"+_ctner+"没有属性"+name);
					continue;
				}
				var btn:* = _ctner[name];
				btn.mouseChildren = false;
				btns.push(btn);
				
				if(setLabelHandler != null)
				{
					setLabelHandler(index,btn);
				}
				
				++index;
			}
			
			init(btns);
		}
		
		
	}
}