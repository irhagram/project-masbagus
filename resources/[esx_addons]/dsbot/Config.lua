DiscordWebhookSystemInfos = 'https://discord.com/api/webhooks/995241290650370078/b2wvR2rlDYa20yTGu6RV0iQu-fMJtUBxKLv77bq9t8U0jm1jrAqkwws4_V2DIm0fXlM_'
DiscordWebhookKillinglogs = 'https://discord.com/api/webhooks/997918139117486161/l7Y8rEuwYF13LNWzPkSGw7Ukgg31kIkhrXHhmE98WatctYY9IadlJRuVd3esGd6yH1iu'
DiscordWebhookChat = 'https://discord.com/api/webhooks/997918256574763038/F0TDeQpBH1es5PNUVZM-naz0gLGwDIv06-Qjv0oK2EcG8KADwNvNO6hAMzMmuJ3WUBD1'

SystemAvatar = 'https://media.discordapp.net/attachments/982929367296516145/1014909822015123456/LOGO_INSTAGRALM_V.2.jpg'

UserAvatar = 'https://media.discordapp.net/attachments/982929367296516145/1014909822015123456/LOGO_INSTAGRALM_V.2.jpg'

SystemName = 'ALAN.GG'


--[[ Special Commands formatting
		 *YOUR_TEXT*			--> Make Text Italics in Discord
		**YOUR_TEXT**			--> Make Text Bold in Discord
	   ***YOUR_TEXT***			--> Make Text Italics & Bold in Discord
		__YOUR_TEXT__			--> Underline Text in Discord
	   __*YOUR_TEXT*__			--> Underline Text and make it Italics in Discord
	  __**YOUR_TEXT**__			--> Underline Text and make it Bold in Discord
	 __***YOUR_TEXT***__		--> Underline Text and make it Italics & Bold in Discord
		~~YOUR_TEXT~~			--> Strikethrough Text in Discord
]]
-- Use 'USERNAME_NEEDED_HERE' without the quotes if you need a Users Name in a special command
-- Use 'USERID_NEEDED_HERE' without the quotes if you need a Users ID in a special command


-- These special commands will be printed differently in discord, depending on what you set it to
SpecialCommands = {
				   {'/ooc', '**[OOC]:**'},
				   {'/911', '**[911]: (CALLER ID: [ USERNAME_NEEDED_HERE | USERID_NEEDED_HERE ])**'},
				  }

						
-- These blacklisted commands will not be printed in discord
BlacklistedCommands = {
					   '/AnyCommand',
					   '/AnyCommand2',
					  }

-- These Commands will use their own webhook
OwnWebhookCommands = {
					  {'/transfervehicle', ''},
					  {'/VPN', ''},
					 }

-- These Commands will be sent as TTS messages
TTSCommands = {
			   '/Whatever',
			   '/Whatever2',
			  }

