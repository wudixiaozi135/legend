package com.view.gameWindow.mainUi.subuis.chatframe
{
	import com.core.bind_t;
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.consts.StringConst;
	
	/**
	 * @author wqhk
	 * 2014-8-8
	 */
	public class MessageCfg
	{
		public static const LINE_LENGTH:int = 310;
		public static const LINE_SPACE:int = 2;
		
		public static const PRIVATE_ONELINE_MAXCHAR:int = 100;
		public static const ITEM_LOUD:int = 95;//喇叭
		
		// "/0"
		public static const CHANNEL_SYSTEM:int = 0; //也包含综合频道
		public static const CHANNEL_WOLD:int = 1;
		public static const CHANNEL_AREA:int = 2;
		public static const CHANNEL_FAMILY:int = 3;
		public static const CHANNEL_TEAM:int = 4;
		public static const CHANNEL_WOLD_SUPER:int = 5; //喇叭
		public static const CHANNEL_PRIVATE:int = 100;//私聊
		
		public static var FONT_NAME:String = "SimSun";
		public static var FONT_SIZE:int = 12;
		
		public static var COLOR_SYSTEM:uint = 0xffffff;
		public static var COLOR_SYSTEM_BACK:uint = 0xc72541;
		public static var COLOR_SPEAKER:uint = 0xffcc00;
		
		public static var URL_SYSTEM:String = "";
		public static var URL_WORLD:String = "";
		public static var URL_AREA:String = "";
		public static var URL_LOUD:String = "";
		public static var URL_PRIVATE:String = "";
		public static var IMG_STORE:Object;//key: url value: bitmapdata
		
		public static const MAX_MSG:int = 100;
		
		public function MessageCfg()
		{
		}
		
		public static function getChannelName(type:int):String
		{
			var re:String = "";
			switch(type)
			{
				case CHANNEL_SYSTEM:
					re = StringConst.CHAT_0001;
					break;
				case CHANNEL_WOLD:
					re = StringConst.CHAT_0005;
					break;
				case CHANNEL_AREA:
					re = StringConst.CHAT_0002;
					break;
				case CHANNEL_FAMILY:
					re = StringConst.CHAT_0004;
					break;
				case CHANNEL_TEAM:
					re = StringConst.CHAT_0003;
					break;
				case CHANNEL_PRIVATE:
					re = StringConst.CHAT_0006;
					break;
				case CHANNEL_WOLD_SUPER:
					re = StringConst.CHAT_0009;
					break;
			}
			
			return re;
		}
		
		//加载频道 “系统” 之类的图片
		public static function initImg(callback:Function):void
		{
			var loader:LoaderPatch = new LoaderPatch();
			
			var string:String = ResourcePathConstants.IMAGE_MAINUI_FOLDER_LOAD+"charFrame/channelFlag.jpg"
			URL_SYSTEM = URL_WORLD = URL_AREA = URL_LOUD = URL_PRIVATE = string;
//			URL_WORLD = ResourcePathConstants.IMAGE_MAINUI_FOLDER_LOAD+"charFrame/world.png";
//			URL_AREA = ResourcePathConstants.IMAGE_MAINUI_FOLDER_LOAD+"charFrame/current.png";
//			URL_LOUD = ResourcePathConstants.IMAGE_MAINUI_FOLDER_LOAD+"charFrame/horn.png";
//			URL_PRIVATE = ResourcePathConstants.IMAGE_MAINUI_FOLDER_LOAD+"charFrame/private.png";
//			var string:String = ResourcePathConstants.IMAGE_MAINUI_FOLDER_LOAD+"charFrame/channelFlag.jpg"
			
//			loader.load([URL_SYSTEM,URL_WORLD,URL_AREA,URL_PRIVATE,URL_LOUD],new bind_t(completeInitImg,callback,loader));
			loader.load([string],new bind_t(completeInitImg,callback,loader));	
		}
		
		private static function completeInitImg(callback:Function,loader:LoaderPatch,result:Object):void
		{
			MessageCfg.IMG_STORE = result;
			loader.destroy();
			callback();
		}
	}
}