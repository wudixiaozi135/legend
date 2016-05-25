package com.view.gameWindow.mainUi.subuis.bottombar.sysAlert
{
    import com.greensock.TweenLite;
    import com.model.business.fileService.constants.ResourcePathConstants;
    import com.model.consts.ToolTipConst;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.mainUi.subuis.bottombar.iconAlert.McIcon;
    import com.view.gameWindow.tips.toolTip.TipVO;
    import com.view.gameWindow.tips.toolTip.ToolTipManager;
    import com.view.gameWindow.util.HtmlUtils;
    
    import flash.display.Sprite;
    import flash.geom.Point;

    public class AlertCellBase extends Sprite implements ISysAlertCell
	{
		private var _id:int; 
		private var _context:String;
		private var _type:int; 
		protected var skin:McIcon;
		private var skin_ok:Boolean = false;
		private var _pos:Point;
//		private var urlSwfLoader:UrlSwfLoader;
//		private var urlSwfLoader2:UrlSwfLoader;
//		private var url2:String;
		public function AlertCellBase()
		{
			initSkin();
		}
		
		private function initSkin():void
		{
			skin = new McIcon();
			skin.mouseEnabled = false;
			addChild(skin);
			skin.btn.alpha = 0;
			this.mouseEnabled = false;
			skin.btn.buttonMode = true;
		}
		
		/**
		 * 显示
		 * 注意路径在panel
		 * */
		public function initView():void
		{
			var rsrLoader:RsrLoader = new RsrLoader();
			addCallBack(rsrLoader);
			rsrLoader.load(skin, ResourcePathConstants.IMAGE_MAINUI_FOLDER_LOAD);
		}
		
		private function addCallBack(rsrLoader:RsrLoader):void
		{
			// TODO Auto Generated method stub
			var _sk:McIcon = skin as McIcon;
			rsrLoader.addCallBack(skin.effectIcon,function():void
			{
				_sk.effectIcon.mouseEnabled = false;
//				if(!skin_ok)
//				_sk.removeChild(_sk.effectIcon);
					_sk.effectIcon.visible = false;
					
			});
			rsrLoader.addCallBack(skin.icon,function():void
			{
				skin_ok = true;
				_sk.icon.mouseEnabled = false;
//				_sk.effectIcon.visible = true;
				doFly();	
			});
		}
		
		public function doFly():void
		{
			TweenLite.to(this,2,{x:_pos.x,y:_pos.y,alpha:1,onComplete:complete});
		}
		
		private function complete():void
		{
			if(this.parent)
				(this.parent as SysAlert).refreshPosition();
		}
		
		public function show():void
		{
//			urlSwfLoader=new UrlSwfLoader(this);
//			urlSwfLoader2=new UrlSwfLoader(this);
//			var url:String =getIconUrl();
//			url2 = ResourcePathConstants.IMAGE_MAINUI_FOLDER_LOAD + "mainUiBottom/tipEffect.swf";
//			urlSwfLoader.loadSwf(url);
//			urlSwfLoader2.loadSwf(url2);
			this.alpha = 0.5;
			_pos = new Point(x,y);
			this.x = 280;
			this.y = -250;
			skin.icon.resUrl = getIconUrl();
			initView();
			initTip();
		}
		
		protected function initTip():void
		{
			var tipVO:TipVO = new TipVO();
			tipVO.tipType = ToolTipConst.TEXT_TIP;
			var str:String=getTipStr();
            str = HtmlUtils.createHtmlStr(0xd4a460, str);
			tipVO.tipData =str;
			ToolTipManager.getInstance().hashTipInfo(skin.btn,tipVO);
			ToolTipManager.getInstance().attach(skin.btn);
		}
		
		protected function getTipStr():String
		{
			// TODO Auto Generated method stub
			throw new Error("this function override");
			return null;
		}
		
		protected function getIconUrl():String
		{
			// TODO Auto Generated method stub
			throw new Error("this function override");
			return null;
		}
		
		public function swfReceive(url:String, swf:Sprite, info:Object):void
		{
//			addChild(swf);
//			if(url == url2)
//			{
//				swf.x = -31;
//				swf.y = -31;
//			}
		}
		
		public function destroy():void
		{
//			if(urlSwfLoader)
//			{
//				urlSwfLoader.destroy();
//			}
			ToolTipManager.getInstance().detach(this);
			if(skin&&skin.parent)
				skin.parent.removeChild(skin);
			skin = null;
//			urlSwfLoader=null;
		}
		
		public function swfProgress(url:String, progress:Number, info:Object):void
		{
		}
		
		public function swfError(url:String, info:Object):void
		{
		}

		public function get id():int
		{
			return _id;
		}

		public function set id(value:int):void
		{
			_id = value;
		}

		public function get context():String
		{
			return _context;
		}

		public function set context(value:String):void
		{
			_context = value;
		}

		public function get type():int
		{
			return _type;
		}

		public function set type(value:int):void
		{
			_type = value;
		}
		
	}
}