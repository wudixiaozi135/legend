package com.view.gameWindow.panel.panels.mail.data
{
	/**
	 * 邮件数据类
	 * @author Administrator
	 */	
	public class MailData
	{
		public var id:int;//4字节有符号整形，邮件id
		public var sender:int;//1字节有符号整形 发件人 1:系统 2:GM
		public var title:String;//utf-8 标题 
		public var content:String;//utf-8 内容
		public var attachment:String;//utf-8 附件
		public var state:int;//1字节有符号整形，邮件状态
		public var time:int;//4字节有符号整形，收件时间，unix时间戳
		
		public function MailData()
		{
			
		}
	}
}