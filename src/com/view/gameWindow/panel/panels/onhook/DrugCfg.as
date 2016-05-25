package com.view.gameWindow.panel.panels.onhook
{
	import flash.utils.ByteArray;
	
	/**
	 * @author wqhk
	 * 2014-10-15
	 */
	public class DrugCfg
	{
		public var isOpen:Boolean = true;
		public var drugs:Array;
		public var revDrugs:Array;
		public var isDescent:Boolean = true;
		public var percent:Number;
		public var cd:int;//second;
		
		public function toSerialize(data:ByteArray):void
		{
			data.writeByte(isOpen?1:0);
			data.writeByte(isDescent?1:0);
			data.writeByte(int(percent/**100*/));
			data.writeInt(cd);
		}
		
		public function deserialize(data:ByteArray):void
		{
			isOpen = Boolean(data.readByte());
			isDescent = Boolean(data.readByte());
			percent = data.readByte()/*/100*/;
			cd = data.readInt();
		}
	}
}