URL     = require("./libs/url")
JSON    = require("./libs/dkjson")
serpent = require("libs/serpent")
json = require('libs/json')
Redis = require('libs/redis').connect('127.0.0.1', 6379)
http  = require("socket.http")
https   = require("ssl.https")
-------------------


local Methods = io.open("./luatele.lua","r")
if Methods then
URL.tdlua_CallBack()
end
SshId = io.popen("echo $SSH_CLIENT ︙ awk '{ print $1}'"):read('*a')
luatele = require 'luatele'
local FileInformation = io.open("./Information.lua","r")
if not FileInformation then
if not Redis:get(SshId.."Info:Redis:Token") then
io.write('\27[1;31mارسل لي توكن البوت الان \nSend Me a Bot Token Now ↡\n\27[0;39;49m')
local TokenBot = io.read()
if TokenBot and TokenBot:match('(%d+):(.*)') then
local url , res = https.request('https://api.telegram.org/bot'..TokenBot..'/getMe')
local Json_Info = JSON.decode(url)
if res ~= 200 then
print('\27[1;34mعذرا توكن البوت خطأ تحقق منه وارسله مره اخره \nBot Token is Wrong\n')
else
io.write('\27[1;34mتم حفظ التوكن بنجاح \nThe token been saved successfully \n\27[0;39;49m')
TheTokenBot = TokenBot:match("(%d+)")
os.execute('sudo rm -fr .CallBack-Bot/'..TheTokenBot)
Redis:set(SshId.."Info:Redis:Token",TokenBot)
Redis:set(SshId.."Info:Redis:Token:User",Json_Info.result.username)
end 
else
print('\27[1;34mلم يتم حفظ التوكن جرب مره اخره \nToken not saved, try again')
end 
os.execute('lua DyLer.lua')
end
if not Redis:get(SshId.."Info:Redis:User") then
io.write('\27[1;31mارسل معرف المطور الاساسي الان \nDeveloper UserName saved ↡\n\27[0;39;49m')
local UserSudo = io.read():gsub('@','')
if UserSudo ~= '' then
io.write('\n\27[1;34mتم حفظ معرف المطور \nDeveloper UserName saved \n\n\27[0;39;49m')
Redis:set(SshId.."Info:Redis:User",UserSudo)
else
print('\n\27[1;34mلم يتم حفظ معرف المطور الاساسي \nDeveloper UserName not saved\n')
end 
os.execute('lua DyLer.lua')
end
if not Redis:get(SshId.."Info:Redis:User:ID") then
io.write('\27[1;31mارسل ايدي المطور الاساسي الان \nDeveloper ID saved ↡\n\27[0;39;49m')
local UserId = io.read()
if UserId and UserId:match('(%d+)') then
io.write('\n\27[1;34mتم حفظ ايدي المطور \nDeveloper ID saved \n\n\27[0;39;49m')
Redis:set(SshId.."Info:Redis:User:ID",UserId)
else
print('\n\27[1;34mلم يتم حفظ ايدي المطور الاساسي \nDeveloper ID not saved\n')
end 
os.execute('lua DyLer.lua')
end
local Informationlua = io.open("Information.lua", 'w')
Informationlua:write([[
return {
Token = "]]..Redis:get(SshId.."Info:Redis:Token")..[[",
UserBot = "]]..Redis:get(SshId.."Info:Redis:Token:User")..[[",
UserSudo = "]]..Redis:get(SshId.."Info:Redis:User")..[[",
SudoId = ]]..Redis:get(SshId.."Info:Redis:User:ID")..[[
}
]])
Informationlua:close()
local DyLer = io.open("DyLer", 'w')
DyLer:write([[
cd $(cd $(dirname $0); pwd)
while(true) do
lua5.3 DyLer.lua
done
]])
DyLer:close()
Redis:del(SshId.."Info:Redis:User:ID");Redis:del(SshId.."Info:Redis:User");Redis:del(SshId.."Info:Redis:Token:User");Redis:del(SshId.."Info:Redis:Token")
os.execute('chmod +x DyLer;chmod +x DyLer;./DyLer')
end
Information = dofile('./Information.lua')
Sudo_Id = Information.SudoId
UserSudo = Information.UserSudo
Token = Information.Token
UserBot = Information.UserBot
DyLer = Token:match("(%d+)")
os.execute('sudo rm -fr .CallBack-Bot/'..DyLer)
LuaTele = luatele.set_config{api_id=1846213,api_hash='c545c613b78f18a30744970910124d53',session_name=DyLer,token=Token}
function var(value)
print(serpent.block(value, {comment=false}))   
end 
function download(url,name)
if not name then
name = url:match('([^/]+)$')
end
if string.find(url,'https') then
data,res = https.request(url)
elseif string.find(url,'http') then
data,res = http.request(url)
else
return 'The link format is incorrect.'
end
if res ~= 200 then
return 'check url , error code : '..res
else
file = io.open(name,'wb')
file:write(data)
file:close()
return './'..name
end
end
clock = os.clock
function sleep(n)
local t0 = clock()
while clock() - t0 <= n do end
end
function Dev(msg) 
if tonumber(msg.sender.user_id) == tonumber(Sudo_Id) or Redis:sismember(DyLer.."Dev",msg.sender.user_id) then
ok = true
else
ok = false
end
return ok
end

function Run(msg,data)  

if data.content and data.content.text and data.content.text.text then
text = data.content.text.text
end
if msg.message then
msg = msg.message
if msg.content.text and msg.content.text.text then
text = msg.content.text.text
end
end
if data.sender and data.sender.user_id then
if tonumber(data.sender.user_id) == tonumber(DyLer) then
return false
end
end
function ChannelJoin(id)
JoinChannel = true
local chh = Redis:get(DyLer.."chfalse")
if chh then
local url = https.request("https://api.telegram.org/bot"..Token.."/getchatmember?chat_id="..chh.."&user_id="..id)
data = json:decode(url)
if data.result.status == "left" or data.result.status == "kicked" then
JoinChannel = false 
end
end 
return JoinChannel
end
function send(chat,rep,text,parse,dis,clear,disn,back,markup)
LuaTele.sendText(chat,rep,text,parse,dis, clear, disn, back, markup)
end
if msg.sender and msg.sender.user_id then
if msg.sender.user_id == tonumber(DyLer) then
return false
end
if Redis:get(DyLer.."chsource") then
chsource = Redis:get(DyLer.."chsource")
else
chsource = "venox_source"
end
function Reply_Status(UserId,TextMsg)
local UserInfo = LuaTele.getUser(UserId)
Name_User = UserInfo.first_name
if Name_User then
UserInfousername = '['..Name_User..'](tg://user?id='..UserId..')'
else
UserInfousername = UserId
end
return {
Lock     = '\n*↯︙️ بواسطه ← *'..UserInfousername..'\n*'..TextMsg..'\n↯︙️خاصيه المسح *',
unLock   = '\n*↯︙️ بواسطه ← *'..UserInfousername..'\n'..TextMsg,
lockKtm  = '\n*↯︙️ بواسطه ← *'..UserInfousername..'\n*'..TextMsg..'\n↯︙️خاصيه الكتم *',
lockKid  = '\n*↯︙️ بواسطه ← *'..UserInfousername..'\n*'..TextMsg..'\n↯︙️خاصيه التقييد *',
lockKick = '\n*↯︙️ بواسطه ← *'..UserInfousername..'\n*'..TextMsg..'\n↯︙️خاصيه الطرد *',
Reply    = '\n*↯︙️ المستخدم ← *'..UserInfousername..'\n*'..TextMsg..'*'
}
end

if Dev(msg) then
if text == "تحديث" or text == "‹ اعادة تشغيل الملفات ›" then
LuaTele.sendText(Sudo_Id,0,"↯︙️ تمت اعاده تشغيل الملفات بنجاح ✅")
dofile('DyLer.lua')  
return false 
end
if msg.reply_to_message_id ~= 0 then
local Message_Get = LuaTele.getMessage(msg.chat_id, msg.reply_to_message_id)
if Message_Get.forward_info then
local Info_User = Redis:get(DyLer.."Twasl:UserId"..Message_Get.forward_info.date) or 46899864
if text == 'حظر' then
Redis:sadd(DyLer..'BaN:In:Tuasl',Info_User)  
return send(msg.chat_id,msg.id,Reply_Status(Info_User,'↯︙️ تم حظره من الصانع').Reply,"md",true)  
end 
if text =='الغاء الحظر' or text =='الغاء حظر' then
Redis:srem(DyLer..'BaN:In:Tuasl',Info_User)  
return send(msg.chat_id,msg.id,Reply_Status(Info_User,'↯︙️ تم الغاء حظره من الصانع ').Reply,"md",true)  
end 
end
end
if text == "‹ الغاء الامر ›" then
Redis:del(DyLer..msg.sender.user_id.."bottoken")
Redis:del(DyLer..msg.sender.user_id.."botuser")
Redis:del(DyLer..msg.sender.user_id.."make:bot")
return send(msg.chat_id,msg.id,"↯︙️ تم الغاء الامر بنجاح")
end
if text == "/start" then
Redis:del(DyLer..msg.sender.user_id.."bottoken")
Redis:del(DyLer..msg.sender.user_id.."botuser")
Redis:del(DyLer..msg.sender.user_id.."make:bot")
reply_markup = LuaTele.replyMarkup{type = 'keyboard',resize = true,is_personal = true,
data = {
{
{text = '‹ انشاء بوت ›',type = 'text'},{text = '‹ حذف بوت ›',type = 'text'},
},
{
{text = '‹ تشغيل بوت ›',type = 'text'},{text = '‹ ايقاف بوت ›',type = 'text'},
},
{
{text = '‹ تفعيل الاشتراك الاجباري ›',type = 'text'},{text = '‹ تعطيل الاشتراك الاجباري ›',type = 'text'},
},
{
{text = '‹ تفعيل الوضع المجاني ›',type = 'text'},{text = '‹ تعطيل الوضع المجاني ›',type = 'text'},
},
{
{text = '‹ اذاعة عام للمجموعات ›',type = 'text'},{text = '‹ اذاعة عام للمشتركين ›',type = 'text'},
},
{
{text = '‹ الاحصائيات ›',type = 'text'},{text = '‹ السكرينات المفتوحة ›',type = 'text'},
},
{
{text = '‹ تفعيل التواصل ›',type = 'text'},{text = '‹ تعطيل التواصل ›',type = 'text'},
},
{
{text = '‹ اذاعة ›',type = 'text'},{text = '‹ اذاعة بالتوجية ›',type = 'text'},
},
{
{text = '‹ تحديث المصنوعات ›',type = 'text'},{text = '‹ تشغيل البوتات ›',type = 'text'},
},
{
{text = '‹ جلب نسخة ›',type = 'text'},{text = '‹ رفع نسخة ›',type = 'text'},
},
{
{text = '‹ اعادة تشغيل الملفات ›',type = 'text'},
},
{
{text = '‹ الغاء الامر ›',type = 'text'},
},
}
}
send(msg.chat_id,msg.id,"↯︙️ اهلا بك عزيزي المطور الاساسي \n","md",true, false, false, true, reply_markup)
return false 
end
---
if text and text:match("^رفع مطور (%d+)$") then
Redis:sadd(DyLer.."Dev",text:match("^رفع مطور (%d+)$"))
send(msg.chat_id,msg.id,'↯︙️ تم رفع العضو مطور ف الصانع بنجاح ',"md",true)  
return false 
end
if text and text:match("^تنزيل مطور (%d+)$") then
Redis:sadd(DyLer.."Dev",text:match("^تنزيل مطور (%d+)$"))
send(msg.chat_id,msg.id,'↯︙️ تم تنزيل العضو مطور من الصانع بنجاح ',"md",true)  
return false 
end

if text == "‹ تفعيل الوضع المجاني ›" then 
Redis:del(DyLer.."free:bot")
send(msg.chat_id,msg.id,'↯︙️ تم تفعيل الوضع المجاني ',"md",true)  
end
if text == "‹ تعطيل الوضع المجاني ›" then 
Redis:set(DyLer.."free:bot",true)
send(msg.chat_id,msg.id,'↯︙️ تم تعطيل الوضع المجاني ',"md",true)  
end
-----تشغيل البوتات ---
if text and Redis:get(DyLer..msg.sender.user_id.."run:bot") then
Redis:del(DyLer..msg.sender.user_id.."run:bot")
Redis:del(DyLer.."screen:on")
Redis:del(DyLer.."bots:folder")
userbot = text:gsub("@","")
for folder in io.popen('ls'):lines() do
if folder:match('@[%a%d_]') then
Redis:sadd(DyLer.."bots:folder",folder:gsub("@",""))
end
end
if not Redis:sismember(DyLer.."bots:folder",userbot) then
send(msg.chat_id,msg.id,"↯︙️ عفوا هذا البوت ليس ضمن البوتات المصنوعه")
return false 
end
for screen in io.popen('ls /var/run/screen/S-root'):lines() do
Redis:sadd(DyLer.."screen:on",screen)
end
local list = Redis:smembers(DyLer..'screen:on')
for k,v in pairs(list) do
if v:match("(%d+)."..userbot) then
send(msg.chat_id,msg.id,"↯︙️ هذا البوت يعمل بالفعل")
return false 
end
end
os.execute("cd @"..userbot.." ; screen -d -m -S "..userbot.." ./Run")
send(msg.chat_id,msg.id,"↯︙️ تم تشغيل البوت @"..userbot.." بنجاح")
return false 
end
if text == "‹ تشغيل بوت ›" then
Redis:set(DyLer..msg.sender.user_id.."run:bot",true)
send(msg.chat_id,msg.id,"↯︙️ ارسل معرف البوت ليتم تشغيله")
return false 
end
---ايقاف البوتات
if text and Redis:get(DyLer..msg.sender.user_id.."stop:bot") then
Redis:del(DyLer..msg.sender.user_id.."stop:bot")
Redis:del(DyLer.."screen:on")
Redis:del(DyLer.."bots:folder")
userbot = text:gsub("@","")
for folder in io.popen('ls'):lines() do
if folder:match('@[%a%d_]') then
Redis:sadd(DyLer.."bots:folder",folder:gsub("@",""))
end
end
if not Redis:sismember(DyLer.."bots:folder",userbot) then
send(msg.chat_id,msg.id,"↯︙️ عفوا هذا البوت ليس ضمن البوتات المصنوعه")
return false 
end
for screen in io.popen('ls /var/run/screen/S-root'):lines() do
Redis:sadd(DyLer.."screen:on",screen)
end
local list = Redis:smembers(DyLer..'screen:on')
for k,v in pairs(list) do
if v:match("(%d+)."..userbot) then
os.execute('screen -X -S '..userbot..' quit')
send(msg.chat_id,msg.id,"↯︙️ تم ايقاف البوت @"..userbot.." بنجاح")
return false 
end
end
send(msg.chat_id,msg.id,"↯︙️ البوت متوقف بالفعل")
return false 
end
if text == "‹ ايقاف بوت ›" then
Redis:set(DyLer..msg.sender.user_id.."stop:bot",true)
send(msg.chat_id,msg.id,"↯︙️ ارسل معرف البوت ليتم ايقافه")
return false 
end
--الاشتراك الاجباري 
if Redis:get(DyLer.."ch:addd"..msg.sender.user_id) == "on" then
Redis:set(DyLer.."ch:addd"..msg.sender.user_id,"off")
local m = https.request("http://api.telegram.org/bot"..Token.."/getchat?chat_id="..text)
da = json:decode(m)
if da.result.invite_link then
local ch = da.result.id
send(msg.chat_id,msg.id,'↯︙️ تم حفظ القناه ',"md",true)  
Redis:del(DyLer.."chfalse")
Redis:set(DyLer.."chfalse",ch)
Redis:del(DyLer.."ch:admin")
Redis:set(DyLer.."ch:admin",da.result.invite_link)
else
send(msg.chat_id,msg.id,'↯︙️ المعرف خطأ او البوت ليس مشرف في القناه ',"md",true)  
end
end
if text == "‹ تفعيل الاشتراك الاجباري ›" then
Redis:set(DyLer.."ch:addd"..msg.sender.user_id,"on")
send(msg.chat_id,msg.id,'↯︙️ ارسل الان معرف القناه ',"md",true)  
end
if text == "‹ تعطيل الاشتراك الاجباري ›" then
Redis:del(DyLer.."ch:admin")
Redis:del(DyLer.."chfalse")
send(msg.chat_id,msg.id,'↯︙️ تم حذف القناه ',"md",true)  
end
if text and Redis:get(DyLer..msg.sender.user_id.."make:bot") == "devuser" then
local UserName = text:match("^@(.*)$")
if UserName then
local UserId_Info = LuaTele.searchPublicChat(UserName)
if not UserId_Info.id then
send(msg.chat_id,msg.id,"↯︙️ اليوزر ليس لحساب شخصي تأكد منه ","md",true)  
return false
end
if UserId_Info.type.is_channel == true then
send(msg.chat_id,msg.id,"↯︙️ اليوزر لقناه او مجموعه تأكد منه","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
send(msg.chat_id,msg.id,"↯︙️ عذرا يجب ان تستخدم معرف لحساب شخصي فقط ","md",true)  
return false
end
local bottoken = Redis:get(DyLer..msg.sender.user_id.."bottoken")
local botuser = Redis:get(DyLer..msg.sender.user_id.."botuser")
local uu = LuaTele.getUser(UserId_Info.id)
local Informationlua = io.open("./source/Information.lua", 'w')
Informationlua:write([[
return {
Token = "]]..bottoken..[[",
UserBot = "]]..botuser..[[",
UserSudo = "]]..UserName..[[",
SudoId = ]]..UserId_Info.id..[[
}
]])
Informationlua:close()
os.execute('cp -a ./source/. ./@'..botuser..' && cd @'..botuser..' && chmod +x * && screen -d -m -S '..botuser..' ./Run')
Redis:sadd(DyLer.."userbots",botuser)
Redis:del(DyLer..msg.sender.user_id.."bottoken")
Redis:del(DyLer..msg.sender.user_id.."botuser")
Redis:del(DyLer..msg.sender.user_id.."make:bot")
send(msg.chat_id,msg.id,"↯︙️ تم تشغيل البوت بنجاح \n↯︙️ معرف البوت [@"..botuser.."]\n↯︙️ المطور ↯︙️ ["..uu.first_name.."](tg://user?id="..UserId_Info.id..")","md",true)  
else
send(msg.chat_id,msg.id,"↯︙️ اليوزر ليس لحساب شخصي تأكد منه ","md",true)  
end
end
if text and Redis:get(DyLer..msg.sender.user_id.."make:bot") == "token" then
if text:match("(%d+):(.*)") then
local url = https.request("http://api.telegram.org/bot"..text.."/getme")
local json = JSON.decode(url)
if json.ok == true then
local botuser = json.result.username
if Redis:sismember(DyLer.."userbots",botuser) then
send(msg.chat_id,msg.id, "\n↯︙️ عذرا هذا البوت مصنوع بالفعل","md",true)  
return false 
end 
Redis:set(DyLer..msg.sender.user_id.."botuser",botuser)
Redis:set(DyLer..msg.sender.user_id.."bottoken",text)
Redis:set(DyLer..msg.sender.user_id.."make:bot","devuser")
send(msg.chat_id,msg.id, "\n↯︙️ ارسل الان معرف المطور الاساسي ")
return false 
end
send(msg.chat_id,msg.id, "\n↯︙️ التوكن الذي ارسلته غير صحيح ")
return false
end
send(msg.chat_id,msg.id, "\n↯︙️ من فضلك ارسل التوكن بشكل صحيح ")
end
if text == "‹ انشاء بوت ›" then
Redis:set(DyLer..msg.sender.user_id.."make:bot","token")
send(msg.chat_id,msg.id, "\n↯︙️ ارسل توكن البوت الان","md",true)  
return false 
end 
----------end making
----broadcast all
if Redis:get(DyLer.."all:texting") then
if text == "الغاء" or text == '‹ الغاء الامر ›' then   
Redis:del(DyLer.."all:texting")
send(msg.chat_id,msg.id, "\n↯︙️ تم الغاء الاذاعه","md",true)  
return false 
end 
Redis:set(DyLer.."3z:gp",text)
Redis:del(DyLer.."all:texting")
send(msg.chat_id,msg.id,"↯︙️ جاري عمل الاذاعه لكل البوتات ومجموعاتهم يرجي الانتظار ...","html",true)
for folder in io.popen('ls'):lines() do
if folder:match('@[%a%d_]') then
m = Redis:get(folder)
x = {m:match("(.*)&(.*)$(.*)+(.*)")}
bot_id = x[1]
botuser = x[2] 
devbot = x[3]
bottoken = x[4]
list = Redis:smembers(bot_id.."ChekBotAdd") 
for k,v in pairs(list) do
https.request("https://api.telegram.org/bot"..bottoken.."/sendmessage?chat_id="..v.."&text="..URL.escape(Redis:get(DyLer.."3z:gp")).."&parse_mode=Markdown")
end
end
end
Redis:del(DyLer.."3z:gp")
Redis:del(DyLer.."all:texting")
send(msg.chat_id,msg.id,"↯︙️ تم انتهاء الاذاعه في كل البوتات","html",true)
end
if Redis:get(DyLer.."all:texting:pv") then
if text == "الغاء" or text == '‹ الغاء الامر ›' then   
Redis:del(DyLer.."all:texting:pv")
send(msg.chat_id,msg.id, "\n↯︙️ تم الغاء الاذاعه","md",true)  
return false 
end 
Redis:set(DyLer.."eza3a:pv",text)
Redis:del(DyLer.."all:texting:pv")
send(msg.chat_id,msg.id,"↯︙️ جاري عمل الاذاعه لكل البوتات ومطورينهم ومشتركينهم يرجي الانتظار ...","html",true)
for folder in io.popen('ls'):lines() do
if folder:match('@[%a%d_]') then
m = Redis:get(folder)
x = {m:match("(.*)&(.*)$(.*)+(.*)")}
bot_id = x[1]
botuser = x[2] 
devbot = x[3]
bottoken = x[4]
list = Redis:smembers(bot_id.."Num:User:Pv") 
for k,v in pairs(list) do
https.request("https://api.telegram.org/bot"..bottoken.."/sendmessage?chat_id="..v.."&text="..URL.escape(Redis:get(DyLer.."eza3a:pv")).."&parse_mode=Markdown")
end
end
end
Redis:del(DyLer.."eza3a:pv")
Redis:del(DyLer.."all:texting:pv")
send(msg.chat_id,msg.id,"↯︙️ تم انتهاء الاذاعه في كل البوتات","html",true)
end
if text == "‹ اذاعة عام للمجموعات ›" then
Redis:set(DyLer.."all:texting",true)
send(msg.chat_id,msg.id,"ارسل النص الان","html",true)
end
if text == "‹ اذاعة عام للمشتركين ›" then
Redis:set(DyLer.."all:texting:pv",true)
send(msg.chat_id,msg.id,"ارسل النص الان","html",true)
end
-------screen -ls
if text == "‹ السكرينات المفتوحة ›" then  
rqm = 0
local message = ' ↯︙️ السكرينات الموجوده بالسيرفر \n\n'
for screnName in io.popen('ls /var/run/screen/S-root'):lines() do
rqm = rqm + 1
message = message..rqm..'-  { `'..screnName..' `}\n'
end
send(msg.chat_id,msg.id,message..'\n حاليا عندك `'..rqm..'` اسكرين مفتوح ...\n',"md",true)
return false
end
---all stutes
if text == "‹ معلومات البوتات المصنوعة ›" then
local txx = "↯︙️ تقرير باحصائيات بوتاتك\n"
for folder in io.popen('ls'):lines() do
if folder:match('@[%a%d_]') then
m = Redis:get(folder)
x = {m:match("(.*)&(.*)$(.*)+(.*)")}
bot_id = x[1]
botuser = x[2] 
devbot = x[3]
bottoken = x[4]
list = Redis:smembers(bot_id.."ChekBotAdd") 
lt = Redis:smembers(bot_id.."Num:User:Pv") 
txx = txx.."↯︙️ ["..botuser.."] *("..#list.." GP)*".." *("..#lt.." PV)*".."\n"
end
end
send(msg.chat_id,msg.id,txx,"md",true)
end
if text == "‹ فحـص ›" then
Redis:del(DyLer.."All:pv:st")
Redis:del(DyLer.."All:gp:st")
for folder in io.popen('ls'):lines() do
if folder:match('@[%a%d_]') then
m = Redis:get(folder)
x = {m:match("(.*)&(.*)$(.*)+(.*)")}
bot_id = x[1]
botuser = x[2] 
devbot = x[3]
bottoken = x[4]
list = Redis:smembers(bot_id.."ChekBotAdd") 
lt = Redis:smembers(bot_id.."Num:User:Pv") 
Redis:incrby(DyLer.."All:gp:st",tonumber(#list))
Redis:incrby(DyLer.."All:pv:st",tonumber(#lt))
end
end
send(msg.chat_id,msg.id,'\n↯︙️ احصائيات جميع البوتات المصنوعه \n ↯︙️ عدد المجموعات '..Redis:get(DyLer.."All:gp:st")..' مجموعه \n↯︙️ عدد المشتركين '..Redis:get(DyLer.."All:pv:st")..' مشترك',"html",true)
end
-----ban all
if text and text:match('^حظر عام (%d+)$') then
local id = text:match('^حظر عام (%d+)$')
local U = LuaTele.getUser(id)
for folder in io.popen('ls'):lines() do
if folder:match('@[%a%d_]') then
m = Redis:get(folder)
x = {m:match("(.*)&(.*)$(.*)+(.*)")}
bot_id = x[1]
Redis:sadd(bot_id.."BanAll:Groups",id) 
end
end
if U.first_name then
name = U.first_name
else
name = id
end
send(msg.chat_id,msg.id,"↯︙️ الكلب ["..name.."](tg://user?id="..id..")\n↯︙️ تم حظره عام","md",true)
end
if text and text:match('^الغاء عام (%d+)$') then
local id = text:match('^الغاء عام (%d+)$')
local U = LuaTele.getUser(id)
for folder in io.popen('ls'):lines() do
if folder:match('@[%a%d_]') then
m = Redis:get(folder)
x = {m:match("(.*)&(.*)$(.*)+(.*)")}
bot_id = x[1]
Redis:srem(bot_id.."BanAll:Groups",id) 
end
end
if U.first_name then
name = U.first_name
else
name = id
end
send(msg.chat_id,msg.id,"↯︙️ العضو ["..name.."](tg://user?id="..id..")\n↯︙️ تم الغاء حظره عام","md",true)
end
----update bots
if text == "‹ تحديث المصنوعات ›" then
Redis:del(DyLer..'3ddbots')
for folder in io.popen('ls'):lines() do
if folder:match('@[%a%d_]') then
os.execute('cp -a ./update/. ./'..folder..' && cd '..folder..' &&chmod +x * && screen -X -S '..folder:gsub("@","")..' quit && screen -d -m -S '..folder:gsub("@","")..' ./Run')
Redis:sadd(DyLer..'3ddbots',folder)
end
end
os.execute('cp -a ./update/. ./source')
local list = Redis:smembers(DyLer..'3ddbots')
send(msg.chat_id,msg.id,"تم تحديث "..#list.." بوت","html",true)  
end
if text == "‹ تشغيل البوتات ›" then
Redis:del(DyLer..'3ddbots')
for folder in io.popen('ls'):lines() do
if folder:match('@[%a%d_]') then
os.execute('cd '..folder..' && chmod +x * && screen -d -m -S '..folder:gsub("@","")..' ./Run')
Redis:sadd(DyLer..'3ddbots',folder)
end
end
local list = Redis:smembers(DyLer..'3ddbots')
send(msg.chat_id,msg.id,"تم تشغيل "..#list.." بوت","html",true)  
end
--------mange bots
if text == "‹ تصفية المصنوعات ›" then
Redis:del(DyLer.."fake")
for folder in io.popen('ls'):lines() do
if folder:match('@[%a%d_]') then
m = Redis:get(folder)
x = {m:match("(.*)&(.*)$(.*)+(.*)")}
bot_id = x[1]
botuser = x[2] 
devbot = x[3]
bottoken = x[4]
list = Redis:smembers(bot_id.."ChekBotAdd") 
lt = Redis:smembers(bot_id.."Num:User:Pv") 
if #list < 2 then
Redis:sadd(DyLer.."fake",botuser )
os.execute("sudo rm -fr "..botuser)
os.execute('screen -X -S '..botuser:gsub("@","")..' quit')
end
end
end
local list = Redis:smembers(DyLer..'fake')
send(msg.chat_id,msg.id,"↯︙️ تم ايقاف "..#list.." بوت \n عدد مجموعاتهم اقل من 2","html",true)
end
if text == "‹ المصنوعات الوهمية ›" then
local txx = "قائمه بوتاتك الوهيمه \n"
for folder in io.popen('ls'):lines() do
if folder:match('@[%a%d_]') then
m = Redis:get(folder)
x = {m:match("(.*)&(.*)$(.*)+(.*)")}
bot_id = x[1]
botuser = x[2] 
devbot = x[3]
bottoken = x[4]
list = Redis:smembers(bot_id.."ChekBotAdd") 
lt = Redis:smembers(bot_id.."Num:User:Pv") 
if #list < 2 then
txx = txx.."↯︙️ "..botuser.." » "..#list.."\n"
end
end
end
send(msg.chat_id,msg.id,txx,"html",true)
end
-------delete 
if text and Redis:get(DyLer..msg.sender.user_id.."make:bot") == "del" then
if text == "الغاء" or text == '‹ الغاء الامر ›' then   
Redis:del(DyLer..msg.sender.user_id.."make:bot")
send(msg.chat_id,msg.id, "\n↯︙️ تم الغاء تعيين قناه ال‹ السورس ›","md",true)  
return false 
end 
Redis:del(DyLer..msg.sender.user_id.."make:bot")
os.execute("sudo rm -fr "..text)
os.execute("screen -X -S "..text:gsub("@","").." quit")
Redis:srem(DyLer.."userbots",text:gsub("@",""))
send(msg.chat_id,msg.id, "\n↯︙️ تم حذف البوت بنجاح","md",true)  
return false 
end 
if text == "‹ حذف بوت ›" then
Redis:set(DyLer..msg.sender.user_id.."make:bot","del")
send(msg.chat_id,msg.id, "\n↯︙️ ارسل معرف البوت الان","md",true)  
return false 
end 
----end deleting 
-----states
if text == "‹ عدد البوتات ›" then
Redis:del(DyLer..'3ddbots')
bots = "\nقائمه البوتات\n"
botat = "\nقائمه البوتات\n"
for folder in io.popen('ls'):lines() do
if folder:match('@[%a%d_]') then
m = Redis:get(folder)
x = {m:match("(.*)&(.*)$(.*)+(.*)")}
bot_id = x[1]
botuser = x[2] 
devbot = x[3]
bottoken = x[4]
Redis:sadd(DyLer..'3ddbots',botuser..' » '..devbot)
end
end
local list = Redis:smembers(DyLer..'3ddbots')
if #list <= 100 then
for k,v in pairs(list) do
bots = bots..' '..k..'-'..v..'\n'
end
else
for k = 1,100 do
bots = bots..' '..k..'-'..list[k]..'\n'
end
for i = 101 , #list do
botat = botat..' '..i..'-'..list[i]..'\n'
end
end
if #list <= 100 then
send(msg.chat_id,msg.id,bots.."\n".."وعددهم "..#list.."","html",true)  
else
send(msg.chat_id,msg.id,bots,"html",true)  
send(msg.chat_id,msg.id,botat.."\n".."وعددهم "..#list.."","html",true)  
end
end
----end--3dd
if text and Redis:get(DyLer..msg.sender.user_id.."setchannel") then
if text == "الغاء" or text == '‹ الغاء الامر ›' then   
Redis:del(DyLer..msg.sender.user_id.."setchannel")
send(msg.chat_id,msg.id, "\n↯︙️ تم الغاء تعيين قناه ال‹ السورس ›","md",true)  
return false 
end 
if text:match("@(.*)") then
local ch = text:match("@(.*)")
Redis:set(DyLer.."chsource",ch)
send(msg.chat_id,msg.id,"↯︙️ تم تعيين قناه البوت بنجاح")
Redis:del(DyLer..msg.sender.user_id.."setchannel")
else
send(msg.chat_id,msg.id,"↯︙️ ارسل المعرف مع علامه @")
end
end
if text == "↯︙️ تعيين قناه البوت" then
Redis:set(DyLer..msg.sender.user_id.."setchannel",true)
send(msg.chat_id,msg.id,"↯︙️ ارسل الان معرف القناه")
return false 
end
if text == "‹ تفعيل التواصل ›" then
Redis:del(DyLer.."twsl")
send(msg.chat_id,msg.id,"↯︙️ تم تفعيل التواصل")
return false 
end
if text == "‹ تعطيل التواصل ›" then
Redis:set(DyLer.."twsl",true)
send(msg.chat_id,msg.id,"↯︙️ تم تعطيل التواصل")
return false 
end
if text == "‹ الاحصائيات ›" then
local list = Redis:smembers(DyLer.."total")
send(msg.chat_id,msg.id,"↯︙️ عدد مشتركين بوتك "..#list.." مشترك")
return false 
end
if text == '‹ رفع نسخة ›' and msg.reply_to_message_id ~= 0 or text == 'رفع نسخه احتياطيه' and msg.reply_to_message_id ~= 0 then
local Message_Reply = LuaTele.getMessage(msg.chat_id, msg.reply_to_message_id)
if Message_Reply.content.document then
local File_Id = Message_Reply.content.document.document.remote.id
local Name_File = Message_Reply.content.document.file_name
if Name_File ~= UserBot..'.json' then
return send(msg_chat_id,msg_id,'↯︙️ عذرا هاذا الملف غير مطابق مع البوت يرجى جلب النسخه الحقيقيه')
end -- end Namefile
local File = json:decode(https.request('https://api.telegram.org/bot'..Token..'/getfile?file_id='..File_Id)) 
local download_ = download('https://api.telegram.org/file/bot'..Token..'/'..File.result.file_path,''..Name_File) 
local Get_Info = io.open("./"..UserBot..".json","r"):read('*a')
local FilesJson = JSON.decode(Get_Info)
if tonumber(DyLer) ~= tonumber(FilesJson.BotId) then
return send(msg_chat_id,msg_id,'↯︙️ عذرا هاذا الملف غير مطابق مع البوت يرجى جلب النسخه الحقيقيه')
end -- end botid
send(msg_chat_id,msg_id,'↯︙️جاري استرجاع المشتركين والجروبات ...')
Y = 0
for k,v in pairs(FilesJson.UsersBot) do
Y = Y + 1
Redis:sadd(DyLer..'total',v)  
end
end
end
if text == "‹ جلب نسخة ›" then
local UsersBot = Redis:smembers(DyLer.."total")
local Get_Json = '{"BotId": '..DyLer..','  
if #UsersBot ~= 0 then 
Get_Json = Get_Json..'"UsersBot":['  
for k,v in pairs(UsersBot) do
if k == 1 then
Get_Json = Get_Json..'"'..v..'"'
else
Get_Json = Get_Json..',"'..v..'"'
end
end   
Get_Json = Get_Json..']'
end
local File = io.open('./'..UserBot..'.json', "w")
File:write(Get_Json)
File:close()
return LuaTele.sendDocument(msg.chat_id,msg.id,'./'..UserBot..'.json', '*• تم جلب النسخه الاحتياطيه\n• تحتوي على 0 جروب \n• وتحتوي على {'..#UsersBot..'} مشترك *\n', 'md')
end
----brodcast all

--brodcast
if Redis:get(DyLer..msg.sender.user_id.."brodcast") then 
if text == "الغاء" or text == '‹ الغاء الامر ›' then   
Redis:del(DyLer..msg.sender.user_id.."brodcast") 
send(msg.chat_id,msg.id, "\n↯︙️ تم الغاء الاذاعه","md",true)  
return false 
end 
local list = Redis:smembers(DyLer.."total") 
if msg.content.video_note then
for k,v in pairs(list) do 
LuaTele.sendVideoNote(v, 0, msg.content.video_note.video.remote.id)
end
elseif msg.content.photo then
if msg.content.photo.sizes[1].photo.remote.id then
idPhoto = msg.content.photo.sizes[1].photo.remote.id
elseif msg.content.photo.sizes[2].photo.remote.id then
idPhoto = msg.content.photo.sizes[2].photo.remote.id
elseif msg.content.photo.sizes[3].photo.remote.id then
idPhoto = msg.content.photo.sizes[3].photo.remote.id
end
for k,v in pairs(list) do 
LuaTele.sendPhoto(v, 0, idPhoto,'')
end
elseif msg.content.sticker then 
for k,v in pairs(list) do 
LuaTele.sendSticker(v, 0, msg.content.sticker.sticker.remote.id)
end
elseif msg.content.voice_note then 
for k,v in pairs(list) do 
LuaTele.sendVoiceNote(v, 0, msg.content.voice_note.voice.remote.id, '', 'md')
end
elseif msg.content.video then 
for k,v in pairs(list) do 
LuaTele.sendVideo(v, 0, msg.content.video.video.remote.id, '', "md")
end
elseif msg.content.animation then 
for k,v in pairs(list) do 
LuaTele.sendAnimation(v,0, msg.content.animation.animation.remote.id, '', 'md')
end
elseif msg.content.document then
for k,v in pairs(list) do 
LuaTele.sendDocument(v, 0, msg.content.document.document.remote.id, '', 'md')
end
elseif msg.content.audio then
for k,v in pairs(list) do 
LuaTele.sendAudio(v, 0, msg.content.audio.audio.remote.id, '', "md") 
end
elseif text then   
for k,v in pairs(list) do 
send(v,0,text,"md",true)  
end
end
send(msg.chat_id,msg.id,"↯︙️ تمت الاذاعه الى *- "..#list.." * عضو في البوت ","md",true)      
Redis:del(DyLer..msg.sender.user_id.."brodcast") 
return false
end
if text == "‹ اذاعة ›" then
Redis:set(DyLer..msg.sender.user_id.."brodcast",true)
send(msg.chat_id,msg.id,"↯︙️ ارسل الاذاعه الان")
return false 
end
---fwd
if Redis:get(DyLer..msg.sender.user_id.."brodcast:fwd") then 
if text == "الغاء" or text == '‹ الغاء الامر ›' then   
Redis:del(DyLer..msg.sender.user_id.."brodcast:fwd")
send(msg.chat_id,msg.id, "\n↯︙️ تم الغاء الاذاعه بالتوجيه","md",true)    
return false 
end 
if msg.forward_info then 
local list = Redis:smembers(DyLer.."total") 
send(msg.chat_id,msg.id,"↯︙️ تم التوجيه الى *- "..#list.." * مشترك ف البوت ","md",true)      
for k,v in pairs(list) do  
LuaTele.forwardMessages(v, msg.chat_id, msg.id,0,0,true,false,false)
end   
Redis:del(DyLer..msg.sender.user_id.."brodcast:fwd")
end 
return false
end
if text == "‹ اذاعة بالتوجية ›" then
Redis:set(DyLer..msg.sender.user_id.."brodcast:fwd",true)
send(msg.chat_id,msg.id,"↯︙️ ارسل التوجيه الان")
return false 
end


end -- sudo cmd
--
if not Dev(msg) then
if text and ChannelJoin(msg.sender.user_id) == false then
chinfo = Redis:get(DyLer.."ch:admin")
send(msg.chat_id,msg.id,'\n↯︙️ عليك الاشتراك في قناة البوت لاستخذام الاوامر\n\n'..chinfo..'')
return false 
end
if not Redis:get(DyLer.."twsl") then
if msg.sender.user_id ~= tonumber(DyLer) then
if Redis:sismember(DyLer..'BaN:In:Tuasl',msg.sender.user_id) then
return false 
end
if msg.id then
Redis:setex(DyLer.."Twasl:UserId"..msg.date,172800,msg.sender.user_id)
LuaTele.forwardMessages(Sudo_Id, msg.chat_id, msg.id,0,0,true,false,false)
end   
end
end
if Redis:sismember(DyLer..'BaN:In:Tuasl',msg.sender.user_id) then
return false 
end
if text and Redis:get(DyLer.."free:bot") then
return send(msg.chat_id,msg.id,"↯︙️ الوضع المجاني معطل من قبل مطور الصانع")
end
if text == "/start" then
if not Redis:sismember(DyLer.."total",msg.sender.user_id) then
Redis:sadd(DyLer.."total",msg.sender.user_id)
end
reply_markup = LuaTele.replyMarkup{type = 'keyboard',resize = true,is_personal = true,
data = {
{
{text = '‹ انشاء بوت ›',type = 'text'},{text = '‹ حذف بوت ›',type = 'text'},
},
{
{text = '‹ المبرمج ›',type = 'text'},{text = '‹ السورس ›',type = 'text'},
},
{
{text = '‹ الدعم ›',type = 'text'},{text = '‹ شرح انشاء توكن ›',type = 'text'},
},
{
{text = '‹ الغاء ›',type = 'text'},
},
}
}
send(msg.chat_id,msg.id,"↯︙اهلا بك في مصنع بوتات الحمايه\n↯︙اصنع بوت مجاني على سورس فينوكس\n↯︙لايحتوي على مشاكل تحديث 64bit\n↯︙قناه السورس : ‹ @venox_source ›","html",true, false, false, true, reply_markup)
return false 
end
---making user
if text and Redis:get(DyLer..msg.sender.user_id.."make:bot") then
if text == "‹ الغاء ›" then
Redis:del(DyLer..msg.sender.user_id.."make:bot")
send(msg.chat_id,msg.id,"↯︙️ تم الغاء امر صناعه البوت")
return false 
end
local url = https.request("http://api.telegram.org/bot"..text.."/getme")
local json = JSON.decode(url)
if json.ok == true then
local botuser = json.result.username
if Redis:sismember(DyLer.."userbots",botuser) then
send(msg.chat_id,msg.id, "\n↯︙️ عذرا هذا البوت مصنوع بالفعل","md",true)  
return false 
end 
local uu = LuaTele.getUser(msg.sender.user_id)
if uu.username then
username = uu.username
else
username = ""
end
if username == "" then
sudo_state = "["..uu.first_name.."](tg://user?id="..msg.sender.user_id..")" 
else
sudo_state = "[@"..username.."]" 
end
local Informationlua = io.open("./source/Information.lua", 'w')
Informationlua:write([[
return {
Token = "]]..text..[[",
UserBot = "]]..botuser..[[",
UserSudo = "]]..username..[[",
SudoId = ]]..msg.sender.user_id..[[
}
]])
Informationlua:close()
os.execute('cp -a ./source/. ./@'..botuser..' && cd @'..botuser..' && chmod +x * && screen -d -m -S '..botuser..' ./Run')
Redis:set(DyLer..msg.sender.user_id.."my:bot",botuser)
Redis:sadd(DyLer.."userbots",botuser)
Redis:del(DyLer..msg.sender.user_id.."make:bot")
send(Sudo_Id,0,"↯︙️ تم تنصيب بوت جديد \n↯︙️ توكن البوت `"..text.."` \n↯︙️ معرف البوت @["..botuser.."] \n↯︙️ معرف المطور الاساسي "..sudo_state.."","md",true)
send(msg.chat_id,msg.id,"↯︙️ تم تنصيب بوتك بنجاح \n↯︙️ معرف البوت @["..botuser.."] \n↯︙️ معرف المطور الاساسي "..sudo_state.."","md",true)
return false 
end
send(msg.chat_id,msg.id,"↯︙️ التوكن غير صحيح تأكد منه")
end
if text == "‹ انشاء بوت ›" then
if Redis:get(DyLer..msg.sender.user_id.."my:bot") then
return send(msg.chat_id,msg.id,"↯︙️ عفوا لديك بوت بالفعل احذفه اولا")
end
Redis:set(DyLer..msg.sender.user_id.."make:bot",true)
send(msg.chat_id,msg.id,"↯︙️ ارسل توكن بوتك الان")
return false 
end
----end making user
if text == "‹ حذف بوت ›" then
if Redis:get(DyLer..msg.sender.user_id.."my:bot") then
local botuser = Redis:get(DyLer..msg.sender.user_id.."my:bot")
os.execute("sudo rm -fr @"..botuser)
os.execute("screen -X -S "..botuser.." quit")
Redis:srem(DyLer.."userbots",botuser)
Redis:del(DyLer..msg.sender.user_id.."my:bot")
send(msg.chat_id,msg.id, "\n↯︙️ تم حذف البوت بنجاح","md",true)  
else
send(msg.chat_id,msg.id, "\n↯︙️ عفوا لم تصنع اي بوت من قبل","md",true)  
end
end

----
if text == 'المطور ستيفن' or text == '‹ المبرمج ›' or text == 'ستيفن' then  
local UserId_Info = LuaTele.searchPublicChat("Q0OO0")
if UserId_Info.id then
local UserInfo = LuaTele.getUser(UserId_Info.id)
local InfoUser = LuaTele.getUserFullInfo(UserId_Info.id)
if InfoUser.bio then
Bio = InfoUser.bio
else
Bio = ''
end
local photo = LuaTele.getUserProfilePhotos(UserId_Info.id)
if photo.total_count > 0 then
local TestText = "  ❲ Venox Team 𝖲𝗈𝗎𝗋𝖼𝖾 ❳\n— — — — — — — — —\n↯︙*Dev Name* :  ["..UserInfo.first_name.."](tg://user?id="..UserId_Info.id..")\n↯︙️*Dev Bio* : [❲ "..Bio.." ❳]"
keyboardd = {} 
keyboardd.inline_keyboard = {
{
{text = '(Source Dev)', url = "https://t.me/Q0OO0"}
},
}
local msg_id = msg.id/2097152/0.5 
return https.request("https://api.telegram.org/bot"..Token..'/sendPhoto?chat_id='..msg.chat_id..'&caption='..URL.escape(TestText)..'&photo='..photo.photos[1].sizes[#photo.photos[1].sizes].photo.remote.id..'&reply_to_message_id='..msg_id..'&parse_mode=markdown&disable_web_page_preview=true&reply_markup='..JSON.encode(keyboardd))
else
local TestText = "٠ معلومات مبرمج السورس : \\nn: name Dev . ["..UserInfo.first_name.."](tg://user?id="..UserId_Info.id..")\n\n ["..Bio.."]"
keyboardd = {} 
keyboardd.inline_keyboard = {
{
{text = '(Source Dev)', url = "https://t.me/Q0OO0"}
},
{
{text = '(Source Ch)', url = "https://t.me/venox_source"},
},
}
local msg_id = msg.id/2097152/0.5 
return https.request("https://api.telegram.org/bot"..Token..'/sendMessage?chat_id=' .. msg.chat_id .. '&text=' .. URL.escape(TestText).."&reply_to_message_id="..msg_id..'&parse_mode=markdown&disable_web_page_preview=true&reply_markup='..JSON.encode(keyboardd))
end
end
end


if text == '‹ شرح انشاء توكن ›' or text == 'توكن' or text == 'توكن بوت' or text == 'source' then
photo = "https://t.me/mmkvjg/269"
local T =[[
᥀︙اهلا بك عزيزي في قسم الشرح
᥀︙لأنشاء بوت جديد اتبع مايلي :
᥀︙1 - اذهب الى بوت فاذر : ‹ @BotFather ›
᥀︙2 - ارسل الامر : ‹ /newbot ›

᥀︙3 - ارسل اسم للبوت كمثال : ‹ Lose ›
᥀︙4 - ارسل معرف للبوت بشرط بالنهايه ‹ bot ›
᥀︙كمثال لمعرف البوت : ‹ @Wgj3BOT ›
᥀︙بعدها يظهر لك رساله تحتوي على التوكن
᥀︙كمثال للتوكن : ‹ 5202924365:AAEQ ›

᥀︙5. قم بأرسال التوكن لصنع بوتك
᥀︙تابع قناتنا : ‹ @venox_source ›
]]
keyboard = {} 
keyboard.inline_keyboard = {
{
{text = '( BotFather )', url = "https://t.me/BotFather"}
},
{
{text = '(Ch Source )', url = "https://t.me/venox_source"}
}, 
}
local msgg = msg.id/2097152/0.5
https.request("https://api.telegram.org/bot"..Token.."/sendphoto?chat_id=" .. msg.chat_id .. "&photo="..photo.."&caption=".. URL.escape(T).."&reply_to_message_id="..msgg.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end

if text == '‹ الدعم ›' or text == 'الدعم' or text == 'دعم' or text == 'source' then
photo = "https://t.me/mmkvjg/268"
local T =[[
↯︙اهلا بك عزيزي في قسم المساعده
↯︙للاستفسار قم بمراسله مبرمج السورس
↯︙من خلال الازرار في الاسفل
]]
keyboard = {} 
keyboard.inline_keyboard = {
{
{text = '( Dev )', url = "https://t.me/Q0OO0"}
},
}
local msgg = msg.id/2097152/0.5
https.request("https://api.telegram.org/bot"..Token.."/sendphoto?chat_id=" .. msg.chat_id .. "&photo="..photo.."&caption=".. URL.escape(T).."&reply_to_message_id="..msgg.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end


if text == 'السورس' or text == '‹ السورس ›' or text == 'سورس' or text == 'source' then
photo = "https://t.me/sstevvv1/3"
local T =[[
↯︙Welcome To Source
↯︙[ Venox Team ](t.me/venox_source)
]]
keyboard = {} 
keyboard.inline_keyboard = {
{
{text = '( Source channel )', url = "https://t.me/venox_source"}
},
{
{text = '(Source Dev)', url = "https://t.me/Q0OO0"},{text = '( Exp Source )', url = "https://t.me/Exp_venox"},
},
{
{text = '(Tws Source )', url = "https://t.me/g1boebot"}
}, 
}
local msgg = msg.id/2097152/0.5
https.request("https://api.telegram.org/bot"..Token.."/sendphoto?chat_id=" .. msg.chat_id .. "&photo="..photo.."&caption=".. URL.escape(T).."&reply_to_message_id="..msgg.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end

end --non Sudo_Id
end--msg.sender
end--Run
function callback(data)
if data and data.luatele and data.luatele == "updateNewMessage" then
if tonumber(data.message.sender.user_id) == tonumber(DyLer) then
return false
end
Run(data.message,data.message)
elseif data and data.luatele and data.luatele == "updateMessageEdited" then
local Message_Edit = LuaTele.getMessage(data.chat_id, data.message_id)
if Message_Edit.sender.user_id == DyLer then
return false
end
Run(Message_Edit,Message_Edit)
elseif data and data.luatele and data.luatele == "updateNewCallbackQuery" then
Text = LuaTele.base64_decode(data.payload.data)
IdUser = data.sender_user_id
ChatId = data.chat_id
Msg_id = data.message_id

end--data
end--callback 
luatele.run(callback)