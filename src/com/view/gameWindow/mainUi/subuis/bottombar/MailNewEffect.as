package com.view.gameWindow.mainUi.subuis.bottombar
{
	import com.greensock.TweenMax;
	import com.model.business.fileService.UrlBitmapDataLoader;
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.business.fileService.interf.IUrlBitmapDataLoaderReceiver;
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.consts.FontFamily;
	import com.pattern.Observer.IObserver;
	import com.view.gameWindow.common.HighlightEffectManager;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.mail.data.PanelMailDataManager;
	import com.view.newMir.NewMirMediator;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import flashx.textLayout.formats.TextAlign;
	
	public class MailNewEffect extends Sprite implements IUrlBitmapDataLoaderReceiver,IObserver 
	{
		private var bmp:Bitmap;
		private var bmp2:Bitmap;
		private var _bmpLoader:UrlBitmapDataLoader;
		private var _bmpLoader2:UrlBitmapDataLoader;
		private var _url1:String;
		private var _url2:String;
		private var timer:Timer;
		private var beginTime:int;
		private var has_init:Boolean;
		private var hl:HighlightEffectManager;
		private var txt:TextField;
		private var sp:Sprite;
		private var load1ok:Boolean = false;
		private var load2ok:Boolean = false;
		public function MailNewEffect()
		{
			super();
			timer = new Timer(1000);
			visible = false;
			PanelMailDataManager.instance.attach(this);
			hl = new HighlightEffectManager();
			
		}
		
		public function initView():void
		{
			if(!has_init){
				_bmpLoader = new UrlBitmapDataLoader(this);
				_url1= ResourcePathConstants.IMAGE_MAINUI_FOLDER_LOAD + "mainUiBottom/newMail" + ResourcePathConstants.POSTFIX_PNG;
				_url2 = ResourcePathConstants.IMAGE_MAINUI_FOLDER_LOAD + "mainUiBottom/redBg" + ResourcePathConstants.POSTFIX_PNG;
				_bmpLoader.loadBitmap(_url1);
				_bmpLoader2 = new UrlBitmapDataLoader(this);
				_bmpLoader2.loadBitmap(_url2);
				txt = new TextField();
				txt.defaultTextFormat = new TextFormat(FontFamily.FONT_NAME,12,0xffffff,false,null,null,null,null,TextAlign.CENTER,null,null,null);
				txt.width = 30;
				txt.height = 18;
				txt.mouseEnabled = false;
				sp = new Sprite();
				addChild(sp);
			}
		}
		
		public function update(proc:int=0):void
		{
			if(proc == GameServiceConstants.SM_MAIL_LIST)
			{
				show();
			}
		}
		
		
		public function show():void
		{
			// TODO Auto Generated method stub
			if(!load1ok||!load2ok)return;
			if(visible)
			{
				if(!PanelMailDataManager.instance.newMail)
					closeHandler();
				return;
			}
			if(!PanelMailDataManager.instance.newMail)return;
			if(timer.running)return;
			beginTime = getTimer();
			resetPosition();
			visible = true;
			timer.start();
			this.addEventListener(MouseEvent.CLICK,onClick);
			timer.addEventListener(TimerEvent.TIMER,onTimer);
			sp.addChild(bmp2);
			sp.addChild(txt);
			bmp2.visible = true;
			txt.visible = true;
			var num:int = PanelMailDataManager.instance.getUnreadMailNumber();
			txt.text = num.toString();
			if(num==0)
			{
				bmp2.visible = false;
				txt.visible = false;
			}
			hl.show(this,sp);
			handlerEffect();
		}
		
		private function resetPosition():void
		{
			// TODO Auto Generated method stub
			var newMirMediator:NewMirMediator = NewMirMediator.getInstance();
			x =  int(newMirMediator.width - this.width) - 50;
			y = int(newMirMediator.height - this.height) - 240 - 40;
			
		}
		
		public function refreshPosition():void
		{
			if(!visible)return;
			var newMirMediator:NewMirMediator = NewMirMediator.getInstance();
			var newX:int = int(newMirMediator.width)/2 + 100;
			var newY:int = int(newMirMediator.height - this.height) - 240 - 40;
			x  =  newX;
			y = newY;
		}
		
		public function urlBitmapDataReceive(url:String, bitmapData:BitmapData, info:Object):void
		{
			if(url!=_url1&&url!=_url2)return;
			if(url == _url1){
				bmp = new Bitmap(bitmapData);
				sp.addChild(bmp);
				load1ok = true;
			}else if(url == _url2){
				bmp2 = new Bitmap(bitmapData);
				bmp2.x = 35;
				bmp2.y = 2;
				txt.x = 30.5;
				txt.y = 2.5;
				load2ok = true;
			}
			this.buttonMode = true;
			resetPosition();
			has_init = true;
			if(load1ok&&load2ok)
			{
				show();
			}
		}
		
		
		public function urlBitmapDataError(url:String, info:Object):void
		{
			// TODO Auto Generated method stub
		}
		
		public function urlBitmapDataProgress(url:String, progress:Number, info:Object):void
		{
			// TODO Auto Generated method stub
			
		}
		
		protected function onTimer(event:TimerEvent):void
		{
			// TODO Auto-generated method stub
			if(getTimer() - beginTime>=20*1000)
			{
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER,onTimer);
				closeHandler();
			}
		}
		
		private function handlerEffect():void
		{
			var newMirMediator:NewMirMediator = NewMirMediator.getInstance();
			var orgX:int = int(newMirMediator.width - this.width) - 50;
			var newX:int = int(newMirMediator.width)/2 + 100;
			var newY:int = int(newMirMediator.height - this.height) - 240- 40;
			
			TweenMax.fromTo(this, 2, {alpha: 0,x: orgX,y:newY}, {
				x: newX, y: newY, alpha: 1, onComplete: function ():void
				{
					TweenMax.killTweensOf(this);
				}
			});
		}
		
		private function closeHandler():void
		{
			visible = false;
			hl.hide(sp);
			resetPosition();
		}
		public function destroy():void
		{
			
			if(bmp&&bmp.parent)
			{
				bmp.parent.removeChild(bmp);
				bmp = null;
			}
			if(bmp2&&bmp2.parent)
			{
				bmp2.parent.removeChild(bmp2);
				bmp2 = null;
			}
			if(txt&&txt.parent)
			{
				txt.parent.removeChild(txt);
				txt = null;
			}
			if(sp&&sp.parent)
			{
				sp.parent.removeChild(sp);
				sp = null;
			}
			if(hl)
			{
				hl.hide(sp);
			}
		}
		
		private function onClick(e:MouseEvent):void
		{
			// TODO Auto Generated method stub
			if(timer&&timer.running)
			{
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER,onTimer);
			}
			closeHandler();
			PanelMailDataManager.instance.newMail = false;
			PanelMailDataManager.instance.readMail(PanelMailDataManager.instance.getNewMailIndex());
			PanelMediator.instance.openPanel(PanelConst.TYPE_MAIL_CONTENT);
		}
	}
}