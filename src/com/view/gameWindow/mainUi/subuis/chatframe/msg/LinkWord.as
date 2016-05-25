package com.view.gameWindow.mainUi.subuis.chatframe.msg
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.EquipCfgData;
	import com.model.gameWindow.mem.MemEquipData;
	import com.model.gameWindow.mem.MemEquipDataManager;
	
	import flash.display.Sprite;
	
	
	/**
	 * @author wqhk
	 * 2014-8-11
	 * 
	 * getDescription
	 * getTooltipData
	 * getTooltipType
	 */
	public class LinkWord
	{
		public static const TYPE_TXT:int = 0;
		public static const TYPE_EQUIP:int = 1;
		public static const TYPE_ITEM:int = 2;
		public static const TYPE_ROLE_NAME:int = 3;
		public static const TYPE_CUSTOM:int = 4;
		
		public var type:int;
		public var caretIndexBegin:int;
		public var caretIndexEnd:int;
		/**
		 * 如果有多项用 ":"连接  文本中不能有 ","
		 */
		public var data:String;
		
		public var event:String;
		public var eventData:String;
		/**
		 * :
		 */
		public static function joinData(...args):String
		{
			return args.join(":");
		}
		
		public static function splitData(value:String):Array
		{
			return value.split(":");
		}
		
		public static function createLinkWord(type:int):LinkWord
		{
			var re:LinkWord = null;
			switch(type)
			{
				case TYPE_EQUIP:
					re = new EquipLinkWord();
					re.type = type;
					break;
				case TYPE_ITEM:
					re = new ItemLinkWord();
					re.type = type;
					break;
				case TYPE_ROLE_NAME:
					re = new RoleNameLinkWord();
					re.type = type;
					break;
				case TYPE_CUSTOM:
					re = new CustomLinkWord();
					re.type = type;
					break;
				case TYPE_TXT:
					re = new TextLinkWord();
					re.type = type;
					break;
			}
			
			return re;
		}
		
		public static function parseMsgHead(txt:String):Vector.<LinkWord>
		{
			var all:Array = txt.split(",");
			
			var re:Vector.<LinkWord> = new Vector.<LinkWord>();
			for(var i:int = 0; i < all.length; i+=4)
			{
				var type:int = all[i];
				var word:LinkWord = createLinkWord(type);
				word.type = type;
				word.caretIndexBegin = all[i+1];
				word.caretIndexEnd = all[i+2];
				word.data = all[i+3];
				re.push(word);
			}
			
			return re;
		}
		
		public static function encodeMsgHead(inputWords:Vector.<LinkWord>):String
		{
			var head:String = "";
			for each(var word:LinkWord in inputWords)
			{
				if(word.type == 1)
				{
					var data:Array = LinkWord.splitData(word.data);
				}
				if(head == "")
				{
					head = "head{"+word.stringify()
				}
				else
				{
					head+= ","+word.stringify();
				}
				
			}
			
			head += "} ";
			
			return head;
		}
		
		
		public function LinkWord()
		{
			super();
		}
		
		public function getEventName():String
		{
			return event;
		}
		
		public function getEventData():String
		{
			return eventData;
		}
		
		public function toObject():Object
		{
			return {};
		}
		
		public function stringify():String
		{
			return type+","+caretIndexBegin+","+caretIndexEnd+","+data;
		}
		
		public function getDescription():String
		{
			return ""
		}
		
		public function get needTooltip():Boolean
		{
			return false;
		}
		
		public function getTooltipData():Object
		{
			return {};
		}
		
		public function getTooltipType():int
		{
			return 0;
		}
		
		public function getColor():uint
		{
			return 0xcccc00;
		}
		
		public function getUnderline():Boolean
		{
			return false;
		}
	}
}