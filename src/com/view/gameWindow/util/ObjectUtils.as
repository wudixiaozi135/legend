package com.view.gameWindow.util
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.Shape;
    import flash.filters.BitmapFilter;
    import flash.filters.ColorMatrixFilter;
    import flash.filters.GlowFilter;
    import flash.geom.Matrix;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.utils.ByteArray;
    import flash.utils.Dictionary;

    /**对象工具集*/
	public class ObjectUtils
	{
		public static const highlightFilter:ColorMatrixFilter = new ColorMatrixFilter(
				[1, 0, 0, 0, 100,
			0, 1, 0, 0, 100,
			0, 0, 1, 0, 100,
			0, 0, 0, 1, 0]);

		/*按钮高亮状态*/
		public static const btnlightFilter:ColorMatrixFilter = new ColorMatrixFilter(
				[1, 0, 0, 0, 50,
					0, 1, 0, 0, 50,
					0, 0, 1, 0, 50,
					0, 0, 0, 1, 0]);
		public static const glowFilter1:GlowFilter = new GlowFilter(0xC5C855, 1, 4, 4, 4, 2);
		public static const glowFilter2:GlowFilter = new GlowFilter(0xffffff, 1, 6, 6, 2, 1, true);
		public static const glowFilter3:GlowFilter = new GlowFilter(0, 1, 2, 2, 10);
		private static const grayFilter:ColorMatrixFilter = new ColorMatrixFilter([0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0, 0, 0, 1, 0]);
		private static var _tf:TextField = new TextField();

		/**添加描边滤镜*/
		public static function addLineFilter(target:DisplayObject, colorStr:String = "0xffffff"):void
		{
			var a:Array = ObjectUtils.fillArray([0x170702, 0.8, 2, 2, 10, 1], colorStr);
			ObjectUtils.addFilter(target, new GlowFilter(a[0], a[1], a[2], a[3], a[4], a[5]));
		}

		/**添加滤镜*/
		public static function addFilter(target:DisplayObject, filter:BitmapFilter):void
		{
			var filters:Array = target.filters || [];
			filters.push(filter);
			target.filters = filters;
		}

		/**清除滤镜*/
		public static function clearFilter(target:DisplayObject, filterType:Class):void
		{
			var filters:Array = target.filters;
			if (filters != null && filters.length > 0)
			{
				for (var i:int = filters.length - 1; i > -1; i--)
				{
					var filter:* = filters[i];
					if (filter is filterType)
					{
						filters.splice(i, 1);
					}
				}
				target.filters = filters;
			}
		}

		/**clone副本*/
		public static function clone(source:*):*
		{
			var bytes:ByteArray = new ByteArray();
			bytes.writeObject(source);
			bytes.position = 0;
			return bytes.readObject();
		}

		/**创建位图*/
		public static function createBitmap(width:int, height:int, color:uint = 0, alpha:Number = 1):Bitmap
		{
			var bitmap:Bitmap = new Bitmap(new BitmapData(1, 1, false, color));
			bitmap.alpha = alpha;
			bitmap.width = width;
			bitmap.height = height;
			return bitmap;
		}

		/**读取AMF*/
		public static function readAMF(bytes:ByteArray):Object
		{
			if (bytes && bytes.length > 0 && bytes.readByte() == 0x11)
			{
				return bytes.readObject();
			}
			return null;
		}

		/**写入AMF*/
		public static function writeAMF(obj:Object):ByteArray
		{
			var bytes:ByteArray = new ByteArray();
			bytes.writeByte(0x11);
			bytes.writeObject(obj);
			return bytes;
		}

		/**让显示对象变成灰色*/
		public static function gray(traget:DisplayObject, isGray:Boolean = true):void
		{
			if (isGray)
			{
				addFilter(traget, grayFilter);
			} else
			{
				clearFilter(traget, ColorMatrixFilter);
			}
		}

		/**获得实际文本*/
		public static function getTextField(format:TextFormat, text:String = "Test"):TextField
		{
			_tf.autoSize = "left";
			_tf.defaultTextFormat = format;
			_tf.text = text;
			return _tf;
		}

		public static function clearAllChild(obj:DisplayObjectContainer):void
		{
			var temp:Object = null;
			while (obj.numChildren > 0)
			{
				temp = obj.removeChildAt(0);
				if (temp is DisplayObjectContainer)
				{
					clearAllChild(temp as DisplayObjectContainer);
				} else if (temp is Bitmap)
				{
					if ((temp as Bitmap).bitmapData)
					{
						(temp as Bitmap).bitmapData.dispose();
						temp.bitmapData = null;
					}
				}
				if (temp)
					temp = null;
			}
		}

		public static function dicToArr(dic:Dictionary):Array
		{
			var arr:Array = [];
			for each(var obj:* in dic)
			{
				arr.push(obj);
			}
			return arr;
		}

		public static function scaleBitmapData(bmpData:BitmapData, scaleX:Number, scaleY:Number):BitmapData
		{
			var matrix:Matrix = new Matrix();
			matrix.scale(scaleX, scaleY);
			var bmpData:BitmapData = new BitmapData(scaleX * bmpData.width, scaleY * bmpData.height, true, 0);
			bmpData.draw(bmpData, matrix);
			return bmpData;
		}

		/**用字符串填充数组，并返回数组副本*/
		public static function fillArray(arr:Array, str:String, type:Class = null):Array
		{
			var temp:Array = ObjectUtils.clone(arr);
			if (Boolean(str))
			{
				var a:Array = str.split(",");
				for (var i:int = 0, n:int = Math.min(temp.length, a.length); i < n; i++)
				{
					var value:String = a[i];
					temp[i] = (value == "true" ? true : (value == "false" ? false : value));
					if (type != null)
					{
						temp[i] = type(value);
					}
				}
			}
			return temp;
		}

		/**
		 *len 总长度
		 * size 每页多少个
		 */
		public static function getTotalPage(len:int, size:int = 9):int
		{
			return len < size ? 1 : ((len % size > 0) ? 1 : 0) + int(len / size);
		}

		public static function stringFormat(num:int):String
		{
			var s:String = String(num);
			var ret:String = '';
			var symbol:String = "";
			if (s.charAt(0) == "+" || s.charAt(0) == "-")
			{
				symbol = s.charAt(0);
				s = s.substr(1);
			}
			for (var i:int = s.length - 3; i > 0; i -= 3)
			{
				ret = ',' + s.substr(i, 3) + ret;
			}
			ret = symbol + s.substr(0, i + 3) + ret;
			return ret;
		}

		public static function forEach(dic:Dictionary, callBack:Function):void
		{
			for each(var item:Object in dic)
			{
				callBack(item);
			}
		}

		public static function getDaysInMonth(month:int, year:int):int
		{
			if (month == 2)
			{
				if ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0)return 29;
				else return 28;
			}
			switch (month)
			{
				case 1:
					return 31;
				case 3:
					return 31;
				case 4:
					return 30;
				case 5:
					return 31;
				case 6:
					return 30;
				case 7:
					return 31;
				case 8:
					return 31;
				case 9:
					return 30;
				case 10:
					return 31;
				case 11:
					return 30;
				case 12:
					return 31;
			}
			return 0;
		}

		public static function getCalendar():Array
		{
			var totalLen:int = 42;
			var dates:Array = new Array(totalLen);
			var nowDate:Date = new Date();
			var firstDate:Date = new Date(nowDate.fullYear, nowDate.month, 1);//本月第一天
			var lastMonthRemains:int = 0;
			if (firstDate.getDay() == 0)
			{
				lastMonthRemains = 7;
			} else
			{
				lastMonthRemains = firstDate.getDay();
			}

			for (var i:int = 0, len:int = dates.length; i < len; i++)
			{
				var date:Date = new Date(nowDate.fullYear, nowDate.month);
				if (i < lastMonthRemains)
				{
					date.date = firstDate.date - (lastMonthRemains - i);
				} else
				{
					date.date = i - lastMonthRemains + 1;
				}
				dates[i] = date;
			}
			return dates;
		}

		public static function draw(container:DisplayObjectContainer, renderItem:DisplayObject):void
		{
			var shape:Shape = new Shape();
			shape.graphics.clear();
			shape.graphics.lineStyle(2, 0xf2ab1f, 1);
			shape.graphics.drawRect(0, 0, renderItem.width, renderItem.height);
			shape.graphics.endFill();
			shape.filters = [new GlowFilter(0x996100, 1, 5, 5)];
			container.addChild(shape);
		}

        public static function radianToAngle(param1:Number):Number
        {
            return param1 * (180 / Math.PI);
        }

        public static function angleToRadian(param1:Number):Number
        {
            return param1 * (Math.PI / 180);
        }

        public static function sinD(param1:Number):Number
        {
            return Math.sin(angleToRadian(param1));
        }

        public static function cosD(param1:Number):Number
        {
            return Math.cos(angleToRadian(param1));
        }

        public static function atan2D(param1:Number, param2:Number):Number
        {
            return radianToAngle(Math.atan2(param1, param2));
        }
	}
}