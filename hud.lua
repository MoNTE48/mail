
local huddata = {}

minetest.register_on_joinplayer(function(player)
	local name = player:get_player_name()
	local data = {}

	data.imageid = player:hud_add({
		hud_elem_type = "image",
		name = "MailIcon",
		position = {x = 0.475, y = 1},
		text = "",
		scale = {x=1,y=1},
		alignment = {x = 0, y = -1},
		offset = {x = 0, y = -130},
	})

	data.textid = player:hud_add({
		hud_elem_type = "text",
		name = "MailText",
		position = {x = 0.5, y = 1},
		text = "",
		number = 0xFFFFFF,
		scale = {x=1,y=1},
		alignment = {x = 0, y = -1},
		offset = {x = 0, y = -130},
	})


	huddata[name] = data
end)

minetest.register_on_leaveplayer(function(player)
	local name = player:get_player_name()
	huddata[name] = nil
end)


function mail.hud_update(playername, messages)
	local data = huddata[playername]
	local player = minetest.get_player_by_name(playername)

	if not data or not player then
		return
	end

	local unreadcount = 0
	for _, message in ipairs(messages) do
		if not message.read then
			unreadcount = unreadcount + 1
		end
	end

	if unreadcount == 0 or (not mail.get_setting(playername, "hud_notifications")) then
		player:hud_change(data.imageid, "text", "")
		player:hud_change(data.textid, "text", "")
	else
		player:hud_change(data.imageid, "text", "email_mail.png")
		player:hud_change(data.textid, "text", unreadcount .. "\032\032\032/mail")
	end

end
