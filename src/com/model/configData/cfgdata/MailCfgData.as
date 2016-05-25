package com.model.configData.cfgdata
{
	public class MailCfgData
	{
		public static const SENDER_SYSTEM:int = 1;
		public static const SENDER_GM:int = 2;
		
		public var id:int;//11	序号
		public var title:String;//32	标题
		public var sender:int;//11	发送者
		public var content:String;//256	内容
		public var attachment:String;//256	附件
		
		public function MailCfgData()
		{
		}
	}
}