package com.model.configData
{
	import com.model.configData.cfgdata.BannedWordCfgData;
	import com.model.configData.cfgdata.VoiceEffectCfgData;
	import com.model.configData.constants.ConfigType;

	public class ConfigDataNewMir
	{
		[Embed("../../../../config/banned_word.cfg",mimeType="application/octet-stream")]
		private const bannedWordClass:Class;
		
		[Embed("../../../../config/voice_effect.cfg",mimeType="application/octet-stream")]
		private const voiceEffectClass:Class;
		
		public function getAllConfigData():Vector.<ConfigDataItem>
		{
			var cfgInfos:Vector.<ConfigDataItem>,i:int,l:int;
			cfgInfos = new Vector.<ConfigDataItem>();
			cfgInfos.push(new ConfigDataItem(ConfigType.keyBannedWord,"id",bannedWordClass,BannedWordCfgData));
			cfgInfos.push(new ConfigDataItem(ConfigType.keyVoiceEffect,"id",voiceEffectClass,VoiceEffectCfgData));
			
			return cfgInfos;
		}
	}
}