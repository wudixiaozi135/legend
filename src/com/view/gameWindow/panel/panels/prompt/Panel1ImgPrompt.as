package com.view.gameWindow.panel.panels.prompt
{
	import com.model.business.fileService.UrlBitmapDataLoader;
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.business.fileService.interf.IUrlBitmapDataLoaderReceiver;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.MapCfgData;
	import com.model.configData.cfgdata.NpcCfgData;
	import com.model.consts.StringConst;
	import com.view.gameWindow.common.Alert;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.scene.GameFlyManager;
	import com.view.gameWindow.util.HtmlUtils;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class Panel1ImgPrompt extends PanelBase implements IUrlBitmapDataLoaderReceiver
	{
		public function Panel1ImgPrompt()
		{
			super();
		}
		
		public static var strContent:String;
		public static var strSureBtn:String;
		public static var strCancelBtn:String;
		public static var flyNpcId:int;
		public static var flyNpcMapId:int;
		public static var sureFunc:Function;
		private var _icon:Sprite;
		private var _bitmap:Bitmap;
		
		override protected function initSkin():void
		{
			_skin = new McPanel1ImgPrompt();
			addChild(_skin);
		}
		
		override protected function initData():void
		{
			var mcPanel1ImgPrompt:McPanel1ImgPrompt = _skin as McPanel1ImgPrompt;
			mcPanel1ImgPrompt.txt.mouseEnabled = false;
			mcPanel1ImgPrompt.sureTxt.mouseEnabled = false;
			mcPanel1ImgPrompt.cancelTxt.mouseEnabled = false;
			mcPanel1ImgPrompt.txt.htmlText = strContent;
			mcPanel1ImgPrompt.sureTxt.text = strSureBtn;
			mcPanel1ImgPrompt.cancelTxt.text = strCancelBtn;
			
			flyNpcId=10402;
			flyNpcMapId=104;
			var npcCfg:NpcCfgData=ConfigDataManager.instance.npcCfgData(flyNpcId,flyNpcMapId);
			var mapCfg:MapCfgData=ConfigDataManager.instance.mapCfgData(flyNpcMapId);
			mcPanel1ImgPrompt.txtNpcName.htmlText=HtmlUtils.createHtmlStr(0xd4a460,mapCfg.name+":"+npcCfg.name);
			
			_icon = new Sprite();
			_bitmap = new Bitmap();
			_icon.addChild(_bitmap);
			_icon.buttonMode = true;
			var bdLoader:UrlBitmapDataLoader = new UrlBitmapDataLoader(this);
			bdLoader.loadBitmap(ResourcePathConstants.IMAGE_ICON_SKILL_FOLDER_LOAD+"9011"+ResourcePathConstants.POSTFIX_PNG);
			addChild(_icon);
			
			_icon.x = 173;
			_icon.y = 63;
			
			addEventListener(MouseEvent.CLICK,onClick);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			var mcPanel1ImgPrompt:McPanel1ImgPrompt = _skin as McPanel1ImgPrompt;
			switch(event.target)
			{
				case mcPanel1ImgPrompt.btnSure:
					sureFunc();
					PanelMediator.instance.closePanel(PanelConst.TYPE_1IMG_PROMPT);
					break;
				case mcPanel1ImgPrompt.btnCancel:
					PanelMediator.instance.closePanel(PanelConst.TYPE_1IMG_PROMPT);
					break;
				case mcPanel1ImgPrompt.txtNpcName:
				case _icon:
					fly();
					PanelMediator.instance.closePanel(PanelConst.TYPE_1IMG_PROMPT);
					break;
			}
		}
		
		private function fly():void
		{
			if(RoleDataManager.instance.isCanFly <=0)
			{
				Alert.warning(StringConst.PROMPT_PANEL_0008);
				return;
			}
			GameFlyManager.getInstance().flyToMapByNPC(flyNpcId);
		}
		
		public function urlBitmapDataError(url:String, info:Object):void
		{
		}
		
		public function urlBitmapDataProgress(url:String, progress:Number, info:Object):void
		{
		}
		
		public function urlBitmapDataReceive(url:String, bitmapData:BitmapData, info:Object):void
		{
			_bitmap.bitmapData=bitmapData;
			_bitmap.scaleX=26/_bitmap.width;
			_bitmap.scaleY=26/_bitmap.height;
			_bitmap.smoothing=true;
		}
		
		override public function destroy():void
		{
			removeEventListener(MouseEvent.CLICK,onClick);
			super.destroy();
		}
	}
}