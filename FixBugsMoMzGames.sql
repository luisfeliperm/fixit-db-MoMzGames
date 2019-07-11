-- Fix Bugs 
-- Cleaner DataBase MOMZGAMES
-- luisfeliperm | _Uchihaker | 

	--> github.com/luisfeliperm/
/*
++++ UDP3 Database Fix ++++++
*/


truncate clan_invites CASCADE; -- Limpa os convites de clan
truncate friends CASCADE; -- Limpa a lista de amizades
truncate nick_history CASCADE; -- Limpa historico de nicks
truncate player_messages CASCADE; -- Mensagens

update accounts set online = false; -- Define contas para offline
--delete from accounts where player_name = '' and rank = 0 ;


-- Lista items de players banidos
/*
 SELECT pi.owner_id,c.player_name,c.player_id,c.access_level 
 FROM player_items pi JOIN accounts c ON c.player_id = pi.owner_id 
 WHERE access_level < 0 ;
*/

delete from ban_history where end_date < now();

-- Registros duplicados
select player_name,player_id from accounts where player_name in (select player_name from accounts group by player_name having Count(player_name)>1);

-- Nicks repetidos
delete from accounts where
player_name in (

select player_name from accounts
   group by player_name
   having Count(player_name)>1
) and player_name != '';

-- Deleta items de players banidos
delete from player_messages where player_messages.owner_id IN
(select accounts.player_id from accounts where access_level < 0);


delete from player_items where player_items.owner_id IN
(select accounts.player_id from accounts where access_level < 0);


delete from player_missions where player_missions.owner_id IN
(select accounts.player_id from accounts where access_level < 0);


delete from player_titles where player_titles.owner_id IN
(select accounts.player_id from accounts where access_level < 0);

delete from player_configs where player_configs.owner_id IN
(select accounts.player_id from accounts where access_level < 0);

delete from player_bonus where player_bonus.player_id IN
(select accounts.player_id from accounts where access_level < 0);

delete from player_events where player_events.player_id IN
(select accounts.player_id from accounts where access_level < 0);


-- delete from accounts where access_level = -1;


-- registros de players que não existem
delete from player_messages i where not exists (select 1 from accounts c where c.player_id = i.owner_id limit 1);
delete from player_items i where not exists (select 1 from accounts c where c.player_id = i.owner_id limit 1);
delete from player_missions i where not exists (select 1 from accounts c where c.player_id = i.owner_id limit 1);
delete from player_titles i where not exists (select 1 from accounts c where c.player_id = i.owner_id limit 1);
delete from player_configs i where not exists (select 1 from accounts c where c.player_id = i.owner_id limit 1);
delete from player_bonus i where not exists (select 1 from accounts c where c.player_id = i.player_id limit 1);
delete from player_events i where not exists (select 1 from accounts c where c.player_id = i.player_id limit 1);
delete from friends i where not exists (select 1 from accounts c where c.player_id = i.owner_id limit 1);



-- Player que participam de clan que não existem, são removidos do clan
select player_id,login,player_name,rank,clan_id from accounts i where clan_id != 0 and not exists (select 1 from clan_data c where c.clan_id = i.clan_id limit 1);
update accounts i set clan_id = 0 where clan_id != 0 and not exists (select 1 from clan_data c where c.clan_id = i.clan_id limit 1);

--- Seleciona clans que o dono está banido permanentemente
select * from clan_data where clan_data.owner_id IN
(select accounts.player_id from accounts where access_level < 0);




-- Banidos
update accounts set
	gp = 0,
	money = 0,
	pc_cafe = 0,
	fights = 0,
	fights_win = 0,
	fights_lost = 0,
	kills_count = 0,
	deaths_count = 0,
	headshots_count = 0,
	escapes = 0,
	weapon_primary = 0,
	weapon_secondary = 0,	
	weapon_melee  = 0,	
	weapon_thrown_normal  = 0,	
	weapon_thrown_special = 0,
	brooch = 0,
	insignia = 0,
	medal = 0,
	clanaccess = 0,
	clandate = 0,
	effects = 0,
	fights_draw =  0,
	mission_id2 = 0,
	mission_id3 = 0,
	totalkills_count = 0,
	totalfights_count = 0,
	clan_game_pt = 0,
	clan_wins_pt = 0
	WHERE access_level < 0;

# Itens invalidos
delete from shop where item_id < 100000000;
delete from player_items where item_id < 100000000;
delete from player_items where item_id < 600000000 and category > 1;



	/* 
	SUA RESPONSABILIDADE
						*/