package com.view.gameWindow.mainUi.subuis.chatframe.msg
{
	import com.view.gameWindow.mainUi.subuis.chatframe.MessageCfg;
	import com.view.selectRole.SelectRoleDataManager;
	
	/**
	 * @author wqhk
	 * 2014-8-15
	 */
	public class RoleNameLinkWord extends LinkWord
	{
		public function RoleNameLinkWord()
		{
			super();
		}
		
		override public function getDescription():String
		{
			var value:Array = LinkWord.splitData(data);
			return value[0];
		}
		
		override public function toObject():Object
		{
			var value:Array = LinkWord.splitData(data);
			
			var sid:int = parseInt(value[1]);
			var cid:int = parseInt(value[2]);
			
			return {sid:sid,cid:cid,name:value[0]};
		}
		
		override public function getColor():uint
		{
			return MessageCfg.COLOR_SPEAKER;
		}
		
		override public function getUnderline():Boolean
		{
			
			var value:Array = LinkWord.splitData(data);
			
			var sid:int = parseInt(value[1]);
			var cid:int = parseInt(value[2]);
			
			if(SelectRoleDataManager.getInstance().selectSid == sid &&
				SelectRoleDataManager.getInstance().selectCid == cid)
			{
				return false;
			}
			else
			{
				return true;
			}
		}
	}
}