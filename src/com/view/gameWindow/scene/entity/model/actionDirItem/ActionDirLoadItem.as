package com.view.gameWindow.scene.entity.model.actionDirItem
{
	import com.model.business.fileService.BytesLoader;
	import com.model.business.fileService.interf.IBytesLoaderReceiver;
	import com.view.gameWindow.scene.entity.constants.ActionTypes;
	import com.view.gameWindow.scene.entity.model.imageItem.ImageItem;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	/**
	 * 接收每个动作需要的图片等信息 
	 * @author Administrator
	 * 
	 */	
	
	public class ActionDirLoadItem implements IBytesLoaderReceiver
	{
		public static const HEADLENGTH:int = 63;//拆包后每个文件文件头的长度
		
		private var _iAction:int;
		private var _actionUrl:String;
		private var _loader:BytesLoader;
		private var _bytes:ByteArray;
		
		private var _imageItems:Vector.<ImageItem>;
		private var _unReadyImageItems:Vector.<ImageItem>;
		
		private var _ready:Boolean;
		private var _available:Boolean;
		private var _inited:Boolean;
		private var _actionInited:Boolean;
		
		private var _nFrame:int;
		private var _width:int;
		private var _height:int;
		private var _directions:int;
		private var _modelHeight:int;
		private var _shadowOffset:int;
		protected var _idle:int;
		protected var _run:int;
		protected var _hurt:int;
		protected var _dead:int;
		protected var _pattack:int;
		protected var _mattack:int;
		protected var _rushidle:int;
		protected var _rush:int;
		protected var _walk:int;
		protected var _unknow1:int;
		protected var _jointattack:int;
		protected var _sunbathe:int;
		protected var _footsie:int;
		protected var _massage:int;
		protected var _beMassage:int;
		protected var _unknow2:int;
		protected var _unknow3:int;
		protected var _unknow4:int;
		protected var _unknow5:int;
		protected var _unknow6:int;
		protected var _gather:int;
		protected var _reveal:int;
		protected var _unknow8:int;
		protected var _unknow9:int;
		protected var _unknow10:int;
		protected var _unknow11:int;
		protected var _unknow12:int;
		protected var _unknow13:int;
		protected var _unknow14:int;
		protected var _unknow15:int;
		protected var _unknow16:int;
		
		protected var _idleFrameRate:int;
		protected var _runFrameRate:int;
		protected var _hurtFrameRate:int;
		protected var _deadFrameRate:int;
		protected var _pattackFrameRate:int;
		protected var _mattackFrameRate:int;
		protected var _rushidleFrameRate:int;
		protected var _rushFrameRate:int;
		protected var _walkFrameRate:int;
		protected var _unknow1FrameRate:int;
		protected var _jointattackFrameRate:int;
		protected var _continuattack1FrameRate:int;
		protected var _continuattack2FrameRate:int;
		protected var _continuattack3FrameRate:int;
		protected var _continuattack4FrameRate:int;
		protected var _unknow2FrameRate:int;
		protected var _unknow3FrameRate:int;
		protected var _unknow4FrameRate:int;
		protected var _unknow5FrameRate:int;
		protected var _unknow6FrameRate:int;
		protected var _gatherFrameRate:int;
		protected var _revealFrameRate:int;
		protected var _unknow8FrameRate:int;
		protected var _unknow9FrameRate:int;
		protected var _unknow10FrameRate:int;
		protected var _unknow11FrameRate:int;
		protected var _unknow12FrameRate:int;
		protected var _unknow13FrameRate:int;
		protected var _unknow14FrameRate:int;
		protected var _unknow15FrameRate:int;
		protected var _unknow16FrameRate:int;
		
		private var _mountY:int;
		
		private var _actionBitmapLoader:ActionDirBitmapLoader;

		private var _url:String;
		
		public var blendModeType:int;
		
		public function ActionDirLoadItem(iAction:int, actionUrl:String)
		{
			_iAction = iAction;
			_actionUrl = actionUrl;
			_ready = false;
			_available = false;
			_inited = false;
			_actionInited = false;
		}
		
		public function init():void
		{
			_loader = new BytesLoader(this);
			_loader.loadBytes(_actionUrl, null);
			_inited = true;
		}
		
		public function bytesReceive(url:String, bytes:ByteArray, info:Object):void
		{
			try
			{
				_url = url;
				_imageItems = new Vector.<ImageItem>();
				_unReadyImageItems = new Vector.<ImageItem>();
				_bytes = bytes;
				_bytes.position = 0;
				var byte1:int = _bytes.readByte();
				var byte2:int = _bytes.readByte();
				var version:int = _bytes.readByte();
				
				_nFrame = _bytes.readShort();
//				trace("ActionDirLoadItem.bytesReceive(url, bytes, info) 资源，url："+url+"单方向总帧数："+_nFrame);
				_width = _bytes.readShort();
				_height = _bytes.readShort();
				_directions = _bytes.readByte();
				_modelHeight = _bytes.readShort();
				_shadowOffset = _bytes.readShort();
				_mountY = _bytes.readShort();
				
				_idle = _bytes.readByte();
				_idleFrameRate = _bytes.readByte();
				_run = _bytes.readByte();
				_runFrameRate = _bytes.readByte();
				_hurt = _bytes.readByte();
				_hurtFrameRate = _bytes.readByte();
				_dead = _bytes.readByte();
				_deadFrameRate = _bytes.readByte();
				_pattack = _bytes.readByte();
				_pattackFrameRate = _bytes.readByte();
				_mattack = _bytes.readByte();
				_mattackFrameRate = _bytes.readByte();
				_rushidle = _bytes.readByte();
				_rushidleFrameRate = _bytes.readByte();
				_rush = _bytes.readByte();
				_rushFrameRate = _bytes.readByte();
				_walk = _bytes.readByte();
				_walkFrameRate = _bytes.readByte();
				_unknow1 = _bytes.readByte();
				_unknow1FrameRate = _bytes.readByte();
				_jointattack = _bytes.readByte();
				_jointattackFrameRate = _bytes.readByte();
				_sunbathe = _bytes.readByte();
				_continuattack1FrameRate = _bytes.readByte();
				_footsie = _bytes.readByte();
				_continuattack2FrameRate = _bytes.readByte();
				_massage = _bytes.readByte();
				_continuattack3FrameRate = _bytes.readByte();
				_beMassage = _bytes.readByte();
				_continuattack4FrameRate = _bytes.readByte();
				_unknow2 = _bytes.readByte();
				_unknow2FrameRate = _bytes.readByte();
				_unknow3 = _bytes.readByte();
				_unknow3FrameRate = _bytes.readByte();
				_unknow4 = _bytes.readByte();
				_unknow4FrameRate = _bytes.readByte();
				_unknow5 = _bytes.readByte();
				_unknow5FrameRate = _bytes.readByte();
				_unknow6 = _bytes.readByte();
				_unknow6FrameRate = _bytes.readByte();
				_gather = _bytes.readByte();
				_gatherFrameRate = _bytes.readByte();
				_reveal = _bytes.readByte();
				_revealFrameRate = _bytes.readByte();
				_unknow8 = _bytes.readByte();
				_unknow8FrameRate = _bytes.readByte();
				_unknow9 = _bytes.readByte();
				_unknow9FrameRate = _bytes.readByte();
				_unknow10 = _bytes.readByte();
				_unknow10FrameRate = _bytes.readByte();
				_unknow11 = _bytes.readByte();
				_unknow11FrameRate = _bytes.readByte();
				_unknow12 = _bytes.readByte();
				_unknow12FrameRate = _bytes.readByte();
				_unknow13 = _bytes.readByte();
				_unknow13FrameRate = _bytes.readByte();
				_unknow14 = _bytes.readByte();
				_unknow14FrameRate = _bytes.readByte();
				_unknow15 = _bytes.readByte();
				_unknow15FrameRate = _bytes.readByte();
				_unknow16 = _bytes.readByte();
				_unknow16FrameRate = _bytes.readByte();
				var iAct:int = _bytes.readByte();
				var imageItem:ImageItem;
				var imgSize:int;
				var imgBytes:ByteArray;
				var nImageItem:int = getNActionFrame(_iAction);
				var imageItemDatas:Vector.<ImageItemData> = new Vector.<ImageItemData>();
				while (nImageItem-- > 0)
				{
					var imageItemData:ImageItemData = new ImageItemData();
					imageItemData.offsetX = _bytes.readShort();
					imageItemData.offsetY = _bytes.readShort();
					imageItemData.bitmapOffsetX = _bytes.readShort();
					imageItemData.bitmapOffsetY = _bytes.readShort();
					imageItemData.bitmapWidth = _bytes.readShort();
					imageItemData.bitmapHeight = _bytes.readShort();
					imageItemData.shadowHeight = _height - imageItemData.offsetY - _shadowOffset;
					imageItem = new ImageItem();
					imageItemData.imageItem = imageItem;
					imageItemDatas.push(imageItemData);
					_imageItems.push(imageItem);
					_unReadyImageItems.push(imageItem);
				}
				if (imageItemDatas.length > 0)
				{
					imgSize = _bytes.readInt();
					imgBytes = new ByteArray();
					imgBytes.endian = Endian.LITTLE_ENDIAN;
					_bytes.readBytes(imgBytes, 0, imgSize);
					_actionBitmapLoader = new ActionDirBitmapLoader();
					_actionBitmapLoader.init(imgBytes, imageItemDatas);
					_available = true;
					_actionInited = true;
				}
				if(_bytes.bytesAvailable)
				{
					blendModeType = _bytes.readByte();
					for each (imageItem in _imageItems)
					{
						imageItem.blendType = blendModeType;
					}
				}
				_bytes = null;
			}
			catch(e:Error)
			{
				trace("url:"+url+"  |  error:"+e.toString());
			}
			
			if(_loader!=null)
			{
				_loader.destroy();
				_loader=null;
			}
		}
		
		public function bytesProgress(url:String, progress:Number, info:Object):void
		{
			
		}
		
		public function bytesError(url:String, info:Object):void
		{
			
		}
		
		public function get ready():Boolean
		{
			if (!_ready)
			{
				if (_actionBitmapLoader)
				{
					if (_actionBitmapLoader.ready)
					{
						_actionBitmapLoader = null;
						_ready = true;
					}
				}
			}
			return _ready;
		}
		
		public function get available():Boolean
		{
			return _available;
		}
		
		public function get inited():Boolean
		{
			return _inited;
		}
		
		private function getNActionFrame(actionId:int):int
		{
			switch (actionId)
			{
				case ActionTypes.IDLE:
					return _idle;
				case ActionTypes.RUN:
					return _run;
				case ActionTypes.HURT:
					return _hurt;
				case ActionTypes.DIE:
					return _dead;
				case ActionTypes.PATTACK:
					return _pattack;
				case ActionTypes.MATTACK:
					return _mattack;
				case ActionTypes.RUSH_IDLE:
					return _rushidle;
				case ActionTypes.RUSH:
					return _rush;
				case ActionTypes.WALK:
					return _walk;
				case ActionTypes.JOINT_ATTACK:
					return _jointattack;
				case ActionTypes.SUNBATHE:
					return _sunbathe;
				case ActionTypes.FOOTSIE:
					return _footsie;
				case ActionTypes.MASSAGE:
					return _massage;
				case ActionTypes.BE_MASSAGE:
					return _beMassage;
				case ActionTypes.UNKNOW2:
					return _unknow2;
				case ActionTypes.UNKNOW3:
					return _unknow3;
				case ActionTypes.UNKNOW4:
					return _unknow4;
				case ActionTypes.UNKNOW5:
					return _unknow5;
				case ActionTypes.UNKNOW6:
					return _unknow6;
				case ActionTypes.GATHER:
					return _gather;
				case ActionTypes.REVEAL:
					return _reveal;
			}
			return 0;
		}
		
		public function get url():String
		{
			return _url;
		}
		
		public function get imageItems():Vector.<ImageItem>
		{
			return _imageItems;
		}
		
		public function get nFrame():int
		{
			return _nFrame;
		}
		
		public function get width():int
		{
			return _width;
		}
		
		public function get height():int
		{
			return _height;
		}
		
		public function get directions():int
		{
			return _directions;
		}
		
		public function get modelHeight():int
		{
			return _modelHeight;
		}
		
		public function get shadowOffset():int
		{
			return _shadowOffset;
		}
		
		public function get idle():int
		{
			return _idle;
		}
		
		public function get run():int
		{
			return _run;
		}
		
		public function get hurt():int
		{
			return _hurt;
		}
		
		public function get dead():int
		{
			return _dead;
		}
		
		public function get pattack():int
		{
			return _pattack;
		}
		
		public function get mattack():int
		{
			return _mattack;
		}
		
		public function get rushidle():int
		{
			return _rushidle;
		}
		
		public function get rush():int
		{
			return _rush;
		}
		
		public function get walk():int
		{
			return _walk;
		}
		
		public function get unknow1():int
		{
			return _unknow1;
		}
		
		public function get jointattack():int
		{
			return _jointattack;
		}
		
		public function get sunbathe():int
		{
			return _sunbathe;
		}
		
		public function get footsie():int
		{
			return _footsie;
		}
		
		public function get massage():int
		{
			return _massage;
		}
		
		public function get beMassage():int
		{
			return _beMassage;
		}
		
		public function get unknow2():int
		{
			return _unknow2;
		}
		
		public function get unknow3():int
		{
			return _unknow3;
		}
		
		public function get unknow4():int
		{
			return _unknow4;
		}
		
		public function get unknow5():int
		{
			return _unknow5;
		}
		
		public function get unknow6():int
		{
			return _unknow6;
		}
		
		public function get gather():int
		{
			return _gather;
		}
		
		public function get reveal():int
		{
			return _reveal;
		}
		
		public function get idleFrameRate():int
		{
			return _idleFrameRate;
		}
		
		public function get runFrameRate():int
		{
			return _runFrameRate;
		}
		
		public function get hurtFrameRate():int
		{
			return _hurtFrameRate;
		}
		
		public function get deadFrameRate():int
		{
			return _deadFrameRate;
		}
		
		public function get pattackFrameRate():int
		{
			return _pattackFrameRate;
		}
		
		public function get mattackFrameRate():int
		{
			return _mattackFrameRate;
		}
		
		public function get rushidleFrameRate():int
		{
			return _rushidleFrameRate;
		}
		
		public function get rushFrameRate():int
		{
			return _rushFrameRate;
		}
		
		public function get walkFrameRate():int
		{
			return _walkFrameRate;
		}
		
		public function get unknow1FrameRate():int
		{
			return _unknow1FrameRate;
		}
		
		public function get jointattackFrameRate():int
		{
			return _jointattackFrameRate;
		}
		
		public function get continuattack1FrameRate():int
		{
			return _continuattack1FrameRate;
		}
		
		public function get continuattack2FrameRate():int
		{
			return _continuattack2FrameRate;
		}
		
		public function get continuattack3FrameRate():int
		{
			return _continuattack3FrameRate;
		}
		
		public function get continuattack4FrameRate():int
		{
			return _continuattack4FrameRate;
		}
		
		public function get unknow2FrameRate():int
		{
			return _unknow2FrameRate;
		}
		
		public function get unknow3FrameRate():int
		{
			return _unknow3FrameRate;
		}
		
		public function get unknow4FrameRate():int
		{
			return _unknow4FrameRate;
		}
		
		public function get unknow5FrameRate():int
		{
			return _unknow5FrameRate;
		}
		
		public function get unknow6FrameRate():int
		{
			return _unknow6FrameRate;
		}
		
		public function get gatherFrameRate():int
		{
			return _gatherFrameRate;
		}
		
		public function get revealFrameRate():int
		{
			return _revealFrameRate;
		}
		
		public function get mountY():int
		{
			return _mountY;
		}
		
		public function destroy():void
		{
			if (_imageItems)
			{
				for each (var imageItem:ImageItem in _imageItems)
				{
					imageItem.destroy();
				}
				_imageItems.length = 0;
				_imageItems = null;
			}
			if (_actionBitmapLoader)
			{
				_actionBitmapLoader.destroy();
			}
		}
	}
}

import com.model.business.fileService.BytesBitmapDataLoader;
import com.model.business.fileService.interf.IBytesBitmapDataLoaderReceiver;
import com.view.gameWindow.scene.entity.model.imageItem.ImageItem;

import flash.display.BitmapData;
import flash.geom.Point;
import flash.utils.ByteArray;

class ImageItemData
{
	private var _offsetX:int;
	private var _offsetY:int;
	private var _shadowHeight:int;
	
	private var _bitmapWidth:int;
	private var _bitmapHeight:int;
	private var _bitmapOffsetX:int;
	private var _bitmapOffsetY:int;
	
	private var _imageItem:ImageItem
	
	public function get offsetX():int
	{
		return _offsetX;
	}
	
	public function get offsetY():int
	{
		return _offsetY;
	}
	
	public function set offsetX(value:int):void
	{
		_offsetX = value;
	}
	
	public function set offsetY(value:int):void
	{
		_offsetY = value;
	}
	
	public function get bitmapOffsetY():int
	{
		return _bitmapOffsetY;
	}
	
	public function set bitmapOffsetY(value:int):void
	{
		_bitmapOffsetY = value;
	}
	
	public function get bitmapWidth():int
	{
		return _bitmapWidth;
	}
	
	public function set bitmapWidth(value:int):void
	{
		_bitmapWidth = value;
	}
	
	public function get bitmapOffsetX():int
	{
		return _bitmapOffsetX;
	}
	
	public function set bitmapOffsetX(value:int):void
	{
		_bitmapOffsetX = value;
	}
	
	public function get bitmapHeight():int
	{
		return _bitmapHeight;
	}
	
	public function set bitmapHeight(value:int):void
	{
		_bitmapHeight = value;
	}
	
	public function get shadowHeight():int
	{
		return _shadowHeight;
	}
	
	public function set shadowHeight(value:int):void
	{
		_shadowHeight = value;
	}
	
	public function get imageItem():ImageItem
	{
		return _imageItem;
	}
	
	public function set imageItem(value:ImageItem):void
	{
		_imageItem = value;
	}
}

class ActionDirBitmapLoader implements IBytesBitmapDataLoaderReceiver
{
	private var _ready:Boolean;
	
	private var _bytes:ByteArray;
	private var _imageItemDatas:Vector.<ImageItemData>;
	
	private var _bitmapData:BitmapData;
	private var _loader:BytesBitmapDataLoader;
	
	public function ActionDirBitmapLoader()
	{
		_ready = false;
	}
	
	public function init(bytes:ByteArray, imageItemDatas:Vector.<ImageItemData>):void
	{
		_bytes = bytes;
		_imageItemDatas = imageItemDatas;
		
		_loader = new BytesBitmapDataLoader(this);
		_loader.loadBitmap(_bytes, null, false);
	}
	
	public function bytesBitmapDataReceive(bytes:ByteArray, bitmapData:BitmapData, info:Object):void
	{
		_bitmapData = bitmapData;
		if(_bitmapData)
		{
			for each (var imageItemData:ImageItemData in _imageItemDatas)
			{
				try
				{
					var imageItem:ImageItem = imageItemData.imageItem;
					imageItem.initByOriBitmapData(_bitmapData, imageItemData.bitmapOffsetX, imageItemData.bitmapOffsetY, imageItemData.bitmapWidth, imageItemData.bitmapHeight, imageItemData.offsetX, imageItemData.offsetY, imageItemData.offsetX, imageItemData.offsetY, imageItemData.shadowHeight);
				}
				catch(e:Error)
				{
					trace(e.message + " in ActionLoadItem.bytesBitmapDataReceive");
				}
			}
			
			_ready = true;
		}
	}
	
	public function bytesBitmapDataError(bytes:ByteArray, info:Object):void
	{
		
	}
	
	public function get ready():Boolean
	{
		return _ready;
	}
	
	public function destroy():void
	{
		if (_bytes)
		{
			_bytes.clear();
			_bytes = null;
		}
		if (_loader)
		{
			_loader.destroy();
			_loader = null;
		}
		if (_bitmapData)
		{
			_bitmapData.dispose();
			_bitmapData = null;
		}
		
		if (_imageItemDatas)
		{
			_imageItemDatas.length = 0;
			_imageItemDatas = null;
		}
	}
}