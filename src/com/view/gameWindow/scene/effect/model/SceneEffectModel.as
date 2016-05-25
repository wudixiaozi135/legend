package com.view.gameWindow.scene.effect.model
{
	import com.model.business.fileService.BytesLoader;
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.business.fileService.interf.IBytesLoaderReceiver;
	
	import flash.utils.ByteArray;
	import flash.utils.getTimer;

	public class SceneEffectModel implements IBytesLoaderReceiver
	{
		private var _nUse:int;
		private var _path:String;
		private var _endTime:int;
		
		private var _loader:BytesLoader;
		private var _imageItems:Vector.<EffectImageItem>;
		private var _ready:Boolean;
		
		private var _totalFrame:int;
		private var _width:int;
		private var _height:int;
		private var _frameRate:int;
		private var _focusX:int;
		private var _focusY:int;
		
		private var _offset1Type:int;
		private var _offset1X:int;
		private var _offset1Y:int;
		private var _offset2Type:int;
		private var _offset2X:int;
		private var _offset2Y:int;
		
		private var _blendModeType:int;
		
		public function SceneEffectModel(path:String)
		{
			_path = path;
			_nUse = 0;
			_ready = false;
		}
		
		public function isMatch(path:String):Boolean
		{
			return _path == path;
		}
		
		public function init():void
		{
			_loader = new BytesLoader(this);
			_loader.loadBytes(ResourcePathConstants.EFFECT_RES_LOAD + _path + ResourcePathConstants.POSTFIX_EFFECT);
		}
		
		public function bytesReceive(url:String, bytes:ByteArray, info:Object):void
		{
			if (_loader == null)
			{
				bytes.clear();
				return;
			}
			try
			{
				bytes.readByte();
				bytes.readByte();
				bytes.readByte();
				_totalFrame = bytes.readShort();
				_frameRate = bytes.readShort();
				
				_width = bytes.readShort();
				_height = bytes.readShort();
				_focusX = bytes.readShort();
				_focusY = bytes.readShort();
				
				bytes.readByte();
				_offset1Type = bytes.readByte();
				_offset1X = bytes.readShort();
				_offset1Y = bytes.readShort();
				_offset2Type = bytes.readByte();
				_offset2X = bytes.readShort();
				_offset2Y = bytes.readShort();
				bytes.readByte();
				bytes.readShort();
				bytes.readShort();
				bytes.readByte();
				bytes.readShort();
				bytes.readShort();
				_imageItems = new Vector.<EffectImageItem>();
				for (var i:int = 0; i < _totalFrame; ++i)
				{
					var imageItem:EffectImageItem = new EffectImageItem();
					imageItem.init(bytes);
					_imageItems.push(imageItem);
				}
				if(bytes.bytesAvailable)
				{
					_blendModeType = bytes.readByte();
				}
			}
			catch(e:Error)
			{
				trace("url:"+url+"  |  error:"+e);
			}
			if (_loader)
			{
				_loader.destroy();
				_loader = null;
			}
		}
		
		public function bytesProgress(url:String, progress:Number, info:Object):void
		{
			
		}
		
		public function bytesError(url:String, info:Object):void
		{
			trace("加载失败"+url+" in"+this+".bytesError");
			if (_loader)
			{
				_loader.destroy();
				_loader = null;
			}
		}
		
		public function get totalFrame():int
		{
			return _totalFrame;
		}
		
		public function get width():int
		{
			return _width;
		}

		public function get height():int
		{
			return _height;
		}
		
		public function get frameRate():int
		{
			return _frameRate;
		}

		public function get focusX():int
		{
			return _focusX;
		}

		public function get focusY():int
		{
			return _focusY;
		}

		public function get offset2Y():int
		{
			return _offset2Y;
		}
		
		public function get offset2X():int
		{
			return _offset2X;
		}
		
		public function get offset1X():int
		{
			return _offset1X;
		}
		
		public function get offset1Type():int
		{
			return _offset1Type;
		}
		
		public function get offset2Type():int
		{
			return _offset2Type;
		}
		
		public function get offset1Y():int
		{
			return _offset1Y;
		}
		
		public function get blendModeType():int
		{
			return _blendModeType;
		}
		
		public function getImageItem(index:int):EffectImageItem
		{
			return _imageItems[index];
		}
		
		public function get nUse():int
		{
			return _nUse;
		}
		
		public function set nUse(value:int):void
		{
			if (_nUse > 0 && value <= 0)
			{
				_endTime = getTimer();
			}
			_nUse = value;
		}
		
		public function get endTime():int
		{
			return _endTime;
		}
		
		public function get ready():Boolean
		{
			if (_ready)
			{
				return _ready;
			}
			if (!_imageItems || _imageItems.length <= 0)
			{
				return false;
			}
			for each (var imageItem:EffectImageItem in _imageItems)
			{
				if (!imageItem.ready)
				{
					return false;
				}
			}
			_ready = true;
			return _ready;
		}
		
		public function destroy():void
		{
			if (_loader)
			{
				_loader.destroy();
				_loader = null;
			}
			for each (var imageItem:EffectImageItem in _imageItems)
			{
				imageItem.destroy();
			}
			if (_imageItems)
			{
				_imageItems.length = 0;
				_imageItems = null;
			}
			
		}
	}
}