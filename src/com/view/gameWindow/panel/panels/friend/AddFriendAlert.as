package com.view.gameWindow.panel.panels.friend
{
	import com.view.gameWindow.common.Alert;
	
	/**
	 * @author wqhk
	 * 2014-11-13
	 */
	public class AddFriendAlert
	{
		public function AddFriendAlert()
		{
		}
		
		private function confirtmAddFriend():void
		{
			ContactDataManager.instance.requestAddContact(selectedFriend.serverId,selectedFriend.roleId,ContactType.FRIEND);
		}
		
		private var selectedFriend:ContactEntry;
		
		public function show():void
		{
			var contact:ContactDataManager = ContactDataManager.instance;
			var message:ContactEntry = contact.popMessage();
			
			if(message)
			{
				selectedFriend = message;
				
				var isFriend:Boolean = contact.isInContact(message.serverId,message.roleId,ContactType.FRIEND);
				
				if(isFriend)
				{
					Alert.show2(message.toDes()+"\n\n 恭喜，你与该玩家已经互相结为好友！");
				}
				else
				{
					Alert.show2(message.toDes()+"\n\n 该玩家已添加你为好友\n 请问你需要添加该玩家为好友吗?",confirtmAddFriend);
				}
			}
			
			contact.updateMessageState();
		}
		
	}
}