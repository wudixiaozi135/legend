package com.view.gameWindow.panel.panels.guardSystem
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.BannedWordCfgData;

	public class GuardManager
	{
		private static var _instance:GuardManager;
		
		private var _bannedWords:Vector.<String>;
		private var _bannedRegs:Vector.<RegExp>;
		
		public static function getInstance():GuardManager
		{
			if (!_instance)
			{
				_instance = new GuardManager(new PrivateClass());
			}
			return _instance;
		}
		
		public function GuardManager(pc:PrivateClass)
		{
			if (!pc)
			{
				throw new Error();
			}
		}
		
		public function init():void
		{
			_bannedWords = new Vector.<String>();
			for each (var cfgBannedWord:BannedWordCfgData in ConfigDataManager.instance.bannedWordCfgData())
			{
				_bannedWords.push(cfgBannedWord.word);
			}
			_bannedWords.sort(sortByLength);
		}
		
		private function initBannedRegs():void
		{
			if(_bannedWords && !_bannedRegs)
			{
				_bannedRegs = new Vector.<RegExp>();
				for each(var s:String in _bannedWords)
				{
					var sExt:String = s.replace(/./g, "$&\\s*");
					var exp:RegExp = new RegExp(sExt, "g");
					_bannedRegs.push(exp);
				}
			}
		}
		
		public function containBannedWord(sentence:String):Boolean
		{
			initBannedRegs();
			
			for each(var reg:RegExp in _bannedRegs)
			{
				if(sentence.search(reg) >= 0)
				{
					return true;
				}
			}
			
			return false;
		}
		
		public function replaceBannedWord(sentence:String):String
		{
			initBannedRegs();
			
			var output:String = sentence;
			
			for each(var reg:RegExp in _bannedRegs)
			{
				if(sentence.search(reg) >= 0)
				{
					output = output.replace(reg, "**");
				}
			}
			
			return output;
		}
		
		private function sortByLength(str1:String, str2:String):int
		{
			return str2.length - str1.length;
		}
	}
}

class PrivateClass{}