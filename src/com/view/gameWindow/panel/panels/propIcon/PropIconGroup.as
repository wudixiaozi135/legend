package com.view.gameWindow.panel.panels.propIcon
{
	import com.view.gameWindow.panel.panels.propIcon.icon.PropIcon;
	import com.view.gameWindow.util.ObjectUtils;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class PropIconGroup extends Sprite
	{
		private var props:Vector.<PropIcon>;
		public function PropIconGroup()
		{
			super();
			init();
		}
		
		private function init():void
		{
			props = new Vector.<PropIcon>();
			this.addEventListener(MouseEvent.MOUSE_OVER,onMouseOverFunc);
			this.addEventListener(MouseEvent.MOUSE_OUT,onMouseOutFunc);
		}		
		
		protected function onMouseOverFunc(event:MouseEvent):void
		{
			var propIcon:PropIcon = event.target as PropIcon;
			if(propIcon!=null)
			{
				propIcon.filters=[ObjectUtils.btnlightFilter];
			}
		}
		
		protected function onMouseOutFunc(event:MouseEvent):void
		{
			var propIcon:PropIcon = event.target as PropIcon;
			if(propIcon!=null)
			{
				propIcon.filters=null;
			}	
		}
		
		public function addIcon(propIcon:PropIcon):void
		{
			if(propIcon==null)return;
			if(propIcon.checkUnLock()==false)
			{
				propIcon.destroy();
				propIcon=null;
				return;
			}
			addChild(propIcon);
			propIcon.x=props.length*24;
			props.push(propIcon);
			
		}
		
		public function removeAllIcon():void
		{
			while(props.length>0)
			{
				var tmp:PropIcon = props.shift();
				tmp.destroy();
				tmp=null;
			}
		}		
		
		public function destroy():void
		{
			removeAllIcon();
			props=null;
			this.removeEventListener(MouseEvent.MOUSE_OVER,onMouseOverFunc);
			this.removeEventListener(MouseEvent.MOUSE_OUT,onMouseOutFunc);
		}
		
	}
}