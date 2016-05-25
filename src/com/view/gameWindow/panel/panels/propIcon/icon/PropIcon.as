package com.view.gameWindow.panel.panels.propIcon.icon
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.view.gameWindow.common.ResManager;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.tips.toolTip.interfaces.IToolTipClient;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.UtilText;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class PropIcon extends Sprite implements IToolTipClient
	{
		protected var _data:Object;
		private var icon:Bitmap;
		private var _level:int;
		private var levelText:TextField;
		
		public function PropIcon()
		{
			super();
			_data=new Object();
			initIcon();
		}
		
		private function initIcon():void
		{
			icon = new Bitmap();
			addChild(icon);
			var url:String=getIconUrl();
			if(url!="")
			{
				ResManager.getInstance().loadBitmap(ResourcePathConstants.IMAGE_ICON_BUFF_FOLDER_LOAD+url,loadIconComple);
			}
			
			levelText = UtilText.getLabel();
			levelText.x=12;
			levelText.y=8;
			addChild(levelText);
			ToolTipManager.getInstance().attach(this);
		}
		
		private function loadIconComple(bitmap:BitmapData,url:String):void
		{
			if(icon!=null)
			{
				icon.bitmapData=bitmap;
			}else
			{
				bitmap.dispose();
			}
		}
		
		public function destroy():void
		{
			ToolTipManager.getInstance().detach(this);
			if(levelText)
			{
				levelText.parent&&levelText.parent.removeChild(levelText);
			}
			levelText=null;
			if(icon)
			{
				icon.bitmapData&&icon.bitmapData.dispose();
				icon.parent&&icon.parent.removeChild(icon);
			}
			icon=null;
		}
		
		protected function getIconUrl():String
		{
			return "";
		}		
		
		public function getTipData():Object
		{
			return null;
		}
		
		public function getTipType():int
		{
			return 0;
		}
		
		public function checkUnLock():Boolean
		{
			return true;
		}

		public function get level():int
		{
			return _level;
		}
		
		

		public function set level(value:int):void
		{
			_level = value;
			levelText.htmlText=HtmlUtils.createHtmlStr(0xebe85f,_level+"",12,true);
		}

		public function getTipCount():int
		{
			// TODO Auto Generated method stub
			return 1;
		}
		
	}
}