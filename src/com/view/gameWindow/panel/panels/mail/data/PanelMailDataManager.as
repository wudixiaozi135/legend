package com.view.gameWindow.panel.panels.mail.data
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
    import com.model.business.gameService.serverMessageManager.subManages.SuccessMessageManager;
    import com.model.business.gameService.socketManager.ClientSocketManager;
    import com.model.dataManager.DataManagerBase;
    
    import flash.utils.ByteArray;
    import flash.utils.Endian;

    /**
	 * 邮件面板邮件数据管理类
	 * @author Administrator
	 */	
	public class PanelMailDataManager extends DataManagerBase
	{
		private static var _instance:PanelMailDataManager;
		public var newMail:Boolean = false;
		public static function get instance():PanelMailDataManager
		{
			return _instance ||= new PanelMailDataManager(new PrivateClass());
		}
		
		public var mailDatas:Vector.<MailData>;
		private var _selectData:MailData,_selectIndex:int = -1;
		private var _hasInit:Boolean = false;
		public function PanelMailDataManager(pc:PrivateClass)
		{
			super();
			if(!pc)
			{
				throw new Error("该类使用单例模式");
			}
			DistributionManager.getInstance().register(GameServiceConstants.SM_MAIL_LIST,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_HAS_MAIL_UNREAD,this);
            SuccessMessageManager.getInstance().register(GameServiceConstants.CM_GET_MAIL_ATTACHMENT, this);
			mailDatas = new Vector.<MailData>();
		}
		
		public function clearInstance():void
		{
			_instance = null;
		}
		
		public function getMailList():void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_GET_MAIL_LIST,byteArray);
		}
		
		public function readMail(index:int):void
		{
			var mailData:MailData = mailDatas[index];
			if(!mailData)
			{
				trace("PanelMailDataManager.readMail 要读的邮件数据不存在");
				return;
			}
			_selectData = mailData;
			_selectIndex = index;
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeInt(mailData.id);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_READ_MAIL,byteArray);
		}
		
		public function getMailAttachment(index:int):void
		{
			var mailData:MailData = mailDatas[index];
			if(!mailData)
			{
				trace("PanelMailDataManager.getMailAttachment 要读的邮件数据不存在");
				return;
			}
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeShort(1);
			byteArray.writeInt(mailData.id);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_GET_MAIL_ATTACHMENT,byteArray);
		}
		
		public function getAllMailAttachment():void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			var datas:Vector.<MailData> = getAllCanGetMail(),data:MailData;
			byteArray.writeShort(datas.length);
			for each(data in datas)
			{
				byteArray.writeInt(data.id);
			}
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_GET_MAIL_ATTACHMENT,byteArray);
		}
		
		private function getAllCanGetMail():Vector.<MailData>
		{
			var vector:Vector.<MailData> = new Vector.<MailData>();
			var data:MailData;
			for each(data in mailDatas)
			{
				if(data.state != MailState.GET)
				{
					vector.push(data);
				}
			}
			return vector;
		}
		
		public function getUnreadMailNumber():int
		{
			var data:MailData;
			var count:int;
			for each(data in mailDatas)
			{
				if(data.state == MailState.UNREAD)
				{
					count++;
				}
			}
			return count;
		}
		
		public function getNewMailIndex():int
		{
			for(var i:int = 0;i<mailDatas.length;i++)
			{
				if(mailDatas[i].state == MailState.UNREAD)
				{
					return i;
				}
			}
			return 0;
		}
		
		public function delMail(index:int):void
		{
			var mailData:MailData = mailDatas[index];
			if(!mailData)
			{
				trace("PanelMailDataManager.getMailAttachment 要读的邮件数据不存在");
				return;
			}
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeShort(1);
			byteArray.writeInt(mailData.id);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_DEL_MAIL,byteArray);
		}
		
		public function delAllMail():void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			var datas:Vector.<MailData> = getAllCanDelMail(),data:MailData;
			byteArray.writeShort(datas.length);
			for each(data in datas)
			{
				byteArray.writeInt(data.id);
			}
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_DEL_MAIL,byteArray);
		}
		
		private function getAllCanDelMail():Vector.<MailData>
		{
			var vector:Vector.<MailData> = new Vector.<MailData>();
			var data:MailData;
			for each(data in mailDatas)
			{
				if(data.state == MailState.GET)
				{
					vector.push(data);
				}
			}
			return vector;
		}
		
		override public function resolveData(proc:int, data:ByteArray):void
		{
			switch(proc)
			{
				case GameServiceConstants.SM_MAIL_LIST:
					dealMailList(data);
					break;
				case GameServiceConstants.SM_HAS_MAIL_UNREAD:
					newMail = true;
					getMailList();
					break;
				default:
					break;
			}
			super.resolveData(proc, data);
		}
		
		private function dealMailList(data:ByteArray):void
		{
			mailDatas.length = 0;
			var count:int = data.readShort();
			while(count--)
			{
				var emailData:MailData = new MailData();
				emailData.id = data.readInt();//4字节有符号整形，邮件id
				emailData.sender = data.readByte();//1字节有符号整形 发件人 1:系统 2:GM
				emailData.title = data.readUTF();//utf-8 标题 
				emailData.content = data.readUTF();//utf-8 内容
				emailData.attachment = data.readUTF();//utf-8 附件
				emailData.state = data.readByte();//1字节有符号整形，邮件状态
				emailData.time = data.readInt();//4字节有符号整形，收件时间，unix时间戳
				mailDatas.push(emailData);
			}
			mailDatas.sort(function (dt1:MailData,dt2:MailData):int
			{
				return dt2.time - dt1.time;
			});
		}

		public function get selectData():MailData
		{
			var _selectData2:MailData = _selectData;
			_selectIndex = -1;
			_selectData = null;
			return _selectData2;
		}

		public function get selectIndex():int
		{
			return _selectIndex;
		}
	}
}
class PrivateClass{}