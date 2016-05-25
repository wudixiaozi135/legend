package com.view.gameWindow.panel.panels.map.mappic
{
	import com.model.business.fileService.UrlBitmapDataLoader;
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.business.fileService.interf.IUrlBitmapDataLoaderReceiver;
	import com.model.configData.cfgdata.MapTeleportCfgData;
	import com.model.configData.cfgdata.MonsterCfgData;
	import com.model.configData.cfgdata.NpcCfgData;
	import com.view.gameWindow.scene.entity.constants.Direction;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	public class MapSign extends Sprite implements IUrlBitmapDataLoaderReceiver /*McMapSign*/
	{
		private static var _dict:Dictionary = new Dictionary();
		
		private var _type:int;
		private var _drct:int = -1;
		private var _mapTeleportData:MapTeleportCfgData;
		private var _npcData:NpcCfgData;
		private var _monsterData:MonsterCfgData;
		
		public var tileX:int = -1;
		public var tileY:int = -1;

//		private var _rsrLoader:RsrLoader;
		private var _loader:UrlBitmapDataLoader;
		private var _img:Bitmap;
		
		public function get drct():int
		{
			return _drct;
		}
		
		public function get type():int
		{
			return _type;
		}
		
		public function get mapTeleportData():MapTeleportCfgData
		{
			return _mapTeleportData;
		}
		
		public function set mapTeleportData(value:MapTeleportCfgData):void
		{
			_mapTeleportData = value;
		}
		
		public function get npcData():NpcCfgData
		{
			return _npcData;
		}
		
		public function set npcData(value:NpcCfgData):void
		{
			_npcData = value;
		}
		
		public function get monsterData():MonsterCfgData
		{
			return _monsterData;
		}
		
		public function set monsterData(value:MonsterCfgData):void
		{
			_monsterData = value;
		}
		
		public function MapSign()
		{
			super();
		}
		
		public function initView(type:int):void
		{
			_type = type;
//			mc.resUrl = getResUrl();
//			var wh:Point = getWH();
//			mc.getChildAt(0).width = wh.x;
//			mc.getChildAt(0).height = wh.y;
//			var xy:Point = getXY();
//			mc.x = xy.x;
//			mc.y = xy.y;
			/*_rsrLoader = new RsrLoader();
			_rsrLoader.load(this, ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD,true);*/
			
			/*var view:MapSign = this;
			ResManager.getInstance().loopLoadBitmap(view,ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD,function(bitmapData:BitmapData,url:String):void
			{
				var theMc:MovieClip = ResManager.getInstance().mcByUrl(view,url);
				if(!theMc)
				{
					return;
				}
				var bitmap:Bitmap = new Bitmap(bitmapData,"auto",true);
				bitmap.width = theMc.width;
				bitmap.height = theMc.height;
				theMc.scaleX = 1;
				theMc.scaleY = 1;
				theMc.addChild(bitmap);
				theMc.removeChildAt(0);
				theMc.mouseEnabled = false;
			});*/
			
			var xy:Point = getXY();
			_img = new Bitmap();
			_img.x = xy.x;
			_img.y = xy.y;
			addChild(_img);
			var url:String = ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD + getResUrl();
			loadImg(url);
		}
		
		private function loadImg(url:String):void
		{
			if(_dict[url])
			{
				urlBitmapDataReceive(url,_dict[url],null);
			}
			else
			{
				_loader = new UrlBitmapDataLoader(this);
				_loader.loadBitmap(url);
			}
		}
		
		private function getResUrl():String
		{
			var str:String;
			switch (_type)
			{
				case MapSignTypes.ARROW:
					str = "mapPanel/sign_arrow.png";
					break;
				case MapSignTypes.BLUE:
					str = "mapPanel/sign_blue.png";
					break;
				case MapSignTypes.END:
					str = "mapPanel/sign_end.png";
					break;
				case MapSignTypes.GREEN:
					str = "mapPanel/sign_green.png";
					break;
				case MapSignTypes.PATH:
					str = "mapPanel/sign_path.png";
					break;
				case MapSignTypes.RED:
					str = "mapPanel/sign_red.png";
					break;
				case MapSignTypes.TELEPORTER:
					str = "mapPanel/sign_teleporter.png";
					break;
			}
			return str;
		}
		
		private function getWH():Point
		{
			var pt:Point;
			switch (_type)
			{
				case MapSignTypes.ARROW:
					pt = new Point(20, 20);
					break;
				case MapSignTypes.RED:
				case MapSignTypes.GREEN:
				case MapSignTypes.BLUE:
					pt = new Point(5,5);
					break;
				case MapSignTypes.END:
				case MapSignTypes.PATH:
					pt = new Point(3, 3);
					break;
				case MapSignTypes.TELEPORTER:
					pt = new Point(28, 32);
					break;
			}
			return pt;
		}
		
		private function getXY():Point
		{
			var pt:Point;
			switch (_type)
			{
				case MapSignTypes.ARROW:
				case MapSignTypes.RED:
				case MapSignTypes.GREEN:
				case MapSignTypes.BLUE:
				case MapSignTypes.END:
				case MapSignTypes.PATH:
					pt = new Point(-getWH().x * .5, -getWH().y * .5);
					break;
				case MapSignTypes.TELEPORTER:
					pt = new Point(-getWH().x * .5, -getWH().y * .75);
					break;
			}
			return pt;
		}
		
		public function refreshDrct(drct:int):void
		{
//			var bitmap:Bitmap = mc.getChildAt(0) as Bitmap;
			
			var bitmap:Bitmap = _img;
			if (!bitmap)
			{
				return;
			}
			_drct = drct;
			switch (drct)
			{
				case Direction.UP_LEFT:
					this.rotation = 0;
					break;
				case Direction.UP:
					this.rotation = 45;
					break;
				case Direction.UP_RIGHT:
					this.rotation = 90;
					break;
				case Direction.RIGHT:
					this.rotation = 135;
					break;
				case Direction.DOWN_RIGHT:
					this.rotation = 180;
					break;
				case Direction.DOWN:
					this.rotation = 225;
					break;
				case Direction.DOWN_LEFT:
					this.rotation = 270;
					break;
				case Direction.LEFT:
					this.rotation = 315;
					break;
			}
		}
		
		public function destroy():void
		{
			_mapTeleportData = null;
			_monsterData = null;
			_npcData = null;
//			if(_rsrLoader)
//			{
//				_rsrLoader.destroy();
//				_rsrLoader = null;
//			}
			
			if(_loader)
			{
				_loader.destroy();
				_loader = null;
			}
			
			if(parent)
			{
				parent.removeChild(this);
			}
		}
		
		public function urlBitmapDataError(url:String, info:Object):void
		{
			
		}
		
		public function urlBitmapDataProgress(url:String, progress:Number, info:Object):void
		{
			
		}
		
		public function urlBitmapDataReceive(url:String, bitmapData:BitmapData, info:Object):void
		{
			_img.bitmapData = bitmapData;
			
			if(!_dict[url])
			{
				_dict[url] = bitmapData;
			}
		}
		
	}
}