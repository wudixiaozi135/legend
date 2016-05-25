package com.view.gameWindow.util
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.view.gameWindow.common.ResManager;
	
	import flash.display.BitmapData;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.ui.MouseCursorData;

	/**
	 * 改变鼠标样式工具
	 * @author Administrator
	 */	
	public class UtilMouse
	{
		public function UtilMouse()
		{
			
		}
		
		private static var bmData:Vector.<BitmapData>=new Vector.<BitmapData>();
		private static const MOUSE_REPAIR_URL:String=ResourcePathConstants.IMAGE_MAINUI_FOLDER_LOAD+"common/repairMouseIcon.png";
		public static const REPAIR:String="repair";
		public static const TALK:String = "talk";
		public static const PLANT:String = "plant";
		public static const WAKUANG:String = "wakuang";
		private static var mouseStyle:String;
		private static var registerCursors:Array=[];
		private static var loadingUrl:Array=[];
		
		public static function setMouseRpair(bool:Boolean):void
		{
			if(bool)
			{
				ResManager.getInstance().loadBitmap(MOUSE_REPAIR_URL,loadMatterFunc);
			}else
			{
				Mouse.unregisterCursor(REPAIR);
			}
		}
		
		public static function setMouseStyle(styleName:String):void
		{
			if(Mouse.cursor==mouseStyle)return;
			mouseStyle=styleName;
			
			try{
				Mouse.cursor=mouseStyle;
			}catch(e:Error){}
//			if(registerCursors.indexOf(styleName)!=-1)
//			{
//				Mouse.cursor=mouseStyle;
//				return;
//			}
			
			var url:String = getStyleUrl(styleName);
			if(loadingUrl.indexOf(url)!=-1)return;
			loadingUrl.push(url);
			ResManager.getInstance().loadBitmap(url,loadMouseStyleFunc);
		}
		
		private static function getStyleUrl(styleName:String):String
		{
			var url:String;
			switch(styleName)
			{
				case REPAIR:
					url=ResourcePathConstants.IMAGE_MOUSEEFFECT_LOAD+"common/repairMouseIcon.png";
					break;
				case TALK:
					url=ResourcePathConstants.IMAGE_MOUSEEFFECT_LOAD+"talk.png";
					break;
				case PLANT:
					url=ResourcePathConstants.IMAGE_MOUSEEFFECT_LOAD+"plant.png";
					break;
				case WAKUANG:
					url=ResourcePathConstants.IMAGE_MOUSEEFFECT_LOAD+"wakuang.png";
					break;
			}
			return url;
		}
		
		private static function getStyleName(url:String):String
		{
			var name:String;
			switch(url)
			{
				case ResourcePathConstants.IMAGE_MOUSEEFFECT_LOAD+"common/repairMouseIcon.png":
					name=REPAIR;
					break;
				case ResourcePathConstants.IMAGE_MOUSEEFFECT_LOAD+"talk.png":
					name=TALK;
					break;
				case ResourcePathConstants.IMAGE_MOUSEEFFECT_LOAD+"plant.png":
					name=PLANT;
					break;
				case ResourcePathConstants.IMAGE_MOUSEEFFECT_LOAD+"wakuang.png":
					name=WAKUANG;
					break;
			}
			return name;
		}
		
		private static function loadMouseStyleFunc(bm:BitmapData,url:String):void
		{
			var bmData1:Vector.<BitmapData>=new Vector.<BitmapData>();
			bmData1.push(bm);
			var cursData:MouseCursorData=new MouseCursorData();
			cursData.data=bmData1;
			cursData.frameRate=bmData.length;
			var name:String = getStyleName(url)
			Mouse.registerCursor(name,cursData);
			trace(name+"reg");
//			registerCursors.push(name);
//			if(loadingUrl.indexOf(url)!=-1)
//			{
//				loadingUrl.splice(loadingUrl.indexOf(url),1);
//			}
			
//			if(registerCursors.indexOf(mouseStyle)!=-1)
//			{
			try{
				Mouse.cursor=mouseStyle;
			}catch(e:Error){}
//			}
		}		
		
		public static function cancelMouseStyle():void
		{
			if(Mouse.cursor==MouseCursor.AUTO)return;
			Mouse.cursor=MouseCursor.AUTO;
//			Mouse.unregisterCursor(mouseStyle);
			mouseStyle="";
		}
		
		private static function loadMatterFunc(bm:BitmapData,url:String):void
		{
			while(bmData.length>0)
			{
				var dtBm:BitmapData= bmData.shift();
				dtBm.dispose();
				dtBm=null;
			}
			bmData.push(bm);
			var cursData:MouseCursorData=new MouseCursorData();
			cursData.data=bmData;
			cursData.frameRate=1;
			Mouse.registerCursor(REPAIR,cursData);
			Mouse.cursor=REPAIR;
		}
	}
}