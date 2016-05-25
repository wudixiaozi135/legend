package com.view.gameWindow.scene.announcement
{
	import com.model.business.fileService.UrlSwfLoader;
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.business.fileService.interf.IUrlSwfLoaderReceiver;
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.pattern.Observer.IObserver;
	import com.view.gameWindow.mainUi.subuis.announcement.AnnouncementDataManager;
	import com.view.gameWindow.mainUi.subuis.chatframe.ChatDataManager;
	import com.view.gameWindow.util.HashMap;
	import com.view.gameWindow.util.MarqueeText;
	import com.view.gameWindow.util.propertyParse.CfgDataParse;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.setInterval;

	public class Announcement  implements IObserver,IUrlSwfLoaderReceiver
	{
		private static var _instance:Announcement;
		private var _layer:Sprite;
		private var mtext:MarqueeText;
		private var _width:int;
		private var _height:int;
		private const _width2:int = 600;
		private const _height2:int = 30;
		private var _marqueeVos:Array;
		private var _sysVos:Array;
		private var sysinterid:uint;
		private var _rsrLoader:UrlSwfLoader;
		private var bg:MovieClip;
		
		public static function get Instance() : Announcement
		{
			return _instance  ||= new Announcement;
		}
		
		public function init(layer:Sprite):void
		{
			_layer = layer;
			_layer.graphics.beginFill(0xff0000,0);
			_layer.graphics.drawRect(0,0,_width2,_height2);
			_layer.graphics.endFill();
			_rsrLoader = new UrlSwfLoader(this);
			_rsrLoader.loadSwf(ResourcePathConstants.IMAGE_ANNOUCEMENT_LOAD+'annoucement.swf');
			mtext = new MarqueeText(_width2,_height2);
			_layer.addChild(mtext);
			
			AnnouncementDataManager.instance.attach(this);
			_layer.addEventListener(Event.REMOVED_FROM_STAGE,onRemove);
			 
			
		}
		protected function checkMarquee():void
		{
			var announcementList:HashMap = AnnouncementDataManager.instance.announcementList;
			_marqueeVos = announcementList.filter(checkMarqueeVo);
			
			if(_marqueeVos.length)
			{
				_marqueeVos.sortOn('begin_time',Array.NUMERIC);
				showAnnouncement(_marqueeVos[0]);
				if(bg)
					bg.visible = true;
			}
			else
			{
				if(bg)
					bg.visible = false;
			}
			
		  //  showAnnouncement(null);  test
		}
		
		private function checkSys():void
		{
			var announcementList:HashMap = AnnouncementDataManager.instance.announcementList;
			_sysVos = announcementList.filter(checkSysVo);
			if(_sysVos.length)
			{
				_sysVos.sortOn('begin_time',Array.NUMERIC);
				showSysAnnouncement(_sysVos[0]);
			}
		}
		private function checkMarqueeVo(id:int,vo:AnnouncementVO):Boolean
		{
			return vo.isShowed == false && vo.type == 1;	
		}
		private function checkSysVo(id:int,vo:AnnouncementVO):Boolean
		{
			return vo.isShowed ==false && vo.type ==2;
		}
		protected function onRemove(event:Event):void
		{
			AnnouncementDataManager.instance.detach(this);
		}
		
		public function update(proc:int = 0):void
		{
			if( GameServiceConstants.SM_ANNOUNCEMENT_OF_GM)
			{
				checkMarquee();
				checkSys();
			}
			else if(GameServiceConstants.SM_ANNOUNCEMENT_OPERATION_GM)
			{
				checkMarquee();
				checkSys();
			} 
		}
		
		private function showAnnouncement(vo:AnnouncementVO):void
		{
			if(mtext.data!=vo && vo.type == 1)
			{ 
				
				mtext.data = vo;
				mtext.delay = vo.interval;
				mtext.repeat = ((vo.end_time - vo.begin_time)/60)/vo.interval;
				var arr:Array =  CfgDataParse.pareseDes(vo.content);
				var str:String = '';
				for each(str in arr)
				{
					mtext.text  += str;
				}
				 
				mtext.callBackFun = marqueeCompleteFun;
				mtext.start();
			}
			
			
			/*mtext.delay = 1000*5;
			mtext.repeat = 3;
			
			var arr:Array =  CfgDataParse.pareseDes("saaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
			var str:String = '';
			for each(str in arr)
			{
				mtext.text  += str;
			}*/
			
			mtext.start(); 
		}
		
		private function showSysAnnouncement(vo:AnnouncementVO):void
		{
			 ChatDataManager.instance.sendSystemNotice(vo.content,0xffff00);
			 vo.isShowed = true;
			 sysinterid = setInterval(sysVoCompleteFun,vo.interval*60*1000,vo);
		}
		
		private function sysVoCompleteFun(vo:AnnouncementVO):void
		{
			var index:int = _sysVos.indexOf(vo);
			if(index !=-1)
			{
				_sysVos.splice(index,1);
			}
			checkSys();
		}
		private function marqueeCompleteFun(data:AnnouncementVO):void
		{
			data.isShowed = true;
			var index:int = _marqueeVos.indexOf(data);
			if(index !=-1)
			{
				_marqueeVos.splice(index,1);	
			}
			checkMarquee();
		}		
		public function swfReceive(url:String, swf:Sprite,info:Object):void
		{
			if(url)
			{
				bg = swf.getChildAt(0) as MovieClip;
				bg.mouseChildren = false;
				bg.mouseEnabled = false;
				bg.x = bg.y = 0;
				bg.width = _width2;
				bg.height = _height2;
				bg.visible = false;
				_layer.addChild(bg);
			}
		}
			
 		
		public function resize(newWidth:int, newHeight:int):void
		{
			_width = newWidth;
			_height = newHeight;
			_layer.x = (_width - _width2)/2;	
			_layer.y = 20;
		}
		
		public function swfProgress(url:String, progress:Number,info:Object):void
		{}
		public function swfError(url:String,info:Object):void
		{}
	}
}