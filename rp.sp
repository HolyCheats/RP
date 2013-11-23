#include <sdktools>
#include <cstrike>
#include <smlib>
#include <sdkhooks>
#include <sourcemod>
#include <cssclantags.inc>

#pragma semicolon 1

new String:chatColorTags[12][16] =
{
	"normal",
	"orange",
	"red",
	"redblue",
	"blue",
	"bluered",
	"team",
	"lightgreen",
	"gray",
	"green",
	"olivegreen",
	"black"
};
new String:chatColorNames[12][0];
new chatColorInfo[12][4] =
{
	{
		1, -1, 1, -3
	},
	{
		1, 0, 1, -3
	},
	{
		3, 9, 1, 2
	},
	{
		3, 4, 1, 2
	},
	{
		3, 9, 1, 3
	},
	{
		3, 2, 1, 3
	},
	{
		3, 9, 1, -2
	},
	{
		3, 9, 1, 0
	},
	{
		3, 9, 1, -1
	},
	{
		4, 0, 1, -3
	},
	{
		5, 9, 1, -3
	},
	{
		6, 9, 1, -3
	}
};
new bool:checkTeamPlay;
new Handle:mp_teamplay;
new bool:isSayText2_supported = 1;
new chatSubject = -2;
new printToChat_excludeclient = 3308130;
new String:base64_mime_chars[4] = "bz2";
new base64_decodeTable[256] =
{
	3308130, 1886221434, 0, 12079, 47, 46, 11822, 623866661, 115, 42, 46, 46, 11822, 623866661, 115, 25202, 25207, 11822, 46, 623866661, 115, 623866661, 115, 1212892243, 1936420719, 0, 1751868531, 1936420719, 1954047278, 0, 3388, 3400, 1, 1, 1701274962, 2017796216, 1936614772, 7237481, 1701274994, 2019896952, 116, 3432, 3448, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 13421772, 5077314, 16728128, 1635151433, 543451500, 1701407843, 1763734638, 2019910766, 6890784, 1701407811, 622883950, 1936269417, 1953459744, 544106784, 1701667175, 0, 7546113, 7546113, 1417240915, 846493797, 0, 6582116, 3, 4, 909124871, 88, 3, 29477, 1417240915, 846493797, 0, 1433691463, 1299342707, 1634956133, 2035574119, 25968, 1601465957, 7890025, 1952540771, 0, 1600615277, 1701667182, 0, 1634886000, 29549, 0, 1634886000, 29549, 0, 1634886000, 29549, 0, 1634886000, 29549, 0, 1717920891, 1953264993, 125, 1, 1717920891, 1953264993, 125, 0, 1634038907, 1819239277, 8221295, 0, 1635151433, 543451500, 1701407843, 1763734638, 2019910766, 6890784, 1701407811, 622883950, 1936269417, 1953459744, 544106784, 1701667175, 0, 1634038907, 1819239277, 8221295, 3, 761355131, 1512915322, 1564028208, 32043, 0, 123, 0, 125, 0, 0, 909124871, 88, 1380928859, 1329799237, 1397903180, 1850286173, 1768843622, 1814062452, 544239471, 1802465890, 3042917, 1667853409, 1970037349, 101, 1768713313, 29541, 1769238113, 2003137905, 1702127976, 0, 1635086689, 0, 1635086689, 1769103725, 25966, 1936291937, 0, 1920301665, 101, 1734960482, 101, 1903389026, 25973, 1667329122, 107, 1851878498, 1684367459, 1869442145, 25710, 1702194274, 0, 1702194274, 1819240822, 29797, 2003792482, 110, 1819440482, 1869576057, 100
};
new String:base64_sTable[68] = "bz2";
new String:_smlib_empty_twodimstring_array[1][16];
new base64_cFillChar = 3308130;
new String:base64_url_chars[4] = "bz2";
public Extension:__ext_sdkhooks =
{
	name = "SDKHooks",
	file = "sdkhooks.ext",
	autoload = 1,
	required = 1,
};
public Extension:__ext_regex =
{
	name = "Regex Extension",
	file = "regex.ext",
	autoload = 1,
	required = 1,
};
new bool:CSkipList[66];
new Handle:CTrie;
new CTeamColors[1][3] =
{
	{
		13421772, 5077314, 16728128
	}
};
new bool:g_bIsMapLoaded;
new bool:g_booljail[66];
new bool:g_boolreturn[66];
new bool:g_IsTazed[66];
new bool:drogue[66];
new bool:g_boolexta[66];
new bool:g_boollsd[66];
new bool:g_boolcoke[66];
new bool:g_boolhero[66];
new bool:g_crochetageon[66];
new bool:g_booldead[66];
new bool:g_chirurgie[66];
new bool:grab[66];
new bool:OnKit[66];
new bool:g_InUse[66];
new bool:HasKillCible[66];
new bool:oncontrat[66];
new bool:g_appart[66];
new Float:g_Count[66];
new String:g_gamedesc[64];
new String:RealZone[1000];
new String:jobname[1000];
new String:rankname[1000];
new Handle:Timers;
new Handle:gTimer;
new Handle:GiveKit;
new Handle:g_jailreturn[66];
new Handle:g_jailtimer[66];
new Handle:TimerHud[66];
new Handle:TimerAppart[66];
new Handle:g_TazerTimer[66];
new Handle:g_croche[66];
new Handle:g_deadtimer[66];
new Handle:heroo[66];
new Handle:extasiie[66];
new Handle:lssd[66];
new Handle:cokk[66];
new Handle:countm4time;
new Handle:countdeagletime;
new Handle:countm3time;
new Handle:countusptime;
new Handle:Contrat[66];
new Handle:pub;
new g_modelLaser;
new g_modelHalo;
new g_LightingSprite;
new g_BeamSprite;
new g_countheure1;
new g_countheure2;
new g_countminute1;
new g_countminute2;
new M4FBI;
new DEAGLEFBI;
new M3COMICO;
new USPCOMICO;
new countm4;
new countdeagle;
new countm3;
new countusp;
new redColor[4] =
{
	255, 75, 75, 255
};
new greenColor[4] =
{
	75, 255, 75, 255
};
new jobid[66];
new rankid[66];
new bank[66];
new kitcrochetage[66];
new capital[66];
new g_IsInJail[66];
new money[66];
new g_jailtime[66];
new salaire[66];
new rib[66];
new ak47[66];
new awp[66];
new m249[66];
new scout[66];
new sg550[66];
new sg552[66];
new ump[66];
new tmp[66];
new mp5[66];
new deagle[66];
new usp[66];
new glock[66];
new xm1014[66];
new m3[66];
new m4a1[66];
new aug[66];
new galil[66];
new mac10[66];
new famas[66];
new p90[66];
new elite[66];
new ticket10[66];
new ticket100[66];
new ticket1000[66];
new levelcut[66];
new cartouche[66];
new permislourd[66];
new permisleger[66];
new cb[66];
new props1[66];
new props2[66];
new heroine[66];
new exta[66];
new lsd[66];
new coke[66];
new pack[66];
new kevlar[66];
new g_succesheadshot[66];
new g_headshot[66];
new g_succesporte20[66];
new g_succesporte50[66];
new g_succesporte100[66];
new g_porte[66];
new price[66];
new responsable[66];
new jail[66];
new g_invisible[66];
new p[66];
new g_tazer[66];
new Entiter[66];
new g_crochetage[66];
new g_CountDead[66];
new l[66];
new z[66];
new banned[66];
new banni[66];
new TransactionWith[66];
new gObj[66];
new m[66];
new g_vol[66];
new cible[66];
new acheteur[66];
new salarychoose[66];
new maison[66];
new maisontime[66];
public Plugin:myinfo =
{
	name = "Y04NN",
	description = "Mod Roleplay pour CS:S",
	author = "Y04NN",
	version = "1.0",
	url = "Y04NN.fr"
};
public __ext_core_SetNTVOptional()
{
	MarkNativeAsOptional("GetFeatureStatus");
	MarkNativeAsOptional("RequireFeature");
	MarkNativeAsOptional("AddCommandListener");
	MarkNativeAsOptional("RemoveCommandListener");
	MarkNativeAsOptional("BfWriteBool");
	MarkNativeAsOptional("BfWriteByte");
	MarkNativeAsOptional("BfWriteChar");
	MarkNativeAsOptional("BfWriteShort");
	MarkNativeAsOptional("BfWriteWord");
	MarkNativeAsOptional("BfWriteNum");
	MarkNativeAsOptional("BfWriteFloat");
	MarkNativeAsOptional("BfWriteString");
	MarkNativeAsOptional("BfWriteEntity");
	MarkNativeAsOptional("BfWriteAngle");
	MarkNativeAsOptional("BfWriteCoord");
	MarkNativeAsOptional("BfWriteVecCoord");
	MarkNativeAsOptional("BfWriteVecNormal");
	MarkNativeAsOptional("BfWriteAngles");
	MarkNativeAsOptional("BfReadBool");
	MarkNativeAsOptional("BfReadByte");
	MarkNativeAsOptional("BfReadChar");
	MarkNativeAsOptional("BfReadShort");
	MarkNativeAsOptional("BfReadWord");
	MarkNativeAsOptional("BfReadNum");
	MarkNativeAsOptional("BfReadFloat");
	MarkNativeAsOptional("BfReadString");
	MarkNativeAsOptional("BfReadEntity");
	MarkNativeAsOptional("BfReadAngle");
	MarkNativeAsOptional("BfReadCoord");
	MarkNativeAsOptional("BfReadVecCoord");
	MarkNativeAsOptional("BfReadVecNormal");
	MarkNativeAsOptional("BfReadAngles");
	MarkNativeAsOptional("BfGetNumBytesLeft");
	MarkNativeAsOptional("PbReadInt");
	MarkNativeAsOptional("PbReadFloat");
	MarkNativeAsOptional("PbReadBool");
	MarkNativeAsOptional("PbReadString");
	MarkNativeAsOptional("PbReadColor");
	MarkNativeAsOptional("PbReadAngle");
	MarkNativeAsOptional("PbReadVector");
	MarkNativeAsOptional("PbReadVector2D");
	MarkNativeAsOptional("PbGetRepeatedFieldCount");
	MarkNativeAsOptional("PbReadRepeatedInt");
	MarkNativeAsOptional("PbReadRepeatedFloat");
	MarkNativeAsOptional("PbReadRepeatedBool");
	MarkNativeAsOptional("PbReadRepeatedString");
	MarkNativeAsOptional("PbReadRepeatedColor");
	MarkNativeAsOptional("PbReadRepeatedAngle");
	MarkNativeAsOptional("PbReadRepeatedVector");
	MarkNativeAsOptional("PbReadRepeatedVector2D");
	MarkNativeAsOptional("PbSetInt");
	MarkNativeAsOptional("PbSetFloat");
	MarkNativeAsOptional("PbSetBool");
	MarkNativeAsOptional("PbSetString");
	MarkNativeAsOptional("PbSetColor");
	MarkNativeAsOptional("PbSetAngle");
	MarkNativeAsOptional("PbSetVector");
	MarkNativeAsOptional("PbSetVector2D");
	MarkNativeAsOptional("PbAddInt");
	MarkNativeAsOptional("PbAddFloat");
	MarkNativeAsOptional("PbAddBool");
	MarkNativeAsOptional("PbAddString");
	MarkNativeAsOptional("PbAddColor");
	MarkNativeAsOptional("PbAddAngle");
	MarkNativeAsOptional("PbAddVector");
	MarkNativeAsOptional("PbAddVector2D");
	MarkNativeAsOptional("PbReadMessage");
	MarkNativeAsOptional("PbReadRepeatedMessage");
	MarkNativeAsOptional("PbAddMessage");
	VerifyCoreVersion();
	return 0;
}

Float:operator*(Float:,_:)(Float:oper1, oper2)
{
	return oper1 * float(oper2);
}

Float:operator+(Float:,_:)(Float:oper1, oper2)
{
	return oper1 + float(oper2);
}

Float:operator-(Float:,_:)(Float:oper1, oper2)
{
	return oper1 - float(oper2);
}

bool:operator>(Float:,_:)(Float:oper1, oper2)
{
	return FloatCompare(oper1, float(oper2)) > 0;
}

bool:operator>=(Float:,Float:)(Float:oper1, Float:oper2)
{
	return FloatCompare(oper1, oper2) >= 0;
}

bool:operator<=(Float:,Float:)(Float:oper1, Float:oper2)
{
	return FloatCompare(oper1, oper2) <= 0;
}

bool:operator<=(Float:,_:)(Float:oper1, oper2)
{
	return FloatCompare(oper1, float(oper2)) <= 0;
}

SubtractVectors(Float:vec1[3], Float:vec2[3], Float:result[3])
{
	result[0] = vec1[0] - vec2[0];
	result[1] = vec1[1] - vec2[1];
	result[2] = vec1[2] - vec2[2];
	return 0;
}

ScaleVector(Float:vec[3], Float:scale)
{
	var1[0] = var1[0] * scale;
	vec[1] *= scale;
	vec[2] *= scale;
	return 0;
}

bool:StrEqual(String:str1[], String:str2[], bool:caseSensitive)
{
	return strcmp(str1, str2, caseSensitive) == 0;
}

CharToLower(chr)
{
	if (IsCharUpper(chr))
	{
		return chr | 32;
	}
	return chr;
}

FindCharInString(String:str[], c, bool:reverse)
{
	new i;
	new len = strlen(str);
	if (!reverse)
	{
		i = 0;
		while (i < len)
		{
			if (c == str[i])
			{
				return i;
			}
			i++;
		}
	}
	else
	{
		i = len + -1;
		while (0 <= i)
		{
			if (c == str[i])
			{
				return i;
			}
			i--;
		}
	}
	return -1;
}

StrCat(String:buffer[], maxlength, String:source[])
{
	new len = strlen(buffer);
	if (len >= maxlength)
	{
		return 0;
	}
	return Format(buffer[len], maxlength - len, "%s", source);
}

Handle:StartMessageOne(String:msgname[], client, flags)
{
	new players[1];
	players[0] = client;
	return StartMessage(msgname, players, 1, flags);
}

GetEntSendPropOffs(ent, String:prop[], bool:actual)
{
	decl String:cls[64];
	if (!GetEntityNetClass(ent, cls, 64))
	{
		return -1;
	}
	if (actual)
	{
		return FindSendPropInfo(cls, prop, 0, 0, 0);
	}
	return FindSendPropOffs(cls, prop);
}

bool:GetEntityClassname(entity, String:clsname[], maxlength)
{
	return !!GetEntPropString(entity, PropType:1, "m_iClassname", clsname, maxlength, 0);
}

SetEntityMoveType(entity, MoveType:mt)
{
	static bool:gotconfig;
	static String:datamap[32];
	if (!gotconfig)
	{
		new Handle:gc = LoadGameConfigFile("core.games");
		new bool:exists = GameConfGetKeyValue(gc, "m_MoveType", datamap, 32);
		CloseHandle(gc);
		if (!exists)
		{
			strcopy(datamap, 32, "m_MoveType");
		}
		gotconfig = 1;
	}
	SetEntProp(entity, PropType:1, datamap, mt, 4, 0);
	return 0;
}

SetEntityRenderColor(entity, r, g, b, a)
{
	static bool:gotconfig;
	static String:prop[32];
	if (!gotconfig)
	{
		new Handle:gc = LoadGameConfigFile("core.games");
		new bool:exists = GameConfGetKeyValue(gc, "m_clrRender", prop, 32);
		CloseHandle(gc);
		if (!exists)
		{
			strcopy(prop, 32, "m_clrRender");
		}
		gotconfig = 1;
	}
	new offset = GetEntSendPropOffs(entity, prop, false);
	if (0 >= offset)
	{
		ThrowError("SetEntityRenderColor not supported by this mod");
	}
	SetEntData(entity, offset, r, 1, true);
	SetEntData(entity, offset + 1, g, 1, true);
	SetEntData(entity, offset + 2, b, 1, true);
	SetEntData(entity, offset + 3, a, 1, true);
	return 0;
}

SetEntityGravity(entity, Float:amount)
{
	static bool:gotconfig;
	static String:datamap[32];
	if (!gotconfig)
	{
		new Handle:gc = LoadGameConfigFile("core.games");
		new bool:exists = GameConfGetKeyValue(gc, "m_flGravity", datamap, 32);
		CloseHandle(gc);
		if (!exists)
		{
			strcopy(datamap, 32, "m_flGravity");
		}
		gotconfig = 1;
	}
	SetEntPropFloat(entity, PropType:1, datamap, amount, 0);
	return 0;
}

SetEntityHealth(entity, amount)
{
	static bool:gotconfig;
	static String:prop[32];
	if (!gotconfig)
	{
		new Handle:gc = LoadGameConfigFile("core.games");
		new bool:exists = GameConfGetKeyValue(gc, "m_iHealth", prop, 32);
		CloseHandle(gc);
		if (!exists)
		{
			strcopy(prop, 32, "m_iHealth");
		}
		gotconfig = 1;
	}
	decl String:cls[64];
	new PropFieldType:type;
	new offset;
	if (!GetEntityNetClass(entity, cls, 64))
	{
		ThrowError("SetEntityHealth not supported by this mod: Could not get serverclass name");
		return 0;
	}
	offset = FindSendPropInfo(cls, prop, type, 0, 0);
	if (0 >= offset)
	{
		ThrowError("SetEntityHealth not supported by this mod");
		return 0;
	}
	if (type == PropFieldType:2)
	{
		SetEntDataFloat(entity, offset, float(amount), false);
	}
	else
	{
		SetEntProp(entity, PropType:0, prop, amount, 4, 0);
	}
	return 0;
}

EmitSoundToClient(client, String:sample[], entity, channel, level, flags, Float:volume, pitch, speakerentity, Float:origin[3], Float:dir[3], bool:updatePos, Float:soundtime)
{
	new clients[1];
	clients[0] = client;
	if (entity == -2)
	{
		var1 = client;
	}
	else
	{
		var1 = entity;
	}
	entity = var1;
	EmitSound(clients, 1, sample, entity, channel, level, flags, volume, pitch, speakerentity, origin, dir, updatePos, soundtime);
	return 0;
}

EmitSoundToAll(String:sample[], entity, channel, level, flags, Float:volume, pitch, speakerentity, Float:origin[3], Float:dir[3], bool:updatePos, Float:soundtime)
{
	new clients[MaxClients];
	new total;
	new i = 1;
	while (i <= MaxClients)
	{
		if (IsClientInGame(i))
		{
			total++;
			clients[total] = i;
			i++;
		}
		i++;
	}
	if (!total)
	{
		return 0;
	}
	EmitSound(clients, total, sample, entity, channel, level, flags, volume, pitch, speakerentity, origin, dir, updatePos, soundtime);
	return 0;
}

AddFileToDownloadsTable(String:filename[])
{
	static table = -1;
	if (table == -1)
	{
		table = FindStringTable("downloadables");
	}
	new bool:save = LockStringTables(false);
	AddToStringTable(table, filename, "", -1);
	LockStringTables(save);
	return 0;
}

TE_SendToAll(Float:delay)
{
	new total;
	new clients[MaxClients];
	new i = 1;
	while (i <= MaxClients)
	{
		if (IsClientInGame(i))
		{
			total++;
			clients[total] = i;
			i++;
		}
		i++;
	}
	return TE_Send(clients, total, delay);
}

TE_SendToClient(client, Float:delay)
{
	new players[1];
	players[0] = client;
	return TE_Send(players, 1, delay);
}

TE_SetupBeamRingPoint(Float:center[3], Float:Start_Radius, Float:End_Radius, ModelIndex, HaloIndex, StartFrame, FrameRate, Float:Life, Float:Width, Float:Amplitude, Color[4], Speed, Flags)
{
	TE_Start("BeamRingPoint");
	TE_WriteVector("m_vecCenter", center);
	TE_WriteFloat("m_flStartRadius", Start_Radius);
	TE_WriteFloat("m_flEndRadius", End_Radius);
	TE_WriteNum("m_nModelIndex", ModelIndex);
	TE_WriteNum("m_nHaloIndex", HaloIndex);
	TE_WriteNum("m_nStartFrame", StartFrame);
	TE_WriteNum("m_nFrameRate", FrameRate);
	TE_WriteFloat("m_fLife", Life);
	TE_WriteFloat("m_fWidth", Width);
	TE_WriteFloat("m_fEndWidth", Width);
	TE_WriteFloat("m_fAmplitude", Amplitude);
	TE_WriteNum("r", Color[0]);
	TE_WriteNum("g", Color[1]);
	TE_WriteNum("b", Color[2]);
	TE_WriteNum("a", Color[3]);
	TE_WriteNum("m_nSpeed", Speed);
	TE_WriteNum("m_nFlags", Flags);
	TE_WriteNum("m_nFadeLength", 0);
	return 0;
}

TE_SetupBeamPoints(Float:start[3], Float:end[3], ModelIndex, HaloIndex, StartFrame, FrameRate, Float:Life, Float:Width, Float:EndWidth, FadeLength, Float:Amplitude, Color[4], Speed)
{
	TE_Start("BeamPoints");
	TE_WriteVector("m_vecStartPoint", start);
	TE_WriteVector("m_vecEndPoint", end);
	TE_WriteNum("m_nModelIndex", ModelIndex);
	TE_WriteNum("m_nHaloIndex", HaloIndex);
	TE_WriteNum("m_nStartFrame", StartFrame);
	TE_WriteNum("m_nFrameRate", FrameRate);
	TE_WriteFloat("m_fLife", Life);
	TE_WriteFloat("m_fWidth", Width);
	TE_WriteFloat("m_fEndWidth", EndWidth);
	TE_WriteFloat("m_fAmplitude", Amplitude);
	TE_WriteNum("r", Color[0]);
	TE_WriteNum("g", Color[1]);
	TE_WriteNum("b", Color[2]);
	TE_WriteNum("a", Color[3]);
	TE_WriteNum("m_nSpeed", Speed);
	TE_WriteNum("m_nFadeLength", FadeLength);
	return 0;
}

Array_FindString(String:array[][], size, String:str[], bool:caseSensitive, start)
{
	if (0 > start)
	{
		start = 0;
	}
	new i = start;
	while (i < size)
	{
		if (StrEqual(array[i], str, caseSensitive))
		{
			return i;
		}
		i++;
	}
	return -1;
}

Entity_IsValid(entity)
{
	return IsValidEntity(entity);
}

Entity_GetName(entity, String:buffer[], size)
{
	GetEntPropString(entity, PropType:1, localIPRanges, buffer, size, 0);
	return 0;
}

Entity_GetClassName(entity, String:buffer[], size)
{
	GetEntPropString(entity, PropType:1, "m_iClassname", buffer, size, 0);
	if (buffer[0])
	{
		return 1;
	}
	return 0;
}

Entity_SetAbsOrigin(entity, Float:vec[3])
{
	TeleportEntity(entity, vec, NULL_VECTOR, NULL_VECTOR);
	return 0;
}

Entity_SetAbsAngles(entity, Float:vec[3])
{
	TeleportEntity(entity, NULL_VECTOR, vec, NULL_VECTOR);
	return 0;
}

bool:Entity_IsLocked(entity)
{
	return GetEntProp(entity, PropType:1, "m_bLocked", 1, 0);
}

Entity_Lock(entity)
{
	SetEntProp(entity, PropType:1, "m_bLocked", any:1, 1, 0);
	return 0;
}

Entity_UnLock(entity)
{
	SetEntProp(entity, PropType:1, "m_bLocked", any:0, 1, 0);
	return 0;
}

bool:Entity_IsPlayer(entity)
{
	if (entity < 1)
	{
		return false;
	}
	return true;
}

Entity_Create(String:className[], ForceEdictIndex)
{
	if (ForceEdictIndex != -1)
	{
		return -1;
	}
	return CreateEntityByName(className, ForceEdictIndex);
}

bool:Entity_Kill(kenny)
{
	if (Entity_IsPlayer(kenny))
	{
		ForcePlayerSuicide(kenny);
		return true;
	}
	return AcceptEntityInput(kenny, "kill", -1, -1, 0);
}

Team_GetAnyClient(index)
{
	static client_cache[32] =
	{
		-1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	};
	new client;
	if (0 < index)
	{
		client = client_cache[index][0][0];
		if (client > 0)
		{
			if (IsClientInGame(client))
			{
				return client;
			}
		}
		client = -1;
	}
	client = 1;
	while (client <= MaxClients)
	{
		if (IsClientInGame(client))
		{
			if (index != GetClientTeam(client))
			{
			}
			else
			{
				client_cache[index] = client;
				return client;
			}
		}
		client++;
	}
	return -1;
}

Color_ChatInitialize()
{
	static initialized;
	if (initialized)
	{
		return 0;
	}
	initialized = 1;
	decl String:gameFolderName[32];
	GetGameFolderName(gameFolderName, 32);
	chatColorInfo[11][0][2] = 0;
	if (strncmp(gameFolderName, "left4dead", 9, false))
	{
		chatColorInfo[7][0][2] = 0;
		chatColorInfo[8][0][2] = 0;
	}
	if (StrEqual(gameFolderName, "tf", false))
	{
		chatColorInfo[11][0][2] = 1;
		chatColorInfo[8][0] = 1;
		chatColorInfo[8][0][3] = -3;
	}
	else
	{
		if (strncmp(gameFolderName, "left4dead", 9, false))
		{
			if (StrEqual(gameFolderName, "hl2mp", false))
			{
				chatColorInfo[2][0][3] = 3;
				chatColorInfo[3][0][3] = 3;
				chatColorInfo[4][0][3] = 2;
				chatColorInfo[5][0][3] = 2;
				chatColorInfo[11][0][2] = 1;
				checkTeamPlay = 1;
			}
			if (StrEqual(gameFolderName, "dod", false))
			{
				chatColorInfo[8][0] = 1;
				chatColorInfo[8][0][3] = -3;
				chatColorInfo[11][0][2] = 1;
				chatColorInfo[1][0][2] = 0;
			}
		}
		chatColorInfo[2][0][3] = 3;
		chatColorInfo[3][0][3] = 3;
		chatColorInfo[4][0][3] = 2;
		chatColorInfo[5][0][3] = 2;
		chatColorInfo[1][0] = 4;
		chatColorInfo[9][0] = 5;
	}
	if (GetUserMessageId("SayText2") == -1)
	{
		isSayText2_supported = 0;
	}
	decl String:path_gamedata[256];
	BuildPath(PathType:0, path_gamedata, 256, "gamedata/%s.txt", "smlib_colors.games");
	if (FileExists(path_gamedata, false))
	{
		new Handle:gamedata;
		gamedata = var2;
		if (var2)
		{
			decl String:keyName[32];
			decl String:buffer[8];
			new i;
			while (i < 12)
			{
				Format(keyName, 32, "%s_code", chatColorTags[i][0][0]);
				if (GameConfGetKeyValue(gamedata, keyName, buffer, 6))
				{
					chatColorInfo[i][0][0][0] = StringToInt(buffer, 10);
				}
				Format(keyName, 32, "%s_alternative", chatColorTags[i][0][0]);
				if (GameConfGetKeyValue(gamedata, keyName, buffer, 6))
				{
					chatColorInfo[i][0][0][1] = buffer[0];
				}
				Format(keyName, 32, "%s_supported", chatColorTags[i][0][0]);
				if (GameConfGetKeyValue(gamedata, keyName, buffer, 6))
				{
					chatColorInfo[i][0][0][2] = StrEqual(buffer, "true", true);
				}
				Format(keyName, 32, "%s_subjecttype", chatColorTags[i][0][0]);
				if (GameConfGetKeyValue(gamedata, keyName, buffer, 6))
				{
					chatColorInfo[i][0][0][3] = StringToInt(buffer, 10);
					i++;
				}
				i++;
			}
			if (GameConfGetKeyValue(gamedata, "checkteamplay", buffer, 6))
			{
				checkTeamPlay = StrEqual(buffer, "true", true);
			}
			CloseHandle(gamedata);
		}
	}
	mp_teamplay = FindConVar("mp_teamplay");
	return 0;
}

Color_GetChatColorInfo(&index, &subject)
{
	Color_ChatInitialize();
	if (index == -1)
	{
		index = 0;
		while (!chatColorInfo[index][0][0][2])
		{
			new alternative = chatColorInfo[index][0][0][1];
			if (alternative == -1)
			{
				index = 0;
				if (index == -1)
				{
					index = 0;
				}
				new newSubject = -2;
				new ChatColorSubjectType:type = chatColorInfo[index][0][0][3];
				switch (type)
				{
					case -3:
					{
					}
					case -2:
					{
						newSubject = chatSubject;
					}
					case -1:
					{
						newSubject = -1;
					}
					case 0:
					{
						newSubject = 0;
					}
					default:
					{
						if (!checkTeamPlay)
						{
							if (subject > 0)
							{
								if (type == GetClientTeam(subject))
								{
									newSubject = subject;
								}
							}
							if (subject == -2)
							{
								new client = Team_GetAnyClient(type);
								if (client != -1)
								{
									newSubject = client;
								}
							}
						}
					}
				}
				if (type > ChatColorSubjectType:-3)
				{
					index = chatColorInfo[index][0][0][1];
					newSubject = Color_GetChatColorInfo(index, subject);
				}
				if (subject == -2)
				{
					subject = newSubject;
				}
				return newSubject;
			}
			index = alternative;
		}
		if (index == -1)
		{
			index = 0;
		}
		new newSubject = -2;
		new ChatColorSubjectType:type = chatColorInfo[index][0][0][3];
		switch (type)
		{
			case -3:
			{
			}
			case -2:
			{
				newSubject = chatSubject;
			}
			case -1:
			{
				newSubject = -1;
			}
			case 0:
			{
				newSubject = 0;
			}
			default:
			{
				if (!checkTeamPlay)
				{
					if (subject > 0)
					{
						if (type == GetClientTeam(subject))
						{
							newSubject = subject;
						}
					}
					if (subject == -2)
					{
						new client = Team_GetAnyClient(type);
						if (client != -1)
						{
							newSubject = client;
						}
					}
				}
			}
		}
		if (type > ChatColorSubjectType:-3)
		{
			index = chatColorInfo[index][0][0][1];
			newSubject = Color_GetChatColorInfo(index, subject);
		}
		if (subject == -2)
		{
			subject = newSubject;
		}
		return newSubject;
	}
	while (!chatColorInfo[index][0][0][2])
	{
		new alternative = chatColorInfo[index][0][0][1];
		if (alternative == -1)
		{
			index = 0;
			if (index == -1)
			{
				index = 0;
			}
			new newSubject = -2;
			new ChatColorSubjectType:type = chatColorInfo[index][0][0][3];
			switch (type)
			{
				case -3:
				{
				}
				case -2:
				{
					newSubject = chatSubject;
				}
				case -1:
				{
					newSubject = -1;
				}
				case 0:
				{
					newSubject = 0;
				}
				default:
				{
					if (!checkTeamPlay)
					{
						if (subject > 0)
						{
							if (type == GetClientTeam(subject))
							{
								newSubject = subject;
							}
						}
						if (subject == -2)
						{
							new client = Team_GetAnyClient(type);
							if (client != -1)
							{
								newSubject = client;
							}
						}
					}
				}
			}
			if (type > ChatColorSubjectType:-3)
			{
				index = chatColorInfo[index][0][0][1];
				newSubject = Color_GetChatColorInfo(index, subject);
			}
			if (subject == -2)
			{
				subject = newSubject;
			}
			return newSubject;
		}
		index = alternative;
	}
	if (index == -1)
	{
		index = 0;
	}
	new newSubject = -2;
	new ChatColorSubjectType:type = chatColorInfo[index][0][0][3];
	switch (type)
	{
		case -3:
		{
		}
		case -2:
		{
			newSubject = chatSubject;
		}
		case -1:
		{
			newSubject = -1;
		}
		case 0:
		{
			newSubject = 0;
		}
		default:
		{
			if (!checkTeamPlay)
			{
				if (subject > 0)
				{
					if (type == GetClientTeam(subject))
					{
						newSubject = subject;
					}
				}
				if (subject == -2)
				{
					new client = Team_GetAnyClient(type);
					if (client != -1)
					{
						newSubject = client;
					}
				}
			}
		}
	}
	if (type > ChatColorSubjectType:-3)
	{
		index = chatColorInfo[index][0][0][1];
		newSubject = Color_GetChatColorInfo(index, subject);
	}
	if (subject == -2)
	{
		subject = newSubject;
	}
	return newSubject;
}

Weapon_Create(String:className[], Float:absOrigin[3], Float:absAngles[3])
{
	new weapon = Entity_Create(className, -1);
	if (weapon == -1)
	{
		return -1;
	}
	Entity_SetAbsOrigin(weapon, absOrigin);
	Entity_SetAbsAngles(weapon, absAngles);
	DispatchSpawn(weapon);
	return weapon;
}

Client_SetScore(client, value)
{
	SetEntProp(client, PropType:1, "m_iFrags", value, 4, 0);
	return 0;
}

Client_SetDeaths(client, value)
{
	SetEntProp(client, PropType:1, "m_iDeaths", value, 4, 0);
	return 0;
}

Client_GetActiveWeapon(client)
{
	new weapon = GetEntPropEnt(client, PropType:1, "m_hActiveWeapon", 0);
	if (!Entity_IsValid(weapon))
	{
		return -1;
	}
	return weapon;
}

Client_GetActiveWeaponName(client, String:buffer[], size)
{
	new weapon = Client_GetActiveWeapon(client);
	if (weapon == -1)
	{
		buffer[0] = 0;
		return -1;
	}
	Entity_GetClassName(weapon, buffer, size);
	return weapon;
}

public bool:_smlib_TraceEntityFilter(entity, contentsMask)
{
	return entity == 0;
}

public Action:_smlib_Timer_Effect_Fade(Handle:Timer, Handle:dataPack)
{
	new entity = ReadPackCell(dataPack);
	new kill = ReadPackCell(dataPack);
	new EffectCallback:callback = ReadPackCell(dataPack);
	new data = ReadPackCell(dataPack);
	if (callback != -1)
	{
		Call_StartFunction(Handle:0, callback);
		Call_PushCell(entity);
		Call_PushCell(data);
		Call_Finish(0);
	}
	if (kill)
	{
		Entity_Kill(entity);
	}
	return Action:4;
}

bool:File_GetBaseName(String:path[], String:buffer[], size)
{
	if (path[0])
	{
		new pos_start = FindCharInString(path, 47, true);
		if (pos_start == -1)
		{
			pos_start = FindCharInString(path, 92, true);
		}
		pos_start++;
		strcopy(buffer, size, path[pos_start]);
		return false;
	}
	buffer[0] = 0;
	return false;
}

bool:File_GetDirName(String:path[], String:buffer[], size)
{
	if (path[0])
	{
		new pos_start = FindCharInString(path, 47, true);
		if (pos_start == -1)
		{
			pos_start = FindCharInString(path, 92, true);
			if (pos_start == -1)
			{
				buffer[0] = 0;
				return false;
			}
		}
		strcopy(buffer, size, path);
		buffer[pos_start] = 0;
		return false;
	}
	buffer[0] = 0;
	return false;
}

bool:File_GetFileName(String:path[], String:buffer[], size)
{
	if (path[0])
	{
		File_GetBaseName(path, buffer, size);
		new pos_ext = FindCharInString(buffer, 46, true);
		if (pos_ext != -1)
		{
			buffer[pos_ext] = 0;
		}
		return false;
	}
	buffer[0] = 0;
	return false;
}

File_GetExtension(String:path[], String:buffer[], size)
{
	new extpos = FindCharInString(path, 46, true);
	if (extpos == -1)
	{
		buffer[0] = 0;
		return 0;
	}
	extpos++;
	strcopy(buffer, size, path[extpos]);
	return 0;
}

File_AddToDownloadsTable(String:path[], bool:recursive, String:ignoreExts[][], size)
{
	if (path[0])
	{
		if (FileExists(path, false))
		{
			new String:fileExtension[4];
			File_GetExtension(path, fileExtension, 4);
			if (StrEqual(fileExtension, printToChat_excludeclient, false))
			{
				return 0;
			}
			if (Array_FindString(ignoreExts, size, fileExtension, true, 0) != -1)
			{
				return 0;
			}
			decl String:path_new[256];
			strcopy(path_new, 256, path);
			ReplaceString(path_new, 256, "//", "/", true);
			AddFileToDownloadsTable(path_new);
		}
		else
		{
			if (recursive)
			{
				decl String:dirEntry[256];
				new Handle:__dir = OpenDirectory(path);
				while (ReadDirEntry(__dir, dirEntry, 256, 0))
				{
					if (StrEqual(dirEntry, ".", true))
					{
					}
				}
				CloseHandle(__dir);
			}
			if (FindCharInString(path, 42, true))
			{
				new String:fileExtension[4];
				File_GetExtension(path, fileExtension, 4);
				if (StrEqual(fileExtension, "*", true))
				{
					decl String:dirName[256];
					decl String:fileName[256];
					decl String:dirEntry[256];
					File_GetDirName(path, dirName, 256);
					File_GetFileName(path, fileName, 256);
					StrCat(fileName, 256, ".");
					new Handle:__dir = OpenDirectory(dirName);
					while (ReadDirEntry(__dir, dirEntry, 256, 0))
					{
						if (StrEqual(dirEntry, ".", true))
						{
						}
					}
					CloseHandle(__dir);
				}
			}
		}
		return 0;
	}
	return 0;
}

bool:File_Copy(String:source[], String:destination[])
{
	new Handle:file_source = OpenFile(source, "rb");
	if (file_source)
	{
		new Handle:file_destination = OpenFile(destination, "wb");
		if (file_destination)
		{
			new buffer[32];
			new cache;
			while (!IsEndOfFile(file_source))
			{
				cache = ReadFile(file_source, buffer, 32, 1);
				WriteFile(file_destination, buffer, cache, 1);
			}
			CloseHandle(file_source);
			CloseHandle(file_destination);
			return true;
		}
		CloseHandle(file_source);
		return false;
	}
	return false;
}

bool:File_CopyRecursive(String:path[], String:destination[], bool:stop_on_error, dirMode)
{
	if (FileExists(path, false))
	{
		return File_Copy(path, destination);
	}
	if (DirExists(path))
	{
		return Sub_File_CopyRecursive(path, destination, stop_on_error, FileType:1, dirMode);
	}
	return false;
}

bool:Sub_File_CopyRecursive(String:path[], String:destination[], bool:stop_on_error, FileType:fileType, dirMode)
{
	if (fileType == FileType:2)
	{
		return File_Copy(path, destination);
	}
	if (fileType == FileType:1)
	{
		if (!CreateDirectory(destination, dirMode))
		{
			return false;
		}
		new Handle:directory = OpenDirectory(path);
		if (directory)
		{
			decl String:source_buffer[256];
			decl String:destination_buffer[256];
			new FileType:type;
			while (ReadDirEntry(directory, source_buffer, 256, type))
			{
				if (StrEqual(source_buffer, "..", true))
				{
				}
			}
			CloseHandle(directory);
		}
		return false;
	}
	else
	{
		if (fileType)
		{
		}
		else
		{
			return false;
		}
	}
	return true;
}

CPrintToChat(client, String:message[])
{
	CCheckTrie();
	if (client <= 0)
	{
		ThrowError("Invalid client index %i", client);
	}
	if (!IsClientInGame(client))
	{
		ThrowError("Client %i is not in game", client);
	}
	decl String:buffer[256];
	decl String:buffer2[256];
	SetGlobalTransTarget(client);
	Format(buffer, 256, "", message);
	VFormat(buffer2, 256, buffer, 3);
	CReplaceColorCodes(buffer2, 0, false, 256);
	CSendMessage(client, buffer2, 0);
	return 0;
}

CPrintToChatAll(String:message[])
{
	CCheckTrie();
	decl String:buffer[256];
	decl String:buffer2[256];
	new i = 1;
	while (i <= MaxClients)
	{
		if (!IsClientInGame(i))
		{
			CSkipList[i] = 0;
		}
		else
		{
			SetGlobalTransTarget(i);
			Format(buffer, 256, "", message);
			VFormat(buffer2, 256, buffer, 2);
			CReplaceColorCodes(buffer2, 0, false, 256);
			CSendMessage(i, buffer2, 0);
		}
		i++;
	}
	return 0;
}

CSendMessage(client, String:message[], author)
{
	if (!author)
	{
		author = client;
	}
	decl String:buffer[256];
	decl String:game[16];
	GetGameFolderName(game, 16);
	strcopy(buffer, 256, message);
	new UserMsg:index = GetUserMessageId("SayText2");
	if (index == UserMsg:-1)
	{
		if (StrEqual(game, "dod", true))
		{
			new team = GetClientTeam(author);
			if (team)
			{
				decl String:temp[16];
				Format(temp, 16, "\x07%06X", var2[0][0][var2][team + -1]);
				ReplaceString(buffer, 256, "\x03", temp, false);
			}
			else
			{
				ReplaceString(buffer, 256, "\x03", "\x04", false);
			}
		}
		PrintToChat(client, "%s", buffer);
		return 0;
	}
	new Handle:buf = StartMessageOne("SayText2", client, 132);
	if (GetFeatureStatus(FeatureType:0, "GetUserMessageType"))
	{
		PbSetInt(buf, "ent_idx", author, -1);
		PbSetBool(buf, "chat", true, -1);
		PbSetString(buf, "msg_name", buffer, -1);
		PbAddString(buf, "params", "");
		PbAddString(buf, "params", "");
		PbAddString(buf, "params", "");
		PbAddString(buf, "params", "");
	}
	else
	{
		BfWriteByte(buf, author);
		BfWriteByte(buf, 1);
		BfWriteString(buf, buffer);
	}
	EndMessage();
	return 0;
}

CCheckTrie()
{
	if (!CTrie)
	{
		CTrie = InitColorTrie();
	}
	return 0;
}

CReplaceColorCodes(String:buffer[], author, bool:removeTags, maxlen)
{
	CCheckTrie();
	if (!removeTags)
	{
		ReplaceString(buffer, maxlen, "{default}", "", false);
	}
	else
	{
		ReplaceString(buffer, maxlen, "{default}", "", false);
		ReplaceString(buffer, maxlen, "{teamcolor}", "", false);
	}
	if (author)
	{
		if (author < 0)
		{
			ThrowError("Invalid client index %i", author);
		}
		if (!IsClientInGame(author))
		{
			ThrowError("Client %i is not in game", author);
		}
		ReplaceString(buffer, maxlen, "{teamcolor}", "\x03", false);
	}
	new cursor;
	new value;
	decl String:tag[32];
	decl String:buff[32];
	decl output[maxlen];
	strcopy(output, maxlen, buffer);
	new Handle:regex = CompileRegex("{[a-zA-Z0-9]+}", 0, "", 0, 0);
	new i;
	while (i < 1000)
	{
		if (MatchRegex(regex, buffer[cursor], 0) < 1)
		{
			CloseHandle(regex);
			strcopy(buffer, maxlen, output);
			return 0;
		}
		GetRegexSubString(regex, 0, tag, 32);
		CStrToLower(tag);
		cursor = StrContains(buffer[cursor], tag, false) + cursor + 1;
		strcopy(buff, 32, tag);
		ReplaceString(buff, 32, "{", "", true);
		ReplaceString(buff, 32, "}", "", true);
		if (GetTrieValue(CTrie, buff, value))
		{
			if (removeTags)
			{
				ReplaceString(output, maxlen, tag, "", false);
			}
			else
			{
				Format(buff, 32, "\x07%06X", value);
				ReplaceString(output, maxlen, tag, buff, false);
			}
		}
		i++;
	}
	LogError("[MORE COLORS] Infinite loop broken.");
	return 0;
}

CStrToLower(String:buffer[])
{
	new len = strlen(buffer);
	new i;
	while (i < len)
	{
		buffer[i] = CharToLower(buffer[i]);
		i++;
	}
	return 0;
}

Handle:InitColorTrie()
{
	new Handle:hTrie = CreateTrie();
	SetTrieValue(hTrie, "aliceblue", any:15792383, true);
	SetTrieValue(hTrie, "allies", any:5077314, true);
	SetTrieValue(hTrie, "antiquewhite", any:16444375, true);
	SetTrieValue(hTrie, "aqua", any:65535, true);
	SetTrieValue(hTrie, "aquamarine", any:8388564, true);
	SetTrieValue(hTrie, "axis", any:16728128, true);
	SetTrieValue(hTrie, "azure", any:32767, true);
	SetTrieValue(hTrie, "beige", any:16119260, true);
	SetTrieValue(hTrie, "bisque", any:16770244, true);
	SetTrieValue(hTrie, "black", any:0, true);
	SetTrieValue(hTrie, "blanchedalmond", any:16772045, true);
	SetTrieValue(hTrie, "blue", any:10079487, true);
	SetTrieValue(hTrie, "blueviolet", any:9055202, true);
	SetTrieValue(hTrie, "brown", any:10824234, true);
	SetTrieValue(hTrie, "burlywood", any:14596231, true);
	SetTrieValue(hTrie, "cadetblue", any:6266528, true);
	SetTrieValue(hTrie, "chartreuse", any:8388352, true);
	SetTrieValue(hTrie, "chocolate", any:13789470, true);
	SetTrieValue(hTrie, "community", any:7385162, true);
	SetTrieValue(hTrie, "coral", any:16744272, true);
	SetTrieValue(hTrie, "cornflowerblue", any:6591981, true);
	SetTrieValue(hTrie, "cornsilk", any:16775388, true);
	SetTrieValue(hTrie, "crimson", any:14423100, true);
	SetTrieValue(hTrie, "cyan", any:65535, true);
	SetTrieValue(hTrie, "darkblue", any:139, true);
	SetTrieValue(hTrie, "darkcyan", any:35723, true);
	SetTrieValue(hTrie, "darkgoldenrod", any:12092939, true);
	SetTrieValue(hTrie, "darkgray", any:11119017, true);
	SetTrieValue(hTrie, "darkgrey", any:11119017, true);
	SetTrieValue(hTrie, "darkgreen", any:25600, true);
	SetTrieValue(hTrie, "darkkhaki", any:12433259, true);
	SetTrieValue(hTrie, "darkmagenta", any:9109643, true);
	SetTrieValue(hTrie, "darkolivegreen", any:5597999, true);
	SetTrieValue(hTrie, "darkorange", any:16747520, true);
	SetTrieValue(hTrie, "darkorchid", any:10040012, true);
	SetTrieValue(hTrie, "darkred", any:9109504, true);
	SetTrieValue(hTrie, "darksalmon", any:15308410, true);
	SetTrieValue(hTrie, "darkseagreen", any:9419919, true);
	SetTrieValue(hTrie, "darkslateblue", any:4734347, true);
	SetTrieValue(hTrie, "darkslategray", any:3100495, true);
	SetTrieValue(hTrie, "darkslategrey", any:3100495, true);
	SetTrieValue(hTrie, "darkturquoise", any:52945, true);
	SetTrieValue(hTrie, "darkviolet", any:9699539, true);
	SetTrieValue(hTrie, "deeppink", any:16716947, true);
	SetTrieValue(hTrie, "deepskyblue", any:49151, true);
	SetTrieValue(hTrie, "dimgray", any:6908265, true);
	SetTrieValue(hTrie, "dimgrey", any:6908265, true);
	SetTrieValue(hTrie, "dodgerblue", any:2003199, true);
	SetTrieValue(hTrie, "firebrick", any:11674146, true);
	SetTrieValue(hTrie, "floralwhite", any:16775920, true);
	SetTrieValue(hTrie, "forestgreen", any:2263842, true);
	SetTrieValue(hTrie, "fuchsia", any:16711935, true);
	SetTrieValue(hTrie, "fullblue", any:255, true);
	SetTrieValue(hTrie, "fullred", any:16711680, true);
	SetTrieValue(hTrie, "gainsboro", any:14474460, true);
	SetTrieValue(hTrie, "genuine", any:5076053, true);
	SetTrieValue(hTrie, "ghostwhite", any:16316671, true);
	SetTrieValue(hTrie, "gold", any:16766720, true);
	SetTrieValue(hTrie, "goldenrod", any:14329120, true);
	SetTrieValue(hTrie, "gray", any:13421772, true);
	SetTrieValue(hTrie, "grey", any:13421772, true);
	SetTrieValue(hTrie, "green", any:4128574, true);
	SetTrieValue(hTrie, "greenyellow", any:11403055, true);
	SetTrieValue(hTrie, "haunted", any:3732395, true);
	SetTrieValue(hTrie, "honeydew", any:15794160, true);
	SetTrieValue(hTrie, "hotpink", any:16738740, true);
	SetTrieValue(hTrie, "indianred", any:13458524, true);
	SetTrieValue(hTrie, "indigo", any:4915330, true);
	SetTrieValue(hTrie, "ivory", any:16777200, true);
	SetTrieValue(hTrie, "khaki", any:15787660, true);
	SetTrieValue(hTrie, "lavender", any:15132410, true);
	SetTrieValue(hTrie, "lavenderblush", any:16773365, true);
	SetTrieValue(hTrie, "lawngreen", any:8190976, true);
	SetTrieValue(hTrie, "lemonchiffon", any:16775885, true);
	SetTrieValue(hTrie, "lightblue", any:11393254, true);
	SetTrieValue(hTrie, "lightcoral", any:15761536, true);
	SetTrieValue(hTrie, "lightcyan", any:14745599, true);
	SetTrieValue(hTrie, "lightgoldenrodyellow", any:16448210, true);
	SetTrieValue(hTrie, "lightgray", any:13882323, true);
	SetTrieValue(hTrie, "lightgrey", any:13882323, true);
	SetTrieValue(hTrie, "lightgreen", any:10092441, true);
	SetTrieValue(hTrie, "lightpink", any:16758465, true);
	SetTrieValue(hTrie, "lightsalmon", any:16752762, true);
	SetTrieValue(hTrie, "lightseagreen", any:2142890, true);
	SetTrieValue(hTrie, "lightskyblue", any:8900346, true);
	SetTrieValue(hTrie, "lightslategray", any:7833753, true);
	SetTrieValue(hTrie, "lightslategrey", any:7833753, true);
	SetTrieValue(hTrie, "lightsteelblue", any:11584734, true);
	SetTrieValue(hTrie, "lightyellow", any:16777184, true);
	SetTrieValue(hTrie, "lime", any:65280, true);
	SetTrieValue(hTrie, "limegreen", any:3329330, true);
	SetTrieValue(hTrie, "linen", any:16445670, true);
	SetTrieValue(hTrie, "magenta", any:16711935, true);
	SetTrieValue(hTrie, "maroon", any:8388608, true);
	SetTrieValue(hTrie, "mediumaquamarine", any:6737322, true);
	SetTrieValue(hTrie, "mediumblue", any:205, true);
	SetTrieValue(hTrie, "mediumorchid", any:12211667, true);
	SetTrieValue(hTrie, "mediumpurple", any:9662680, true);
	SetTrieValue(hTrie, "mediumseagreen", any:3978097, true);
	SetTrieValue(hTrie, "mediumslateblue", any:8087790, true);
	SetTrieValue(hTrie, "mediumspringgreen", any:64154, true);
	SetTrieValue(hTrie, "mediumturquoise", any:4772300, true);
	SetTrieValue(hTrie, "mediumvioletred", any:13047173, true);
	SetTrieValue(hTrie, "midnightblue", any:1644912, true);
	SetTrieValue(hTrie, "mintcream", any:16121850, true);
	SetTrieValue(hTrie, "mistyrose", any:16770273, true);
	SetTrieValue(hTrie, "moccasin", any:16770229, true);
	SetTrieValue(hTrie, "navajowhite", any:16768685, true);
	SetTrieValue(hTrie, "navy", any:128, true);
	SetTrieValue(hTrie, "normal", any:11711154, true);
	SetTrieValue(hTrie, "oldlace", any:16643558, true);
	SetTrieValue(hTrie, "olive", any:10404687, true);
	SetTrieValue(hTrie, "olivedrab", any:7048739, true);
	SetTrieValue(hTrie, "orange", any:16753920, true);
	SetTrieValue(hTrie, "orangered", any:16729344, true);
	SetTrieValue(hTrie, "orchid", any:14315734, true);
	SetTrieValue(hTrie, "palegoldenrod", any:15657130, true);
	SetTrieValue(hTrie, "palegreen", any:10025880, true);
	SetTrieValue(hTrie, "paleturquoise", any:11529966, true);
	SetTrieValue(hTrie, "palevioletred", any:14184595, true);
	SetTrieValue(hTrie, "papayawhip", any:16773077, true);
	SetTrieValue(hTrie, "peachpuff", any:16767673, true);
	SetTrieValue(hTrie, "peru", any:13468991, true);
	SetTrieValue(hTrie, "pink", any:16761035, true);
	SetTrieValue(hTrie, "plum", any:14524637, true);
	SetTrieValue(hTrie, "powderblue", any:11591910, true);
	SetTrieValue(hTrie, "purple", any:8388736, true);
	SetTrieValue(hTrie, "red", any:16728128, true);
	SetTrieValue(hTrie, "rosybrown", any:12357519, true);
	SetTrieValue(hTrie, "royalblue", any:4286945, true);
	SetTrieValue(hTrie, "saddlebrown", any:9127187, true);
	SetTrieValue(hTrie, "salmon", any:16416882, true);
	SetTrieValue(hTrie, "sandybrown", any:16032864, true);
	SetTrieValue(hTrie, "seagreen", any:3050327, true);
	SetTrieValue(hTrie, "seashell", any:16774638, true);
	SetTrieValue(hTrie, "selfmade", any:7385162, true);
	SetTrieValue(hTrie, "sienna", any:10506797, true);
	SetTrieValue(hTrie, "silver", any:12632256, true);
	SetTrieValue(hTrie, "skyblue", any:8900331, true);
	SetTrieValue(hTrie, "slateblue", any:6970061, true);
	SetTrieValue(hTrie, "slategray", any:7372944, true);
	SetTrieValue(hTrie, "slategrey", any:7372944, true);
	SetTrieValue(hTrie, "snow", any:16775930, true);
	SetTrieValue(hTrie, "springgreen", any:65407, true);
	SetTrieValue(hTrie, "steelblue", any:4620980, true);
	SetTrieValue(hTrie, "strange", any:13593138, true);
	SetTrieValue(hTrie, "tan", any:13808780, true);
	SetTrieValue(hTrie, "teal", any:32896, true);
	SetTrieValue(hTrie, "thistle", any:14204888, true);
	SetTrieValue(hTrie, "tomato", any:16737095, true);
	SetTrieValue(hTrie, "turquoise", any:4251856, true);
	SetTrieValue(hTrie, "unique", any:16766720, true);
	SetTrieValue(hTrie, "unusual", any:8802476, true);
	SetTrieValue(hTrie, "valve", any:10817401, true);
	SetTrieValue(hTrie, "vintage", any:4678289, true);
	SetTrieValue(hTrie, "violet", any:15631086, true);
	SetTrieValue(hTrie, "wheat", any:16113331, true);
	SetTrieValue(hTrie, "white", any:16777215, true);
	SetTrieValue(hTrie, "whitesmoke", any:16119285, true);
	SetTrieValue(hTrie, "yellow", any:16776960, true);
	SetTrieValue(hTrie, "yellowgreen", any:10145074, true);
	return hTrie;
}

public OnPluginStart()
{
	BuildPath(PathType:0, KVPath, 256, "roleplay.txt");
	HookEvent("round_start", OnRoundStart, EventHookMode:1);
	HookEvent("player_team", OnPlayerTeam, EventHookMode:0);
	HookEvent("player_death", OnPlayerDeath, EventHookMode:1);
	PrecacheModel("models/player/leb/t_leet.mdl", true);
	PrecacheModel("models/player/notdelite/desert_sas/ct_sas.mdl", true);
	PrecacheModel("models/player/ics/ct_gign_fbi/ct_gign.mdl", true);
	PrecacheModel("models/player/natalya/police/chp_male_jacket.mdl", true);
	PrecacheModel("models/player/elis/po/police.mdl", true);
	PrecacheModel("models/player/slow/vin_diesel/slow.mdl", true);
	PrecacheModel("models/player/slow/niko_bellic/slow.mdl", true);
	PrecacheModel("models/player/slow/50cent/slow.mdl", true);
	RegConsoleCmd("sm_ent", Command_Ent, "", 0);
	RegConsoleCmd("sm_entity", Command_Entity, "", 0);
	RegConsoleCmd("sm_lock", Cmd_Lock, "", 0);
	RegConsoleCmd("sm_unlock", Cmd_Unlock, "", 0);
	RegConsoleCmd("sm_civil", Command_Civil, "", 0);
	RegConsoleCmd("sm_give", Command_Cash, "", 0);
	RegConsoleCmd("sm_jail", Command_Jail, "", 0);
	RegConsoleCmd("sm_jaillist", Command_Jaillist, "", 0);
	RegConsoleCmd("sm_vis", Command_Vis, "", 0);
	RegConsoleCmd("sm_jobmenu", Command_Jobmenu, "", 0);
	RegConsoleCmd("sm_money", Command_Money, "", 0);
	RegConsoleCmd("sm_infos", Command_Infos, "", 0);
	RegConsoleCmd("sm_tazer", Command_tazer, "", 0);
	RegConsoleCmd("sm_item", Command_Item, "", 0);
	RegConsoleCmd("sm_demission", Command_Demission, "", 0);
	RegConsoleCmd("sm_engager", Command_Engager, "", 0);
	RegConsoleCmd("sm_enquete", Command_Enquete, "", 0);
	RegConsoleCmd("sm_del", Command_Rw, "", 0);
	RegConsoleCmd("sm_rp", Command_Roleplay, "", 0);
	RegConsoleCmd("sm_perquisition", Command_Perqui, "", 0);
	RegConsoleCmd("sm_perquisitionoff", Command_PerquiOff, "", 0);
	RegConsoleCmd("sm_armurerie", Command_Armurie, "", 0);
	RegConsoleCmd("sm_out", Command_Out, "", 0);
	RegConsoleCmd("sm_vendre", Command_Vente, "", 0);
	RegConsoleCmd("sm_+force", Command_Grab, "", 0);
	RegConsoleCmd("sm_virer", Command_Virer, "", 0);
	RegConsoleCmd("sm_licencier", Command_Virer, "", 0);
	RegConsoleCmd("sm_exclure", Command_Virer, "", 0);
	RegConsoleCmd("sm_vol", Command_Vol, "", 0);
	RegConsoleCmd("sm_infoscut", Command_Infoscut, "", 0);
	RegConsoleCmd("sm_contrat", Command_Contrat, "", 0);
	RegConsoleCmd("sm_salaire", Command_Salaire, "", 0);
	RegConsoleCmd("sm_pay", Command_Salaire, "", 0);
	RegConsoleCmd("sm_paie", Command_Salaire, "", 0);
	RegConsoleCmd("sm_time", Command_Time, "", 0);
	RegConsoleCmd("sm_forum", Command_Forum, "", 0);
	Format(g_gamedesc, 64, "CSS-RP");
	RegConsoleCmd("jointeam", Block_CMD, "", 0);
	RegConsoleCmd("explode", Block_CMD, "", 0);
	RegConsoleCmd("kill", Block_CMD, "", 0);
	RegConsoleCmd("coverme", Block_CMD, "", 0);
	RegConsoleCmd("takepoint", Block_CMD, "", 0);
	RegConsoleCmd("holdpos", Block_CMD, "", 0);
	RegConsoleCmd("regroup", Block_CMD, "", 0);
	RegConsoleCmd("followme", Block_CMD, "", 0);
	RegConsoleCmd("takingfire", Block_CMD, "", 0);
	RegConsoleCmd("go", Block_CMD, "", 0);
	RegConsoleCmd("fallback", Block_CMD, "", 0);
	RegConsoleCmd("sticktog", Block_CMD, "", 0);
	RegConsoleCmd("getinpos", Block_CMD, "", 0);
	RegConsoleCmd("stormfront", Block_CMD, "", 0);
	RegConsoleCmd("report", Block_CMD, "", 0);
	RegConsoleCmd("roger", Block_CMD, "", 0);
	RegConsoleCmd("enemyspot", Block_CMD, "", 0);
	RegConsoleCmd("needbackup", Block_CMD, "", 0);
	RegConsoleCmd("sectorclear", Block_CMD, "", 0);
	RegConsoleCmd("inposition", Block_CMD, "", 0);
	RegConsoleCmd("reportingin", Block_CMD, "", 0);
	RegConsoleCmd("getout", Block_CMD, "", 0);
	RegConsoleCmd("negative", Block_CMD, "", 0);
	RegConsoleCmd("enemydown", Block_CMD, "", 0);
	RegConsoleCmd("+left", Block_CMD, "", 0);
	RegConsoleCmd("-left", Block_CMD, "", 0);
	AddCommandListener(OnSay, "say");
	AddCommandListener(OnSayTeam, "say_team");
	HookUserMessage(GetUserMessageId("TextMsg"), TextMsg, true, MsgPostHook:-1);
	return 0;
}

public SaveInfosClient(client)
{
	new Handle:DBase = CreateKeyValues("PlayerInfos", "", "");
	FileToKeyValues(DBase, KVPath);
	new String:SID[32];
	GetClientAuthString(client, SID, 32, true);
	if (KvJumpToKey(DBase, SID, true))
	{
		KvSetNum(DBase, "jobid", jobid[client][0][0]);
		KvSetNum(DBase, "cash", money[client][0][0]);
		KvSetNum(DBase, "bank", bank[client][0][0]);
		KvSetNum(DBase, "kit", kitcrochetage[client][0][0]);
		KvSetNum(DBase, "capital", capital[client][0][0]);
		KvSetNum(DBase, "jail", g_IsInJail[client][0][0]);
		KvSetNum(DBase, "jailtime", g_jailtime[client][0][0]);
		KvSetNum(DBase, "salaire", salaire[client][0][0]);
		KvSetNum(DBase, "rib", rib[client][0][0]);
		KvSetNum(DBase, "ak47", ak47[client][0][0]);
		KvSetNum(DBase, "awp", awp[client][0][0]);
		KvSetNum(DBase, "m249", m249[client][0][0]);
		KvSetNum(DBase, "scout", scout[client][0][0]);
		KvSetNum(DBase, "sg550", sg550[client][0][0]);
		KvSetNum(DBase, "sg552", sg552[client][0][0]);
		KvSetNum(DBase, "ump", ump[client][0][0]);
		KvSetNum(DBase, "tmp", tmp[client][0][0]);
		KvSetNum(DBase, "mp5", mp5[client][0][0]);
		KvSetNum(DBase, "deagle", deagle[client][0][0]);
		KvSetNum(DBase, "usp", usp[client][0][0]);
		KvSetNum(DBase, "glock", glock[client][0][0]);
		KvSetNum(DBase, "xm1014", xm1014[client][0][0]);
		KvSetNum(DBase, "m3", m3[client][0][0]);
		KvSetNum(DBase, "m4a1", m4a1[client][0][0]);
		KvSetNum(DBase, "aug", aug[client][0][0]);
		KvSetNum(DBase, "galil", galil[client][0][0]);
		KvSetNum(DBase, "mac10", mac10[client][0][0]);
		KvSetNum(DBase, "famas", famas[client][0][0]);
		KvSetNum(DBase, "p90", p90[client][0][0]);
		KvSetNum(DBase, "elite", elite[client][0][0]);
		KvSetNum(DBase, "ticket10", ticket10[client][0][0]);
		KvSetNum(DBase, "ticket100", ticket100[client][0][0]);
		KvSetNum(DBase, "ticket1000", ticket1000[client][0][0]);
		KvSetNum(DBase, "levelcut", levelcut[client][0][0]);
		KvSetNum(DBase, "cartouche", cartouche[client][0][0]);
		KvSetNum(DBase, "permislourd", permislourd[client][0][0]);
		KvSetNum(DBase, "permisleger", permisleger[client][0][0]);
		KvSetNum(DBase, "cb", cb[client][0][0]);
		KvSetNum(DBase, "prop1", props1[client][0][0]);
		KvSetNum(DBase, "prop2", props2[client][0][0]);
		KvSetNum(DBase, "heroine", heroine[client][0][0]);
		KvSetNum(DBase, "exta", exta[client][0][0]);
		KvSetNum(DBase, "lsd", lsd[client][0][0]);
		KvSetNum(DBase, "coke", coke[client][0][0]);
		KvSetNum(DBase, "pack", pack[client][0][0]);
		KvSetNum(DBase, "kevlar", kevlar[client][0][0]);
		KvSetNum(DBase, "maison", maison[client][0][0]);
		KvSetNum(DBase, "maisontime", maisontime[client][0][0]);
		KvRewind(DBase);
		KeyValuesToFile(DBase, KVPath);
		CloseHandle(DBase);
	}
	return 0;
}

public GetInfosClient(client)
{
	new Handle:DBase = CreateKeyValues("PlayerInfos", "", "");
	FileToKeyValues(DBase, KVPath);
	new String:SID[32];
	GetClientAuthString(client, SID, 32, true);
	if (KvJumpToKey(DBase, SID, true))
	{
		new a1;
		new a2;
		new a3;
		new a4;
		new a5;
		new a6;
		new a7;
		new a8;
		new a9;
		new a10;
		new a11;
		new a12;
		new a13;
		new a14;
		new a15;
		new a16;
		new a17;
		new a18;
		new a19;
		new a20;
		new a21;
		new a22;
		new a23;
		new a24;
		new a25;
		new a26;
		new a27;
		new a28;
		new a29;
		new a30;
		new a31;
		new a32;
		new a33;
		new a34;
		new a35;
		new a36;
		new a37;
		new a38;
		new a39;
		new a40;
		new a41;
		new a42;
		new a43;
		new a44;
		new a45;
		new a46;
		new a47;
		new a48;
		a1 = KvGetNum(DBase, "jobid", 0);
		a2 = KvGetNum(DBase, "cash", 20000);
		a3 = KvGetNum(DBase, "bank", 0);
		a4 = KvGetNum(DBase, "kit", 0);
		a5 = KvGetNum(DBase, "capital", 0);
		a6 = KvGetNum(DBase, "jail", 0);
		a7 = KvGetNum(DBase, "jailtime", 0);
		a8 = KvGetNum(DBase, "salaire", 50);
		a9 = KvGetNum(DBase, "rib", 1);
		a10 = KvGetNum(DBase, "ak47", 0);
		a11 = KvGetNum(DBase, "awp", 0);
		a12 = KvGetNum(DBase, "m249", 0);
		a13 = KvGetNum(DBase, "scout", 0);
		a14 = KvGetNum(DBase, "sg550", 0);
		a15 = KvGetNum(DBase, "sg552", 0);
		a16 = KvGetNum(DBase, "ump", 0);
		a17 = KvGetNum(DBase, "tmp", 0);
		a18 = KvGetNum(DBase, "mp5", 0);
		a19 = KvGetNum(DBase, "deagle", 0);
		a20 = KvGetNum(DBase, "usp", 0);
		a21 = KvGetNum(DBase, "glock", 0);
		a22 = KvGetNum(DBase, "xm1014", 0);
		a23 = KvGetNum(DBase, "m3", 0);
		a24 = KvGetNum(DBase, "m4a1", 0);
		a25 = KvGetNum(DBase, "aug", 0);
		a26 = KvGetNum(DBase, "galil", 0);
		a27 = KvGetNum(DBase, "mac10", 0);
		a28 = KvGetNum(DBase, "famas", 0);
		a29 = KvGetNum(DBase, "p90", 0);
		a30 = KvGetNum(DBase, "elite", 0);
		a31 = KvGetNum(DBase, "ticket10", 0);
		a32 = KvGetNum(DBase, "ticket100", 0);
		a33 = KvGetNum(DBase, "ticket1000", 0);
		a34 = KvGetNum(DBase, "levelcut", 0);
		a35 = KvGetNum(DBase, "cartouche", 0);
		a36 = KvGetNum(DBase, "permislourd", 0);
		a37 = KvGetNum(DBase, "permisleger", 0);
		a38 = KvGetNum(DBase, "cb", 0);
		a39 = KvGetNum(DBase, "prop1", 0);
		a40 = KvGetNum(DBase, "prop2", 0);
		a41 = KvGetNum(DBase, "heroine", 0);
		a42 = KvGetNum(DBase, "exta", 0);
		a43 = KvGetNum(DBase, "lsd", 0);
		a44 = KvGetNum(DBase, "coke", 0);
		a45 = KvGetNum(DBase, "pack", 0);
		a46 = KvGetNum(DBase, "kevlar", 0);
		a47 = KvGetNum(DBase, "maison", 0);
		a48 = KvGetNum(DBase, "maisontime", 0);
		KvRewind(DBase);
		KeyValuesToFile(DBase, KVPath);
		CloseHandle(DBase);
		jobid[client] = a1;
		money[client] = a2;
		bank[client] = a3;
		kitcrochetage[client] = a4;
		capital[client] = a5;
		g_IsInJail[client] = a6;
		g_jailtime[client] = a7;
		salaire[client] = a8;
		rib[client] = a9;
		ak47[client] = a10;
		awp[client] = a11;
		m249[client] = a12;
		scout[client] = a13;
		sg550[client] = a14;
		sg552[client] = a15;
		ump[client] = a16;
		tmp[client] = a17;
		mp5[client] = a18;
		deagle[client] = a19;
		usp[client] = a20;
		glock[client] = a21;
		xm1014[client] = a22;
		m3[client] = a23;
		m4a1[client] = a24;
		aug[client] = a25;
		galil[client] = a26;
		mac10[client] = a27;
		famas[client] = a28;
		p90[client] = a29;
		elite[client] = a30;
		ticket10[client] = a31;
		ticket100[client] = a32;
		ticket1000[client] = a33;
		levelcut[client] = a34;
		cartouche[client] = a35;
		permislourd[client] = a36;
		permisleger[client] = a37;
		cb[client] = a38;
		props1[client] = a39;
		props2[client] = a40;
		heroine[client] = a41;
		exta[client] = a42;
		lsd[client] = a43;
		coke[client] = a44;
		pack[client] = a45;
		kevlar[client] = a46;
		maison[client] = a47;
		maisontime[client] = a48;
	}
	return 0;
}

public Action:OnGetGameDescription(String:gameDesc[64])
{
	if (g_bIsMapLoaded)
	{
		strcopy(gameDesc, 64, g_gamedesc);
		return Action:1;
	}
	return Action:0;
}

public OnMapStart()
{
	new Handle:mp_startmoney = FindConVar("mp_startmoney");
	if (mp_startmoney)
	{
		SetConVarBounds(mp_startmoney, ConVarBounds:1, false, 0);
	}
	AddFileToDownloadsTable("sound/roleplay/noteam.wav");
	AddFileToDownloadsTable("sound/roleplay/salaire.wav");
	AddFileToDownloadsTable("sound/roleplay/success.wav");
	AddFileToDownloadsTable("sound/roleplay/telephone.mp3");
	PrecacheSound("doors/latchunlocked1.wav", true);
	PrecacheSound("doors/default_locked.wav", true);
	PrecacheSound("roleplay/noteam.wav", true);
	PrecacheSound("roleplay/salaire.wav", true);
	PrecacheSound("roleplay/success.wav", true);
	PrecacheSound("roleplay/telephone.mp3", true);
	PrecacheSound("ambient/machines/zap1.wav", true);
	PrecacheModel("models/player/leb/t_leet.mdl", true);
	PrecacheModel("models/player/notdelite/desert_sas/ct_sas.mdl", true);
	PrecacheModel("models/player/ics/ct_gign_fbi/ct_gign.mdl", true);
	PrecacheModel("models/player/natalya/police/chp_male_jacket.mdl", true);
	PrecacheModel("models/player/elis/po/police.mdl", true);
	PrecacheModel("models/player/slow/vin_diesel/slow.mdl", true);
	PrecacheModel("models/player/slow/niko_bellic/slow.mdl", true);
	PrecacheModel("models/player/slow/50cent/slow.mdl", true);
	PrecacheModel("models/player/slow/jamis/kingpin/slow_v2.mdl", true);
	g_modelLaser = PrecacheModel("sprites/laser.vmt", false);
	g_modelHalo = PrecacheModel("materials/sprites/halo01.vmt", false);
	g_LightingSprite = PrecacheModel("sprites/lgtning.vmt", false);
	g_BeamSprite = PrecacheModel("materials/sprites/laser.vmt", false);
	startheure();
	KillLogic();
	PrintToServer("[CSS-RP] : Le plugin Roleplay a bien démarré.");
	g_bIsMapLoaded = 1;
	gTimer = CreateTimer(0.1, UpdateObjects, any:0, 1);
	new i;
	while (i < 64)
	{
		gObj[i] = -1;
		i++;
	}
	pub = CreateTimer(90, Timer_Pub, any:0, 1);
	return 0;
}

public APLRes:AskPluginLoad2(Handle:myself, bool:late, String:error[], err_max)
{
	PrintToServer("[CSS-RP] Chargement des natives...");
	CreateNative("GetClientBank", NativeGetClientBank);
	CreateNative("SetClientBank", NativeSetClientBank);
	CreateNative("SetClientMoney", NativeSetClientMoney);
	PrintToServer("[CSS-RP] Natives chargées.");
	return APLRes:0;
}

public OnMapEnd()
{
	CloseHandle(gTimer);
	KillTimer(Timers, false);
	KillTimer(pub, false);
	g_bIsMapLoaded = 0;
	return 0;
}

public Action:OnRoundStart(Handle:event, String:name[], bool:dontBroadcast)
{
	LockingDoor();
	CPrintToChatAll("%s: Toutes les portes du serveurs on été férmé à clefs.", "{red}[CSS-RP] ");
	KillLogic();
	return Action:0;
}

public Action:OnPlayerDeath(Handle:event, String:name[], bool:dontBroadcast)
{
	new MoneyOffset = FindSendPropOffs("CCSPlayer", "m_iAccount");
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	new killer = GetClientOfUserId(GetEventInt(event, "attacker"));
	new bool:headshot = GetEventBool(event, "headshot");
	if (0 < killer)
	{
		if (IsClientInGame(killer))
		{
			if (client != killer)
			{
				if (GetClientTeam(killer) == 2)
				{
					money[killer] = GetEntData(killer, MoneyOffset, 4);
					var5 = var5[0][0][-75];
					SetEntData(killer, MoneyOffset, money[killer][0][0], 4, true);
					Client_SetScore(killer, 0);
					Client_SetDeaths(client, 0);
				}
				else
				{
					if (GetClientTeam(killer) == 3)
					{
						money[killer] = GetEntData(killer, MoneyOffset, 4);
						var6 = var6[0][0][-75];
						SetEntData(killer, MoneyOffset, money[killer][0][0], 4, true);
						Client_SetScore(killer, 0);
						Client_SetDeaths(client, 0);
					}
					if (GetClientTeam(killer) == 2)
					{
						money[killer] = GetEntData(killer, MoneyOffset, 4);
						var7 = var7[0][0][825];
						SetEntData(killer, MoneyOffset, money[killer][0][0], 4, true);
						Client_SetScore(killer, 0);
						Client_SetDeaths(client, 0);
					}
					if (GetClientTeam(killer) == 3)
					{
						money[killer] = GetEntData(killer, MoneyOffset, 4);
						var8 = var8[0][0][825];
						SetEntData(killer, MoneyOffset, money[killer][0][0], 4, true);
						Client_SetScore(killer, 0);
						Client_SetDeaths(client, 0);
					}
				}
				DestroyLevel(killer);
				if (oncontrat[killer][0][0])
				{
					HasKillCible[killer] = 1;
				}
			}
			if (headshot == true)
			{
				g_headshot[killer]++;
				if (g_headshot[killer][0][0] == 30)
				{
					CPrintToChatAll("%s: Le joueur %N a remporter le succès \x03Headshot attitude ", "{red}[CSS-RP] ", killer);
					EmitSoundToClient(killer, "roleplay/success.wav", -2, 0, 75, 0, 1, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0);
					g_succesheadshot[killer] = 1;
				}
			}
		}
	}
	gObj[client] = -1;
	if (g_IsTazed[client][0][0] == true)
	{
		g_IsTazed[client] = 0;
		KillTazer(client);
	}
	if (0 > money[client][0][0])
	{
		money[client] = 0;
	}
	if (0 > bank[client][0][0])
	{
		bank[client] = 0;
	}
	if (!IsPlayerAlive(client))
	{
		g_CountDead[client] = 10;
		g_deadtimer[client] = CreateTimer(1, Timer_Dead, client, 1);
	}
	if (g_boolexta[client][0][0])
	{
		g_boolexta[client] = 0;
	}
	if (g_boollsd[client][0][0])
	{
		g_boollsd[client] = 0;
	}
	if (g_boolcoke[client][0][0])
	{
		g_boolcoke[client] = 0;
	}
	if (g_boolhero[client][0][0])
	{
		g_boolhero[client] = 0;
	}
	if (g_chirurgie[client][0][0])
	{
		g_chirurgie[client] = 0;
	}
	return Action:0;
}

public Action:Timer_Dead(Handle:timer, client)
{
	if (IsClientInGame(client))
	{
		if (!IsPlayerAlive(client))
		{
			var1 = var1[0][0][0];
			PrintCenterText(client, "Vous êtes sur la table d'opération pendant %i secondes", g_CountDead[client]);
			g_booldead[client] = 1;
			if (g_CountDead[client][0][0])
			{
				switch (GetRandomInt(1, 5))
				{
					case 1:
					{
						TeleportEntity(client, 40868, NULL_VECTOR, NULL_VECTOR);
					}
					case 2:
					{
						TeleportEntity(client, 40880, NULL_VECTOR, NULL_VECTOR);
					}
					case 3:
					{
						TeleportEntity(client, 40892, NULL_VECTOR, NULL_VECTOR);
					}
					case 4:
					{
						TeleportEntity(client, 40904, NULL_VECTOR, NULL_VECTOR);
					}
					case 5:
					{
						TeleportEntity(client, 40916, NULL_VECTOR, NULL_VECTOR);
					}
					default:
					{
					}
				}
			}
			else
			{
				CS_RespawnPlayer(client);
				disarm(client);
				GivePlayerItem(client, "weapon_knife", 0);
				CPrintToChat(client, "%s: Une ambulance a retrouvé votre corps, et vous a fait les premiers soins. ", "{red}[CSS-RP] ");
				ClientCommand(client, "r_screenoverlay 0");
				if (jobid[client][0][0])
				{
					if (jobid[client][0][0] == 1)
					{
						CS_SwitchTeam(client, 3);
						SetEntityHealth(client, 500);
						CS_SetClientClanTag(client, "C. Police -");
					}
					if (jobid[client][0][0] == 2)
					{
						CS_SwitchTeam(client, 3);
						CS_SetClientClanTag(client, "Agent CIA -");
						SetEntityHealth(client, 400);
					}
					if (jobid[client][0][0] == 3)
					{
						CS_SwitchTeam(client, 3);
						CS_SetClientClanTag(client, "Agent du FBI -");
						SetEntityHealth(client, 300);
					}
					if (jobid[client][0][0] == 4)
					{
						CS_SwitchTeam(client, 3);
						CS_SetClientClanTag(client, "Policier -");
						SetEntityHealth(client, 200);
					}
					if (jobid[client][0][0] == 5)
					{
						CS_SwitchTeam(client, 3);
						CS_SetClientClanTag(client, "Gardien -");
						SetEntityHealth(client, 150);
					}
					if (jobid[client][0][0] == 6)
					{
						CS_SwitchTeam(client, 2);
						CS_SetClientClanTag(client, "C. Mafia -");
						SetEntityHealth(client, 100);
					}
					if (jobid[client][0][0] == 7)
					{
						CS_SwitchTeam(client, 2);
						CS_SetClientClanTag(client, "Mafieux -");
						SetEntityHealth(client, 100);
					}
					if (jobid[client][0][0] == 8)
					{
						CS_SwitchTeam(client, 2);
						CS_SetClientClanTag(client, "A. Mafieux -");
						SetEntityHealth(client, 100);
					}
					if (jobid[client][0][0] == 9)
					{
						CS_SwitchTeam(client, 2);
						CS_SetClientClanTag(client, "C. Dealer -");
						SetEntityHealth(client, 100);
					}
					if (jobid[client][0][0] == 10)
					{
						CS_SwitchTeam(client, 2);
						CS_SetClientClanTag(client, "Dealer -");
						SetEntityHealth(client, 100);
					}
					if (jobid[client][0][0] == 11)
					{
						CS_SwitchTeam(client, 2);
						CS_SetClientClanTag(client, "A. Dealer -");
						SetEntityHealth(client, 100);
					}
					if (jobid[client][0][0] == 12)
					{
						CS_SwitchTeam(client, 2);
						CS_SetClientClanTag(client, "C. Coach -");
						SetEntityHealth(client, 100);
					}
					if (jobid[client][0][0] == 13)
					{
						CS_SwitchTeam(client, 2);
						CS_SetClientClanTag(client, "Coach -");
						SetEntityHealth(client, 100);
					}
					if (jobid[client][0][0] == 14)
					{
						CS_SwitchTeam(client, 2);
						CS_SetClientClanTag(client, "A. Coach -");
						SetEntityHealth(client, 100);
					}
					if (jobid[client][0][0] == 15)
					{
						CS_SwitchTeam(client, 2);
						CS_SetClientClanTag(client, "C. Ikea -");
						SetEntityHealth(client, 100);
					}
					if (jobid[client][0][0] == 16)
					{
						CS_SwitchTeam(client, 2);
						CS_SetClientClanTag(client, "V. Ikea -");
						SetEntityHealth(client, 100);
					}
					if (jobid[client][0][0] == 17)
					{
						CS_SwitchTeam(client, 2);
						CS_SetClientClanTag(client, "A.V. Ikea -");
						SetEntityHealth(client, 100);
					}
					if (jobid[client][0][0] == 18)
					{
						CS_SwitchTeam(client, 2);
						CS_SetClientClanTag(client, "C. Armurie -");
						SetEntityHealth(client, 100);
					}
					if (jobid[client][0][0] == 19)
					{
						CS_SwitchTeam(client, 2);
						CS_SetClientClanTag(client, "Armurier -");
						SetEntityHealth(client, 100);
					}
					if (jobid[client][0][0] == 20)
					{
						CS_SwitchTeam(client, 2);
						CS_SetClientClanTag(client, "A. Armurier -");
						SetEntityHealth(client, 100);
					}
					if (jobid[client][0][0] == 21)
					{
						CS_SwitchTeam(client, 2);
						CS_SetClientClanTag(client, "C. Loto -");
						SetEntityHealth(client, 100);
					}
					if (jobid[client][0][0] == 22)
					{
						CS_SwitchTeam(client, 2);
						CS_SetClientClanTag(client, "V. de Ticket -");
						SetEntityHealth(client, 100);
					}
					if (jobid[client][0][0] == 23)
					{
						CS_SwitchTeam(client, 2);
						CS_SetClientClanTag(client, "A.V. de Ticket -");
						SetEntityHealth(client, 100);
					}
					if (jobid[client][0][0] == 24)
					{
						CS_SwitchTeam(client, 2);
						CS_SetClientClanTag(client, "C. Banquier -");
						SetEntityHealth(client, 100);
					}
					if (jobid[client][0][0] == 25)
					{
						CS_SwitchTeam(client, 2);
						CS_SetClientClanTag(client, "Banquier -");
						SetEntityHealth(client, 100);
					}
					if (jobid[client][0][0] == 26)
					{
						CS_SwitchTeam(client, 2);
						CS_SetClientClanTag(client, "A. Banquier -");
						SetEntityHealth(client, 100);
					}
					if (jobid[client][0][0] == 27)
					{
						CS_SwitchTeam(client, 2);
						CS_SetClientClanTag(client, "D. Hopital -");
						SetEntityHealth(client, 100);
					}
					if (jobid[client][0][0] == 28)
					{
						CS_SwitchTeam(client, 2);
						CS_SetClientClanTag(client, "Médecin -");
						SetEntityHealth(client, 100);
					}
					if (jobid[client][0][0] == 29)
					{
						CS_SwitchTeam(client, 2);
						CS_SetClientClanTag(client, "Infirmier -");
						SetEntityHealth(client, 100);
					}
					if (jobid[client][0][0] == 30)
					{
						CS_SwitchTeam(client, 2);
						CS_SetClientClanTag(client, "Chirurgien -");
						SetEntityHealth(client, 100);
					}
					if (jobid[client][0][0] == 31)
					{
						CS_SwitchTeam(client, 2);
						CS_SetClientClanTag(client, "C. Artificier -");
						SetEntityHealth(client, 100);
					}
					if (jobid[client][0][0] == 32)
					{
						CS_SwitchTeam(client, 2);
						CS_SetClientClanTag(client, "Artificier -");
						SetEntityHealth(client, 100);
					}
					if (jobid[client][0][0] == 33)
					{
						CS_SwitchTeam(client, 2);
						CS_SetClientClanTag(client, "A. Artificier -");
						SetEntityHealth(client, 100);
					}
					if (jobid[client][0][0] == 34)
					{
						CS_SwitchTeam(client, 2);
						CS_SetClientClanTag(client, "C. Tueur -");
						SetEntityHealth(client, 100);
					}
					if (jobid[client][0][0] == 35)
					{
						CS_SwitchTeam(client, 2);
						CS_SetClientClanTag(client, "Tueur d'élite -");
						SetEntityHealth(client, 100);
					}
					if (jobid[client][0][0] == 36)
					{
						CS_SwitchTeam(client, 2);
						CS_SetClientClanTag(client, "Tueur novice -");
						SetEntityHealth(client, 100);
					}
					if (jobid[client][0][0] == 37)
					{
						CS_SwitchTeam(client, 2);
						CS_SetClientClanTag(client, "D. Hotel -");
						SetEntityHealth(client, 100);
					}
					if (jobid[client][0][0] == 38)
					{
						CS_SwitchTeam(client, 2);
						CS_SetClientClanTag(client, "Hotelier -");
						SetEntityHealth(client, 100);
					}
					if (jobid[client][0][0] == 39)
					{
						CS_SwitchTeam(client, 2);
						CS_SetClientClanTag(client, "A. Hotelier -");
						SetEntityHealth(client, 100);
					}
				}
				else
				{
					CS_SwitchTeam(client, 2);
					SetEntityHealth(client, 100);
					CS_SetClientClanTag(client, "Chômeur -");
				}
				chooseskin(client);
				if (0 < g_jailtime[client][0][0])
				{
					switch (GetRandomInt(1, 4))
					{
						case 1:
						{
							TeleportEntity(client, 40776, NULL_VECTOR, NULL_VECTOR);
						}
						case 2:
						{
							TeleportEntity(client, 40788, NULL_VECTOR, NULL_VECTOR);
						}
						case 3:
						{
							TeleportEntity(client, 40800, NULL_VECTOR, NULL_VECTOR);
						}
						case 4:
						{
							TeleportEntity(client, 40812, NULL_VECTOR, NULL_VECTOR);
						}
						default:
						{
						}
					}
					SetClientListeningFlags(client, 1);
					SetEntityModel(client, "models/player/natalya/prison/prisoner.mdl");
				}
			}
			KillTimer(g_deadtimer[client][0][0], false);
			g_booldead[client] = 0;
		}
	}
	return Action:0;
}

public Action:OnPlayerTeam(Handle:event, String:name[], bool:dontBroadcast)
{
	return Action:3;
}

public Action:OnPlayerConnect(Handle:event, String:name[], bool:dontBroadcast)
{
	return Action:3;
}

public Action:OnClientPreAdminCheck(client)
{
	CreateTimer(1, Timer_Choose, client, 0);
	CreateTimer(5, Timer_Tag, client, 0);
	TimerHud[client] = CreateTimer(0.7, HudTimer, client, 1);
	if (0 < maisontime[client][0][0])
	{
		TimerAppart[client] = CreateTimer(1, Timer_Appart, client, 1);
		g_appart[client] = 1;
	}
	gObj[client] = -1;
	SDKHook(client, SDKHookType:16, OnWeaponEquip);
	SDKHook(client, SDKHookType:2, OnTakeDamagePre);
	responsable[client] = 0;
	price[client] = 0;
	jail[client] = 0;
	TransactionWith[client] = 0;
	cible[client] = 0;
	acheteur[client] = 0;
	oncontrat[client] = 0;
	OnKit[client] = 0;
	return Action:0;
}

public OnClientSettingsChanged(client)
{
	change_tag(client);
	return 0;
}

public OnClientPutInServer(client)
{
	if (client)
	{
		GetInfosClient(client);
		if (g_jailtime[client][0][0] > 1)
		{
			TeleportEntity(client, 40928, NULL_VECTOR, NULL_VECTOR);
		}
		g_boolexta[client] = 0;
		g_boolhero[client] = 0;
		g_boollsd[client] = 0;
		g_boolcoke[client] = 0;
		g_chirurgie[client] = 0;
	}
	return 0;
}

public startheure()
{
	Timers = CreateTimer(1, Timer_Horloge, any:0, 1);
	return 0;
}

public Action:Timer_Horloge(Handle:timer, client)
{
	g_countminute2 = g_countminute2 + 1;
	if (g_countminute2 >= 10)
	{
		g_countminute2 = 0;
		g_countminute1 = g_countminute1 + 1;
		if (g_countminute1 >= 6)
		{
			g_countminute1 = 0;
			g_countheure2 = g_countheure2 + 1;
			if (g_countheure2 >= 10)
			{
				g_countheure2 = 0;
				g_countheure1 = g_countheure1 + 1;
			}
		}
	}
	if (g_countheure1 >= 2)
	{
		g_countheure1 = 0;
		g_countheure2 = 0;
		new i = 1;
		while (i <= MaxClients)
		{
			if (IsClientInGame(i))
			{
				GiveSalaire(i);
				capital[rankid[i][0][0]] = capital[rankid[i][0][0]][0][0] - salaire[i][0][0];
				EmitSoundToClient(i, "roleplay/salaire.wav", -2, 0, 75, 0, 1, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0);
				i++;
			}
			i++;
		}
	}
	if (g_countheure1)
	{
		Jour();
		CPrintToChatAll("%s: Après cette nuit mouvementé, le jour se lève sur riverside!", "{red}[CSS-RP] ");
		new maxent = GetMaxEntities();
		new String:szClass[68];
		new i = MaxClients;
		while (i <= maxent)
		{
			if (IsValidEdict(i))
			{
				GetEdictClassname(i, szClass, 65);
				if (StrEqual("light_dynamic", szClass, true))
				{
					RemoveEdict(i);
					i++;
				}
				i++;
			}
			i++;
		}
	}
	if (g_countheure1 == 1)
	{
		Nuit();
		CPrintToChatAll("%s: Après cette journée mouvementé, la nuit tombe sur riverside!", "{red}[CSS-RP] ");
	}
	return Action:0;
}

Jour()
{
	new maxent = GetMaxEntities();
	new String:szClass[68];
	new String:Name[200];
	new i = MaxClients;
	while (i <= maxent)
	{
		if (IsValidEdict(i))
		{
			GetEdictClassname(i, szClass, 65);
			if (StrEqual("point_spotlight", szClass, true))
			{
				AcceptEntityInput(i, "LightOff", -1, -1, 0);
				i++;
			}
			if (StrEqual("light_spot", szClass, true))
			{
				AcceptEntityInput(i, "TurnOff", -1, -1, 0);
				i++;
			}
			if (StrEqual("env_sun", szClass, true))
			{
				AcceptEntityInput(i, "TurnOn", -1, -1, 0);
				i++;
			}
			if (StrEqual("light_environment", szClass, true))
			{
				AcceptEntityInput(i, "TurnOn", -1, -1, 0);
				i++;
			}
			if (StrEqual("func_brush", szClass, true))
			{
				Entity_GetName(i, Name, 200);
				if (StrEqual(Name, "night_skybox", true))
				{
					DispatchKeyValue(i, "renderamt", "0");
					i++;
				}
				i++;
			}
			i++;
		}
		i++;
	}
	return 0;
}

Nuit()
{
	new maxent = GetMaxEntities();
	new String:szClass[68];
	new String:Name[200];
	new i = MaxClients;
	while (i <= maxent)
	{
		if (IsValidEdict(i))
		{
			GetEdictClassname(i, szClass, 65);
			if (StrEqual("point_spotlight", szClass, true))
			{
				AcceptEntityInput(i, "LightOn", -1, -1, 0);
				i++;
			}
			if (StrEqual("light_spot", szClass, true))
			{
				AcceptEntityInput(i, "TurnOn", -1, -1, 0);
				i++;
			}
			if (StrEqual("env_sun", szClass, true))
			{
				AcceptEntityInput(i, "TurnOff", -1, -1, 0);
				i++;
			}
			if (StrEqual("light_environment", szClass, true))
			{
				AcceptEntityInput(i, "TurnOff", -1, -1, 0);
				i++;
			}
			if (StrEqual("func_brush", szClass, true))
			{
				Entity_GetName(i, Name, 200);
				if (StrEqual(Name, "night_skybox", true))
				{
					DispatchKeyValue(i, "renderamt", "255");
					i++;
				}
				i++;
			}
			i++;
		}
		i++;
	}
	return 0;
}

public GiveSalaire(client)
{
	if (IsPlayerAlive(client))
	{
		if (g_IsInJail[client][0][0])
		{
			CPrintToChat(client, "%s: Vous êtes en prison, vous n'avez pas votre salaire.", "{red}[CSS-RP] ");
		}
		else
		{
			AddCash(client, salaire[client][0][0]);
		}
	}
	else
	{
		CPrintToChat(client, "%s: Vous devez être vivant pour avoir votre salaire.", "{red}[CSS-RP] ");
	}
	return 0;
}

AddCash(client, montant)
{
	new MoneyOffset = FindSendPropOffs("CCSPlayer", "m_iAccount");
	new current = money[client][0][0][montant];
	CPrintToChat(client, "%s: Vous avez reçu votre salaire de %d€", "{red}[CSS-RP] ", montant);
	SetEntData(client, MoneyOffset, current, 4, true);
	return 0;
}

AdCash(client, montant)
{
	new MoneyOffset = FindSendPropOffs("CCSPlayer", "m_iAccount");
	new current = money[client][0][0][montant];
	SetEntData(client, MoneyOffset, current, 4, true);
	return 0;
}

public Action:Block_CMD(client, Args)
{
	return Action:3;
}

LockingDoor()
{
	LockingEntity("func_door_rotating");
	LockingEntity("prop_door_rotating");
	LockingEntity("func_door");
	return 0;
}

LockingEntity(String:ClassName[])
{
	new entity = -1;
	entity = var2;
	while (var2 != -1)
	{
		if (IsValidEdict(entity))
		{
			SetEntProp(entity, PropType:1, "m_bLocked", any:1, 1, 0);
		}
	}
	return 0;
}

public Action:OnSay(client, String:command[], args)
{
	if (client)
	{
		if (IsClientInGame(client))
		{
			if (!IsFakeClient(client))
			{
				if (!IsPlayerAlive(client))
				{
					CPrintToChat(client, "%s: Vous devez être en vie pour parler avec les citoyens.", "{red}[CSS-RP] ");
					return Action:3;
				}
				if (0 < g_IsInJail[client][0][0])
				{
					CPrintToChat(client, "%s: Les prisonniers ne peuvent pas parler avec les citoyens.", "{red}[CSS-RP] ");
					return Action:3;
				}
			}
		}
	}
	return Action:0;
}

public Action:OnSayTeam(client, String:command[], args)
{
	if (client > 0)
	{
		if (IsClientInGame(client))
		{
			if (IsPlayerAlive(client))
			{
				decl String:text[128];
				GetCmdArg(1, text, 128);
				CPrintToChatAll("%s de \x03 %N ", "{grey}[CHUCHOTEMENT] ", client, text);
				return Action:3;
			}
		}
	}
	return Action:0;
}

public Action:Timer_Tag(Handle:timer, client)
{
	if (IsClientInGame(client))
	{
		change_tag(client);
	}
	return Action:0;
}

public change_tag(client)
{
	if (IsClientInGame(client))
	{
		if (jobid[client][0][0] == 1)
		{
			CS_SetClientClanTag(client, "C. Etat -");
		}
		if (jobid[client][0][0])
		{
			if (jobid[client][0][0] == 2)
			{
				CS_SetClientClanTag(client, "Agent C.I.A -");
			}
			if (jobid[client][0][0] == 3)
			{
				CS_SetClientClanTag(client, "Agent du F.B.I -");
			}
			if (jobid[client][0][0] == 4)
			{
				CS_SetClientClanTag(client, "Policier -");
			}
			if (jobid[client][0][0] == 5)
			{
				CS_SetClientClanTag(client, "Gardien -");
			}
			if (jobid[client][0][0] == 6)
			{
				CS_SetClientClanTag(client, "C. Mafia -");
			}
			if (jobid[client][0][0] == 7)
			{
				CS_SetClientClanTag(client, "Mafieux -");
			}
			if (jobid[client][0][0] == 8)
			{
				CS_SetClientClanTag(client, "A. Mafieux -");
			}
			if (jobid[client][0][0] == 9)
			{
				CS_SetClientClanTag(client, "C. Dealer -");
			}
			if (jobid[client][0][0] == 10)
			{
				CS_SetClientClanTag(client, "Dealer -");
			}
			if (jobid[client][0][0] == 11)
			{
				CS_SetClientClanTag(client, "A. Dealer -");
			}
			if (jobid[client][0][0] == 12)
			{
				CS_SetClientClanTag(client, "C. Coach -");
			}
			if (jobid[client][0][0] == 13)
			{
				CS_SetClientClanTag(client, "Coach -");
			}
			if (jobid[client][0][0] == 14)
			{
				CS_SetClientClanTag(client, "A. Coach -");
			}
			if (jobid[client][0][0] == 15)
			{
				CS_SetClientClanTag(client, "D. Ikea -");
			}
			if (jobid[client][0][0] == 16)
			{
				CS_SetClientClanTag(client, "V. Ikea -");
			}
			if (jobid[client][0][0] == 17)
			{
				CS_SetClientClanTag(client, "A.V. Ikea -");
			}
			if (jobid[client][0][0] == 18)
			{
				CS_SetClientClanTag(client, "C. Armurie -");
			}
			if (jobid[client][0][0] == 19)
			{
				CS_SetClientClanTag(client, "Armurier -");
			}
			if (jobid[client][0][0] == 20)
			{
				CS_SetClientClanTag(client, "A. Armurier -");
			}
			if (jobid[client][0][0] == 21)
			{
				CS_SetClientClanTag(client, "C. Loto -");
			}
			if (jobid[client][0][0] == 22)
			{
				CS_SetClientClanTag(client, "V. de Ticket -");
			}
			if (jobid[client][0][0] == 23)
			{
				CS_SetClientClanTag(client, "A.V. de Ticket -");
			}
			if (jobid[client][0][0] == 24)
			{
				CS_SetClientClanTag(client, "D. Banque -");
			}
			if (jobid[client][0][0] == 25)
			{
				CS_SetClientClanTag(client, "Banquier -");
			}
			if (jobid[client][0][0] == 26)
			{
				CS_SetClientClanTag(client, "A. Banquier -");
			}
			if (jobid[client][0][0] == 27)
			{
				CS_SetClientClanTag(client, "D. Hopital -");
			}
			if (jobid[client][0][0] == 28)
			{
				CS_SetClientClanTag(client, "Médecin -");
			}
			if (jobid[client][0][0] == 29)
			{
				CS_SetClientClanTag(client, "Infirmier -");
			}
			if (jobid[client][0][0] == 30)
			{
				CS_SetClientClanTag(client, "Chirurgien -");
			}
			if (jobid[client][0][0] == 31)
			{
				CS_SetClientClanTag(client, "C. Artificier -");
			}
			if (jobid[client][0][0] == 32)
			{
				CS_SetClientClanTag(client, "Artificier -");
			}
			if (jobid[client][0][0] == 33)
			{
				CS_SetClientClanTag(client, "A. Artificier -");
			}
			if (jobid[client][0][0] == 34)
			{
				CS_SetClientClanTag(client, "C. Tueur -");
			}
			if (jobid[client][0][0] == 35)
			{
				CS_SetClientClanTag(client, "Tueur d'élite -");
			}
			if (jobid[client][0][0] == 36)
			{
				CS_SetClientClanTag(client, "Tueur novice -");
			}
			if (jobid[client][0][0] == 37)
			{
				CS_SetClientClanTag(client, "D. Immobilier -");
			}
			if (jobid[client][0][0] == 38)
			{
				CS_SetClientClanTag(client, "V. Immobilier -");
			}
			if (jobid[client][0][0] == 39)
			{
				CS_SetClientClanTag(client, "A.V Immobilier -");
			}
		}
		CS_SetClientClanTag(client, "Chômeur -");
	}
	return 0;
}

public chooseskin(client)
{
	if (jobid[client][0][0] > 5)
	{
		switch (GetRandomInt(1, 3))
		{
			case 1:
			{
				SetEntityModel(client, "models/player/slow/vin_diesel/slow.mdl");
			}
			case 2:
			{
				SetEntityModel(client, "models/player/slow/niko_bellic/slow.mdl");
			}
			case 3:
			{
				SetEntityModel(client, "models/player/slow/50cent/slow.mdl");
			}
			default:
			{
			}
		}
	}
	else
	{
		if (jobid[client][0][0] == 1)
		{
			SetEntityModel(client, "models/player/leb/t_leet.mdl");
		}
		if (jobid[client][0][0] == 2)
		{
			SetEntityModel(client, "models/player/notdelite/desert_sas/ct_sas.mdl");
		}
		if (jobid[client][0][0] == 3)
		{
			SetEntityModel(client, "models/player/ics/ct_gign_fbi/ct_gign.mdl");
		}
		if (jobid[client][0][0] == 4)
		{
			SetEntityModel(client, "models/player/natalya/police/chp_male_jacket.mdl");
		}
		if (jobid[client][0][0] == 5)
		{
			SetEntityModel(client, "models/player/elis/po/police.mdl");
		}
	}
	return 0;
}

public Action:Timer_Choose(Handle:timer, client)
{
	if (IsClientInGame(client))
	{
		ClientCommand(client, "r_screenoverlay 0");
		new Handle:menu = CreateMenu(Connect_Menu, MenuAction:28);
		SetMenuTitle(menu, "%s", "AltayirRP - BETA 1.0");
		if (jobid[client][0][0] == 1)
		{
			CS_SwitchTeam(client, 3);
			CS_RespawnPlayer(client);
			SetEntityHealth(client, 500);
			rankid[client] = 1;
			AddMenuItem(menu, "job", "-------------------", 1);
			AddMenuItem(menu, "job", "Métier: Chef d'État", 1);
			AddMenuItem(menu, "job", "Rôle: Gérer le gouvernement", 1);
			AddMenuItem(menu, "", "-------------------", 1);
		}
		else
		{
			if (jobid[client][0][0])
			{
				if (jobid[client][0][0] == 2)
				{
					CS_SwitchTeam(client, 3);
					CS_RespawnPlayer(client);
					SetEntityHealth(client, 400);
					rankid[client] = 1;
					AddMenuItem(menu, "", "-------------------", 1);
					AddMenuItem(menu, "", "Métier: Agent de la C.I.A", 1);
					AddMenuItem(menu, "", "Rôle: Faire respecter l'ordre dans la ville", 1);
					AddMenuItem(menu, "", "-------------------", 1);
				}
				if (jobid[client][0][0] == 3)
				{
					CS_SwitchTeam(client, 3);
					CS_RespawnPlayer(client);
					SetEntityHealth(client, 300);
					rankid[client] = 1;
					AddMenuItem(menu, "", "-------------------", 1);
					AddMenuItem(menu, "", "Métier: Agent du F.B.I", 1);
					AddMenuItem(menu, "", "Rôle: Faire respecter l'ordre dans la ville", 1);
					AddMenuItem(menu, "", "-------------------", 1);
				}
				if (jobid[client][0][0] == 4)
				{
					CS_SwitchTeam(client, 3);
					CS_RespawnPlayer(client);
					SetEntityHealth(client, 200);
					rankid[client] = 1;
					AddMenuItem(menu, "", "-------------------", 1);
					AddMenuItem(menu, "", "Métier: Agent de police", 1);
					AddMenuItem(menu, "", "Rôle: Faire respecter l'ordre dans la ville", 1);
					AddMenuItem(menu, "", "-------------------", 1);
				}
				if (jobid[client][0][0] == 5)
				{
					CS_SwitchTeam(client, 3);
					CS_RespawnPlayer(client);
					SetEntityHealth(client, 150);
					rankid[client] = 1;
					AddMenuItem(menu, "", "-------------------", 1);
					AddMenuItem(menu, "", "Métier: Gardien", 1);
					AddMenuItem(menu, "", "Rôle: Faire respecter l'ordre dans la ville", 1);
					AddMenuItem(menu, "", "-------------------", 1);
				}
				if (jobid[client][0][0] == 6)
				{
					CS_SwitchTeam(client, 2);
					CS_RespawnPlayer(client);
					rankid[client] = 2;
					AddMenuItem(menu, "", "-------------------", 1);
					AddMenuItem(menu, "", "Métier: Chef de la mafia", 1);
					AddMenuItem(menu, "", "Rôle: Terroriser la population", 1);
					AddMenuItem(menu, "", "-------------------", 1);
				}
				if (jobid[client][0][0] == 7)
				{
					CS_SwitchTeam(client, 2);
					CS_RespawnPlayer(client);
					rankid[client] = 2;
					AddMenuItem(menu, "", "-------------------", 1);
					AddMenuItem(menu, "", "Métier: Mafieux", 1);
					AddMenuItem(menu, "", "Rôle: Terroriser la population", 1);
					AddMenuItem(menu, "", "-------------------", 1);
				}
				if (jobid[client][0][0] == 8)
				{
					CS_SwitchTeam(client, 2);
					CS_RespawnPlayer(client);
					rankid[client] = 2;
					AddMenuItem(menu, "", "-------------------", 1);
					AddMenuItem(menu, "", "Métier: Apprenti Mafieux", 1);
					AddMenuItem(menu, "", "Rôle: Terroriser la population", 1);
					AddMenuItem(menu, "", "-------------------", 1);
				}
				if (jobid[client][0][0] == 9)
				{
					CS_SwitchTeam(client, 2);
					CS_RespawnPlayer(client);
					rankid[client] = 3;
					AddMenuItem(menu, "", "-------------------", 1);
					AddMenuItem(menu, "", "Métier: Chef Dealer", 1);
					AddMenuItem(menu, "", "Rôle: Faire marcher le business de la drogue", 1);
					AddMenuItem(menu, "", "-------------------", 1);
				}
				if (jobid[client][0][0] == 10)
				{
					CS_SwitchTeam(client, 2);
					CS_RespawnPlayer(client);
					rankid[client] = 3;
					AddMenuItem(menu, "", "-------------------", 1);
					AddMenuItem(menu, "", "Métier: Dealer", 1);
					AddMenuItem(menu, "", "Rôle: Faire marcher le business de la drogue", 1);
					AddMenuItem(menu, "", "-------------------", 1);
				}
				if (jobid[client][0][0] == 11)
				{
					CS_SwitchTeam(client, 2);
					CS_RespawnPlayer(client);
					rankid[client] = 3;
					AddMenuItem(menu, "", "-------------------", 1);
					AddMenuItem(menu, "", "Métier: Apprenti Dealer", 1);
					AddMenuItem(menu, "", "Rôle: Faire marcher le business de la drogue", 1);
					AddMenuItem(menu, "", "-------------------", 1);
				}
				if (jobid[client][0][0] == 12)
				{
					CS_SwitchTeam(client, 2);
					CS_RespawnPlayer(client);
					rankid[client] = 4;
					AddMenuItem(menu, "", "-------------------", 1);
					AddMenuItem(menu, "", "Métier: Chef Coach", 1);
					AddMenuItem(menu, "", "Rôle: Apprendre à la population à se défendre !", 1);
					AddMenuItem(menu, "", "-------------------", 1);
				}
				if (jobid[client][0][0] == 13)
				{
					CS_SwitchTeam(client, 2);
					CS_RespawnPlayer(client);
					rankid[client] = 4;
					AddMenuItem(menu, "", "-------------------", 1);
					AddMenuItem(menu, "", "Métier: Coach", 1);
					AddMenuItem(menu, "", "Rôle: Apprendre à la population à se défendre !", 1);
					AddMenuItem(menu, "", "-------------------", 1);
				}
				if (jobid[client][0][0] == 14)
				{
					CS_SwitchTeam(client, 2);
					CS_RespawnPlayer(client);
					rankid[client] = 4;
					AddMenuItem(menu, "", "-------------------", 1);
					AddMenuItem(menu, "", "Métier: Apprenti Coach", 1);
					AddMenuItem(menu, "", "Rôle: Apprendre à la population à se défendre !", 1);
					AddMenuItem(menu, "", "-------------------", 1);
				}
				if (jobid[client][0][0] == 15)
				{
					CS_SwitchTeam(client, 2);
					CS_RespawnPlayer(client);
					rankid[client] = 5;
					AddMenuItem(menu, "", "-------------------", 1);
					AddMenuItem(menu, "", "Métier: Directeur de Ikea", 1);
					AddMenuItem(menu, "", "Rôle: Vendre des meubles pour aménager son chez-soi !", 1);
					AddMenuItem(menu, "", "-------------------", 1);
				}
				if (jobid[client][0][0] == 16)
				{
					CS_SwitchTeam(client, 2);
					CS_RespawnPlayer(client);
					rankid[client] = 5;
					AddMenuItem(menu, "", "-------------------", 1);
					AddMenuItem(menu, "", "Métier: Vendeur Ikea", 1);
					AddMenuItem(menu, "", "Rôle: Vendre des meubles pour aménager son chez-soi !", 1);
					AddMenuItem(menu, "", "-------------------", 1);
				}
				if (jobid[client][0][0] == 17)
				{
					CS_SwitchTeam(client, 2);
					CS_RespawnPlayer(client);
					rankid[client] = 5;
					AddMenuItem(menu, "", "-------------------", 1);
					AddMenuItem(menu, "", "Métier: Apprenti Vendeur Ikea", 1);
					AddMenuItem(menu, "", "Rôle: Vendre des meubles pour aménager son chez-soi !", 1);
					AddMenuItem(menu, "", "-------------------", 1);
				}
				if (jobid[client][0][0] == 18)
				{
					CS_SwitchTeam(client, 2);
					CS_RespawnPlayer(client);
					rankid[client] = 6;
					AddMenuItem(menu, "", "-------------------", 1);
					AddMenuItem(menu, "", "Métier: Chef de l'armurerie", 1);
					AddMenuItem(menu, "", "Rôle: Vendre des armes pour pouvoir se défendre !", 1);
					AddMenuItem(menu, "", "-------------------", 1);
				}
				if (jobid[client][0][0] == 19)
				{
					CS_SwitchTeam(client, 2);
					CS_RespawnPlayer(client);
					rankid[client] = 6;
					AddMenuItem(menu, "", "-------------------", 1);
					AddMenuItem(menu, "", "Métier: Armurier", 1);
					AddMenuItem(menu, "", "Rôle: Vendre des armes pour pouvoir se défendre !", 1);
					AddMenuItem(menu, "", "-------------------", 1);
				}
				if (jobid[client][0][0] == 20)
				{
					CS_SwitchTeam(client, 2);
					CS_RespawnPlayer(client);
					rankid[client] = 6;
					AddMenuItem(menu, "", "-------------------", 1);
					AddMenuItem(menu, "", "Métier: Apprenti Armurier", 1);
					AddMenuItem(menu, "", "Rôle: Vendre des armes pour pouvoir se défendre !", 1);
					AddMenuItem(menu, "", "-------------------", 1);
				}
				if (jobid[client][0][0] == 21)
				{
					CS_SwitchTeam(client, 2);
					CS_RespawnPlayer(client);
					rankid[client] = 7;
					AddMenuItem(menu, "", "-------------------", 1);
					AddMenuItem(menu, "", "Métier: Chef du Loto", 1);
					AddMenuItem(menu, "", "Rôle: Vendre des tickets pour gagner de l'argent !", 1);
					AddMenuItem(menu, "", "-------------------", 1);
				}
				if (jobid[client][0][0] == 22)
				{
					CS_SwitchTeam(client, 2);
					CS_RespawnPlayer(client);
					rankid[client] = 7;
					AddMenuItem(menu, "", "-------------------", 1);
					AddMenuItem(menu, "", "Métier: Vendeur de ticket", 1);
					AddMenuItem(menu, "", "Rôle: Vendre des tickets pour gagner de l'argent !", 1);
					AddMenuItem(menu, "", "-------------------", 1);
				}
				if (jobid[client][0][0] == 23)
				{
					CS_SwitchTeam(client, 2);
					CS_RespawnPlayer(client);
					rankid[client] = 7;
					AddMenuItem(menu, "", "-------------------", 1);
					AddMenuItem(menu, "", "Métier: Apprenti Vendeur de ticket", 1);
					AddMenuItem(menu, "", "Rôle: Vendre des tickets pour gagner de l'argent !", 1);
					AddMenuItem(menu, "", "-------------------", 1);
				}
				if (jobid[client][0][0] == 24)
				{
					CS_SwitchTeam(client, 2);
					CS_RespawnPlayer(client);
					rankid[client] = 8;
					AddMenuItem(menu, "", "-------------------", 1);
					AddMenuItem(menu, "", "Métier: Directeur de la banque", 1);
					AddMenuItem(menu, "", "Rôle: Garder l'argent des clients au chaud !", 1);
					AddMenuItem(menu, "", "-------------------", 1);
				}
				if (jobid[client][0][0] == 25)
				{
					CS_SwitchTeam(client, 2);
					CS_RespawnPlayer(client);
					rankid[client] = 8;
					AddMenuItem(menu, "", "-------------------", 1);
					AddMenuItem(menu, "", "Métier: Banquier", 1);
					AddMenuItem(menu, "", "Rôle: Garder l'argent des clients au chaud !", 1);
					AddMenuItem(menu, "", "-------------------", 1);
				}
				if (jobid[client][0][0] == 26)
				{
					CS_SwitchTeam(client, 2);
					CS_RespawnPlayer(client);
					rankid[client] = 8;
					AddMenuItem(menu, "", "-------------------", 1);
					AddMenuItem(menu, "", "Métier: Apprenti Banquier", 1);
					AddMenuItem(menu, "", "Rôle: Garder l'argent des clients au chaud !", 1);
					AddMenuItem(menu, "", "-------------------", 1);
				}
				if (jobid[client][0][0] == 27)
				{
					CS_SwitchTeam(client, 2);
					CS_RespawnPlayer(client);
					rankid[client] = 9;
					AddMenuItem(menu, "", "-------------------", 1);
					AddMenuItem(menu, "", "Métier: Directeur de l'hôpital", 1);
					AddMenuItem(menu, "", "Rôle: Soigner les malades et faire de la chirurgie !", 1);
					AddMenuItem(menu, "", "-------------------", 1);
				}
				if (jobid[client][0][0] == 28)
				{
					CS_SwitchTeam(client, 2);
					CS_RespawnPlayer(client);
					rankid[client] = 9;
					AddMenuItem(menu, "", "-------------------", 1);
					AddMenuItem(menu, "", "Métier: Medecin", 1);
					AddMenuItem(menu, "", "Rôle: Soigner les malades !", 1);
					AddMenuItem(menu, "", "-------------------", 1);
				}
				if (jobid[client][0][0] == 29)
				{
					CS_SwitchTeam(client, 2);
					CS_RespawnPlayer(client);
					rankid[client] = 9;
					AddMenuItem(menu, "", "-------------------", 1);
					AddMenuItem(menu, "", "Métier: Medecin", 1);
					AddMenuItem(menu, "", "Rôle: Soigner les malades !", 1);
					AddMenuItem(menu, "", "-------------------", 1);
				}
				if (jobid[client][0][0] == 30)
				{
					CS_SwitchTeam(client, 2);
					CS_RespawnPlayer(client);
					rankid[client] = 9;
					AddMenuItem(menu, "", "-------------------", 1);
					AddMenuItem(menu, "", "Métier: Chirurgien", 1);
					AddMenuItem(menu, "", "Rôle: Pratiquer de la chirurgie sur les patients !", 1);
					AddMenuItem(menu, "", "-------------------", 1);
				}
				if (jobid[client][0][0] == 31)
				{
					CS_SwitchTeam(client, 2);
					CS_RespawnPlayer(client);
					rankid[client] = 10;
					AddMenuItem(menu, "", "-------------------", 1);
					AddMenuItem(menu, "", "Métier: Chef Artificier", 1);
					AddMenuItem(menu, "", "Rôle: Vendre des articles de fête !", 1);
					AddMenuItem(menu, "", "-------------------", 1);
				}
				if (jobid[client][0][0] == 32)
				{
					CS_SwitchTeam(client, 2);
					CS_RespawnPlayer(client);
					rankid[client] = 10;
					AddMenuItem(menu, "", "-------------------", 1);
					AddMenuItem(menu, "", "Métier: Artificier", 1);
					AddMenuItem(menu, "", "Rôle: Vendre des articles de fête !", 1);
					AddMenuItem(menu, "", "-------------------", 1);
				}
				if (jobid[client][0][0] == 33)
				{
					CS_SwitchTeam(client, 2);
					CS_RespawnPlayer(client);
					rankid[client] = 10;
					AddMenuItem(menu, "", "-------------------", 1);
					AddMenuItem(menu, "", "Métier: Apprenti Artificier", 1);
					AddMenuItem(menu, "", "Rôle: Vendre des articles de fête !", 1);
					AddMenuItem(menu, "", "-------------------", 1);
				}
				if (jobid[client][0][0] == 34)
				{
					CS_SwitchTeam(client, 2);
					CS_RespawnPlayer(client);
					rankid[client] = 11;
					AddMenuItem(menu, "", "-------------------", 1);
					AddMenuItem(menu, "", "Métier: Chef tueur", 1);
					AddMenuItem(menu, "", "Rôle: Tuer les citoyens en toute discrétion !", 1);
					AddMenuItem(menu, "", "-------------------", 1);
				}
				if (jobid[client][0][0] == 35)
				{
					CS_SwitchTeam(client, 2);
					CS_RespawnPlayer(client);
					rankid[client] = 11;
					AddMenuItem(menu, "", "-------------------", 1);
					AddMenuItem(menu, "", "Métier: Tueur D'élite", 1);
					AddMenuItem(menu, "", "Rôle: Tuer les citoyens en toute discrétion !", 1);
					AddMenuItem(menu, "", "-------------------", 1);
				}
				if (jobid[client][0][0] == 36)
				{
					CS_SwitchTeam(client, 2);
					CS_RespawnPlayer(client);
					rankid[client] = 11;
					AddMenuItem(menu, "", "-------------------", 1);
					AddMenuItem(menu, "", "Métier: Tueur Novice", 1);
					AddMenuItem(menu, "", "Rôle: Tuer les citoyens en toute discrétion !", 1);
					AddMenuItem(menu, "", "-------------------", 1);
				}
				if (jobid[client][0][0] == 37)
				{
					CS_SwitchTeam(client, 2);
					CS_RespawnPlayer(client);
					rankid[client] = 12;
					AddMenuItem(menu, "", "-------------------", 1);
					AddMenuItem(menu, "", "Métier: Directeur Immobilier", 1);
					AddMenuItem(menu, "", "Rôle: Vendre des appartements/maisons !", 1);
					AddMenuItem(menu, "", "-------------------", 1);
				}
				if (jobid[client][0][0] == 38)
				{
					CS_SwitchTeam(client, 2);
					CS_RespawnPlayer(client);
					rankid[client] = 12;
					AddMenuItem(menu, "", "-------------------", 1);
					AddMenuItem(menu, "", "Métier: Vendeur Immobilier", 1);
					AddMenuItem(menu, "", "Rôle: Vendre des appartements/maisons !", 1);
					AddMenuItem(menu, "", "-------------------", 1);
				}
				if (jobid[client][0][0] == 39)
				{
					CS_SwitchTeam(client, 2);
					CS_RespawnPlayer(client);
					rankid[client] = 12;
					AddMenuItem(menu, "", "-------------------", 1);
					AddMenuItem(menu, "", "Métier: Apprenti Vendeur Immobilier", 1);
					AddMenuItem(menu, "", "Rôle: Vendre des appartements/maisons !", 1);
					AddMenuItem(menu, "", "-------------------", 1);
				}
			}
			CS_SwitchTeam(client, 2);
			CS_RespawnPlayer(client);
			SetEntityHealth(client, 100);
			rankid[client] = 0;
			AddMenuItem(menu, "", "-------------------", 1);
			AddMenuItem(menu, "", "Métier: Chômeur", 1);
			AddMenuItem(menu, "", "Rôle: Rechercher un métier et se faire embaucher.", 1);
			AddMenuItem(menu, "", "-------------------", 1);
		}
		DisplayMenu(menu, client, 0);
		chooseskin(client);
		change_tag(client);
		disarm(client);
		GivePlayerItem(client, "weapon_knife", 0);
		if (g_jailtime[client][0][0])
		{
			switch (GetRandomInt(1, 4))
			{
				case 1:
				{
					TeleportEntity(client, 48080, NULL_VECTOR, NULL_VECTOR);
				}
				case 2:
				{
					TeleportEntity(client, 48092, NULL_VECTOR, NULL_VECTOR);
				}
				case 3:
				{
					TeleportEntity(client, 48104, NULL_VECTOR, NULL_VECTOR);
				}
				case 4:
				{
					TeleportEntity(client, 48116, NULL_VECTOR, NULL_VECTOR);
				}
				default:
				{
				}
			}
			SetClientListeningFlags(client, 1);
			g_jailreturn[client] = CreateTimer(1, Jail_Return, client, 1);
			g_boolreturn[client] = 1;
		}
		else
		{
			g_IsInJail[client] = 0;
			switch (GetRandomInt(1, 5))
			{
				case 1:
				{
					TeleportEntity(client, 48020, NULL_VECTOR, NULL_VECTOR);
				}
				case 2:
				{
					TeleportEntity(client, 48032, NULL_VECTOR, NULL_VECTOR);
				}
				case 3:
				{
					TeleportEntity(client, 48044, NULL_VECTOR, NULL_VECTOR);
				}
				case 4:
				{
					TeleportEntity(client, 48056, NULL_VECTOR, NULL_VECTOR);
				}
				case 5:
				{
					TeleportEntity(client, 48068, NULL_VECTOR, NULL_VECTOR);
				}
				default:
				{
				}
			}
		}
		CPrintToChat(client, "%s Message de \x03John Shepard", "{red}[CSS-RP] ");
		CPrintToChat(client, "%s: Si tu trouves un bug n'hésite pas à le rapporter sur  : %s", "{red}[CSS-RP] ", "Y04NN.fr");
	}
	return Action:0;
}

public Connect_Menu(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:16)
	{
		CloseHandle(menu);
	}
	return 0;
}

public Action:HudTimer(Handle:timer, client)
{
	new Handle:hBuffer = StartMessageOne("KeyHintText", client, 0);
	new MoneyOffset = FindSendPropOffs("CCSPlayer", "m_iAccount");
	money[client] = GetEntData(client, MoneyOffset, 4);
	GetZone(client);
	GetJobName(client);
	GetRankName(client);
	if (!IsClientInGame(client))
	{
		CloseHandle(TimerHud[client][0][0]);
		return Action:4;
	}
	if (hBuffer)
	{
		new String:tmptext[10000];
		if (g_IsInJail[client][0][0])
		{
			Format(tmptext, 9999, "Argent : %i€\nBanque : %i€\nMétier : %s\nEntreprise : %s\nCapital : %i€\nHorloge : %i%i:%i%i\nZone : %s\nTemps de Jail : %i\n", money[client], bank[client], jobname, rankname, capital[rankid[client][0][0]], g_countheure1, g_countheure2, g_countminute1, g_countminute2, RealZone, g_jailtime[client]);
		}
		else
		{
			Format(tmptext, 9999, "Argent : %i€\nBanque : %i€\nMétier : %s\nEntreprise : %s\nSalaire : %i€\nCapital : %i€\nHorloge : %i%i:%i%i\nZone : %s\n", money[client], bank[client], jobname, rankname, salaire[client], capital[rankid[client][0][0]], g_countheure1, g_countheure2, g_countminute1, g_countminute2, RealZone);
		}
		BfWriteByte(hBuffer, 1);
		BfWriteString(hBuffer, tmptext);
		EndMessage();
	}
	else
	{
		CPrintToChat(client, "INVALID_HANDLE");
	}
	new aim = GetClientAimTarget(client, true);
	if (aim != -1)
	{
		new health = GetClientHealth(aim);
		GetJobName(aim);
		PrintHintText(client, "%N | [HP:%i]\nJob: %s", aim, health, jobname);
		StopSound(client, 6, "UI/hint.wav");
	}
	return Action:0;
}

public GetZone(client)
{
	if (IsClientInGame(client))
	{
		if (IsInDistribIkea(client))
		{
			Format(RealZone, 999, "Distributeur Ikea");
		}
		if (IsInDistribLoto(client))
		{
			Format(RealZone, 999, "Distributeur Atlantic");
		}
		if (IsInDistribMafia(client))
		{
			Format(RealZone, 999, "Distributeur Mafia");
		}
		if (IsInDistribBanque(client))
		{
			Format(RealZone, 999, "Distributeur Banque");
		}
		if (IsInPlace(client))
		{
			Format(RealZone, 999, "Place Marchande");
		}
		if (IsInComico(client))
		{
			Format(RealZone, 999, "Commissariat");
		}
		if (IsInFbi(client))
		{
			Format(RealZone, 999, "F.B.I");
		}
		if (IsInArmu(client))
		{
			Format(RealZone, 999, "Armurerie");
		}
		if (IsInHosto(client))
		{
			Format(RealZone, 999, "Hôpital");
		}
		if (IsInDealer(client))
		{
			Format(RealZone, 999, "Planque des Dealers");
		}
		if (IsInMafia(client))
		{
			Format(RealZone, 999, "Planque Mafia");
		}
		if (IsInMafia(client))
		{
			Format(RealZone, 999, "Salle d'opération");
		}
		if (IsInLoto(client))
		{
			Format(RealZone, 999, "Loto");
		}
		if (IsInBank(client))
		{
			Format(RealZone, 999, "Banque");
		}
		if (IsInIkea(client))
		{
			Format(RealZone, 999, "Ikea");
		}
		if (IsInCoach(client))
		{
			Format(RealZone, 999, "Planque Coach");
		}
		if (IsInEleven(client))
		{
			Format(RealZone, 999, "Planque des Artificier");
		}
		if (IsInTueur(client))
		{
			Format(RealZone, 999, "Planque des Tueurs");
		}
		if (IsInHotel(client))
		{
			Format(RealZone, 999, "Hôtel");
		}
		if (IsInHotel(client))
		{
			Format(RealZone, 999, "Appartement n°1");
		}
		if (IsInHotel(client))
		{
			Format(RealZone, 999, "Appartement n°2");
		}
		if (IsInHotel(client))
		{
			Format(RealZone, 999, "Appartement n°3");
		}
		if (IsInHotel(client))
		{
			Format(RealZone, 999, "Appartement n°4");
		}
		if (IsInHotel(client))
		{
			Format(RealZone, 999, "Appartement n°5");
		}
		if (IsInHotel(client))
		{
			Format(RealZone, 999, "Appartement n°6");
		}
		if (IsInHotel(client))
		{
			Format(RealZone, 999, "Appartement n°7");
		}
		if (IsInHotel(client))
		{
			Format(RealZone, 999, "Appartement n°8");
		}
		if (IsInHotel(client))
		{
			Format(RealZone, 999, "Appartement n°9");
		}
		if (IsInHotel(client))
		{
			Format(RealZone, 999, "Appartement n°10");
		}
		Format(RealZone, 999, "Extérieur");
	}
	return 0;
}

public GetJobName(client)
{
	if (IsClientInGame(client))
	{
		if (jobid[client][0][0] == 1)
		{
			Format(jobname, 999, "Chef d'Etat");
		}
		if (jobid[client][0][0] == 2)
		{
			Format(jobname, 999, "Agent C.I.A");
		}
		if (jobid[client][0][0] == 3)
		{
			Format(jobname, 999, "Agent F.B.I");
		}
		if (jobid[client][0][0] == 4)
		{
			Format(jobname, 999, "Policier");
		}
		if (jobid[client][0][0] == 5)
		{
			Format(jobname, 999, "Gardien");
		}
		if (jobid[client][0][0] == 6)
		{
			Format(jobname, 999, "Chef Mafia");
		}
		if (jobid[client][0][0] == 7)
		{
			Format(jobname, 999, "Mafieux");
		}
		if (jobid[client][0][0] == 8)
		{
			Format(jobname, 999, "Apprenti Mafieux");
		}
		if (jobid[client][0][0] == 9)
		{
			Format(jobname, 999, "Chef Dealer");
		}
		if (jobid[client][0][0] == 10)
		{
			Format(jobname, 999, "Dealer");
		}
		if (jobid[client][0][0] == 11)
		{
			Format(jobname, 999, "Apprenti Dealer");
		}
		if (jobid[client][0][0] == 12)
		{
			Format(jobname, 999, "Chef Coach");
		}
		if (jobid[client][0][0] == 13)
		{
			Format(jobname, 999, "Coach");
		}
		if (jobid[client][0][0] == 14)
		{
			Format(jobname, 999, "Apprenti Coach");
		}
		if (jobid[client][0][0] == 15)
		{
			Format(jobname, 999, "D. Ikea");
		}
		if (jobid[client][0][0] == 16)
		{
			Format(jobname, 999, "Vendeur Ikea");
		}
		if (jobid[client][0][0] == 17)
		{
			Format(jobname, 999, "Apprenti Vendeur Ikea");
		}
		if (jobid[client][0][0] == 18)
		{
			Format(jobname, 999, "Chef Armurerie");
		}
		if (jobid[client][0][0] == 19)
		{
			Format(jobname, 999, "Armurier");
		}
		if (jobid[client][0][0] == 20)
		{
			Format(jobname, 999, "Apprenti Armurier");
		}
		if (jobid[client][0][0] == 21)
		{
			Format(jobname, 999, "Chef Loto");
		}
		if (jobid[client][0][0] == 22)
		{
			Format(jobname, 999, "Vendeur de Tickets");
		}
		if (jobid[client][0][0] == 23)
		{
			Format(jobname, 999, "Apprenti Vendeur de Tickets");
		}
		if (jobid[client][0][0] == 24)
		{
			Format(jobname, 999, "D. Banquier");
		}
		if (jobid[client][0][0] == 25)
		{
			Format(jobname, 999, "Banquier");
		}
		if (jobid[client][0][0] == 26)
		{
			Format(jobname, 999, "Apprenti Banquier");
		}
		if (jobid[client][0][0] == 27)
		{
			Format(jobname, 999, "D. Hôpital");
		}
		if (jobid[client][0][0] == 28)
		{
			Format(jobname, 999, "Médecin");
		}
		if (jobid[client][0][0] == 29)
		{
			Format(jobname, 999, "Infirmier");
		}
		if (jobid[client][0][0] == 30)
		{
			Format(jobname, 999, "Chirurgien");
		}
		if (jobid[client][0][0] == 31)
		{
			Format(jobname, 999, "Chef Artificer");
		}
		if (jobid[client][0][0] == 32)
		{
			Format(jobname, 999, "Artificier");
		}
		if (jobid[client][0][0] == 33)
		{
			Format(jobname, 999, "Apprenti Artificer");
		}
		if (jobid[client][0][0] == 34)
		{
			Format(jobname, 999, "Chef Tueurs");
		}
		if (jobid[client][0][0] == 35)
		{
			Format(jobname, 999, "Tueur d'élite");
		}
		if (jobid[client][0][0] == 36)
		{
			Format(jobname, 999, "Tueur novice");
		}
		if (jobid[client][0][0] == 37)
		{
			Format(jobname, 999, "D. Immobilier");
		}
		if (jobid[client][0][0] == 38)
		{
			Format(jobname, 999, "V. Immobilier");
		}
		if (jobid[client][0][0] == 39)
		{
			Format(jobname, 999, "A.V Immobilier");
		}
		if (jobid[client][0][0])
		{
		}
		else
		{
			Format(jobname, 999, "Chômeur");
		}
	}
	return 0;
}

public GetRankName(client)
{
	if (IsClientInGame(client))
	{
		if (rankid[client][0][0] == 1)
		{
			Format(rankname, 999, "Gouvernement");
		}
		if (rankid[client][0][0] == 2)
		{
			Format(rankname, 999, "Mafia");
		}
		if (rankid[client][0][0] == 3)
		{
			Format(rankname, 999, "Dealer");
		}
		if (rankid[client][0][0] == 4)
		{
			Format(rankname, 999, "Coach");
		}
		if (rankid[client][0][0] == 5)
		{
			Format(rankname, 999, "Ikea");
		}
		if (rankid[client][0][0] == 6)
		{
			Format(rankname, 999, "Armurerie");
		}
		if (rankid[client][0][0] == 7)
		{
			Format(rankname, 999, "Loto");
		}
		if (rankid[client][0][0] == 8)
		{
			Format(rankname, 999, "Banque");
		}
		if (rankid[client][0][0] == 9)
		{
			Format(rankname, 999, "Hôpital");
		}
		if (rankid[client][0][0] == 10)
		{
			Format(rankname, 999, "Artificier");
		}
		if (rankid[client][0][0] == 11)
		{
			Format(rankname, 999, "Tueurs");
		}
		if (rankid[client][0][0] == 12)
		{
			Format(rankname, 999, "Immobilier");
		}
		if (rankid[client][0][0])
		{
		}
		else
		{
			Format(rankname, 999, "Aucune");
		}
	}
	return 0;
}

public disarm(player)
{
	new wepIdx;
	new f;
	while (f < 6)
	{
		if (f < 6)
		{
			RemovePlayerItem(player, wepIdx);
			f++;
		}
		f++;
	}
	return 0;
}

IsInDistribIkea(client)
{
	new Float:v[3] = 0;
	GetEntPropVector(client, PropType:0, "m_vecOrigin", v, 0);
	if (v[0] >= -5200.438)
	{
		return 1;
	}
	return 0;
}

IsInDistribBanque(client)
{
	new Float:v[3] = 0;
	GetEntPropVector(client, PropType:0, "m_vecOrigin", v, 0);
	if (v[0] >= -2104.442)
	{
		return 1;
	}
	return 0;
}

IsInDistribMafia(client)
{
	new Float:v[3] = 0;
	GetEntPropVector(client, PropType:0, "m_vecOrigin", v, 0);
	if (v[0] >= 1945.3)
	{
		return 1;
	}
	return 0;
}

IsInDistribLoto(client)
{
	new Float:v[3] = 0;
	GetEntPropVector(client, PropType:0, "m_vecOrigin", v, 0);
	if (v[0] >= -2980)
	{
		return 1;
	}
	return 0;
}

IsInPlace(client)
{
	new Float:v[3] = 0;
	GetEntPropVector(client, PropType:0, "m_vecOrigin", v, 0);
	if (v[0] >= -5202)
	{
		return 1;
	}
	return 0;
}

IsInComico(client)
{
	new Float:v[3] = 0;
	GetEntPropVector(client, PropType:0, "m_vecOrigin", v, 0);
	if (v[0] >= -3552)
	{
		return 1;
	}
	if (v[0] >= -3553.4)
	{
		return 1;
	}
	return 0;
}

IsInFbi(client)
{
	new Float:v[3] = 0;
	GetEntPropVector(client, PropType:0, "m_vecOrigin", v, 0);
	if (v[0] >= -2863.9)
	{
		return 1;
	}
	return 0;
}

IsInArmu(client)
{
	new Float:v[3] = 0;
	GetEntPropVector(client, PropType:0, "m_vecOrigin", v, 0);
	if (v[0] >= -5183.9)
	{
		return 1;
	}
	return 0;
}

IsInLoto(client)
{
	new Float:v[3] = 0;
	GetEntPropVector(client, PropType:0, "m_vecOrigin", v, 0);
	if (v[0] >= -3255.9)
	{
		return 1;
	}
	return 0;
}

IsInBank(client)
{
	new Float:v[3] = 0;
	GetEntPropVector(client, PropType:0, "m_vecOrigin", v, 0);
	if (v[0] >= -2050)
	{
		return 1;
	}
	return 0;
}

IsInMafia(client)
{
	new Float:v[3] = 0;
	GetEntPropVector(client, PropType:0, "m_vecOrigin", v, 0);
	if (v[0] >= 695)
	{
		return 1;
	}
	return 0;
}

IsInSalle(client)
{
	new Float:v[3] = 0;
	GetEntPropVector(client, PropType:0, "m_vecOrigin", v, 0);
	if (v[0] >= 1488)
	{
		return 1;
	}
	return 0;
}

IsInDealer(client)
{
	new Float:v[3] = 0;
	GetEntPropVector(client, PropType:0, "m_vecOrigin", v, 0);
	if (v[0] >= -847)
	{
		return 1;
	}
	if (v[0] >= -1153.9)
	{
		return 1;
	}
	return 0;
}

IsInHosto(client)
{
	new Float:v[3] = 0;
	GetEntPropVector(client, PropType:0, "m_vecOrigin", v, 0);
	if (v[0] >= -1771.5)
	{
		return 1;
	}
	return 0;
}

IsInIkea(client)
{
	new Float:v[3] = 0;
	GetEntPropVector(client, PropType:0, "m_vecOrigin", v, 0);
	if (v[0] >= -4672)
	{
		return 1;
	}
	return 0;
}

IsInCoach(client)
{
	new Float:v[3] = 0;
	GetEntPropVector(client, PropType:0, "m_vecOrigin", v, 0);
	if (v[0] >= 1130)
	{
		return 1;
	}
	return 0;
}

IsInEleven(client)
{
	new Float:v[3] = 0;
	GetEntPropVector(client, PropType:0, "m_vecOrigin", v, 0);
	if (v[0] >= -3503.969)
	{
		return 1;
	}
	return 0;
}

IsInTueur(client)
{
	new Float:v[3] = 0;
	GetEntPropVector(client, PropType:0, "m_vecOrigin", v, 0);
	if (v[0] >= 450)
	{
		return 1;
	}
	return 0;
}

IsInHotel(client)
{
	new Float:v[3] = 0;
	GetEntPropVector(client, PropType:0, "m_vecOrigin", v, 0);
	if (v[0] >= -2022.9)
	{
		return 1;
	}
	return 0;
}

IsInA1(client)
{
	new Float:v[3] = 0;
	GetEntPropVector(client, PropType:0, "m_vecOrigin", v, 0);
	if (v[0] >= -1587.6)
	{
		return 1;
	}
	return 0;
}

IsInA2(client)
{
	new Float:v[3] = 0;
	GetEntPropVector(client, PropType:0, "m_vecOrigin", v, 0);
	if (v[0] >= -2022.9)
	{
		return 1;
	}
	return 0;
}

IsInA3(client)
{
	new Float:v[3] = 0;
	GetEntPropVector(client, PropType:0, "m_vecOrigin", v, 0);
	if (v[0] >= -2022.9)
	{
		return 1;
	}
	return 0;
}

IsInA4(client)
{
	new Float:v[3] = 0;
	GetEntPropVector(client, PropType:0, "m_vecOrigin", v, 0);
	if (v[0] >= -1587.6)
	{
		return 1;
	}
	return 0;
}

IsInA5(client)
{
	new Float:v[3] = 0;
	GetEntPropVector(client, PropType:0, "m_vecOrigin", v, 0);
	if (v[0] >= -1587.6)
	{
		return 1;
	}
	return 0;
}

IsInA6(client)
{
	new Float:v[3] = 0;
	GetEntPropVector(client, PropType:0, "m_vecOrigin", v, 0);
	if (v[0] >= -1587.6)
	{
		return 1;
	}
	return 0;
}

IsInA7(client)
{
	new Float:v[3] = 0;
	GetEntPropVector(client, PropType:0, "m_vecOrigin", v, 0);
	if (v[0] >= -2022.9)
	{
		return 1;
	}
	return 0;
}

IsInA8(client)
{
	new Float:v[3] = 0;
	GetEntPropVector(client, PropType:0, "m_vecOrigin", v, 0);
	if (v[0] >= -2022.9)
	{
		return 1;
	}
	return 0;
}

IsInA9(client)
{
	new Float:v[3] = 0;
	GetEntPropVector(client, PropType:0, "m_vecOrigin", v, 0);
	if (v[0] >= -2022.9)
	{
		return 1;
	}
	return 0;
}

IsInA10(client)
{
	new Float:v[3] = 0;
	GetEntPropVector(client, PropType:0, "m_vecOrigin", v, 0);
	if (v[0] >= -1587.6)
	{
		return 1;
	}
	return 0;
}

public OnClientDisconnect(client)
{
	SaveInfosClient(client);
	if (IsClientInGame(client))
	{
		if (0 > g_jailtime[client][0][0])
		{
			g_jailtime[client] = 0;
		}
		if (0 > levelcut[client][0][0])
		{
			levelcut[client] = 0;
		}
		if (g_IsTazed[client][0][0])
		{
			g_IsTazed[client] = 0;
		}
		if (g_chirurgie[client][0][0])
		{
			g_chirurgie[client] = 0;
		}
		if (g_boolexta[client][0][0])
		{
			g_boolexta[client] = 0;
			drogue[client] = 0;
		}
		if (g_boollsd[client][0][0])
		{
			g_boollsd[client] = 0;
			drogue[client] = 0;
		}
		if (g_boolcoke[client][0][0])
		{
			g_boolcoke[client] = 0;
			drogue[client] = 0;
		}
		if (g_boolhero[client][0][0])
		{
			g_boolhero[client] = 0;
			drogue[client] = 0;
		}
		if (g_appart[client][0][0])
		{
			KillTimer(TimerAppart[client][0][0], false);
		}
		KillTazer(client);
		SDKUnhook(client, SDKHookType:16, OnWeaponEquip);
		SDKUnhook(client, SDKHookType:2, OnTakeDamagePre);
		responsable[client] = 0;
		price[client] = 0;
		jail[client] = 0;
		TransactionWith[client] = 0;
		cible[client] = 0;
		acheteur[client] = 0;
		oncontrat[client] = 0;
		HasKillCible[client] = 0;
		SaveInfosClient(client);
		banned[client] = 0;
		banni[client] = 0;
		maison[client] = 0;
		maisontime[client] = 0;
		gObj[client] = -1;
		fTrashTimer(client);
		if (OnKit[client][0][0])
		{
			OnKit[client] = 0;
			CloseHandle(GiveKit);
		}
	}
	SaveInfosClient(client);
	return 0;
}

fTrashTimer(client)
{
	if (TimerHud[client][0][0])
	{
		KillTimer(TimerHud[client][0][0], false);
		TimerHud[client] = 0;
	}
	if (g_boolreturn[client][0][0])
	{
		KillTimer(g_jailreturn[client][0][0], false);
		g_boolreturn[client] = 0;
	}
	if (g_booljail[client][0][0])
	{
		KillTimer(g_jailtimer[client][0][0], false);
		g_booljail[client] = 0;
	}
	if (oncontrat[client][0][0])
	{
		KillTimer(Contrat[client][0][0], false);
	}
	if (g_booldead[client][0][0])
	{
		KillTimer(g_deadtimer[client][0][0], false);
		g_booldead[client] = 0;
	}
	if (g_crochetageon[client][0][0])
	{
		KillTimer(g_croche[client][0][0], false);
		g_crochetageon[client] = 0;
	}
	if (g_boolexta[client][0][0])
	{
		KillTimer(extasiie[client][0][0], false);
	}
	if (g_boollsd[client][0][0])
	{
		KillTimer(lssd[client][0][0], false);
	}
	if (g_boolcoke[client][0][0])
	{
		KillTimer(cokk[client][0][0], false);
	}
	if (g_boolhero[client][0][0])
	{
		KillTimer(heroo[client][0][0], false);
	}
	return 0;
}

public Action:Command_Ent(client, args)
{
	new Ent = GetClientAimTarget(client, false);
	if (IsPlayerAlive(client))
	{
		if (0 < GetUserFlagBits(client))
		{
			CPrintToChat(client, "%s: Entité <=> %d.", "{red}[CSS-RP] ", Ent);
			return Action:3;
		}
		CPrintToChat(client, "%s: Vous n'avez pas accès a cette commande.", "{red}[CSS-RP] ");
	}
	else
	{
		CPrintToChat(client, "%s: Vous devez être en vie pour utilisé cette commande.", "{red}[CSS-RP] ");
	}
	return Action:0;
}

public Action:Cmd_Lock(client, args)
{
	decl Ent;
	decl String:Door[256];
	Ent = GetClientAimTarget(client, false);
	if (IsPlayerAlive(client))
	{
		new String:SteamId[32];
		GetClientAuthString(client, SteamId, 32, true);
		if (jobid[client][0][0] == 1)
		{
			if (Ent != -1)
			{
				GetEdictClassname(Ent, Door, 255);
				if (StrEqual(Door, "func_door_rotating", true))
				{
					if (Entity_IsLocked(Ent))
					{
						CPrintToChat(client, "%s: La porte est déjà  fermée a clef.", "{red}[CSS-RP] ");
					}
					CPrintToChat(client, "%s: Vous avez fermé la porte a clef.", "{red}[CSS-RP] ");
					PrintToConsole(client, "%s: La porte %d est maintenant fermée a clef.", "{red}[CSS-RP] ", Ent);
					Entity_Lock(Ent);
					EmitSoundToAll("doors/default_locked.wav", Ent, 0, 75, 0, 1, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0);
				}
			}
			else
			{
				CPrintToChat(client, "%s: Vous devez visé une porte.", "{red}[CSS-RP] ");
			}
			return Action:3;
		}
		if (jobid[client][0][0] == 4)
		{
			if (Ent != -1)
			{
				if (IsInComico(Ent))
				{
					GetEdictClassname(Ent, Door, 255);
					if (StrEqual(Door, "func_door_rotating", true))
					{
						if (Entity_IsLocked(Ent))
						{
							CPrintToChat(client, "%s: La porte est déjà  fermée a clef.", "{red}[CSS-RP] ");
						}
						CPrintToChat(client, "%s: Vous avez fermé la porte a clef.", "{red}[CSS-RP] ");
						PrintToConsole(client, "%s: La porte %d est maintenant fermée a clef.", "{red}[CSS-RP] ", Ent);
						Entity_Lock(Ent);
						EmitSoundToAll("doors/default_locked.wav", Ent, 0, 75, 0, 1, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0);
					}
				}
				else
				{
					CPrintToChat(client, "%s: Vous n'avez pas les clef de cette porte.", "{red}[CSS-RP] ");
				}
			}
			else
			{
				CPrintToChat(client, "%s: Vous devez visé une porte.", "{red}[CSS-RP] ");
			}
			return Action:3;
		}
		if (jobid[client][0][0] == 6)
		{
			if (Ent != -1)
			{
				if (IsInMafia(Ent))
				{
					GetEdictClassname(Ent, Door, 255);
					if (StrEqual(Door, "func_door_rotating", true))
					{
						if (Entity_IsLocked(Ent))
						{
							CPrintToChat(client, "%s: La porte est déjà  fermée a clef.", "{red}[CSS-RP] ");
						}
						CPrintToChat(client, "%s: Vous avez fermé la porte a clef.", "{red}[CSS-RP] ");
						PrintToConsole(client, "%s: La porte %d est maintenant fermée a clef.", "{red}[CSS-RP] ", Ent);
						Entity_Lock(Ent);
						EmitSoundToAll("doors/default_locked.wav", Ent, 0, 75, 0, 1, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0);
					}
				}
				else
				{
					CPrintToChat(client, "%s: Vous n'avez pas les clef de cette porte.", "{red}[CSS-RP] ");
				}
			}
			else
			{
				CPrintToChat(client, "%s: Vous devez visé une porte.", "{red}[CSS-RP] ");
			}
			return Action:3;
		}
		if (jobid[client][0][0] == 9)
		{
			if (Ent != -1)
			{
				if (IsInDealer(Ent))
				{
					GetEdictClassname(Ent, Door, 255);
					if (StrEqual(Door, "func_door_rotating", true))
					{
						if (Entity_IsLocked(Ent))
						{
							CPrintToChat(client, "%s: La porte est déjà  fermée a clef.", "{red}[CSS-RP] ");
						}
						CPrintToChat(client, "%s: Vous avez fermé la porte a clef.", "{red}[CSS-RP] ");
						PrintToConsole(client, "%s: La porte %d est maintenant fermée a clef.", "{red}[CSS-RP] ", Ent);
						Entity_Lock(Ent);
						EmitSoundToAll("doors/default_locked.wav", Ent, 0, 75, 0, 1, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0);
					}
				}
				else
				{
					CPrintToChat(client, "%s: Vous n'avez pas les clef de cette porte.", "{red}[CSS-RP] ");
				}
			}
			else
			{
				CPrintToChat(client, "%s: Vous devez visé une porte.", "{red}[CSS-RP] ");
			}
			return Action:3;
		}
		if (jobid[client][0][0] == 12)
		{
			if (Ent != -1)
			{
				if (IsInCoach(Ent))
				{
					GetEdictClassname(Ent, Door, 255);
					if (StrEqual(Door, "func_door_rotating", true))
					{
						if (Entity_IsLocked(Ent))
						{
							CPrintToChat(client, "%s: La porte est déjà  fermée a clef.", "{red}[CSS-RP] ");
						}
						CPrintToChat(client, "%s: Vous avez fermé la porte a clef.", "{red}[CSS-RP] ");
						PrintToConsole(client, "%s: La porte %d est maintenant fermée a clef.", "{red}[CSS-RP] ", Ent);
						Entity_Lock(Ent);
						EmitSoundToAll("doors/default_locked.wav", Ent, 0, 75, 0, 1, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0);
					}
				}
				else
				{
					CPrintToChat(client, "%s: Vous n'avez pas les clef de cette porte.", "{red}[CSS-RP] ");
				}
			}
			else
			{
				CPrintToChat(client, "%s: Vous devez visé une porte.", "{red}[CSS-RP] ");
			}
			return Action:3;
		}
		if (jobid[client][0][0] == 15)
		{
			if (Ent != -1)
			{
				if (IsInIkea(Ent))
				{
					GetEdictClassname(Ent, Door, 255);
					if (StrEqual(Door, "func_door_rotating", true))
					{
						if (Entity_IsLocked(Ent))
						{
							CPrintToChat(client, "%s: La porte est déjà  fermée a clef.", "{red}[CSS-RP] ");
						}
						CPrintToChat(client, "%s: Vous avez fermé la porte a clef.", "{red}[CSS-RP] ");
						PrintToConsole(client, "%s: La porte %d est maintenant fermée a clef.", "{red}[CSS-RP] ", Ent);
						Entity_Lock(Ent);
						EmitSoundToAll("doors/default_locked.wav", Ent, 0, 75, 0, 1, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0);
					}
				}
				else
				{
					CPrintToChat(client, "%s: Vous n'avez pas les clef de cette porte.", "{red}[CSS-RP] ");
				}
			}
			else
			{
				CPrintToChat(client, "%s: Vous devez visé une porte.", "{red}[CSS-RP] ");
			}
			return Action:3;
		}
		if (jobid[client][0][0] == 18)
		{
			if (Ent != -1)
			{
				if (IsInArmu(Ent))
				{
					GetEdictClassname(Ent, Door, 255);
					if (StrEqual(Door, "func_door_rotating", true))
					{
						if (Entity_IsLocked(Ent))
						{
							CPrintToChat(client, "%s: La porte est déjà  fermée a clef.", "{red}[CSS-RP] ");
						}
						CPrintToChat(client, "%s: Vous avez fermé la porte a clef.", "{red}[CSS-RP] ");
						PrintToConsole(client, "%s: La porte %d est maintenant fermée a clef.", "{red}[CSS-RP] ", Ent);
						Entity_Lock(Ent);
						EmitSoundToAll("doors/default_locked.wav", Ent, 0, 75, 0, 1, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0);
					}
				}
				else
				{
					CPrintToChat(client, "%s: Vous n'avez pas les clef de cette porte.", "{red}[CSS-RP] ");
				}
			}
			else
			{
				CPrintToChat(client, "%s: Vous devez visé une porte.", "{red}[CSS-RP] ");
			}
			return Action:3;
		}
		if (jobid[client][0][0] == 21)
		{
			if (Ent != -1)
			{
				if (IsInLoto(Ent))
				{
					GetEdictClassname(Ent, Door, 255);
					if (StrEqual(Door, "func_door_rotating", true))
					{
						if (Entity_IsLocked(Ent))
						{
							CPrintToChat(client, "%s: La porte est déjà  fermée a clef.", "{red}[CSS-RP] ");
						}
						CPrintToChat(client, "%s: Vous avez fermé la porte a clef.", "{red}[CSS-RP] ");
						PrintToConsole(client, "%s: La porte %d est maintenant fermée a clef.", "{red}[CSS-RP] ", Ent);
						Entity_Lock(Ent);
						EmitSoundToAll("doors/default_locked.wav", Ent, 0, 75, 0, 1, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0);
					}
				}
				else
				{
					CPrintToChat(client, "%s: Vous n'avez pas les clef de cette porte.", "{red}[CSS-RP] ");
				}
			}
			else
			{
				CPrintToChat(client, "%s: Vous devez visé une porte.", "{red}[CSS-RP] ");
			}
			return Action:3;
		}
		if (jobid[client][0][0] == 24)
		{
			if (Ent != -1)
			{
				if (IsInBank(Ent))
				{
					GetEdictClassname(Ent, Door, 255);
					if (StrEqual(Door, "func_door_rotating", true))
					{
						if (Entity_IsLocked(Ent))
						{
							CPrintToChat(client, "%s: La porte est déjà  fermée a clef.", "{red}[CSS-RP] ");
						}
						CPrintToChat(client, "%s: Vous avez fermé la porte a clef.", "{red}[CSS-RP] ");
						PrintToConsole(client, "%s: La porte %d est maintenant fermée a clef.", "{red}[CSS-RP] ", Ent);
						Entity_Lock(Ent);
						EmitSoundToAll("doors/default_locked.wav", Ent, 0, 75, 0, 1, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0);
					}
				}
				else
				{
					CPrintToChat(client, "%s: Vous n'avez pas les clef de cette porte.", "{red}[CSS-RP] ");
				}
			}
			else
			{
				CPrintToChat(client, "%s: Vous devez visé une porte.", "{red}[CSS-RP] ");
			}
			return Action:3;
		}
		if (jobid[client][0][0] == 27)
		{
			if (Ent != -1)
			{
				if (IsInHosto(Ent))
				{
					GetEdictClassname(Ent, Door, 255);
					if (StrEqual(Door, "func_door_rotating", true))
					{
						if (Entity_IsLocked(Ent))
						{
							CPrintToChat(client, "%s: La porte est déjà  fermée a clef.", "{red}[CSS-RP] ");
						}
						CPrintToChat(client, "%s: Vous avez fermé la porte a clef.", "{red}[CSS-RP] ");
						PrintToConsole(client, "%s: La porte %d est maintenant fermée a clef.", "{red}[CSS-RP] ", Ent);
						Entity_Lock(Ent);
						EmitSoundToAll("doors/default_locked.wav", Ent, 0, 75, 0, 1, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0);
					}
				}
				else
				{
					CPrintToChat(client, "%s: Vous n'avez pas les clef de cette porte.", "{red}[CSS-RP] ");
				}
			}
			else
			{
				CPrintToChat(client, "%s: Vous devez visé une porte.", "{red}[CSS-RP] ");
			}
			return Action:3;
		}
		if (jobid[client][0][0] == 31)
		{
			if (Ent != -1)
			{
				if (IsInEleven(Ent))
				{
					GetEdictClassname(Ent, Door, 255);
					if (StrEqual(Door, "func_door_rotating", true))
					{
						if (Entity_IsLocked(Ent))
						{
							CPrintToChat(client, "%s: La porte est déjà  fermée a clef.", "{red}[CSS-RP] ");
						}
						CPrintToChat(client, "%s: Vous avez fermé la porte a clef.", "{red}[CSS-RP] ");
						PrintToConsole(client, "%s: La porte %d est maintenant fermée a clef.", "{red}[CSS-RP] ", Ent);
						Entity_Lock(Ent);
						EmitSoundToAll("doors/default_locked.wav", Ent, 0, 75, 0, 1, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0);
					}
				}
				else
				{
					CPrintToChat(client, "%s: Vous n'avez pas les clef de cette porte.", "{red}[CSS-RP] ");
				}
			}
			else
			{
				CPrintToChat(client, "%s: Vous devez visé une porte.", "{red}[CSS-RP] ");
			}
			return Action:3;
		}
		if (jobid[client][0][0] == 34)
		{
			if (Ent != -1)
			{
				if (IsInTueur(Ent))
				{
					GetEdictClassname(Ent, Door, 255);
					if (StrEqual(Door, "func_door_rotating", true))
					{
						if (Entity_IsLocked(Ent))
						{
							CPrintToChat(client, "%s: La porte est déjà  fermée a clef.", "{red}[CSS-RP] ");
						}
						CPrintToChat(client, "%s: Vous avez fermé la porte a clef.", "{red}[CSS-RP] ");
						PrintToConsole(client, "%s: La porte %d est maintenant fermée a clef.", "{red}[CSS-RP] ", Ent);
						Entity_Lock(Ent);
						EmitSoundToAll("doors/default_locked.wav", Ent, 0, 75, 0, 1, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0);
					}
				}
				else
				{
					CPrintToChat(client, "%s: Vous n'avez pas les clef de cette porte.", "{red}[CSS-RP] ");
				}
			}
			else
			{
				CPrintToChat(client, "%s: Vous devez visé une porte.", "{red}[CSS-RP] ");
			}
			return Action:3;
		}
		if (jobid[client][0][0] == 37)
		{
			if (Ent != -1)
			{
				if (IsInHotel(Ent))
				{
					GetEdictClassname(Ent, Door, 255);
					if (StrEqual(Door, "func_door_rotating", true))
					{
						if (Entity_IsLocked(Ent))
						{
							CPrintToChat(client, "%s: La porte est déjà  fermée a clef.", "{red}[CSS-RP] ");
						}
						CPrintToChat(client, "%s: Vous avez fermé la porte a clef.", "{red}[CSS-RP] ");
						PrintToConsole(client, "%s: La porte %d est maintenant fermée a clef.", "{red}[CSS-RP] ", Ent);
						Entity_Lock(Ent);
						EmitSoundToAll("doors/default_locked.wav", Ent, 0, 75, 0, 1, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0);
					}
				}
				else
				{
					CPrintToChat(client, "%s: Vous n'avez pas les clef de cette porte.", "{red}[CSS-RP] ");
				}
			}
			else
			{
				CPrintToChat(client, "%s: Vous devez visé une porte.", "{red}[CSS-RP] ");
			}
			return Action:3;
		}
		if (jobid[client][0][0])
		{
			if (maison[client][0][0] == 1)
			{
				if (Ent != -1)
				{
					GetEdictClassname(Ent, Door, 255);
					if (IsInA1(Ent))
					{
						if (StrEqual(Door, "func_door_rotating", true))
						{
							if (Entity_IsLocked(Ent))
							{
								CPrintToChat(client, "%s: La porte est déjà  fermée a clef.", "{red}[CSS-RP] ");
							}
							CPrintToChat(client, "%s: Vous avez fermé la porte a clef.", "{red}[CSS-RP] ");
							PrintToConsole(client, "%s: La porte %d est maintenant fermée a clef.", "{red}[CSS-RP] ", Ent);
							Entity_Lock(Ent);
							EmitSoundToAll("doors/default_locked.wav", Ent, 0, 75, 0, 1, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0);
						}
					}
					else
					{
						CPrintToChat(client, "%s: Vous n'avez pas les clef de cette porte.", "{red}[CSS-RP] ");
					}
				}
				else
				{
					CPrintToChat(client, "%s: Vous devez visé une porte.", "{red}[CSS-RP] ");
				}
				return Action:3;
			}
			if (maison[client][0][0] == 2)
			{
				if (Ent != -1)
				{
					GetEdictClassname(Ent, Door, 255);
					if (IsInA2(Ent))
					{
						if (StrEqual(Door, "func_door_rotating", true))
						{
							if (Entity_IsLocked(Ent))
							{
								CPrintToChat(client, "%s: La porte est déjà  fermée a clef.", "{red}[CSS-RP] ");
							}
							CPrintToChat(client, "%s: Vous avez fermé la porte a clef.", "{red}[CSS-RP] ");
							PrintToConsole(client, "%s: La porte %d est maintenant fermée a clef.", "{red}[CSS-RP] ", Ent);
							Entity_Lock(Ent);
							EmitSoundToAll("doors/default_locked.wav", Ent, 0, 75, 0, 1, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0);
						}
					}
					else
					{
						CPrintToChat(client, "%s: Vous n'avez pas les clef de cette porte.", "{red}[CSS-RP] ");
					}
				}
				else
				{
					CPrintToChat(client, "%s: Vous devez visé une porte.", "{red}[CSS-RP] ");
				}
				return Action:3;
			}
			if (maison[client][0][0] == 3)
			{
				if (Ent != -1)
				{
					GetEdictClassname(Ent, Door, 255);
					if (IsInA3(Ent))
					{
						if (StrEqual(Door, "func_door_rotating", true))
						{
							if (Entity_IsLocked(Ent))
							{
								CPrintToChat(client, "%s: La porte est déjà  fermée a clef.", "{red}[CSS-RP] ");
							}
							CPrintToChat(client, "%s: Vous avez fermé la porte a clef.", "{red}[CSS-RP] ");
							PrintToConsole(client, "%s: La porte %d est maintenant fermée a clef.", "{red}[CSS-RP] ", Ent);
							Entity_Lock(Ent);
							EmitSoundToAll("doors/default_locked.wav", Ent, 0, 75, 0, 1, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0);
						}
					}
					else
					{
						CPrintToChat(client, "%s: Vous n'avez pas les clef de cette porte.", "{red}[CSS-RP] ");
					}
				}
				else
				{
					CPrintToChat(client, "%s: Vous devez visé une porte.", "{red}[CSS-RP] ");
				}
				return Action:3;
			}
			if (maison[client][0][0] == 4)
			{
				if (Ent != -1)
				{
					GetEdictClassname(Ent, Door, 255);
					if (IsInA4(Ent))
					{
						if (StrEqual(Door, "func_door_rotating", true))
						{
							if (Entity_IsLocked(Ent))
							{
								CPrintToChat(client, "%s: La porte est déjà  fermée a clef.", "{red}[CSS-RP] ");
							}
							CPrintToChat(client, "%s: Vous avez fermé la porte a clef.", "{red}[CSS-RP] ");
							PrintToConsole(client, "%s: La porte %d est maintenant fermée a clef.", "{red}[CSS-RP] ", Ent);
							Entity_Lock(Ent);
							EmitSoundToAll("doors/default_locked.wav", Ent, 0, 75, 0, 1, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0);
						}
					}
					else
					{
						CPrintToChat(client, "%s: Vous n'avez pas les clef de cette porte.", "{red}[CSS-RP] ");
					}
				}
				else
				{
					CPrintToChat(client, "%s: Vous devez visé une porte.", "{red}[CSS-RP] ");
				}
				return Action:3;
			}
			if (maison[client][0][0] == 5)
			{
				if (Ent != -1)
				{
					GetEdictClassname(Ent, Door, 255);
					if (IsInA5(Ent))
					{
						if (StrEqual(Door, "func_door_rotating", true))
						{
							if (Entity_IsLocked(Ent))
							{
								CPrintToChat(client, "%s: La porte est déjà  fermée a clef.", "{red}[CSS-RP] ");
							}
							CPrintToChat(client, "%s: Vous avez fermé la porte a clef.", "{red}[CSS-RP] ");
							PrintToConsole(client, "%s: La porte %d est maintenant fermée a clef.", "{red}[CSS-RP] ", Ent);
							Entity_Lock(Ent);
							EmitSoundToAll("doors/default_locked.wav", Ent, 0, 75, 0, 1, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0);
						}
					}
					else
					{
						CPrintToChat(client, "%s: Vous n'avez pas les clef de cette porte.", "{red}[CSS-RP] ");
					}
				}
				else
				{
					CPrintToChat(client, "%s: Vous devez visé une porte.", "{red}[CSS-RP] ");
				}
				return Action:3;
			}
			if (maison[client][0][0] == 6)
			{
				if (Ent != -1)
				{
					GetEdictClassname(Ent, Door, 255);
					if (IsInA6(Ent))
					{
						if (StrEqual(Door, "func_door_rotating", true))
						{
							if (Entity_IsLocked(Ent))
							{
								CPrintToChat(client, "%s: La porte est déjà  fermée a clef.", "{red}[CSS-RP] ");
							}
							CPrintToChat(client, "%s: Vous avez fermé la porte a clef.", "{red}[CSS-RP] ");
							PrintToConsole(client, "%s: La porte %d est maintenant fermée a clef.", "{red}[CSS-RP] ", Ent);
							Entity_Lock(Ent);
							EmitSoundToAll("doors/default_locked.wav", Ent, 0, 75, 0, 1, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0);
						}
					}
					else
					{
						CPrintToChat(client, "%s: Vous n'avez pas les clef de cette porte.", "{red}[CSS-RP] ");
					}
				}
				else
				{
					CPrintToChat(client, "%s: Vous devez visé une porte.", "{red}[CSS-RP] ");
				}
				return Action:3;
			}
			if (maison[client][0][0] == 7)
			{
				if (Ent != -1)
				{
					GetEdictClassname(Ent, Door, 255);
					if (IsInA7(Ent))
					{
						if (StrEqual(Door, "func_door_rotating", true))
						{
							if (Entity_IsLocked(Ent))
							{
								CPrintToChat(client, "%s: La porte est déjà  fermée a clef.", "{red}[CSS-RP] ");
							}
							CPrintToChat(client, "%s: Vous avez fermé la porte a clef.", "{red}[CSS-RP] ");
							PrintToConsole(client, "%s: La porte %d est maintenant fermée a clef.", "{red}[CSS-RP] ", Ent);
							Entity_Lock(Ent);
							EmitSoundToAll("doors/default_locked.wav", Ent, 0, 75, 0, 1, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0);
						}
					}
					else
					{
						CPrintToChat(client, "%s: Vous n'avez pas les clef de cette porte.", "{red}[CSS-RP] ");
					}
				}
				else
				{
					CPrintToChat(client, "%s: Vous devez visé une porte.", "{red}[CSS-RP] ");
				}
				return Action:3;
			}
			if (maison[client][0][0] == 8)
			{
				if (Ent != -1)
				{
					GetEdictClassname(Ent, Door, 255);
					if (IsInA8(Ent))
					{
						if (StrEqual(Door, "func_door_rotating", true))
						{
							if (Entity_IsLocked(Ent))
							{
								CPrintToChat(client, "%s: La porte est déjà  fermée a clef.", "{red}[CSS-RP] ");
							}
							CPrintToChat(client, "%s: Vous avez fermé la porte a clef.", "{red}[CSS-RP] ");
							PrintToConsole(client, "%s: La porte %d est maintenant fermée a clef.", "{red}[CSS-RP] ", Ent);
							Entity_Lock(Ent);
							EmitSoundToAll("doors/default_locked.wav", Ent, 0, 75, 0, 1, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0);
						}
					}
					else
					{
						CPrintToChat(client, "%s: Vous n'avez pas les clef de cette porte.", "{red}[CSS-RP] ");
					}
				}
				else
				{
					CPrintToChat(client, "%s: Vous devez visé une porte.", "{red}[CSS-RP] ");
				}
				return Action:3;
			}
			if (maison[client][0][0] == 9)
			{
				if (Ent != -1)
				{
					GetEdictClassname(Ent, Door, 255);
					if (IsInA9(Ent))
					{
						if (StrEqual(Door, "func_door_rotating", true))
						{
							if (Entity_IsLocked(Ent))
							{
								CPrintToChat(client, "%s: La porte est déjà  fermée a clef.", "{red}[CSS-RP] ");
							}
							CPrintToChat(client, "%s: Vous avez fermé la porte a clef.", "{red}[CSS-RP] ");
							PrintToConsole(client, "%s: La porte %d est maintenant fermée a clef.", "{red}[CSS-RP] ", Ent);
							Entity_Lock(Ent);
							EmitSoundToAll("doors/default_locked.wav", Ent, 0, 75, 0, 1, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0);
						}
					}
					else
					{
						CPrintToChat(client, "%s: Vous n'avez pas les clef de cette porte.", "{red}[CSS-RP] ");
					}
				}
				else
				{
					CPrintToChat(client, "%s: Vous devez visé une porte.", "{red}[CSS-RP] ");
				}
				return Action:3;
			}
			if (maison[client][0][0] == 10)
			{
				if (Ent != -1)
				{
					GetEdictClassname(Ent, Door, 255);
					if (IsInA10(Ent))
					{
						if (StrEqual(Door, "func_door_rotating", true))
						{
							if (Entity_IsLocked(Ent))
							{
								CPrintToChat(client, "%s: La porte est déjà  fermée a clef.", "{red}[CSS-RP] ");
							}
							CPrintToChat(client, "%s: Vous avez fermé la porte a clef.", "{red}[CSS-RP] ");
							PrintToConsole(client, "%s: La porte %d est maintenant fermée a clef.", "{red}[CSS-RP] ", Ent);
							Entity_Lock(Ent);
							EmitSoundToAll("doors/default_locked.wav", Ent, 0, 75, 0, 1, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0);
						}
					}
					else
					{
						CPrintToChat(client, "%s: Vous n'avez pas les clef de cette porte.", "{red}[CSS-RP] ");
					}
				}
				else
				{
					CPrintToChat(client, "%s: Vous devez visé une porte.", "{red}[CSS-RP] ");
				}
				return Action:3;
			}
		}
		if (Ent != -1)
		{
			GetEdictClassname(Ent, Door, 255);
			if (StrEqual(Door, "func_door_rotating", true))
			{
				CPrintToChat(client, "%s: Vous n'avez pas les clef de cette porte.", "{red}[CSS-RP] ");
			}
		}
		else
		{
			CPrintToChat(client, "%s: Vous devez visé une porte.", "{red}[CSS-RP] ");
		}
		return Action:3;
	}
	return Action:0;
}

public Action:Cmd_Unlock(client, args)
{
	decl Ent;
	decl String:Doors[256];
	Ent = GetClientAimTarget(client, false);
	if (IsPlayerAlive(client))
	{
		new String:SteamId[32];
		GetClientAuthString(client, SteamId, 32, true);
		if (Ent != -1)
		{
			if (jobid[client][0][0] == 1)
			{
				if (Ent != -1)
				{
					GetEdictClassname(Ent, Doors, 255);
					if (StrEqual(Doors, "func_door_rotating", true))
					{
						if (!Entity_IsLocked(Ent))
						{
							CPrintToChat(client, "%s: La porte est déjà  ouverte.", "{red}[CSS-RP] ");
						}
						CPrintToChat(client, "%s: Vous avez ouvert la porte.", "{red}[CSS-RP] ");
						Entity_UnLock(Ent);
						EmitSoundToAll("doors/latchunlocked1.wav", Ent, 0, 75, 0, 1, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0);
					}
				}
				else
				{
					CPrintToChat(client, "%s: Vous devez visé une porte.", "{red}[CSS-RP] ");
				}
				return Action:3;
			}
			if (jobid[client][0][0] == 4)
			{
				if (IsInComico(Ent))
				{
					if (Ent != -1)
					{
						GetEdictClassname(Ent, Doors, 255);
						if (StrEqual(Doors, "func_door_rotating", true))
						{
							if (!Entity_IsLocked(Ent))
							{
								CPrintToChat(client, "%s: La porte est déjà  ouverte.", "{red}[CSS-RP] ");
							}
							CPrintToChat(client, "%s: Vous avez ouvert la porte.", "{red}[CSS-RP] ");
							Entity_UnLock(Ent);
							EmitSoundToAll("doors/latchunlocked1.wav", Ent, 0, 75, 0, 1, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0);
						}
					}
					else
					{
						CPrintToChat(client, "%s: Vous devez visé une porte.", "{red}[CSS-RP] ");
					}
				}
				else
				{
					CPrintToChat(client, "%s: Vous n'avez pas les clef de cette porte.", "{red}[CSS-RP] ");
				}
				return Action:3;
			}
			if (jobid[client][0][0] == 6)
			{
				if (IsInMafia(Ent))
				{
					if (Ent != -1)
					{
						GetEdictClassname(Ent, Doors, 255);
						if (StrEqual(Doors, "func_door_rotating", true))
						{
							if (!Entity_IsLocked(Ent))
							{
								CPrintToChat(client, "%s: La porte est déjà  ouverte.", "{red}[CSS-RP] ");
							}
							CPrintToChat(client, "%s: Vous avez ouvert la porte.", "{red}[CSS-RP] ");
							Entity_UnLock(Ent);
							EmitSoundToAll("doors/latchunlocked1.wav", Ent, 0, 75, 0, 1, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0);
						}
					}
					else
					{
						CPrintToChat(client, "%s: Vous devez visé une porte.", "{red}[CSS-RP] ");
					}
				}
				else
				{
					CPrintToChat(client, "%s: Vous n'avez pas les clef de cette porte.", "{red}[CSS-RP] ");
				}
				return Action:3;
			}
			if (jobid[client][0][0] == 9)
			{
				if (IsInDealer(Ent))
				{
					if (Ent != -1)
					{
						GetEdictClassname(Ent, Doors, 255);
						if (StrEqual(Doors, "func_door_rotating", true))
						{
							if (!Entity_IsLocked(Ent))
							{
								CPrintToChat(client, "%s: La porte est déjà  ouverte.", "{red}[CSS-RP] ");
							}
							CPrintToChat(client, "%s: Vous avez ouvert la porte.", "{red}[CSS-RP] ");
							Entity_UnLock(Ent);
							EmitSoundToAll("doors/latchunlocked1.wav", Ent, 0, 75, 0, 1, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0);
						}
					}
					else
					{
						CPrintToChat(client, "%s: Vous devez visé une porte.", "{red}[CSS-RP] ");
					}
				}
				else
				{
					CPrintToChat(client, "%s: Vous n'avez pas les clef de cette porte.", "{red}[CSS-RP] ");
				}
				return Action:3;
			}
			if (jobid[client][0][0] == 12)
			{
				if (IsInCoach(Ent))
				{
					if (Ent != -1)
					{
						GetEdictClassname(Ent, Doors, 255);
						if (StrEqual(Doors, "func_door_rotating", true))
						{
							if (!Entity_IsLocked(Ent))
							{
								CPrintToChat(client, "%s: La porte est déjà  ouverte.", "{red}[CSS-RP] ");
							}
							CPrintToChat(client, "%s: Vous avez ouvert la porte.", "{red}[CSS-RP] ");
							Entity_UnLock(Ent);
							EmitSoundToAll("doors/latchunlocked1.wav", Ent, 0, 75, 0, 1, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0);
						}
					}
					else
					{
						CPrintToChat(client, "%s: Vous devez visé une porte.", "{red}[CSS-RP] ");
					}
				}
				else
				{
					CPrintToChat(client, "%s: Vous n'avez pas les clef de cette porte.", "{red}[CSS-RP] ");
				}
				return Action:3;
			}
			if (jobid[client][0][0] == 15)
			{
				if (IsInIkea(Ent))
				{
					if (Ent != -1)
					{
						GetEdictClassname(Ent, Doors, 255);
						if (StrEqual(Doors, "func_door_rotating", true))
						{
							if (!Entity_IsLocked(Ent))
							{
								CPrintToChat(client, "%s: La porte est déjà  ouverte.", "{red}[CSS-RP] ");
							}
							CPrintToChat(client, "%s: Vous avez ouvert la porte.", "{red}[CSS-RP] ");
							Entity_UnLock(Ent);
							EmitSoundToAll("doors/latchunlocked1.wav", Ent, 0, 75, 0, 1, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0);
						}
					}
					else
					{
						CPrintToChat(client, "%s: Vous devez visé une porte.", "{red}[CSS-RP] ");
					}
				}
				else
				{
					CPrintToChat(client, "%s: Vous n'avez pas les clef de cette porte.", "{red}[CSS-RP] ");
				}
				return Action:3;
			}
			if (jobid[client][0][0] == 18)
			{
				if (IsInArmu(Ent))
				{
					if (Ent != -1)
					{
						GetEdictClassname(Ent, Doors, 255);
						if (StrEqual(Doors, "func_door_rotating", true))
						{
							if (!Entity_IsLocked(Ent))
							{
								CPrintToChat(client, "%s: La porte est déjà  ouverte.", "{red}[CSS-RP] ");
							}
							CPrintToChat(client, "%s: Vous avez ouvert la porte.", "{red}[CSS-RP] ");
							Entity_UnLock(Ent);
							EmitSoundToAll("doors/latchunlocked1.wav", Ent, 0, 75, 0, 1, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0);
						}
					}
					else
					{
						CPrintToChat(client, "%s: Vous devez visé une porte.", "{red}[CSS-RP] ");
					}
				}
				else
				{
					CPrintToChat(client, "%s: Vous n'avez pas les clef de cette porte.", "{red}[CSS-RP] ");
				}
				return Action:3;
			}
			if (jobid[client][0][0] == 21)
			{
				if (IsInLoto(Ent))
				{
					if (Ent != -1)
					{
						GetEdictClassname(Ent, Doors, 255);
						if (StrEqual(Doors, "func_door_rotating", true))
						{
							if (!Entity_IsLocked(Ent))
							{
								CPrintToChat(client, "%s: La porte est déjà  ouverte.", "{red}[CSS-RP] ");
							}
							CPrintToChat(client, "%s: Vous avez ouvert la porte.", "{red}[CSS-RP] ");
							Entity_UnLock(Ent);
							EmitSoundToAll("doors/latchunlocked1.wav", Ent, 0, 75, 0, 1, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0);
						}
					}
					else
					{
						CPrintToChat(client, "%s: Vous devez visé une porte.", "{red}[CSS-RP] ");
					}
				}
				else
				{
					CPrintToChat(client, "%s: Vous n'avez pas les clef de cette porte.", "{red}[CSS-RP] ");
				}
				return Action:3;
			}
			if (jobid[client][0][0] == 24)
			{
				if (IsInBank(Ent))
				{
					if (Ent != -1)
					{
						GetEdictClassname(Ent, Doors, 255);
						if (StrEqual(Doors, "func_door_rotating", true))
						{
							if (!Entity_IsLocked(Ent))
							{
								CPrintToChat(client, "%s: La porte est déjà  ouverte.", "{red}[CSS-RP] ");
							}
							CPrintToChat(client, "%s: Vous avez ouvert la porte.", "{red}[CSS-RP] ");
							Entity_UnLock(Ent);
							EmitSoundToAll("doors/latchunlocked1.wav", Ent, 0, 75, 0, 1, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0);
						}
					}
					else
					{
						CPrintToChat(client, "%s: Vous devez visé une porte.", "{red}[CSS-RP] ");
					}
				}
				else
				{
					CPrintToChat(client, "%s: Vous n'avez pas les clef de cette porte.", "{red}[CSS-RP] ");
				}
				return Action:3;
			}
			if (jobid[client][0][0] == 27)
			{
				if (IsInHosto(Ent))
				{
					if (Ent != -1)
					{
						GetEdictClassname(Ent, Doors, 255);
						if (StrEqual(Doors, "func_door_rotating", true))
						{
							if (!Entity_IsLocked(Ent))
							{
								CPrintToChat(client, "%s: La porte est déjà  ouverte.", "{red}[CSS-RP] ");
							}
							CPrintToChat(client, "%s: Vous avez ouvert la porte.", "{red}[CSS-RP] ");
							Entity_UnLock(Ent);
							EmitSoundToAll("doors/latchunlocked1.wav", Ent, 0, 75, 0, 1, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0);
						}
					}
					else
					{
						CPrintToChat(client, "%s: Vous devez visé une porte.", "{red}[CSS-RP] ");
					}
				}
				else
				{
					CPrintToChat(client, "%s: Vous n'avez pas les clef de cette porte.", "{red}[CSS-RP] ");
				}
				return Action:3;
			}
			if (jobid[client][0][0] == 31)
			{
				if (IsInEleven(Ent))
				{
					if (Ent != -1)
					{
						GetEdictClassname(Ent, Doors, 255);
						if (StrEqual(Doors, "func_door_rotating", true))
						{
							if (!Entity_IsLocked(Ent))
							{
								CPrintToChat(client, "%s: La porte est déjà  ouverte.", "{red}[CSS-RP] ");
							}
							CPrintToChat(client, "%s: Vous avez ouvert la porte.", "{red}[CSS-RP] ");
							Entity_UnLock(Ent);
							EmitSoundToAll("doors/latchunlocked1.wav", Ent, 0, 75, 0, 1, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0);
						}
					}
					else
					{
						CPrintToChat(client, "%s: Vous devez visé une porte.", "{red}[CSS-RP] ");
					}
				}
				else
				{
					CPrintToChat(client, "%s: Vous n'avez pas les clef de cette porte.", "{red}[CSS-RP] ");
				}
				return Action:3;
			}
			if (jobid[client][0][0] == 34)
			{
				if (IsInTueur(Ent))
				{
					if (Ent != -1)
					{
						GetEdictClassname(Ent, Doors, 255);
						if (StrEqual(Doors, "func_door_rotating", true))
						{
							if (!Entity_IsLocked(Ent))
							{
								CPrintToChat(client, "%s: La porte est déjà  ouverte.", "{red}[CSS-RP] ");
							}
							CPrintToChat(client, "%s: Vous avez ouvert la porte.", "{red}[CSS-RP] ");
							Entity_UnLock(Ent);
							EmitSoundToAll("doors/latchunlocked1.wav", Ent, 0, 75, 0, 1, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0);
						}
					}
					else
					{
						CPrintToChat(client, "%s: Vous devez visé une porte.", "{red}[CSS-RP] ");
					}
				}
				else
				{
					CPrintToChat(client, "%s: Vous n'avez pas les clef de cette porte.", "{red}[CSS-RP] ");
				}
				return Action:3;
			}
			if (jobid[client][0][0] == 37)
			{
				if (IsInHotel(Ent))
				{
					if (Ent != -1)
					{
						GetEdictClassname(Ent, Doors, 255);
						if (StrEqual(Doors, "func_door_rotating", true))
						{
							if (!Entity_IsLocked(Ent))
							{
								CPrintToChat(client, "%s: La porte est déjà  ouverte.", "{red}[CSS-RP] ");
							}
							CPrintToChat(client, "%s: Vous avez ouvert la porte.", "{red}[CSS-RP] ");
							Entity_UnLock(Ent);
							EmitSoundToAll("doors/latchunlocked1.wav", Ent, 0, 75, 0, 1, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0);
						}
					}
					else
					{
						CPrintToChat(client, "%s: Vous devez visé une porte.", "{red}[CSS-RP] ");
					}
				}
				else
				{
					CPrintToChat(client, "%s: Vous n'avez pas les clef de cette porte.", "{red}[CSS-RP] ");
				}
				return Action:3;
			}
			if (jobid[client][0][0])
			{
				if (maison[client][0][0] == 1)
				{
					if (Ent != -1)
					{
						if (IsInA1(Ent))
						{
							GetEdictClassname(Ent, Doors, 255);
							if (StrEqual(Doors, "func_door_rotating", true))
							{
								if (!Entity_IsLocked(Ent))
								{
									CPrintToChat(client, "%s: La porte est déjà  ouverte.", "{red}[CSS-RP] ");
								}
								CPrintToChat(client, "%s: Vous avez ouvert la porte.", "{red}[CSS-RP] ");
								Entity_UnLock(Ent);
								EmitSoundToAll("doors/latchunlocked1.wav", Ent, 0, 75, 0, 1, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0);
							}
						}
						else
						{
							CPrintToChat(client, "%s: Vous n'avez pas les clef de cette porte.", "{red}[CSS-RP] ");
						}
					}
					else
					{
						CPrintToChat(client, "%s: Vous devez visé une porte.", "{red}[CSS-RP] ");
					}
					return Action:3;
				}
				if (maison[client][0][0] == 2)
				{
					if (Ent != -1)
					{
						if (IsInA2(Ent))
						{
							GetEdictClassname(Ent, Doors, 255);
							if (StrEqual(Doors, "func_door_rotating", true))
							{
								if (!Entity_IsLocked(Ent))
								{
									CPrintToChat(client, "%s: La porte est déjà  ouverte.", "{red}[CSS-RP] ");
								}
								CPrintToChat(client, "%s: Vous avez ouvert la porte.", "{red}[CSS-RP] ");
								Entity_UnLock(Ent);
								EmitSoundToAll("doors/latchunlocked1.wav", Ent, 0, 75, 0, 1, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0);
							}
						}
						else
						{
							CPrintToChat(client, "%s: Vous n'avez pas les clef de cette porte.", "{red}[CSS-RP] ");
						}
					}
					else
					{
						CPrintToChat(client, "%s: Vous devez visé une porte.", "{red}[CSS-RP] ");
					}
					return Action:3;
				}
				if (maison[client][0][0] == 3)
				{
					if (Ent != -1)
					{
						if (IsInA3(Ent))
						{
							GetEdictClassname(Ent, Doors, 255);
							if (StrEqual(Doors, "func_door_rotating", true))
							{
								if (!Entity_IsLocked(Ent))
								{
									CPrintToChat(client, "%s: La porte est déjà  ouverte.", "{red}[CSS-RP] ");
								}
								CPrintToChat(client, "%s: Vous avez ouvert la porte.", "{red}[CSS-RP] ");
								Entity_UnLock(Ent);
								EmitSoundToAll("doors/latchunlocked1.wav", Ent, 0, 75, 0, 1, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0);
							}
						}
						else
						{
							CPrintToChat(client, "%s: Vous n'avez pas les clef de cette porte.", "{red}[CSS-RP] ");
						}
					}
					else
					{
						CPrintToChat(client, "%s: Vous devez visé une porte.", "{red}[CSS-RP] ");
					}
					return Action:3;
				}
				if (maison[client][0][0] == 4)
				{
					if (Ent != -1)
					{
						if (IsInA4(Ent))
						{
							GetEdictClassname(Ent, Doors, 255);
							if (StrEqual(Doors, "func_door_rotating", true))
							{
								if (!Entity_IsLocked(Ent))
								{
									CPrintToChat(client, "%s: La porte est déjà  ouverte.", "{red}[CSS-RP] ");
								}
								CPrintToChat(client, "%s: Vous avez ouvert la porte.", "{red}[CSS-RP] ");
								Entity_UnLock(Ent);
								EmitSoundToAll("doors/latchunlocked1.wav", Ent, 0, 75, 0, 1, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0);
							}
						}
						else
						{
							CPrintToChat(client, "%s: Vous n'avez pas les clef de cette porte.", "{red}[CSS-RP] ");
						}
					}
					else
					{
						CPrintToChat(client, "%s: Vous devez visé une porte.", "{red}[CSS-RP] ");
					}
					return Action:3;
				}
				if (maison[client][0][0] == 5)
				{
					if (Ent != -1)
					{
						if (IsInA5(Ent))
						{
							GetEdictClassname(Ent, Doors, 255);
							if (StrEqual(Doors, "func_door_rotating", true))
							{
								if (!Entity_IsLocked(Ent))
								{
									CPrintToChat(client, "%s: La porte est déjà  ouverte.", "{red}[CSS-RP] ");
								}
								CPrintToChat(client, "%s: Vous avez ouvert la porte.", "{red}[CSS-RP] ");
								Entity_UnLock(Ent);
								EmitSoundToAll("doors/latchunlocked1.wav", Ent, 0, 75, 0, 1, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0);
							}
						}
						else
						{
							CPrintToChat(client, "%s: Vous n'avez pas les clef de cette porte.", "{red}[CSS-RP] ");
						}
					}
					else
					{
						CPrintToChat(client, "%s: Vous devez visé une porte.", "{red}[CSS-RP] ");
					}
					return Action:3;
				}
				if (maison[client][0][0] == 6)
				{
					if (Ent != -1)
					{
						if (IsInA6(Ent))
						{
							GetEdictClassname(Ent, Doors, 255);
							if (StrEqual(Doors, "func_door_rotating", true))
							{
								if (!Entity_IsLocked(Ent))
								{
									CPrintToChat(client, "%s: La porte est déjà  ouverte.", "{red}[CSS-RP] ");
								}
								CPrintToChat(client, "%s: Vous avez ouvert la porte.", "{red}[CSS-RP] ");
								Entity_UnLock(Ent);
								EmitSoundToAll("doors/latchunlocked1.wav", Ent, 0, 75, 0, 1, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0);
							}
						}
						else
						{
							CPrintToChat(client, "%s: Vous n'avez pas les clef de cette porte.", "{red}[CSS-RP] ");
						}
					}
					else
					{
						CPrintToChat(client, "%s: Vous devez visé une porte.", "{red}[CSS-RP] ");
					}
					return Action:3;
				}
				if (maison[client][0][0] == 7)
				{
					if (Ent != -1)
					{
						if (IsInA7(Ent))
						{
							GetEdictClassname(Ent, Doors, 255);
							if (StrEqual(Doors, "func_door_rotating", true))
							{
								if (!Entity_IsLocked(Ent))
								{
									CPrintToChat(client, "%s: La porte est déjà  ouverte.", "{red}[CSS-RP] ");
								}
								CPrintToChat(client, "%s: Vous avez ouvert la porte.", "{red}[CSS-RP] ");
								Entity_UnLock(Ent);
								EmitSoundToAll("doors/latchunlocked1.wav", Ent, 0, 75, 0, 1, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0);
							}
						}
						else
						{
							CPrintToChat(client, "%s: Vous n'avez pas les clef de cette porte.", "{red}[CSS-RP] ");
						}
					}
					else
					{
						CPrintToChat(client, "%s: Vous devez visé une porte.", "{red}[CSS-RP] ");
					}
					return Action:3;
				}
				if (maison[client][0][0] == 8)
				{
					if (Ent != -1)
					{
						if (IsInA8(Ent))
						{
							GetEdictClassname(Ent, Doors, 255);
							if (StrEqual(Doors, "func_door_rotating", true))
							{
								if (!Entity_IsLocked(Ent))
								{
									CPrintToChat(client, "%s: La porte est déjà  ouverte.", "{red}[CSS-RP] ");
								}
								CPrintToChat(client, "%s: Vous avez ouvert la porte.", "{red}[CSS-RP] ");
								Entity_UnLock(Ent);
								EmitSoundToAll("doors/latchunlocked1.wav", Ent, 0, 75, 0, 1, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0);
							}
						}
						else
						{
							CPrintToChat(client, "%s: Vous n'avez pas les clef de cette porte.", "{red}[CSS-RP] ");
						}
					}
					else
					{
						CPrintToChat(client, "%s: Vous devez visé une porte.", "{red}[CSS-RP] ");
					}
					return Action:3;
				}
				if (maison[client][0][0] == 9)
				{
					if (Ent != -1)
					{
						if (IsInA9(Ent))
						{
							GetEdictClassname(Ent, Doors, 255);
							if (StrEqual(Doors, "func_door_rotating", true))
							{
								if (!Entity_IsLocked(Ent))
								{
									CPrintToChat(client, "%s: La porte est déjà  ouverte.", "{red}[CSS-RP] ");
								}
								CPrintToChat(client, "%s: Vous avez ouvert la porte.", "{red}[CSS-RP] ");
								Entity_UnLock(Ent);
								EmitSoundToAll("doors/latchunlocked1.wav", Ent, 0, 75, 0, 1, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0);
							}
						}
						else
						{
							CPrintToChat(client, "%s: Vous n'avez pas les clef de cette porte.", "{red}[CSS-RP] ");
						}
					}
					else
					{
						CPrintToChat(client, "%s: Vous devez visé une porte.", "{red}[CSS-RP] ");
					}
					return Action:3;
				}
				if (maison[client][0][0] == 10)
				{
					if (Ent != -1)
					{
						if (IsInA10(Ent))
						{
							GetEdictClassname(Ent, Doors, 255);
							if (StrEqual(Doors, "func_door_rotating", true))
							{
								if (!Entity_IsLocked(Ent))
								{
									CPrintToChat(client, "%s: La porte est déjà  ouverte.", "{red}[CSS-RP] ");
								}
								CPrintToChat(client, "%s: Vous avez ouvert la porte.", "{red}[CSS-RP] ");
								Entity_UnLock(Ent);
								EmitSoundToAll("doors/latchunlocked1.wav", Ent, 0, 75, 0, 1, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0);
							}
						}
						else
						{
							CPrintToChat(client, "%s: Vous n'avez pas les clef de cette porte.", "{red}[CSS-RP] ");
						}
					}
					else
					{
						CPrintToChat(client, "%s: Vous devez visé une porte.", "{red}[CSS-RP] ");
					}
					return Action:3;
				}
			}
			if (Ent != -1)
			{
				GetEdictClassname(Ent, Doors, 255);
				if (StrEqual(Doors, "func_door_rotating", true))
				{
					CPrintToChat(client, "%s: Vous n'avez pas les clef de cette porte.", "{red}[CSS-RP] ");
				}
			}
			else
			{
				CPrintToChat(client, "%s: Vous devez visé une porte.", "{red}[CSS-RP] ");
			}
			return Action:3;
		}
		else
		{
			CPrintToChat(client, "%s: Vous devez visé une porte.", "{red}[CSS-RP] ");
		}
	}
	return Action:0;
}

public Action:Command_Civil(client, args)
{
	if (jobid[client][0][0] == 1)
	{
		if (GetClientTeam(client) == 3)
		{
			CS_SwitchTeam(client, 2);
			CS_SetClientClanTag(client, "Chômeur -");
			CPrintToChat(client, "%s: Vous êtes désormais en civil.", "{red}[CSS-RP] ");
			SetEntityModel(client, "models/player/slow/50cent/slow.mdl");
		}
		else
		{
			CS_SwitchTeam(client, 3);
			CS_SetClientClanTag(client, "C. Police -");
			CPrintToChat(client, "%s: Vous êtes désormais en flic.", "{red}[CSS-RP] ");
			SetEntityModel(client, "models/player/leb/t_leet.mdl");
		}
	}
	else
	{
		if (jobid[client][0][0] == 2)
		{
			if (GetClientTeam(client) == 3)
			{
				CS_SwitchTeam(client, 2);
				CS_SetClientClanTag(client, "Chômeur -");
				CPrintToChat(client, "%s: Vous êtes désormais en civil.", "{red}[CSS-RP] ");
				SetEntityModel(client, "models/player/slow/50cent/slow.mdl");
			}
			else
			{
				CS_SwitchTeam(client, 3);
				CS_SetClientClanTag(client, "Agent CIA -");
				CPrintToChat(client, "%s: Vous êtes désormais en flic.", "{red}[CSS-RP] ");
				SetEntityModel(client, "models/player/notdelite/desert_sas/ct_sas.mdl");
			}
		}
		if (jobid[client][0][0] == 3)
		{
			if (GetClientTeam(client) == 3)
			{
				CS_SwitchTeam(client, 2);
				CS_SetClientClanTag(client, "Chômeur -");
				CPrintToChat(client, "%s: Vous êtes désormais en civil.", "{red}[CSS-RP] ");
				SetEntityModel(client, "models/player/slow/50cent/slow.mdl");
			}
			else
			{
				CS_SwitchTeam(client, 3);
				CS_SetClientClanTag(client, "Agent du FBI -");
				CPrintToChat(client, "%s: Vous êtes désormais en flic.", "{red}[CSS-RP] ");
				SetEntityModel(client, "models/player/ics/ct_gign_fbi/ct_gign.mdl");
			}
		}
		CPrintToChat(client, "%s: Vous n'avez pas accès a cette commande.", "{red}[CSS-RP] ");
	}
	return Action:0;
}

public Action:Command_Cash(client, args)
{
	if (!IsPlayerAlive(client))
	{
		CPrintToChat(client, "%s: Vous ne pouvez pas utiliser cette commande quand vous êtes mort.", "{red}[CSS-RP] ");
		return Action:3;
	}
	new String:arg1[32];
	GetCmdArg(1, arg1, 32);
	if (0 >= args)
	{
		CPrintToChat(client, "%s: Usage: sm_give 'amount'", "{red}[CSS-RP] ");
		return Action:3;
	}
	if (IsPlayerAlive(client))
	{
		if (g_IsInJail[client][0][0])
		{
			CPrintToChat(client, "%s: Vous ne pouvez pas donné de l'argent en prison.", "{red}[CSS-RP] ");
		}
		else
		{
			new MoneyOffset = FindSendPropOffs("CCSPlayer", "m_iAccount");
			money[client] = GetEntData(client, MoneyOffset, 4);
			new debit_amt = StringToInt(arg1, 10);
			if (0 > debit_amt)
			{
				CPrintToChat(client, "%s: Vous ne pouvez pas donné une somme négative.", "{red}[CSS-RP] ");
				return Action:3;
			}
			if (money[client][0][0] < debit_amt)
			{
				CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
				return Action:3;
			}
			decl Ent;
			decl String:ClassName[256];
			Ent = GetClientAimTarget(client, false);
			if (Ent != -1)
			{
				GetEdictClassname(Ent, ClassName, 255);
				new total_cash = money[Ent][0][0][debit_amt];
				if (total_cash > 65535)
				{
					new difference = total_cash + -65535;
					debit_amt -= difference;
				}
				var1 = var1[0][0][debit_amt];
				SetEntData(Ent, MoneyOffset, money[Ent][0][0], 4, true);
				var2 = var2[0][0] - debit_amt;
				SetEntData(client, MoneyOffset, money[client][0][0], 4, true);
				CPrintToChat(client, "%s: Tu as donné %i€ à  %N.", "{red}[CSS-RP] ", debit_amt, Ent);
				CPrintToChat(Ent, "%s: Tu as reçu %i€ par %N.", "{red}[CSS-RP] ", debit_amt, client);
				return Action:3;
			}
			CPrintToChat(client, "%s: Tu dois regarder un joueur.", "{red}[CSS-RP] ");
		}
	}
	else
	{
		CPrintToChat(client, "%s: Vous devez être en vie.", "{red}[CSS-RP] ");
	}
	return Action:0;
}

public Action:Command_Jail(client, args)
{
	if (client > 0)
	{
		if (IsClientInGame(client))
		{
			if (IsPlayerAlive(client))
			{
				if (GetClientTeam(client) == 3)
				{
					jail[client] = GetClientAimTarget(client, true);
					if (jail[client][0][0] != -1)
					{
						if (g_invisible[client][0][0])
						{
							CPrintToChat(client, "%s: Vous devez être visible pour jail.", "{red}[CSS-RP] ");
						}
						if (jail[client][0][0] < 1)
						{
							CPrintToChat(client, "%s: Vous devez visé un joueur", "{red}[CSS-RP] ");
							return Action:3;
						}
						new Float:entorigin[3] = 0;
						new Float:clientent[3] = 0;
						GetEntPropVector(jail[client][0][0], PropType:0, "m_vecOrigin", entorigin, 0);
						GetEntPropVector(client, PropType:0, "m_vecOrigin", clientent, 0);
						new Float:distance = GetVectorDistance(entorigin, clientent, false);
						if (GetClientTeam(jail[client][0][0]) == 2)
						{
							if (distance <= 1.401298E-42)
							{
								switch (GetRandomInt(1, 4))
								{
									case 1:
									{
										TeleportEntity(jail[client][0][0], 67184, NULL_VECTOR, NULL_VECTOR);
									}
									case 2:
									{
										TeleportEntity(jail[client][0][0], 67196, NULL_VECTOR, NULL_VECTOR);
									}
									case 3:
									{
										TeleportEntity(jail[client][0][0], 67208, NULL_VECTOR, NULL_VECTOR);
									}
									case 4:
									{
										TeleportEntity(jail[client][0][0], 67220, NULL_VECTOR, NULL_VECTOR);
									}
									default:
									{
									}
								}
								CPrintToChat(client, "%s: Tu as emprisonné le joueur : %N", "{red}[CSS-RP] ", jail[client]);
								CPrintToChat(jail[client][0][0], "%s: Tu as été emprisonné par : %N", "{red}[CSS-RP] ", client);
								disarm(jail[client][0][0]);
								GivePlayerItem(jail[client][0][0], "weapon_knife", 0);
								SetClientListeningFlags(jail[client][0][0], 1);
								g_IsInJail[jail[client][0][0]] = 1;
								gObj[jail[client][0][0]] = -1;
								grab[jail[client][0][0]] = 0;
								new Handle:menu = CreateMenu(Menu_Jail, MenuAction:28);
								SetMenuTitle(menu, "Choisissez la peine pour %N :", jail[client]);
								AddMenuItem(menu, "meurtrep", "Meurtre sur Policier.", 0);
								AddMenuItem(menu, "meurtrec", "Meurtre sur Civil.", 0);
								AddMenuItem(menu, "tentative", "Tentative de Meurtre.", 0);
								AddMenuItem(menu, "crochetage", "Crochetage.", 0);
								AddMenuItem(menu, "vol", "Vol.", 0);
								AddMenuItem(menu, "nuisances", "Nuisances sonores", 0);
								AddMenuItem(menu, "insultes", "Insultes.", 0);
								AddMenuItem(menu, "permis", "Possession d'armes illà©gales.", 0);
								AddMenuItem(menu, "intrusion", "Intrusion.", 0);
								AddMenuItem(menu, "tir", "Tir dans la rue.", 0);
								AddMenuItem(menu, "obstruction", "Obstruction envers les forces de l'ordres", 0);
								AddMenuItem(menu, "evasion", "Tentative d'à©vasion", 0);
								AddMenuItem(menu, "liberation", "Libà©rà© Le joueur", 0);
								DisplayMenu(menu, client, 0);
								if (g_booljail[jail[client][0][0]][0][0])
								{
									KillTimer(g_jailtimer[jail[client][0][0]][0][0], false);
								}
								if (g_boolreturn[jail[client][0][0]][0][0])
								{
									KillTimer(g_jailreturn[jail[client][0][0]][0][0], false);
								}
							}
							else
							{
								CPrintToChat(client, "%s: Vous êtes trop loin pour mettre en prison.", "{red}[CSS-RP] ");
							}
						}
						else
						{
							CPrintToChat(client, "%s: Vous ne pouvez pas mettre en prison un policier.", "{red}[CSS-RP] ");
						}
					}
				}
				else
				{
					CPrintToChat(client, "%s: Vous n'avez pas accès a cette commande.", "{red}[CSS-RP] ");
				}
			}
			CPrintToChat(client, "%s: vous devez être en vie pour emprisonné un joueur.", "{red}[CSS-RP] ");
		}
	}
	return Action:0;
}

public Menu_Jail(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		if (jail[client][0][0] > 0)
		{
			if (IsClientInGame(jail[client][0][0]))
			{
				if (jail[client][0][0] != -1)
				{
					new String:info[64];
					GetMenuItem(menu, param2, info, 64, 0, "", 0);
					if (StrEqual(info, "meurtrep", true))
					{
						SetupJail(client, jail[client][0][0], 480, 1000);
						CPrintToChat(jail[client][0][0], "%s: Vous avez été emprisonné pour meurtre sur policier.", "{red}[CSS-RP] ");
					}
					else
					{
						if (StrEqual(info, "meurtrec", true))
						{
							SetupJail(client, jail[client][0][0], 360, 800);
							CPrintToChat(jail[client][0][0], "%s: Vous avez été emprisonné pour meurtre sur civil.", "{red}[CSS-RP] ");
						}
						if (StrEqual(info, "tentative", true))
						{
							SetupJail(client, jail[client][0][0], 300, 500);
							CPrintToChat(jail[client][0][0], "%s: Vous avez été emprisonné pour tentative de meurtre.", "{red}[CSS-RP] ");
						}
						if (StrEqual(info, "crochetage", true))
						{
							SetupJail(client, jail[client][0][0], 180, 200);
							CPrintToChat(jail[client][0][0], "%s: Vous avez été emprisonné pour crochetage.", "{red}[CSS-RP] ");
						}
						if (StrEqual(info, "vol", true))
						{
							SetupJail(client, jail[client][0][0], 180, 200);
							CPrintToChat(jail[client][0][0], "%s: Vous avez été emprisonné pour vol.", "{red}[CSS-RP] ");
						}
						if (StrEqual(info, "nuisances", true))
						{
							SetupJail(client, jail[client][0][0], 240, 500);
							CPrintToChat(jail[client][0][0], "%s: Vous avez été emprisonné pour nuisances sonores.", "{red}[CSS-RP] ");
						}
						if (StrEqual(info, "insultes", true))
						{
							SetupJail(client, jail[client][0][0], 240, 600);
							CPrintToChat(jail[client][0][0], "%s: Vous avez été emprisonné pour insultes.", "{red}[CSS-RP] ");
						}
						if (StrEqual(info, "permis", true))
						{
							SetupJail(client, jail[client][0][0], 300, 600);
							CPrintToChat(jail[client][0][0], "%s: Vous avez été emprisonné pour possession d'armes illà©gales.", "{red}[CSS-RP] ");
						}
						if (StrEqual(info, "intrusion", true))
						{
							SetupJail(client, jail[client][0][0], 180, 200);
							CPrintToChat(jail[client][0][0], "%s: Vous avez été emprisonné pour intrusion.", "{red}[CSS-RP] ");
						}
						if (StrEqual(info, "tir", true))
						{
							SetupJail(client, jail[client][0][0], 180, 250);
							CPrintToChat(jail[client][0][0], "%s: Vous avez été emprisonné pour tir dans la rue.", "{red}[CSS-RP] ");
						}
						if (StrEqual(info, "obstruction", true))
						{
							SetupJail(client, jail[client][0][0], 120, 250);
							CPrintToChat(jail[client][0][0], "%s: Vous avez été emprisonné pour obstruction envers la police.", "{red}[CSS-RP] ");
						}
						if (StrEqual(info, "evasion", true))
						{
							SetupJail(client, jail[client][0][0], 200, 400);
							CPrintToChat(jail[client][0][0], "%s: Vous avez été emprisonné pour Tentative d'évasion.", "{red}[CSS-RP] ");
						}
						if (StrEqual(info, "liberation", true))
						{
							SetupJail(client, jail[client][0][0], 10, 0);
							CPrintToChat(jail[client][0][0], "%s: Vous allez être liberé !", "{red}[CSS-RP] ");
						}
					}
				}
			}
		}
	}
	return 0;
}

public SetupJail(policier, detenu, temps, amende)
{
	if (IsClientInGame(detenu))
	{
		if (IsClientInGame(policier))
		{
			g_jailtime[detenu] = temps;
			g_booljail[detenu] = 1;
			price[detenu] = amende;
			responsable[detenu] = policier;
			new Handle:menu = CreateMenu(Caution_Menu, MenuAction:28);
			SetMenuTitle(menu, "Voulez-vous payé votre caution de %i€ ?", amende);
			AddMenuItem(menu, "oui", "Oui je veux.", 0);
			AddMenuItem(menu, "non", "Non merci.", 0);
			DisplayMenu(menu, detenu, 0);
			g_jailtimer[detenu] = CreateTimer(1, Jail_Raison, detenu, 1);
		}
	}
	return 0;
}

public Caution_Menu(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[64];
		GetMenuItem(menu, param2, info, 64, 0, "", 0);
		new MoneyOffset = FindSendPropOffs("CCSPlayer", "m_iAccount");
		if (client > 0)
		{
			if (StrEqual(info, "oui", true))
			{
				if (price[client][0][0] <= money[client][0][0])
				{
					if (0 < price[client][0][0])
					{
						CPrintToChat(responsable[client][0][0], "%s: Le joueur %N a payé sa caution de %i", "{red}[CSS-RP] ", client, price[client]);
						CPrintToChat(client, "%s: Vous avez payé votre caution de %i.", "{red}[CSS-RP] ", price[client]);
						money[client] = money[client][0][0] - price[client][0][0];
						AdCash(responsable[client][0][0], price[client][0][0] / 2);
						capital[rankid[responsable[client][0][0]][0][0]] = capital[rankid[responsable[client][0][0]][0][0]][0][0][price[client][0][0] / 2];
						g_jailtime[client] = g_jailtime[client][0][0] / 2;
						SetEntData(client, MoneyOffset, money[client][0][0], 4, true);
					}
					else
					{
						CPrintToChat(client, "%s: Vous ne pouvez pas payé votre caution, vous allez être libéré.", "{red}[CSS-RP] ");
					}
				}
				else
				{
					if (cb[client][0][0] == 1)
					{
						if (price[client][0][0] <= bank[client][0][0])
						{
							if (0 < price[client][0][0])
							{
								CPrintToChat(responsable[client][0][0], "%s: Le joueur %N a payé sa caution de %i", "{red}[CSS-RP] ", client, price[client]);
								CPrintToChat(client, "%s: Vous avez payé votre caution de %i.", "{red}[CSS-RP] ", price[client]);
								money[client] = money[client][0][0] - price[client][0][0];
								AdCash(responsable[client][0][0], price[client][0][0] / 2);
								capital[rankid[responsable[client][0][0]][0][0]] = capital[rankid[responsable[client][0][0]][0][0]][0][0][price[client][0][0] / 2];
								g_jailtime[client] = g_jailtime[client][0][0] / 2;
							}
							else
							{
								CPrintToChat(client, "%s: Vous ne pouvez pas payé votre caution, vous allez être libéré.", "{red}[CSS-RP] ");
							}
						}
						else
						{
							CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
							CPrintToChat(responsable[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
						}
					}
					CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
					CPrintToChat(responsable[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
				}
			}
			if (StrEqual(info, "non", true))
			{
				CPrintToChat(responsable[client][0][0], "%s: Le joueur %N a refusé de payé sa caution de %i.", "{red}[CSS-RP] ", client, price[client]);
				CPrintToChat(client, "%s: Vous avez refusé de payé votre caution de %i.", "{red}[CSS-RP] ", price[client]);
			}
		}
	}
	return 0;
}

public Action:Jail_Raison(Handle:timer, client)
{
	if (client > any:0)
	{
		if (IsClientInGame(client))
		{
			if (0 < g_jailtime[client][0][0])
			{
				var2 = var2[0][0][0];
				if (g_jailtime[client][0][0])
				{
				}
				else
				{
					KillTimer(g_jailtimer[client][0][0], false);
					CPrintToChat(client, "%s: Vous avez été libéré de prison.", "{red}[CSS-RP] ");
					SetClientListeningFlags(client, 0);
					switch (GetRandomInt(1, 5))
					{
						case 1:
						{
							TeleportEntity(client, 70128, NULL_VECTOR, NULL_VECTOR);
						}
						case 2:
						{
							TeleportEntity(client, 70140, NULL_VECTOR, NULL_VECTOR);
						}
						case 3:
						{
							TeleportEntity(client, 70152, NULL_VECTOR, NULL_VECTOR);
						}
						case 4:
						{
							TeleportEntity(client, 70164, NULL_VECTOR, NULL_VECTOR);
						}
						case 5:
						{
							TeleportEntity(client, 70176, NULL_VECTOR, NULL_VECTOR);
						}
						default:
						{
						}
					}
					g_IsInJail[client] = 0;
					g_jailtime[client] = 0;
					price[client] = 0;
					responsable[client] = 0;
					g_booljail[client] = 0;
				}
			}
		}
	}
	return Action:0;
}

public Action:Jail_Return(Handle:timer, client)
{
	if (IsClientInGame(client))
	{
		if (0 < g_jailtime[client][0][0])
		{
			var1 = var1[0][0][0];
			if (g_jailtime[client][0][0])
			{
			}
			else
			{
				g_IsInJail[client] = 0;
				g_jailtime[client] = 0;
				price[client] = 0;
				responsable[client] = 0;
				CPrintToChat(client, "%s: Vous avez été libéré de prison.", "{red}[CSS-RP] ");
				switch (GetRandomInt(1, 5))
				{
					case 1:
					{
						TeleportEntity(client, 70244, NULL_VECTOR, NULL_VECTOR);
					}
					case 2:
					{
						TeleportEntity(client, 70256, NULL_VECTOR, NULL_VECTOR);
					}
					case 3:
					{
						TeleportEntity(client, 70268, NULL_VECTOR, NULL_VECTOR);
					}
					case 4:
					{
						TeleportEntity(client, 70280, NULL_VECTOR, NULL_VECTOR);
					}
					case 5:
					{
						TeleportEntity(client, 70292, NULL_VECTOR, NULL_VECTOR);
					}
					default:
					{
					}
				}
				KillTimer(g_jailreturn[client][0][0], false);
				g_boolreturn[client] = 0;
			}
		}
	}
	return Action:0;
}

public Action:Command_Jaillist(client, args)
{
	if (IsClientInGame(client))
	{
		if (IsPlayerAlive(client))
		{
			if (GetClientTeam(client) == 3)
			{
				ShowPrisonner(client);
				return Action:3;
			}
			CPrintToChat(client, "%s: Vous n'avez pas accès a cette commande.", "{red}[CSS-RP] ");
		}
		CPrintToChat(client, "%s: Vous devez être en vie.", "{red}[CSS-RP] ");
	}
	return Action:0;
}

ShowPrisonner(client)
{
	if (client > 0)
	{
		decl String:sMenuText[64];
		sMenuText[0] = 0;
		new Handle:menu = CreateMenu(Menu_Prisonnier, MenuAction:28);
		SetMenuTitle(menu, "Liste des prisonniers :");
		SetMenuExitButton(menu, true);
		AddPrisonniers(menu);
		DisplayMenu(menu, client, 0);
	}
	return 0;
}

public AddPrisonniers(Handle:menu)
{
	decl String:user_id[12];
	decl String:name[32];
	decl String:display[48];
	new i = 1;
	while (i <= MaxClients)
	{
		if (IsClientInGame(i))
		{
			IntToString(GetClientUserId(i), user_id, 12);
			GetClientName(i, name, 32);
			Format(display, 47, "%s => %i", name, g_jailtime[i]);
			AddMenuItem(menu, user_id, display, 1);
			i++;
		}
		i++;
	}
	return 0;
}

public Menu_Prisonnier(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:16)
	{
		CloseHandle(menu);
	}
	return 0;
}

public Action:Command_Vis(client, args)
{
	if (jobid[client][0][0] == 1)
	{
		if (IsPlayerAlive(client))
		{
			if (g_invisible[client][0][0] == 1)
			{
				SDKUnhook(client, SDKHookType:6, Hook_SetTransmit);
				CPrintToChat(client, "%s: Vous êtes désormais visible.", "{red}[CSS-RP] ");
				g_invisible[client] = 0;
			}
			else
			{
				SDKHook(client, SDKHookType:6, Hook_SetTransmit);
				CPrintToChat(client, "%s: Vous êtes désormais invisible.", "{red}[CSS-RP] ");
				g_invisible[client] = 1;
			}
		}
		else
		{
			CPrintToChat(client, "%s: Vous devez être en vie pour utilisé cette commande.", "{red}[CSS-RP] ");
		}
	}
	else
	{
		CPrintToChat(client, "%s: Vous n'avez pas accès a cette commande.", "{red}[CSS-RP] ");
	}
	return Action:0;
}

public Action:Hook_SetTransmit(entity, client)
{
	if (client != entity)
	{
		return Action:3;
	}
	return Action:0;
}

public Action:Command_Jobmenu(client, args)
{
	if (GetUserFlagBits(client) & 16384)
	{
		LoopPlayers(client);
	}
	else
	{
		CPrintToChat(client, "%s: Vous n'avez pas accès a cette commande.", "{red}[CSS-RP] ");
	}
	return Action:0;
}

LoopPlayers(client)
{
	if (client > 0)
	{
		decl String:sMenuText[64];
		sMenuText[0] = 0;
		new Handle:menu = CreateMenu(MenuHandler_LoopPlayers, MenuAction:28);
		SetMenuTitle(menu, "Choisissez Le joueur :");
		SetMenuExitButton(menu, true);
		Addplayers(menu);
		DisplayMenu(menu, client, 0);
	}
	return 0;
}

public Addplayers(Handle:menu)
{
	decl String:user_id[12];
	decl String:name[32];
	decl String:display[48];
	new i = 1;
	while (i <= MaxClients)
	{
		if (IsClientInGame(i))
		{
			IntToString(GetClientUserId(i), user_id, 12);
			GetClientName(i, name, 32);
			Format(display, 47, "%s (%s)", name, user_id);
			AddMenuItem(menu, user_id, display, 0);
			i++;
		}
		i++;
	}
	return 0;
}

public MenuHandler_LoopPlayers(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[64];
		new String:SteamId[32];
		GetMenuItem(menu, param2, info, 64, 0, "", 0);
		new UserID = StringToInt(info, 10);
		p[client] = GetClientOfUserId(UserID);
		GetClientAuthString(client, SteamId, 32, true);
		new Handle:menuc = CreateMenu(jobmenu, MenuAction:28);
		SetMenuTitle(menuc, "Choisissez le job de : %N (%d) :", p[client], UserID);
		AddMenuItem(menuc, "1", "Chef police", 0);
		AddMenuItem(menuc, "2", "Agent de la CIA", 0);
		AddMenuItem(menuc, "3", "Agent du FBI", 0);
		AddMenuItem(menuc, "4", "Agent de police", 0);
		AddMenuItem(menuc, "5", "Gardien", 0);
		AddMenuItem(menuc, "6", "Chef mafia", 0);
		AddMenuItem(menuc, "7", "Mafieux", 0);
		AddMenuItem(menuc, "8", "Apprenti Mafieux", 0);
		AddMenuItem(menuc, "15", "D. Ikea", 0);
		AddMenuItem(menuc, "16", "Vendeur Ikea", 0);
		AddMenuItem(menuc, "17", "Apprenti V Ikea", 0);
		AddMenuItem(menuc, "18", "Chef de l'armurie", 0);
		AddMenuItem(menuc, "19", "Armurier", 0);
		AddMenuItem(menuc, "20", "Apprenti Armurier", 0);
		AddMenuItem(menuc, "12", "Chef des Coach", 0);
		AddMenuItem(menuc, "13", "Coach", 0);
		AddMenuItem(menuc, "14", "Apprenti Coach", 0);
		AddMenuItem(menuc, "0", "Chômeur", 0);
		AddMenuItem(menuc, "21", "Chef Loto", 0);
		AddMenuItem(menuc, "22", "Vendeur de Ticket", 0);
		AddMenuItem(menuc, "23", "Apprenti Vendeur de Ticket", 0);
		AddMenuItem(menuc, "9", "Chef Dealer", 0);
		AddMenuItem(menuc, "10", "Dealer", 0);
		AddMenuItem(menuc, "11", "Apprenti Dealer", 0);
		AddMenuItem(menuc, "24", "Chef Banquier", 0);
		AddMenuItem(menuc, "25", "Banquier", 0);
		AddMenuItem(menuc, "26", "Apprenti Banquier", 0);
		AddMenuItem(menuc, "27", "D. Hopital", 0);
		AddMenuItem(menuc, "28", "Médecin", 0);
		AddMenuItem(menuc, "29", "Infirmier", 0);
		AddMenuItem(menuc, "30", "Chirurgien", 0);
		AddMenuItem(menuc, "31", "Chef Artificier", 0);
		AddMenuItem(menuc, "32", "Artificier", 0);
		AddMenuItem(menuc, "33", "Apprenti Artificier", 0);
		AddMenuItem(menuc, "34", "Chef Tueur", 0);
		AddMenuItem(menuc, "35", "Tueur d'élite", 0);
		AddMenuItem(menuc, "36", "Tueur novice", 0);
		AddMenuItem(menuc, "37", "D. Immobilier", 0);
		AddMenuItem(menuc, "38", "V. Immobilier", 0);
		AddMenuItem(menuc, "39", "Apprenti V. Immobilier", 0);
		DisplayMenu(menuc, client, 0);
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public jobmenu(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[32];
		GetMenuItem(menu, param2, info, 32, 0, "", 0);
		jobid[p[client][0][0]] = StringToInt(info, 10);
		chooseskin(p[client][0][0]);
		if (StrEqual(info, "2", true))
		{
			CS_SetClientClanTag(p[client][0][0], "Agent CIA -");
			rankid[p[client][0][0]] = 1;
			if (GetClientTeam(p[client][0][0]) == 2)
			{
				CS_SwitchTeam(p[client][0][0], 3);
				SetEntityModel(p[client][0][0], "models/player/ct_gign.mdl");
			}
		}
		else
		{
			if (StrEqual(info, "1", true))
			{
				CS_SetClientClanTag(p[client][0][0], "C. police -");
				rankid[p[client][0][0]] = 1;
				if (GetClientTeam(p[client][0][0]) == 2)
				{
					CS_SwitchTeam(p[client][0][0], 3);
					SetEntityModel(p[client][0][0], "models/player/ct_gign.mdl");
				}
			}
			if (StrEqual(info, "3", true))
			{
				CS_SetClientClanTag(p[client][0][0], "Agent du FBI -");
				rankid[p[client][0][0]] = 1;
				if (GetClientTeam(p[client][0][0]) == 2)
				{
					CS_SwitchTeam(p[client][0][0], 3);
					SetEntityModel(p[client][0][0], "models/player/ct_gign.mdl");
				}
			}
			if (StrEqual(info, "4", true))
			{
				CS_SetClientClanTag(p[client][0][0], "Policier -");
				rankid[p[client][0][0]] = 1;
				if (GetClientTeam(p[client][0][0]) == 2)
				{
					CS_SwitchTeam(p[client][0][0], 3);
					SetEntityModel(p[client][0][0], "models/player/ct_gign.mdl");
				}
			}
			if (StrEqual(info, "5", true))
			{
				CS_SetClientClanTag(p[client][0][0], "Gardien -");
				rankid[p[client][0][0]] = 1;
				if (GetClientTeam(p[client][0][0]) == 2)
				{
					CS_SwitchTeam(p[client][0][0], 3);
					SetEntityModel(p[client][0][0], "models/player/ct_gign.mdl");
				}
			}
			if (StrEqual(info, "6", true))
			{
				CS_SetClientClanTag(p[client][0][0], "C. Mafia -");
				rankid[p[client][0][0]] = 2;
				if (GetClientTeam(p[client][0][0]) == 3)
				{
					CS_SwitchTeam(p[client][0][0], 2);
					SetEntityModel(p[client][0][0], "models/player/t_guerilla.mdl");
				}
			}
			if (StrEqual(info, "7", true))
			{
				CS_SetClientClanTag(p[client][0][0], "Mafieux -");
				rankid[p[client][0][0]] = 2;
				if (GetClientTeam(p[client][0][0]) == 3)
				{
					CS_SwitchTeam(p[client][0][0], 2);
					SetEntityModel(p[client][0][0], "models/player/t_guerilla.mdl");
				}
			}
			if (StrEqual(info, "8", true))
			{
				CS_SetClientClanTag(p[client][0][0], "A. Mafieux -");
				rankid[p[client][0][0]] = 2;
				if (GetClientTeam(p[client][0][0]) == 3)
				{
					CS_SwitchTeam(p[client][0][0], 2);
					SetEntityModel(p[client][0][0], "models/player/t_guerilla.mdl");
				}
			}
			if (StrEqual(info, "21", true))
			{
				CS_SetClientClanTag(p[client][0][0], "C. Loto -");
				rankid[p[client][0][0]] = 7;
				if (GetClientTeam(p[client][0][0]) == 3)
				{
					CS_SwitchTeam(p[client][0][0], 2);
					SetEntityModel(p[client][0][0], "models/player/t_guerilla.mdl");
				}
			}
			if (StrEqual(info, "22", true))
			{
				CS_SetClientClanTag(p[client][0][0], "V. Ticket -");
				rankid[p[client][0][0]] = 7;
				if (GetClientTeam(p[client][0][0]) == 3)
				{
					CS_SwitchTeam(p[client][0][0], 2);
					SetEntityModel(p[client][0][0], "models/player/t_guerilla.mdl");
				}
			}
			if (StrEqual(info, "31", true))
			{
				CS_SetClientClanTag(p[client][0][0], "C. Artificier -");
				rankid[p[client][0][0]] = 10;
				if (GetClientTeam(p[client][0][0]) == 3)
				{
					CS_SwitchTeam(p[client][0][0], 2);
					SetEntityModel(p[client][0][0], "models/player/t_guerilla.mdl");
				}
			}
			if (StrEqual(info, "32", true))
			{
				CS_SetClientClanTag(p[client][0][0], "Artificier -");
				rankid[p[client][0][0]] = 10;
				if (GetClientTeam(p[client][0][0]) == 3)
				{
					CS_SwitchTeam(p[client][0][0], 2);
					SetEntityModel(p[client][0][0], "models/player/t_guerilla.mdl");
				}
			}
			if (StrEqual(info, "33", true))
			{
				CS_SetClientClanTag(p[client][0][0], "A. Artificier -");
				rankid[p[client][0][0]] = 10;
				if (GetClientTeam(p[client][0][0]) == 3)
				{
					CS_SwitchTeam(p[client][0][0], 2);
					SetEntityModel(p[client][0][0], "models/player/t_guerilla.mdl");
				}
			}
			if (StrEqual(info, "23", true))
			{
				CS_SetClientClanTag(p[client][0][0], "A.V. Ticket -");
				rankid[p[client][0][0]] = 7;
				if (GetClientTeam(p[client][0][0]) == 3)
				{
					CS_SwitchTeam(p[client][0][0], 2);
					SetEntityModel(p[client][0][0], "models/player/t_guerilla.mdl");
				}
			}
			if (StrEqual(info, "18", true))
			{
				CS_SetClientClanTag(p[client][0][0], "C. Armurie -");
				rankid[p[client][0][0]] = 6;
				if (GetClientTeam(p[client][0][0]) == 3)
				{
					CS_SwitchTeam(p[client][0][0], 2);
					SetEntityModel(p[client][0][0], "models/player/t_guerilla.mdl");
				}
			}
			if (StrEqual(info, "19", true))
			{
				CS_SetClientClanTag(p[client][0][0], "Armurier -");
				rankid[p[client][0][0]] = 6;
				if (GetClientTeam(p[client][0][0]) == 3)
				{
					CS_SwitchTeam(p[client][0][0], 2);
					SetEntityModel(p[client][0][0], "models/player/t_guerilla.mdl");
				}
			}
			if (StrEqual(info, "20", true))
			{
				CS_SetClientClanTag(p[client][0][0], "A. Armurier -");
				rankid[p[client][0][0]] = 6;
				if (GetClientTeam(p[client][0][0]) == 3)
				{
					CS_SwitchTeam(p[client][0][0], 2);
					SetEntityModel(p[client][0][0], "models/player/t_guerilla.mdl");
				}
			}
			if (StrEqual(info, "15", true))
			{
				CS_SetClientClanTag(p[client][0][0], "C. Ikea -");
				rankid[p[client][0][0]] = 5;
				if (GetClientTeam(p[client][0][0]) == 3)
				{
					CS_SwitchTeam(p[client][0][0], 2);
					SetEntityModel(p[client][0][0], "models/player/t_guerilla.mdl");
				}
			}
			if (StrEqual(info, "16", true))
			{
				CS_SetClientClanTag(p[client][0][0], "V. Ikea -");
				rankid[p[client][0][0]] = 5;
				if (GetClientTeam(p[client][0][0]) == 3)
				{
					CS_SwitchTeam(p[client][0][0], 2);
					SetEntityModel(p[client][0][0], "models/player/t_guerilla.mdl");
				}
			}
			if (StrEqual(info, "17", true))
			{
				CS_SetClientClanTag(p[client][0][0], "A.V. Ikea -");
				rankid[p[client][0][0]] = 5;
				if (GetClientTeam(p[client][0][0]) == 3)
				{
					CS_SwitchTeam(p[client][0][0], 2);
					SetEntityModel(p[client][0][0], "models/player/t_guerilla.mdl");
				}
			}
			if (StrEqual(info, "0", true))
			{
				CS_SetClientClanTag(p[client][0][0], "Chômeur -");
				rankid[p[client][0][0]] = 0;
				salaire[p[client][0][0]] = 50;
				if (GetClientTeam(p[client][0][0]) == 3)
				{
					CS_SwitchTeam(p[client][0][0], 2);
					SetEntityModel(p[client][0][0], "models/player/t_guerilla.mdl");
				}
			}
			if (StrEqual(info, "12", true))
			{
				CS_SetClientClanTag(p[client][0][0], "C. Coach -");
				rankid[p[client][0][0]] = 4;
				if (GetClientTeam(p[client][0][0]) == 3)
				{
					CS_SwitchTeam(p[client][0][0], 2);
					SetEntityModel(p[client][0][0], "models/player/t_guerilla.mdl");
				}
			}
			if (StrEqual(info, "13", true))
			{
				CS_SetClientClanTag(p[client][0][0], "Coach -");
				rankid[p[client][0][0]] = 4;
				if (GetClientTeam(p[client][0][0]) == 3)
				{
					CS_SwitchTeam(p[client][0][0], 2);
					SetEntityModel(p[client][0][0], "models/player/t_guerilla.mdl");
				}
			}
			if (StrEqual(info, "14", true))
			{
				CS_SetClientClanTag(p[client][0][0], "A. Coach -");
				rankid[p[client][0][0]] = 4;
				if (GetClientTeam(p[client][0][0]) == 3)
				{
					CS_SwitchTeam(p[client][0][0], 2);
					SetEntityModel(p[client][0][0], "models/player/t_guerilla.mdl");
				}
			}
			if (StrEqual(info, "9", true))
			{
				CS_SetClientClanTag(p[client][0][0], "C. Dealer -");
				rankid[p[client][0][0]] = 3;
				if (GetClientTeam(p[client][0][0]) == 3)
				{
					CS_SwitchTeam(p[client][0][0], 2);
					SetEntityModel(p[client][0][0], "models/player/t_guerilla.mdl");
				}
			}
			if (StrEqual(info, "10", true))
			{
				CS_SetClientClanTag(p[client][0][0], "Dealer -");
				rankid[p[client][0][0]] = 3;
				if (GetClientTeam(p[client][0][0]) == 3)
				{
					CS_SwitchTeam(p[client][0][0], 2);
					SetEntityModel(p[client][0][0], "models/player/t_guerilla.mdl");
				}
			}
			if (StrEqual(info, "11", true))
			{
				CS_SetClientClanTag(p[client][0][0], "A. Dealer -");
				rankid[p[client][0][0]] = 3;
				if (GetClientTeam(p[client][0][0]) == 3)
				{
					CS_SwitchTeam(p[client][0][0], 2);
					SetEntityModel(p[client][0][0], "models/player/t_guerilla.mdl");
				}
			}
			if (StrEqual(info, "24", true))
			{
				CS_SetClientClanTag(p[client][0][0], "C. Banquier -");
				rankid[p[client][0][0]] = 8;
				if (GetClientTeam(p[client][0][0]) == 3)
				{
					CS_SwitchTeam(p[client][0][0], 2);
					SetEntityModel(p[client][0][0], "models/player/t_guerilla.mdl");
				}
			}
			if (StrEqual(info, "25", true))
			{
				CS_SetClientClanTag(p[client][0][0], "Banquier -");
				rankid[p[client][0][0]] = 8;
				if (GetClientTeam(p[client][0][0]) == 3)
				{
					CS_SwitchTeam(p[client][0][0], 2);
					SetEntityModel(p[client][0][0], "models/player/t_guerilla.mdl");
				}
			}
			if (StrEqual(info, "26", true))
			{
				CS_SetClientClanTag(p[client][0][0], "A. Banquier -");
				rankid[p[client][0][0]] = 8;
				if (GetClientTeam(p[client][0][0]) == 3)
				{
					CS_SwitchTeam(p[client][0][0], 2);
					SetEntityModel(p[client][0][0], "models/player/t_guerilla.mdl");
				}
			}
			if (StrEqual(info, "27", true))
			{
				CS_SetClientClanTag(p[client][0][0], "D. Hôpital -");
				rankid[p[client][0][0]] = 9;
				if (GetClientTeam(p[client][0][0]) == 3)
				{
					CS_SwitchTeam(p[client][0][0], 2);
					SetEntityModel(p[client][0][0], "models/player/t_guerilla.mdl");
				}
			}
			if (StrEqual(info, "28", true))
			{
				CS_SetClientClanTag(p[client][0][0], "Médecin -");
				rankid[p[client][0][0]] = 9;
				if (GetClientTeam(p[client][0][0]) == 3)
				{
					CS_SwitchTeam(p[client][0][0], 2);
					SetEntityModel(p[client][0][0], "models/player/t_guerilla.mdl");
				}
			}
			if (StrEqual(info, "29", true))
			{
				CS_SetClientClanTag(p[client][0][0], "Infirmier -");
				rankid[p[client][0][0]] = 9;
				if (GetClientTeam(p[client][0][0]) == 3)
				{
					CS_SwitchTeam(p[client][0][0], 2);
					SetEntityModel(p[client][0][0], "models/player/t_guerilla.mdl");
				}
			}
			if (StrEqual(info, "30", true))
			{
				CS_SetClientClanTag(p[client][0][0], "Chirurgien -");
				rankid[p[client][0][0]] = 9;
				if (GetClientTeam(p[client][0][0]) == 3)
				{
					CS_SwitchTeam(p[client][0][0], 2);
					SetEntityModel(p[client][0][0], "models/player/t_guerilla.mdl");
				}
			}
			if (StrEqual(info, "34", true))
			{
				CS_SetClientClanTag(p[client][0][0], "C. Tueur -");
				rankid[p[client][0][0]] = 11;
				if (GetClientTeam(p[client][0][0]) == 3)
				{
					CS_SwitchTeam(p[client][0][0], 2);
					SetEntityModel(p[client][0][0], "models/player/t_guerilla.mdl");
				}
			}
			if (StrEqual(info, "35", true))
			{
				CS_SetClientClanTag(p[client][0][0], "Tueur d'élite -");
				rankid[p[client][0][0]] = 11;
				if (GetClientTeam(p[client][0][0]) == 3)
				{
					CS_SwitchTeam(p[client][0][0], 2);
					SetEntityModel(p[client][0][0], "models/player/t_guerilla.mdl");
				}
			}
			if (StrEqual(info, "36", true))
			{
				CS_SetClientClanTag(p[client][0][0], "Tueur Novice -");
				rankid[p[client][0][0]] = 11;
				if (GetClientTeam(p[client][0][0]) == 3)
				{
					CS_SwitchTeam(p[client][0][0], 2);
					SetEntityModel(p[client][0][0], "models/player/t_guerilla.mdl");
				}
			}
			if (StrEqual(info, "37", true))
			{
				CS_SetClientClanTag(p[client][0][0], "C. V. Immobilier -");
				rankid[p[client][0][0]] = 12;
				if (GetClientTeam(p[client][0][0]) == 3)
				{
					CS_SwitchTeam(p[client][0][0], 2);
					SetEntityModel(p[client][0][0], "models/player/t_guerilla.mdl");
				}
			}
			if (StrEqual(info, "38", true))
			{
				CS_SetClientClanTag(p[client][0][0], "V. Immobilier -");
				rankid[p[client][0][0]] = 12;
				if (GetClientTeam(p[client][0][0]) == 3)
				{
					CS_SwitchTeam(p[client][0][0], 2);
					SetEntityModel(p[client][0][0], "models/player/t_guerilla.mdl");
				}
			}
			if (StrEqual(info, "39", true))
			{
				CS_SetClientClanTag(p[client][0][0], "Apprenti V. Immobilier -");
				rankid[p[client][0][0]] = 12;
				if (GetClientTeam(p[client][0][0]) == 3)
				{
					CS_SwitchTeam(p[client][0][0], 2);
					SetEntityModel(p[client][0][0], "models/player/t_guerilla.mdl");
				}
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public Action:Command_Money(client, args)
{
	if (jobid[client][0][0] == 1)
	{
		seekplayers(client);
	}
	else
	{
		CPrintToChat(client, "%s: Vous n'avez pas accès a cette commande.", "{red}[CSS-RP] ");
	}
	return Action:0;
}

seekplayers(client)
{
	if (client > 0)
	{
		decl String:sMenuText[64];
		sMenuText[0] = 0;
		new Handle:menu = CreateMenu(menu_money, MenuAction:28);
		SetMenuTitle(menu, "Choisissez Le joueur :");
		SetMenuExitButton(menu, true);
		ajoutplayers(menu);
		DisplayMenu(menu, client, 0);
	}
	return 0;
}

public ajoutplayers(Handle:menu)
{
	decl String:user_id[12];
	decl String:name[32];
	decl String:display[48];
	new i = 1;
	while (i <= MaxClients)
	{
		if (IsClientInGame(i))
		{
			IntToString(GetClientUserId(i), user_id, 12);
			GetClientName(i, name, 32);
			Format(display, 47, "%s (%s)", name, user_id);
			AddMenuItem(menu, user_id, display, 0);
			i++;
		}
		i++;
	}
	return 0;
}

public menu_money(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[64];
		GetMenuItem(menu, param2, info, 64, 0, "", 0);
		new UserID = StringToInt(info, 10);
		p[client] = GetClientOfUserId(UserID);
		new Handle:menuc = CreateMenu(menu_givemoney, MenuAction:28);
		SetMenuTitle(menuc, "Choisissez le montant : %N (%d) :", p[client], UserID);
		AddMenuItem(menuc, "1", "1000", 0);
		AddMenuItem(menuc, "2", "10000", 0);
		AddMenuItem(menuc, "3", "100000", 0);
		AddMenuItem(menuc, "4", "1000000", 0);
		DisplayMenu(menuc, client, 0);
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public menu_givemoney(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[32];
		GetMenuItem(menu, param2, info, 32, 0, "", 0);
		if (StrEqual(info, "1", true))
		{
			bank[p[client][0][0]] = bank[p[client][0][0]][0][0][250];
			CPrintToChat(p[client][0][0], "%s: Vous avez reçu 1000€ en banque par %N", "{red}[CSS-RP] ", client);
			CPrintToChat(client, "%s: Vous avez donné 1000€ à  %N", "{red}[CSS-RP] ", p[client]);
		}
		else
		{
			if (StrEqual(info, "2", true))
			{
				bank[p[client][0][0]] = bank[p[client][0][0]][0][0][2500];
				CPrintToChat(p[client][0][0], "%s: Vous avez reçu 10000€ en banque par %N", "{red}[CSS-RP] ", client);
				CPrintToChat(client, "%s: Vous avez donné 10000€ à  %N", "{red}[CSS-RP] ", p[client]);
			}
			if (StrEqual(info, "3", true))
			{
				bank[p[client][0][0]] = bank[p[client][0][0]][0][0][25000];
				CPrintToChat(p[client][0][0], "%s: Vous avez reçu 100000€ en banque par %N", "{red}[CSS-RP] ", client);
				CPrintToChat(client, "%s: Vous avez donné 100000€ à  %N", "{red}[CSS-RP] ", p[client]);
			}
			if (StrEqual(info, "4", true))
			{
				bank[p[client][0][0]] = bank[p[client][0][0]][0][0][250000];
				CPrintToChat(p[client][0][0], "%s: Vous avez reçu 1000000€ en banque par %N", "{red}[CSS-RP] ", client);
				CPrintToChat(client, "%s: Vous avez donné 1000000€ à  %N", "{red}[CSS-RP] ", p[client]);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public Action:Command_Infos(client, args)
{
	if (IsPlayerAlive(client))
	{
		new Handle:panel = CreatePanel(Handle:0);
		SetPanelTitle(panel, "Roleplay City :", false);
		new String:forum[60];
		new String:version[60];
		Format(version, 60, "Infos Roleplay City : %s", "1.0");
		Format(forum, 60, "Forum : %s", "Y04NN.fr");
		DrawPanelText(panel, forum);
		DrawPanelText(panel, "Codeur : Ultimatum Phoenix Qc");
		DrawPanelText(panel, "Recrutement : [ON]");
		DrawPanelText(panel, version);
		SendPanelToClient(panel, client, infos, 50);
	}
	return Action:0;
}

public infos(Handle:panel, MenuAction:action, client, param2)
{
	if (action == MenuAction:16)
	{
		CloseHandle(panel);
	}
	return 0;
}

public Action:Command_tazer(client, args)
{
	if (GetClientTeam(client) == 3)
	{
		new i = GetClientAimTarget(client, true);
		if (!IsValidEdict(i))
		{
			return Action:3;
		}
		new Float:entorigin[3] = 0;
		new Float:clientent[3] = 0;
		GetEntPropVector(i, PropType:0, "m_vecOrigin", entorigin, 0);
		GetEntPropVector(client, PropType:0, "m_vecOrigin", clientent, 0);
		new Float:distance = GetVectorDistance(entorigin, clientent, false);
		if (distance <= 1.121039E-42)
		{
			g_IsTazed[i] = 1;
			decl String:player_name[68];
			decl String:gardien_name[68];
			GetClientName(i, player_name, 65);
			GetClientName(client, gardien_name, 65);
			g_Count[i] = 1092616192;
			g_tazer[client]--;
			EmitSoundToAll("ambient/machines/zap1.wav", client, 0, 75, 0, 1, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0);
			var2 = var2[45];
			var3 = var3[45];
			TE_SetupBeamPoints(clientent, entorigin, g_LightingSprite, 0, 1, 0, 1, 20, 0, 2, 5, 74420, 3);
			TE_SendToAll(0);
			SetEntityMoveType(i, MoveType:0);
			g_TazerTimer[i] = CreateTimer(1, DoTazer, i, 1);
		}
		else
		{
			CPrintToChat(client, "%s: Vous êtes trop loin pour tazer.", "{red}[CSS-RP] ");
		}
	}
	else
	{
		CPrintToChat(client, "%s: Vous n'avez pas accès à  cette commande", "{red}[CSS-RP] ");
	}
	return Action:0;
}

public Action:DoTazer(Handle:timer, client)
{
	if (g_IsTazed[client][0][0] == true)
	{
		var2 = var2[0][0] - 1;
		if (g_Count[client][0][0] >= 0)
		{
			new Float:entorigin[3] = 0;
			GetEntPropVector(client, PropType:0, "m_vecOrigin", entorigin, 0);
			new ii = 1;
			while (ii < 8)
			{
				var3 = var3[ii * 9];
				TE_SetupBeamRingPoint(entorigin, 45, 45.1, g_modelLaser, g_modelHalo, 0, 1, 0.1, 8, 1, 74568, 1, 0);
				TE_SendToAll(0);
				entorigin[2] -= ii * 9;
				ii++;
			}
		}
		g_IsTazed[client] = 0;
		g_Count[client] = 0;
		SetEntityMoveType(client, MoveType:2);
		KillTazer(client);
	}
	return Action:0;
}

public KillTazer(client)
{
	if (g_TazerTimer[client][0][0])
	{
		KillTimer(g_TazerTimer[client][0][0], false);
		g_TazerTimer[client] = 0;
	}
	return 0;
}

public Action:Command_Item(client, args)
{
	if (IsClientInGame(client))
	{
		if (IsPlayerAlive(client))
		{
			if (g_IsInJail[client][0][0])
			{
				CPrintToChat(client, "%s: Vous ne pouvez pas ouvrir votre sac en prison.", "{red}[CSS-RP] ");
			}
			else
			{
				new Handle:menu = CreateMenu(Menu_Item, MenuAction:28);
				SetMenuTitle(menu, "Voici ce que contient ton sac :");
				if (0 < kitcrochetage[client][0][0])
				{
					new String:kit[64];
					Format(kit, 64, "Kit de crochetage(Quantité(s) : %d)", kitcrochetage[client]);
					AddMenuItem(menu, "Kit", kit, 0);
				}
				if (0 < awp[client][0][0])
				{
					new String:awpp[64];
					Format(awpp, 64, "AWP(Quantité(s) : %d)", awp[client]);
					AddMenuItem(menu, "awp", awpp, 0);
				}
				if (0 < m249[client][0][0])
				{
					new String:batteuse[64];
					Format(batteuse, 64, "M249(Quantité(s) : %d)", m249[client]);
					AddMenuItem(menu, "m249", batteuse, 0);
				}
				if (0 < ak47[client][0][0])
				{
					new String:ak[64];
					Format(ak, 64, "AK47(Quantité(s) : %d)", ak47[client]);
					AddMenuItem(menu, "ak47", ak, 0);
				}
				if (0 < m4a1[client][0][0])
				{
					new String:m4[64];
					Format(m4, 64, "M4A1(Quantité(s) : %d)", m4a1[client]);
					AddMenuItem(menu, "m4a1", m4, 0);
				}
				if (0 < sg550[client][0][0])
				{
					new String:sg5500[64];
					Format(sg5500, 64, "SG550(Quantité(s) : %d)", sg550[client]);
					AddMenuItem(menu, "sg550", sg5500, 0);
				}
				if (0 < sg552[client][0][0])
				{
					new String:sg5520[64];
					Format(sg5520, 64, "SG552(Quantité(s) : %d)", sg552[client]);
					AddMenuItem(menu, "sg552", sg5520, 0);
				}
				if (0 < aug[client][0][0])
				{
					new String:augg[64];
					Format(augg, 64, "AUG(Quantité(s) : %d)", aug[client]);
					AddMenuItem(menu, "aug", augg, 0);
				}
				if (0 < galil[client][0][0])
				{
					new String:galile[64];
					Format(galile, 64, "GALIL(Quantité(s) : %d)", galil[client]);
					AddMenuItem(menu, "galil", galile, 0);
				}
				if (0 < famas[client][0][0])
				{
					new String:famass[64];
					Format(famass, 64, "FAMAS(Quantité(s) : %d)", famas[client]);
					AddMenuItem(menu, "famas", famass, 0);
				}
				if (0 < scout[client][0][0])
				{
					new String:scoutt[64];
					Format(scoutt, 64, "SCOUT(Quantité(s) : %d)", scout[client]);
					AddMenuItem(menu, "scout", scoutt, 0);
				}
				if (0 < mp5[client][0][0])
				{
					new String:mp55[64];
					Format(mp55, 64, "MP5(Quantité(s) : %d)", mp5[client]);
					AddMenuItem(menu, "mp5", mp55, 0);
				}
				if (0 < tmp[client][0][0])
				{
					new String:tmpp[64];
					Format(tmpp, 64, "TMP(Quantité(s) : %d)", tmp[client]);
					AddMenuItem(menu, "tmp", tmpp, 0);
				}
				if (0 < ump[client][0][0])
				{
					new String:umpp[64];
					Format(umpp, 64, "UMP(Quantité(s) : %d)", ump[client]);
					AddMenuItem(menu, "ump", umpp, 0);
				}
				if (0 < p90[client][0][0])
				{
					new String:p900[64];
					Format(p900, 64, "P90(Quantité(s) : %d)", p90[client]);
					AddMenuItem(menu, "p90", p900, 0);
				}
				if (0 < mac10[client][0][0])
				{
					new String:mac100[64];
					Format(mac100, 64, "MAC10(Quantité(s) : %d)", mac10[client]);
					AddMenuItem(menu, "mac10", mac100, 0);
				}
				if (0 < m3[client][0][0])
				{
					new String:m33[64];
					Format(m33, 64, "M3(Quantité(s) : %d)", m3[client]);
					AddMenuItem(menu, "m3", m33, 0);
				}
				if (0 < xm1014[client][0][0])
				{
					new String:xm[64];
					Format(xm, 64, "XM1014(Quantité(s) : %d)", xm1014[client]);
					AddMenuItem(menu, "xm1014", xm, 0);
				}
				if (0 < deagle[client][0][0])
				{
					new String:deag[64];
					Format(deag, 64, "DEAGLE(Quantité(s) : %d)", deagle[client]);
					AddMenuItem(menu, "deagle", deag, 0);
				}
				if (0 < usp[client][0][0])
				{
					new String:uspp[64];
					Format(uspp, 64, "USP(Quantité(s) : %d)", usp[client]);
					AddMenuItem(menu, "usp", uspp, 0);
				}
				if (0 < glock[client][0][0])
				{
					new String:gloc[64];
					Format(gloc, 64, "GLOCK(Quantité(s) : %d)", glock[client]);
					AddMenuItem(menu, "glock", gloc, 0);
				}
				if (0 < elite[client][0][0])
				{
					new String:elit[64];
					Format(elit, 64, "ELITE(Quantité(s) : %d)", elite[client]);
					AddMenuItem(menu, "elite", elit, 0);
				}
				if (0 < ticket10[client][0][0])
				{
					new String:ticket10000[64];
					Format(ticket10000, 64, "Ticket 10€(Quantité(s) : %d)", ticket10[client]);
					AddMenuItem(menu, "tic10", ticket10000, 0);
				}
				if (0 < ticket100[client][0][0])
				{
					new String:ticket100000[64];
					Format(ticket100000, 64, "Ticket 100€(Quantité(s) : %d)", ticket100[client]);
					AddMenuItem(menu, "tic100", ticket100000, 0);
				}
				if (0 < ticket1000[client][0][0])
				{
					new String:ticket1000000[64];
					Format(ticket1000000, 64, "Ticket 1000€(Quantité(s) : %d)", ticket1000[client]);
					AddMenuItem(menu, "tic1000", ticket1000000, 0);
				}
				if (0 < cartouche[client][0][0])
				{
					new String:kar[64];
					Format(kar, 64, "Cartouche(Quantité(s) : %d)", cartouche[client]);
					AddMenuItem(menu, "cartouche", kar, 0);
				}
				if (0 < props1[client][0][0])
				{
					new String:props11[64];
					Format(props11, 64, "PROPS1(Quantité(s) : %d)", props1[client]);
					AddMenuItem(menu, "props1", props11, 0);
				}
				if (0 < props2[client][0][0])
				{
					new String:props22[64];
					Format(props22, 64, "PROPS2(Quantité(s) : %d)", props2[client]);
					AddMenuItem(menu, "props2", props22, 0);
				}
				if (0 < heroine[client][0][0])
				{
					new String:hero[64];
					Format(hero, 64, "HEROINE(Quantité(s) : %d)", heroine[client]);
					AddMenuItem(menu, "heroine", hero, 0);
				}
				if (0 < exta[client][0][0])
				{
					new String:ext[64];
					Format(ext, 64, "EXTASIE(Quantité(s) : %d)", exta[client]);
					AddMenuItem(menu, "exta", ext, 0);
				}
				if (0 < lsd[client][0][0])
				{
					new String:ls[64];
					Format(ls, 64, "LSD(Quantité(s) : %d)", lsd[client]);
					AddMenuItem(menu, "lsd", ls, 0);
				}
				if (0 < coke[client][0][0])
				{
					new String:cok[64];
					Format(cok, 64, "COKE(Quantité(s) : %d)", coke[client]);
					AddMenuItem(menu, "coke", cok, 0);
				}
				if (0 < pack[client][0][0])
				{
					new String:pak[64];
					Format(pak, 64, "PROJECTILES(Quantité(s) : %d)", pack[client]);
					AddMenuItem(menu, "pack", pak, 0);
				}
				if (0 < kevlar[client][0][0])
				{
					new String:kev[64];
					Format(kev, 64, "KEVLAR(Quantité(s) : %d)", kevlar[client]);
					AddMenuItem(menu, "kevlar", kev, 0);
				}
				DisplayMenu(menu, client, 0);
			}
		}
		CPrintToChat(client, "%s: Vous devez être en vie pour ouvrir votre sac.", "{red}[CSS-RP] ");
	}
	return Action:0;
}

public Menu_Item(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		if (IsClientInGame(client))
		{
			new String:info[32];
			GetMenuItem(menu, param2, info, 32, 0, "", 0);
			if (StrEqual(info, "Kit", true))
			{
				if (jobid[client][0][0] == 6)
				{
					if (!g_crochetageon[client][0][0])
					{
						new String:Door[256];
						Entiter[client] = GetClientAimTarget(client, false);
						if (Entiter[client][0][0] != -1)
						{
							GetEdictClassname(Entiter[client][0][0], Door, 255);
							if (StrEqual(Door, "func_door_rotating", true))
							{
								if (Entity_IsLocked(Entiter[client][0][0]))
								{
									new timestamp = GetTime({0,0});
									if (timestamp - g_crochetage[client][0][0] < 20)
									{
										CPrintToChat(client, "%s: Vous devez attendre %i secondes avant de pouvoir crocheter une porte.", "{red}[CSS-RP] ", 20 - timestamp - g_crochetage[client][0][0]);
									}
									else
									{
										new Float:entorigin[3] = 0;
										new Float:clientent[3] = 0;
										GetEntPropVector(Entiter[client][0][0], PropType:0, "m_vecOrigin", entorigin, 0);
										GetEntPropVector(client, PropType:0, "m_vecOrigin", clientent, 0);
										new Float:distance = GetVectorDistance(entorigin, clientent, false);
										new Float:vec[3] = 0;
										GetClientAbsOrigin(client, vec);
										var4 = var4[10];
										if (distance > 1.121039E-43)
										{
											CPrintToChat(client, "%s: Vous êtes trop loin pour crocheter cette porte.", "{red}[CSS-RP] ");
										}
										else
										{
											g_crochetage[client] = GetTime({0,0});
											SetEntPropFloat(client, PropType:0, "m_flProgressBarStartTime", GetGameTime(), 0);
											SetEntProp(client, PropType:0, "m_iProgressBarDuration", any:8, 4, 0);
											g_croche[client] = CreateTimer(8, TimerCrochetage, client, 1);
											SetEntityRenderColor(client, 255, 0, 0, 0);
											SetEntityMoveType(client, MoveType:0);
											TE_SetupBeamRingPoint(vec, 50, 70, g_BeamSprite, g_modelHalo, 0, 15, 0.6, 15, 0, redColor, 10, 0);
											TE_SendToAll(0);
											CPrintToChat(client, "%s: Vous crochetez la porte.", "{red}[CSS-RP] ");
											CPrintToChat(client, "%s: Vous avez utilisez un kit de crochetage.", "{red}[CSS-RP] ");
											kitcrochetage[client] = kitcrochetage[client][0][0][0];
											g_crochetageon[client] = 1;
										}
									}
								}
								else
								{
									CPrintToChat(client, "%s: La porte est déjà  ouverte.", "{red}[CSS-RP] ");
								}
							}
							else
							{
								CPrintToChat(client, "%s: Veuillez viser une porte.", "{red}[CSS-RP] ");
							}
						}
						else
						{
							CPrintToChat(client, "%s: Veuillez viser une porte.", "{red}[CSS-RP] ");
						}
					}
					else
					{
						CPrintToChat(client, "%s: Vous êtes déjà  en train de crocheter.", "{red}[CSS-RP] ");
					}
				}
				else
				{
					CPrintToChat(client, "%s: Vous devez être mafieux pour utilisez cet objet.", "{red}[CSS-RP] ");
				}
			}
			else
			{
				if (StrEqual(info, "awp", true))
				{
					GivePlayerItem(client, "weapon_awp", 0);
					CPrintToChat(client, "%s: Vous avez utilisez une AWP.", "{red}[CSS-RP] ");
					awp[client] = awp[client][0][0][0];
				}
				if (StrEqual(info, "scout", true))
				{
					GivePlayerItem(client, "weapon_scout", 0);
					CPrintToChat(client, "%s: Vous avez utilisez un SCOUT.", "{red}[CSS-RP] ");
					scout[client] = scout[client][0][0][0];
				}
				if (StrEqual(info, "m249", true))
				{
					GivePlayerItem(client, "weapon_m249", 0);
					CPrintToChat(client, "%s: Vous avez utilisez une M249.", "{red}[CSS-RP] ");
					m249[client] = m249[client][0][0][0];
				}
				if (StrEqual(info, "ak47", true))
				{
					GivePlayerItem(client, "weapon_ak47", 0);
					CPrintToChat(client, "%s: Vous avez utilisez un AK47.", "{red}[CSS-RP] ");
					ak47[client] = ak47[client][0][0][0];
				}
				if (StrEqual(info, "m4a1", true))
				{
					GivePlayerItem(client, "weapon_m4a1", 0);
					CPrintToChat(client, "%s: Vous avez utilisez une M4A1", "{red}[CSS-RP] ");
					m4a1[client] = m4a1[client][0][0][0];
				}
				if (StrEqual(info, "sg550", true))
				{
					GivePlayerItem(client, "weapon_sg550", 0);
					CPrintToChat(client, "%s: Vous avez utilisez un SG550", "{red}[CSS-RP] ");
					sg550[client] = sg550[client][0][0][0];
				}
				if (StrEqual(info, "sg552", true))
				{
					GivePlayerItem(client, "weapon_sg552", 0);
					CPrintToChat(client, "%s: Vous avez utilisez un SG552", "{red}[CSS-RP] ");
					sg552[client] = sg552[client][0][0][0];
				}
				if (StrEqual(info, "aug", true))
				{
					GivePlayerItem(client, "weapon_aug", 0);
					CPrintToChat(client, "%s: Vous avez utilisez un AUG", "{red}[CSS-RP] ");
					aug[client] = aug[client][0][0][0];
				}
				if (StrEqual(info, "galil", true))
				{
					GivePlayerItem(client, "weapon_galil", 0);
					CPrintToChat(client, "%s: Vous avez utilisez un GALIL", "{red}[CSS-RP] ");
					galil[client] = galil[client][0][0][0];
				}
				if (StrEqual(info, "famas", true))
				{
					GivePlayerItem(client, "weapon_famas", 0);
					CPrintToChat(client, "%s: Vous avez utilisez un FAMAS", "{red}[CSS-RP] ");
					famas[client] = famas[client][0][0][0];
				}
				if (StrEqual(info, "mp5", true))
				{
					GivePlayerItem(client, "weapon_mp5navy", 0);
					CPrintToChat(client, "%s: Vous avez utilisez une MP5", "{red}[CSS-RP] ");
					mp5[client] = mp5[client][0][0][0];
				}
				if (StrEqual(info, "mac10", true))
				{
					GivePlayerItem(client, "weapon_mac10", 0);
					CPrintToChat(client, "%s: Vous avez utilisez un MAC10", "{red}[CSS-RP] ");
					mac10[client] = mac10[client][0][0][0];
				}
				if (StrEqual(info, "tmp", true))
				{
					GivePlayerItem(client, "weapon_tmp", 0);
					CPrintToChat(client, "%s: Vous avez utilisez un TMP", "{red}[CSS-RP] ");
					tmp[client] = tmp[client][0][0][0];
				}
				if (StrEqual(info, "ump", true))
				{
					GivePlayerItem(client, "weapon_ump45", 0);
					CPrintToChat(client, "%s: Vous avez utilisez un UMP45", "{red}[CSS-RP] ");
					ump[client] = ump[client][0][0][0];
				}
				if (StrEqual(info, "p90", true))
				{
					GivePlayerItem(client, "weapon_p90", 0);
					CPrintToChat(client, "%s: Vous avez utilisez une P90", "{red}[CSS-RP] ");
					p90[client] = p90[client][0][0][0];
				}
				if (StrEqual(info, "m3", true))
				{
					GivePlayerItem(client, "weapon_m3", 0);
					CPrintToChat(client, "%s: Vous avez utilisez un M3", "{red}[CSS-RP] ");
					m3[client] = m3[client][0][0][0];
				}
				if (StrEqual(info, "xm1014", true))
				{
					GivePlayerItem(client, "weapon_xm1014", 0);
					CPrintToChat(client, "%s: Vous avez utilisez un XM1014", "{red}[CSS-RP] ");
					xm1014[client] = xm1014[client][0][0][0];
				}
				if (StrEqual(info, "deagle", true))
				{
					GivePlayerItem(client, "weapon_deagle", 0);
					CPrintToChat(client, "%s: Vous avez utilisez un DEAGLE", "{red}[CSS-RP] ");
					deagle[client] = deagle[client][0][0][0];
				}
				if (StrEqual(info, "usp", true))
				{
					GivePlayerItem(client, "weapon_usp", 0);
					CPrintToChat(client, "%s: Vous avez utilisez un USP", "{red}[CSS-RP] ");
					usp[client] = usp[client][0][0][0];
				}
				if (StrEqual(info, "glock", true))
				{
					GivePlayerItem(client, "weapon_glock", 0);
					CPrintToChat(client, "%s: Vous avez utilisez une GLOCK", "{red}[CSS-RP] ");
					glock[client] = glock[client][0][0][0];
				}
				if (StrEqual(info, "elite", true))
				{
					GivePlayerItem(client, "weapon_elite", 0);
					CPrintToChat(client, "%s: Vous avez utilisez des ELITES", "{red}[CSS-RP] ");
					elite[client] = elite[client][0][0][0];
				}
				if (StrEqual(info, "pack", true))
				{
					GivePlayerItem(client, "weapon_flashbang", 0);
					GivePlayerItem(client, "weapon_hegrenade", 0);
					GivePlayerItem(client, "weapon_smokegrenade", 0);
					CPrintToChat(client, "%s: Vous avez utilisez des PROJECTILES", "{red}[CSS-RP] ");
					pack[client] = pack[client][0][0][0];
				}
				if (StrEqual(info, "kevlar", true))
				{
					SetEntProp(client, PropType:1, "m_ArmorValue", any:100, 4, 0);
					CPrintToChat(client, "%s: Vous avez utilisez un KEVLAR", "{red}[CSS-RP] ");
					kevlar[client] = kevlar[client][0][0][0];
				}
				if (StrEqual(info, "tic10", true))
				{
					CPrintToChat(client, "%s: Vous avez utilisez un ticket de 10€", "{red}[CSS-RP] ");
					switch (GetRandomInt(1, 10))
					{
						case 1:
						{
							CPrintToChat(client, "%s: Vous n'avez rien gagner.", "{red}[CSS-RP] ");
						}
						case 2:
						{
							AdCash(client, 30);
							CPrintToChat(client, "%s: Vous avez gagner 30€.", "{red}[CSS-RP] ");
						}
						case 3:
						{
							AdCash(client, 5);
							CPrintToChat(client, "%s: Vous avez gagner 5€.", "{red}[CSS-RP] ");
						}
						case 4:
						{
							CPrintToChat(client, "%s: Vous n'avez rien gagner.", "{red}[CSS-RP] ");
						}
						case 5:
						{
							CPrintToChat(client, "%s: Vous n'avez rien gagner.", "{red}[CSS-RP] ");
						}
						case 6:
						{
							CPrintToChat(client, "%s: Vous n'avez rien gagner.", "{red}[CSS-RP] ");
						}
						case 7:
						{
							CPrintToChat(client, "%s: Vous n'avez rien gagner.", "{red}[CSS-RP] ");
						}
						case 8:
						{
							CPrintToChat(client, "%s: Vous n'avez rien gagner.", "{red}[CSS-RP] ");
						}
						case 9:
						{
							CPrintToChat(client, "%s: Vous n'avez rien gagner.", "{red}[CSS-RP] ");
						}
						case 10:
						{
							CPrintToChat(client, "%s: Vous n'avez rien gagner.", "{red}[CSS-RP] ");
						}
						default:
						{
						}
					}
					var5 = var5[0][0][0];
				}
				if (StrEqual(info, "tic100", true))
				{
					CPrintToChat(client, "%s: Vous avez utilisez un ticket de 100€", "{red}[CSS-RP] ");
					switch (GetRandomInt(1, 10))
					{
						case 1:
						{
							CPrintToChat(client, "%s: Vous n'avez rien gagner.", "{red}[CSS-RP] ");
						}
						case 2:
						{
							AdCash(client, 300);
							CPrintToChat(client, "%s: Vous avez gagner 300€.", "{red}[CSS-RP] ");
						}
						case 3:
						{
							AdCash(client, 70);
							CPrintToChat(client, "%s: Vous avez gagner 70€.", "{red}[CSS-RP] ");
						}
						case 4:
						{
							CPrintToChat(client, "%s: Vous n'avez rien gagner.", "{red}[CSS-RP] ");
						}
						case 5:
						{
							CPrintToChat(client, "%s: Vous n'avez rien gagner.", "{red}[CSS-RP] ");
						}
						case 6:
						{
							CPrintToChat(client, "%s: Vous n'avez rien gagner.", "{red}[CSS-RP] ");
						}
						case 7:
						{
							CPrintToChat(client, "%s: Vous n'avez rien gagner.", "{red}[CSS-RP] ");
						}
						case 8:
						{
							CPrintToChat(client, "%s: Vous n'avez rien gagner.", "{red}[CSS-RP] ");
						}
						case 9:
						{
							CPrintToChat(client, "%s: Vous n'avez rien gagner.", "{red}[CSS-RP] ");
						}
						case 10:
						{
							CPrintToChat(client, "%s: Vous n'avez rien gagner.", "{red}[CSS-RP] ");
						}
						default:
						{
						}
					}
					var6 = var6[0][0][0];
				}
				if (StrEqual(info, "tic1000", true))
				{
					CPrintToChat(client, "%s: Vous avez utilisez un ticket de 1000€", "{red}[CSS-RP] ");
					switch (GetRandomInt(1, 10))
					{
						case 1:
						{
							CPrintToChat(client, "%s: Vous n'avez rien gagner.", "{red}[CSS-RP] ");
						}
						case 2:
						{
							AdCash(client, 3000);
							CPrintToChat(client, "%s: Vous avez gagner 3000€.", "{red}[CSS-RP] ");
						}
						case 3:
						{
							AdCash(client, 700);
							CPrintToChat(client, "%s: Vous avez gagner 700€.", "{red}[CSS-RP] ");
						}
						case 4:
						{
							CPrintToChat(client, "%s: Vous n'avez rien gagner.", "{red}[CSS-RP] ");
						}
						case 5:
						{
							CPrintToChat(client, "%s: Vous n'avez rien gagner.", "{red}[CSS-RP] ");
						}
						case 6:
						{
							CPrintToChat(client, "%s: Vous n'avez rien gagner.", "{red}[CSS-RP] ");
						}
						case 7:
						{
							CPrintToChat(client, "%s: Vous n'avez rien gagner.", "{red}[CSS-RP] ");
						}
						case 8:
						{
							CPrintToChat(client, "%s: Vous n'avez rien gagner.", "{red}[CSS-RP] ");
						}
						case 9:
						{
							CPrintToChat(client, "%s: Vous n'avez rien gagner.", "{red}[CSS-RP] ");
						}
						case 10:
						{
							CPrintToChat(client, "%s: Vous n'avez rien gagner.", "{red}[CSS-RP] ");
						}
						default:
						{
						}
					}
					var7 = var7[0][0][0];
				}
				if (StrEqual(info, "cartouche", true))
				{
					decl String:WeaponName[32];
					Client_GetActiveWeaponName(client, WeaponName, 32);
					new weapon = Client_GetActiveWeapon(client);
					RemoveEdict(weapon);
					GivePlayerItem(client, WeaponName, 0);
					CPrintToChat(client, "%s: Vous avez utilisez une CARTOUCHE.", "{red}[CSS-RP] ");
					cartouche[client] = cartouche[client][0][0][0];
				}
				if (StrEqual(info, "heroine", true))
				{
					if (!drogue[client][0][0])
					{
						SetEntityHealth(client, 500);
						SetEntPropFloat(client, PropType:1, "m_flLaggedMovementValue", 1.5, 0);
						CPrintToChat(client, "%s: Vous avez utilisez de l'héroine.", "{red}[CSS-RP] ");
						heroine[client] = heroine[client][0][0][0];
						drogue[client] = 1;
						heroo[client] = CreateTimer(60, Timer_Hero, client, 0);
						g_boolhero[client] = 1;
						ClientCommand(client, "r_screenoverlay effects/com_shield002a.vmt");
					}
					else
					{
						CPrintToChat(client, "%s: Vous êtes déjà  en train d'utilisez une drogue.", "{red}[CSS-RP] ");
					}
				}
				if (StrEqual(info, "coke", true))
				{
					if (!drogue[client][0][0])
					{
						SetEntityHealth(client, 300);
						SetEntityGravity(client, 0.5);
						CPrintToChat(client, "%s: Vous avez utilisez de la coke.", "{red}[CSS-RP] ");
						coke[client] = coke[client][0][0][0];
						drogue[client] = 1;
						cokk[client] = CreateTimer(60, Timer_Coke, client, 0);
						g_boolcoke[client] = 1;
						ClientCommand(client, "r_screenoverlay debug/yuv.vmt");
					}
					else
					{
						CPrintToChat(client, "%s: Vous êtes déjà  en train d'utilisez une drogue.", "{red}[CSS-RP] ");
					}
				}
				if (StrEqual(info, "lsd", true))
				{
					if (!drogue[client][0][0])
					{
						SetEntityHealth(client, 200);
						SetEntityGravity(client, 0.5);
						SetEntPropFloat(client, PropType:1, "m_flLaggedMovementValue", 1.2, 0);
						CPrintToChat(client, "%s: Vous avez utilisez du LSD.", "{red}[CSS-RP] ");
						lsd[client] = lsd[client][0][0][0];
						drogue[client] = 1;
						lssd[client] = CreateTimer(60, Timer_Lsd, client, 0);
						g_boollsd[client] = 1;
						ClientCommand(client, "r_screenoverlay models/effects/portalfunnel_sheet.vmt");
					}
					else
					{
						CPrintToChat(client, "%s: Vous êtes déjà  en train d'utilisez une drogue.", "{red}[CSS-RP] ");
					}
				}
				if (StrEqual(info, "exta", true))
				{
					if (!drogue[client][0][0])
					{
						SetEntityHealth(client, 150);
						SetEntityGravity(client, 0.5);
						SetEntPropFloat(client, PropType:1, "m_flLaggedMovementValue", 1.2, 0);
						CPrintToChat(client, "%s: Vous avez utilisez de l' extasie.", "{red}[CSS-RP] ");
						exta[client] = exta[client][0][0][0];
						drogue[client] = 1;
						extasiie[client] = CreateTimer(60, Timer_Exta, client, 0);
						g_boolexta[client] = 1;
						ClientCommand(client, "r_screenoverlay effects/tp_eyefx/tp_eyefx.vmt");
					}
					CPrintToChat(client, "%s: Vous êtes déjà  en train d'utilisez une drogue.", "{red}[CSS-RP] ");
				}
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public Action:TimerCrochetage(Handle:timer, client)
{
	if (IsClientInGame(client))
	{
		if (IsPlayerAlive(client))
		{
			new String:Door[256];
			GetEdictClassname(Entiter[client][0][0], Door, 255);
			switch (GetRandomInt(1, 2))
			{
				case 1:
				{
					if (StrEqual(Door, "func_door_rotating", true))
					{
						CPrintToChat(client, "%s: Vous avez crocheter la porte avec succès.", "{red}[CSS-RP] ");
						Entity_UnLock(Entiter[client][0][0]);
						AcceptEntityInput(Entiter[client][0][0], "Toggle", client, client, 0);
						SetEntityMoveType(client, MoveType:2);
						SetEntityRenderColor(client, 255, 255, 255, 255);
						var3 = var3[0][0][0];
						g_crochetageon[client] = 0;
						if (g_porte[client][0][0] == 20)
						{
							CPrintToChatAll("%s: Le joueur \x03%N", "{red}[CSS-RP] ", client);
							EmitSoundToClient(client, "roleplay/success.wav", -2, 0, 75, 0, 1, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0);
							g_succesporte20[client] = 1;
							if (g_porte[client][0][0] == 50)
							{
								CPrintToChatAll("%s: Le joueur \x03%N", "{red}[CSS-RP] ", client);
								EmitSoundToClient(client, "roleplay/success.wav", -2, 0, 75, 0, 1, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0);
								g_succesporte50[client] = 1;
								if (g_porte[client][0][0] == 100)
								{
									CPrintToChatAll("%s: Le joueur \x03%N", "{red}[CSS-RP] ", client);
									EmitSoundToClient(client, "roleplay/success.wav", -2, 0, 75, 0, 1, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0);
									g_succesporte100[client] = 1;
								}
							}
						}
					}
					else
					{
						CPrintToChat(client, "%s: Vous devez viser la porte, réessayez !", "{red}[CSS-RP] ");
					}
				}
				case 2:
				{
					if (StrEqual(Door, "func_door_rotating", true))
					{
						CPrintToChat(client, "%s: Vous avez échoué le crochetage.", "{red}[CSS-RP] ");
						SetEntityMoveType(client, MoveType:2);
						SetEntityRenderColor(client, 255, 255, 255, 255);
						g_crochetageon[client] = 0;
					}
				}
				default:
				{
				}
			}
			SetEntPropFloat(client, PropType:0, "m_flProgressBarStartTime", GetGameTime(), 0);
			SetEntProp(client, PropType:0, "m_iProgressBarDuration", any:0, 4, 0);
			KillTimer(g_croche[client][0][0], false);
		}
	}
	return Action:0;
}

public Action:Timer_Hero(Handle:timer, client)
{
	if (IsClientInGame(client))
	{
		if (IsPlayerAlive(client))
		{
			drogue[client] = 0;
			CPrintToChat(client, "%s: Votre drogue ne fait plus d'effet.", "{red}[CSS-RP] ");
			SetEntPropFloat(client, PropType:1, "m_flLaggedMovementValue", 1, 0);
			g_boolhero[client] = 0;
			ClientCommand(client, "r_screenoverlay 0");
		}
	}
	return Action:0;
}

public Action:Timer_Coke(Handle:timer, client)
{
	if (IsClientInGame(client))
	{
		if (IsPlayerAlive(client))
		{
			drogue[client] = 0;
			CPrintToChat(client, "%s: Votre drogue ne fait plus d'effet.", "{red}[CSS-RP] ");
			SetEntityGravity(client, 1);
			g_boolcoke[client] = 0;
			ClientCommand(client, "r_screenoverlay 0");
		}
	}
	return Action:0;
}

public Action:Timer_Lsd(Handle:timer, client)
{
	if (IsClientInGame(client))
	{
		if (IsPlayerAlive(client))
		{
			drogue[client] = 0;
			CPrintToChat(client, "%s: Votre drogue ne fait plus d'effet.", "{red}[CSS-RP] ");
			SetEntityGravity(client, 1);
			SetEntPropFloat(client, PropType:1, "m_flLaggedMovementValue", 1, 0);
			g_boollsd[client] = 0;
			ClientCommand(client, "r_screenoverlay 0");
		}
	}
	return Action:0;
}

public Action:Timer_Exta(Handle:timer, client)
{
	if (IsClientInGame(client))
	{
		if (IsPlayerAlive(client))
		{
			drogue[client] = 0;
			CPrintToChat(client, "%s: Votre drogue ne fait plus d'effet.", "{red}[CSS-RP] ");
			SetEntityGravity(client, 1);
			SetEntPropFloat(client, PropType:1, "m_flLaggedMovementValue", 1, 0);
			g_boolexta[client] = 0;
			ClientCommand(client, "r_screenoverlay 0");
		}
	}
	return Action:0;
}

public Action:Command_Demission(client, args)
{
	if (IsClientInGame(client))
	{
		if (IsPlayerAlive(client))
		{
			if (0 < jobid[client][0][0])
			{
				new Handle:menu = CreateMenu(Menu_Demission, MenuAction:28);
				SetMenuTitle(menu, "Veux tu démissioner ?");
				AddMenuItem(menu, "oui", "Oui je veux.", 0);
				AddMenuItem(menu, "non", "Non je me suis trompé.", 0);
				DisplayMenu(menu, client, 0);
			}
			else
			{
				CPrintToChat(client, "%s: Vous n'avez pas de job.", "{red}[CSS-RP] ");
			}
		}
		CPrintToChat(client, "%s: Vous devez être vivant pour cette commande.", "{red}[CSS-RP] ");
	}
	return Action:0;
}

public Menu_Demission(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[64];
		GetMenuItem(menu, param2, info, 64, 0, "", 0);
		if (StrEqual(info, "oui", true))
		{
			jobid[client] = 0;
			rankid[client] = 0;
			salaire[client] = 50;
			CPrintToChat(client, "%s: Vous avez quitter votre travail.", "{red}[CSS-RP] ");
			if (GetClientTeam(client) == 3)
			{
				CS_SwitchTeam(client, 2);
				SetEntityModel(client, "models/player/t_guerilla.mdl");
			}
			CS_SetClientClanTag(client, "Chômeur -");
		}
		else
		{
			if (StrEqual(info, "non", true))
			{
				CloseHandle(menu);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public DestroyLevel(client)
{
	if (IsClientInGame(client))
	{
		new String:sWeaponName[64];
		GetClientWeapon(client, sWeaponName, 64);
		if (StrEqual(sWeaponName, "weapon_knife", true))
		{
			if (0 < levelcut[client][0][0])
			{
				levelcut[client] = levelcut[client][0][0][0];
			}
		}
	}
	return 0;
}

public Action:Command_Engager(client, args)
{
	if (IsClientInGame(client))
	{
		if (IsPlayerAlive(client))
		{
			if (jobid[client][0][0] == 6)
			{
				ShowClients(client);
			}
			else
			{
				CPrintToChat(client, "%s: Vous devez être chef.", "{red}[CSS-RP] ");
			}
		}
		CPrintToChat(client, "%s: Vous devez être vivant.", "{red}[CSS-RP] ");
	}
	return Action:0;
}

ShowClients(client)
{
	if (client > 0)
	{
		decl String:sMenuText[64];
		sMenuText[0] = 0;
		new Handle:menu = CreateMenu(MenuHandler_PlayerList, MenuAction:28);
		SetMenuTitle(menu, "Choisissez Le joueur :");
		SetMenuExitButton(menu, true);
		AddAlivePlayersToMenu(menu);
		DisplayMenu(menu, client, 0);
	}
	return 0;
}

public AddAlivePlayersToMenu(Handle:menu)
{
	decl String:user_id[12];
	decl String:name[32];
	decl String:display[48];
	new i = 1;
	while (i <= MaxClients)
	{
		if (IsClientInGame(i))
		{
			IntToString(GetClientUserId(i), user_id, 12);
			GetClientName(i, name, 32);
			Format(display, 47, "%s (%s)", name, user_id);
			AddMenuItem(menu, user_id, display, 0);
			i++;
		}
		i++;
	}
	return 0;
}

public MenuHandler_PlayerList(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[64];
		GetMenuItem(menu, param2, info, 64, 0, "", 0);
		new UserID = StringToInt(info, 10);
		l[client] = GetClientOfUserId(UserID);
		if (jobid[client][0][0] == 6)
		{
			new Handle:menua = CreateMenu(MenuHandler_Mafia, MenuAction:28);
			SetMenuTitle(menua, "Choisissez le job :");
			AddMenuItem(menua, "7", "Mafieux", 0);
			AddMenuItem(menua, "8", "Apprenti Mafieux", 0);
			DisplayMenu(menua, client, 0);
		}
		else
		{
			if (jobid[client][0][0] == 9)
			{
				new Handle:menua = CreateMenu(MenuHandler_Deal, MenuAction:28);
				SetMenuTitle(menua, "Choisissez le job :");
				AddMenuItem(menua, "10", "Dealer", 0);
				AddMenuItem(menua, "11", "Apprenti Dealer", 0);
				DisplayMenu(menua, client, 0);
			}
			if (jobid[client][0][0] == 12)
			{
				new Handle:menua = CreateMenu(MenuHandler_Coach, MenuAction:28);
				SetMenuTitle(menua, "Choisissez le job :");
				AddMenuItem(menua, "13", "Coach", 0);
				AddMenuItem(menua, "14", "Apprenti Coach", 0);
				DisplayMenu(menua, client, 0);
			}
			if (jobid[client][0][0] == 15)
			{
				new Handle:menua = CreateMenu(MenuHandler_Ikea, MenuAction:28);
				SetMenuTitle(menua, "Choisissez le job :");
				AddMenuItem(menua, "16", "Vendeur Ikea", 0);
				AddMenuItem(menua, "17", "Apprenti Vendeur Ikea", 0);
				DisplayMenu(menua, client, 0);
			}
			if (jobid[client][0][0] == 18)
			{
				new Handle:menua = CreateMenu(MenuHandler_Armurie, MenuAction:28);
				SetMenuTitle(menua, "Choisissez le job :");
				AddMenuItem(menua, "19", "Armurier", 0);
				AddMenuItem(menua, "20", "Apprenti Armurier", 0);
				DisplayMenu(menua, client, 0);
			}
			if (jobid[client][0][0] == 21)
			{
				new Handle:menua = CreateMenu(MenuHandler_Loto, MenuAction:28);
				SetMenuTitle(menua, "Choisissez le job :");
				AddMenuItem(menua, "22", "Vendeur de Tickets", 0);
				AddMenuItem(menua, "23", "Apprenti Vendeur de Tickets", 0);
				DisplayMenu(menua, client, 0);
			}
			if (jobid[client][0][0] == 24)
			{
				new Handle:menua = CreateMenu(MenuHandler_Bank, MenuAction:28);
				SetMenuTitle(menua, "Choisissez le job :");
				AddMenuItem(menua, "25", "Banquier", 0);
				AddMenuItem(menua, "26", "Apprenti Banquier", 0);
				DisplayMenu(menua, client, 0);
			}
			if (jobid[client][0][0] == 27)
			{
				new Handle:menua = CreateMenu(MenuHandler_Hosto, MenuAction:28);
				SetMenuTitle(menua, "Choisissez le job :");
				AddMenuItem(menua, "28", "Médecin", 0);
				AddMenuItem(menua, "29", "Infirmier", 0);
				AddMenuItem(menua, "30", "Chirurgien", 0);
				DisplayMenu(menua, client, 0);
			}
			if (jobid[client][0][0] == 31)
			{
				new Handle:menua = CreateMenu(MenuHandler_Artifice, MenuAction:28);
				SetMenuTitle(menua, "Choisissez le job :");
				AddMenuItem(menua, "32", "Artificier", 0);
				AddMenuItem(menua, "33", "Apprenti Artificier", 0);
				DisplayMenu(menua, client, 0);
			}
			if (jobid[client][0][0] == 34)
			{
				new Handle:menua = CreateMenu(MenuHandler_Tueur, MenuAction:28);
				SetMenuTitle(menua, "Choisissez le job :");
				AddMenuItem(menua, "35", "Tueur d'élite", 0);
				AddMenuItem(menua, "36", "Tueur novice", 0);
				DisplayMenu(menua, client, 0);
			}
			if (jobid[client][0][0] == 37)
			{
				new Handle:menua = CreateMenu(MenuHandler_Hotel, MenuAction:28);
				SetMenuTitle(menua, "Choisissez le job :");
				AddMenuItem(menua, "38", "V. Immobilier", 0);
				AddMenuItem(menua, "39", "Apprenti V. Immobilier", 0);
				DisplayMenu(menua, client, 0);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public MenuHandler_Mafia(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[64];
		GetMenuItem(menu, param2, info, 64, 0, "", 0);
		if (StrEqual(info, "7", true))
		{
			new Handle:menu1 = CreateMenu(MenuHandler_Mafieux, MenuAction:28);
			SetMenuTitle(menu1, "Veux-tu devenir Mafieux ?");
			AddMenuItem(menu1, "oui", "Oui je veux", 0);
			AddMenuItem(menu1, "non", "Non merci", 0);
			DisplayMenu(menu1, l[client][0][0], 0);
		}
		else
		{
			if (StrEqual(info, "8", true))
			{
				new Handle:menu1 = CreateMenu(MenuHandler_AMafieux, MenuAction:28);
				SetMenuTitle(menu1, "Veux-tu devenir Apprenti Mafieux ?");
				AddMenuItem(menu1, "oui", "Oui je veux", 0);
				AddMenuItem(menu1, "non", "Non merci", 0);
				DisplayMenu(menu1, l[client][0][0], 0);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public MenuHandler_Tueur(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[64];
		GetMenuItem(menu, param2, info, 64, 0, "", 0);
		if (StrEqual(info, "35", true))
		{
			new Handle:menu1 = CreateMenu(MenuHandler_Elite, MenuAction:28);
			SetMenuTitle(menu1, "Veux-tu devenir Tueur d'élite ?");
			AddMenuItem(menu1, "oui", "Oui je veux", 0);
			AddMenuItem(menu1, "non", "Non merci", 0);
			DisplayMenu(menu1, l[client][0][0], 0);
		}
		else
		{
			if (StrEqual(info, "36", true))
			{
				new Handle:menu1 = CreateMenu(MenuHandler_Novice, MenuAction:28);
				SetMenuTitle(menu1, "Veux-tu devenir Tueur novice ?");
				AddMenuItem(menu1, "oui", "Oui je veux", 0);
				AddMenuItem(menu1, "non", "Non merci", 0);
				DisplayMenu(menu1, l[client][0][0], 0);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public MenuHandler_Elite(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[64];
		GetMenuItem(menu, param2, info, 64, 0, "", 0);
		if (StrEqual(info, "oui", true))
		{
			jobid[client] = 35;
			rankid[client] = 11;
			CS_SetClientClanTag(client, "Tueur d'élite -");
		}
		else
		{
			if (StrEqual(info, "non", true))
			{
				CloseHandle(menu);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public MenuHandler_Novice(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[64];
		GetMenuItem(menu, param2, info, 64, 0, "", 0);
		if (StrEqual(info, "oui", true))
		{
			jobid[client] = 36;
			rankid[client] = 11;
			CS_SetClientClanTag(client, "Tueur novice -");
		}
		else
		{
			if (StrEqual(info, "non", true))
			{
				CloseHandle(menu);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public MenuHandler_Hosto(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[64];
		GetMenuItem(menu, param2, info, 64, 0, "", 0);
		if (StrEqual(info, "28", true))
		{
			new Handle:menu1 = CreateMenu(MenuHandler_Medecin, MenuAction:28);
			SetMenuTitle(menu1, "Veux-tu devenir Médecin ?");
			AddMenuItem(menu1, "oui", "Oui je veux", 0);
			AddMenuItem(menu1, "non", "Non merci", 0);
			DisplayMenu(menu1, l[client][0][0], 0);
		}
		else
		{
			if (StrEqual(info, "29", true))
			{
				new Handle:menu1 = CreateMenu(MenuHandler_Infirmier, MenuAction:28);
				SetMenuTitle(menu1, "Veux-tu devenir Infirmier ?");
				AddMenuItem(menu1, "oui", "Oui je veux", 0);
				AddMenuItem(menu1, "non", "Non merci", 0);
				DisplayMenu(menu1, l[client][0][0], 0);
			}
			if (StrEqual(info, "30", true))
			{
				new Handle:menu1 = CreateMenu(MenuHandler_Chirurgien, MenuAction:28);
				SetMenuTitle(menu1, "Veux-tu devenir Chirurgien ?");
				AddMenuItem(menu1, "oui", "Oui je veux", 0);
				AddMenuItem(menu1, "non", "Non merci", 0);
				DisplayMenu(menu1, l[client][0][0], 0);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public MenuHandler_Hotel(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[64];
		GetMenuItem(menu, param2, info, 64, 0, "", 0);
		if (StrEqual(info, "38", true))
		{
			new Handle:menu1 = CreateMenu(MenuHandler_Hotelier, MenuAction:28);
			SetMenuTitle(menu1, "Veux-tu devenir V. Immobilier ?");
			AddMenuItem(menu1, "oui", "Oui je veux", 0);
			AddMenuItem(menu1, "non", "Non merci", 0);
			DisplayMenu(menu1, l[client][0][0], 0);
		}
		else
		{
			if (StrEqual(info, "39", true))
			{
				new Handle:menu1 = CreateMenu(MenuHandler_AHotelier, MenuAction:28);
				SetMenuTitle(menu1, "Veux-tu devenir Apprenti V. Immobilier ?");
				AddMenuItem(menu1, "oui", "Oui je veux", 0);
				AddMenuItem(menu1, "non", "Non merci", 0);
				DisplayMenu(menu1, l[client][0][0], 0);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public MenuHandler_Hotelier(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[64];
		GetMenuItem(menu, param2, info, 64, 0, "", 0);
		if (StrEqual(info, "oui", true))
		{
			jobid[client] = 38;
			rankid[client] = 12;
			CS_SetClientClanTag(client, "Artificier -");
		}
		else
		{
			if (StrEqual(info, "non", true))
			{
				CloseHandle(menu);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public MenuHandler_AHotelier(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[64];
		GetMenuItem(menu, param2, info, 64, 0, "", 0);
		if (StrEqual(info, "oui", true))
		{
			jobid[client] = 39;
			rankid[client] = 12;
			CS_SetClientClanTag(client, "A. Artificier -");
		}
		else
		{
			if (StrEqual(info, "non", true))
			{
				CloseHandle(menu);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public MenuHandler_Artifice(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[64];
		GetMenuItem(menu, param2, info, 64, 0, "", 0);
		if (StrEqual(info, "32", true))
		{
			new Handle:menu1 = CreateMenu(MenuHandler_Artificier, MenuAction:28);
			SetMenuTitle(menu1, "Veux-tu devenir Artificier ?");
			AddMenuItem(menu1, "oui", "Oui je veux", 0);
			AddMenuItem(menu1, "non", "Non merci", 0);
			DisplayMenu(menu1, l[client][0][0], 0);
		}
		else
		{
			if (StrEqual(info, "33", true))
			{
				new Handle:menu1 = CreateMenu(MenuHandler_Aartificier, MenuAction:28);
				SetMenuTitle(menu1, "Veux-tu devenir Apprenti Artificier ?");
				AddMenuItem(menu1, "oui", "Oui je veux", 0);
				AddMenuItem(menu1, "non", "Non merci", 0);
				DisplayMenu(menu1, l[client][0][0], 0);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public MenuHandler_Artificier(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[64];
		GetMenuItem(menu, param2, info, 64, 0, "", 0);
		if (StrEqual(info, "oui", true))
		{
			jobid[client] = 32;
			rankid[client] = 10;
			capital[client] = capital[rankid[client][0][0]][0][0];
			CS_SetClientClanTag(client, "Artificier -");
		}
		else
		{
			if (StrEqual(info, "non", true))
			{
				CloseHandle(menu);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public MenuHandler_Aartificier(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[64];
		GetMenuItem(menu, param2, info, 64, 0, "", 0);
		if (StrEqual(info, "oui", true))
		{
			jobid[client] = 33;
			rankid[client] = 10;
			capital[client] = capital[rankid[client][0][0]][0][0];
			CS_SetClientClanTag(client, "A. Artificier -");
		}
		else
		{
			if (StrEqual(info, "non", true))
			{
				CloseHandle(menu);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public MenuHandler_Bank(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[64];
		GetMenuItem(menu, param2, info, 64, 0, "", 0);
		if (StrEqual(info, "25", true))
		{
			new Handle:menu1 = CreateMenu(MenuHandler_Banquier, MenuAction:28);
			SetMenuTitle(menu1, "Veux-tu devenir Banquier ?");
			AddMenuItem(menu1, "oui", "Oui je veux", 0);
			AddMenuItem(menu1, "non", "Non merci", 0);
			DisplayMenu(menu1, l[client][0][0], 0);
		}
		else
		{
			if (StrEqual(info, "26", true))
			{
				new Handle:menu1 = CreateMenu(MenuHandler_ABanquier, MenuAction:28);
				SetMenuTitle(menu1, "Veux-tu devenir Apprenti Banquier ?");
				AddMenuItem(menu1, "oui", "Oui je veux", 0);
				AddMenuItem(menu1, "non", "Non merci", 0);
				DisplayMenu(menu1, l[client][0][0], 0);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public MenuHandler_Banquier(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[64];
		GetMenuItem(menu, param2, info, 64, 0, "", 0);
		if (StrEqual(info, "oui", true))
		{
			jobid[client] = 25;
			rankid[client] = 8;
			CS_SetClientClanTag(client, "Banquier -");
		}
		else
		{
			if (StrEqual(info, "non", true))
			{
				CloseHandle(menu);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public MenuHandler_ABanquier(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[64];
		GetMenuItem(menu, param2, info, 64, 0, "", 0);
		if (StrEqual(info, "oui", true))
		{
			jobid[client] = 26;
			rankid[client] = 8;
			CS_SetClientClanTag(client, "A. Banquier -");
		}
		else
		{
			if (StrEqual(info, "non", true))
			{
				CloseHandle(menu);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public MenuHandler_Mafieux(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[64];
		GetMenuItem(menu, param2, info, 64, 0, "", 0);
		if (StrEqual(info, "oui", true))
		{
			jobid[client] = 7;
			rankid[client] = 2;
			CS_SetClientClanTag(client, "Mafieux -");
		}
		else
		{
			if (StrEqual(info, "non", true))
			{
				CloseHandle(menu);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public MenuHandler_AMafieux(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[64];
		GetMenuItem(menu, param2, info, 64, 0, "", 0);
		if (StrEqual(info, "oui", true))
		{
			jobid[client] = 8;
			rankid[client] = 2;
			CS_SetClientClanTag(client, "A. Mafieux -");
		}
		else
		{
			if (StrEqual(info, "non", true))
			{
				CloseHandle(menu);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public MenuHandler_Medecin(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[64];
		GetMenuItem(menu, param2, info, 64, 0, "", 0);
		if (StrEqual(info, "oui", true))
		{
			jobid[client] = 28;
			rankid[client] = 9;
			CS_SetClientClanTag(client, "Médecin -");
		}
		else
		{
			if (StrEqual(info, "non", true))
			{
				CloseHandle(menu);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public MenuHandler_Infirmier(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[64];
		GetMenuItem(menu, param2, info, 64, 0, "", 0);
		if (StrEqual(info, "oui", true))
		{
			jobid[client] = 29;
			rankid[client] = 9;
			CS_SetClientClanTag(client, "Infirmier -");
		}
		else
		{
			if (StrEqual(info, "non", true))
			{
				CloseHandle(menu);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public MenuHandler_Chirurgien(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[64];
		GetMenuItem(menu, param2, info, 64, 0, "", 0);
		if (StrEqual(info, "oui", true))
		{
			jobid[client] = 30;
			rankid[client] = 9;
			CS_SetClientClanTag(client, "Chirurgien -");
		}
		else
		{
			if (StrEqual(info, "non", true))
			{
				CloseHandle(menu);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public MenuHandler_Deal(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[64];
		GetMenuItem(menu, param2, info, 64, 0, "", 0);
		if (StrEqual(info, "10", true))
		{
			new Handle:menu1 = CreateMenu(MenuHandler_Dealer, MenuAction:28);
			SetMenuTitle(menu1, "Veux-tu devenir Dealer ?");
			AddMenuItem(menu1, "oui", "Oui je veux", 0);
			AddMenuItem(menu1, "non", "Non merci", 0);
			DisplayMenu(menu1, l[client][0][0], 0);
		}
		else
		{
			if (StrEqual(info, "11", true))
			{
				new Handle:menu2 = CreateMenu(MenuHandler_ADealer, MenuAction:28);
				SetMenuTitle(menu2, "Veux-tu devenir Apprenti Dealer ?");
				AddMenuItem(menu2, "oui", "Oui je veux", 0);
				AddMenuItem(menu2, "non", "Non merci", 0);
				DisplayMenu(menu2, l[client][0][0], 0);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public MenuHandler_Dealer(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[64];
		GetMenuItem(menu, param2, info, 64, 0, "", 0);
		if (StrEqual(info, "oui", true))
		{
			jobid[client] = 10;
			rankid[client] = 3;
			CS_SetClientClanTag(client, "Dealer -");
		}
		else
		{
			if (StrEqual(info, "non", true))
			{
				CloseHandle(menu);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public MenuHandler_ADealer(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[64];
		GetMenuItem(menu, param2, info, 64, 0, "", 0);
		if (StrEqual(info, "oui", true))
		{
			jobid[client] = 11;
			rankid[client] = 3;
			CS_SetClientClanTag(client, "A. Dealer -");
		}
		else
		{
			if (StrEqual(info, "non", true))
			{
				CloseHandle(menu);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public MenuHandler_Coach(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[64];
		GetMenuItem(menu, param2, info, 64, 0, "", 0);
		if (StrEqual(info, "13", true))
		{
			new Handle:menu1 = CreateMenu(MenuHandler_Coachh, MenuAction:28);
			SetMenuTitle(menu1, "Veux-tu devenir Coach ?");
			AddMenuItem(menu1, "oui", "Oui je veux", 0);
			AddMenuItem(menu1, "non", "Non merci", 0);
			DisplayMenu(menu1, l[client][0][0], 0);
		}
		else
		{
			if (StrEqual(info, "14", true))
			{
				new Handle:menu1 = CreateMenu(MenuHandler_ACoach, MenuAction:28);
				SetMenuTitle(menu1, "Veux-tu devenir Apprenti Coach ?");
				AddMenuItem(menu1, "oui", "Oui je veux", 0);
				AddMenuItem(menu1, "non", "Non merci", 0);
				DisplayMenu(menu1, l[client][0][0], 0);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public MenuHandler_Coachh(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[64];
		GetMenuItem(menu, param2, info, 64, 0, "", 0);
		if (StrEqual(info, "oui", true))
		{
			jobid[client] = 13;
			rankid[client] = 4;
			CS_SetClientClanTag(client, "Coach -");
		}
		else
		{
			if (StrEqual(info, "non", true))
			{
				CloseHandle(menu);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public MenuHandler_ACoach(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[64];
		GetMenuItem(menu, param2, info, 64, 0, "", 0);
		if (StrEqual(info, "oui", true))
		{
			jobid[client] = 14;
			rankid[client] = 4;
			CS_SetClientClanTag(client, "A. Coach -");
		}
		else
		{
			if (StrEqual(info, "non", true))
			{
				CloseHandle(menu);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public MenuHandler_Ikea(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[64];
		GetMenuItem(menu, param2, info, 64, 0, "", 0);
		if (StrEqual(info, "16", true))
		{
			new Handle:menu1 = CreateMenu(MenuHandler_VIkea, MenuAction:28);
			SetMenuTitle(menu1, "Veux-tu devenir Vendeur Ikea ?");
			AddMenuItem(menu1, "oui", "Oui je veux", 0);
			AddMenuItem(menu1, "non", "Non merci", 0);
			DisplayMenu(menu1, l[client][0][0], 0);
		}
		else
		{
			if (StrEqual(info, "17", true))
			{
				new Handle:menu1 = CreateMenu(MenuHandler_AVIkea, MenuAction:28);
				SetMenuTitle(menu1, "Veux-tu devenir Apprenti Vendeur Ikea ?");
				AddMenuItem(menu1, "oui", "Oui je veux", 0);
				AddMenuItem(menu1, "non", "Non merci", 0);
				DisplayMenu(menu1, l[client][0][0], 0);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public MenuHandler_VIkea(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[64];
		GetMenuItem(menu, param2, info, 64, 0, "", 0);
		if (StrEqual(info, "oui", true))
		{
			jobid[client] = 16;
			rankid[client] = 5;
			CS_SetClientClanTag(client, "V. Ikea -");
		}
		else
		{
			if (StrEqual(info, "non", true))
			{
				CloseHandle(menu);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public MenuHandler_AVIkea(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[64];
		GetMenuItem(menu, param2, info, 64, 0, "", 0);
		if (StrEqual(info, "oui", true))
		{
			jobid[client] = 17;
			rankid[client] = 5;
			CS_SetClientClanTag(client, "A.V. Ikea -");
		}
		else
		{
			if (StrEqual(info, "non", true))
			{
				CloseHandle(menu);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public MenuHandler_Armurie(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[64];
		GetMenuItem(menu, param2, info, 64, 0, "", 0);
		if (StrEqual(info, "19", true))
		{
			new Handle:menu1 = CreateMenu(MenuHandler_Armurier, MenuAction:28);
			SetMenuTitle(menu1, "Veux-tu devenir Armurier ?");
			AddMenuItem(menu1, "oui", "Oui je veux", 0);
			AddMenuItem(menu1, "non", "Non merci", 0);
			DisplayMenu(menu1, l[client][0][0], 0);
		}
		else
		{
			if (StrEqual(info, "20", true))
			{
				new Handle:menu1 = CreateMenu(MenuHandler_AArmurier, MenuAction:28);
				SetMenuTitle(menu1, "Veux-tu devenir Apprenti Armurier ?");
				AddMenuItem(menu1, "oui", "Oui je veux", 0);
				AddMenuItem(menu1, "non", "Non merci", 0);
				DisplayMenu(menu1, l[client][0][0], 0);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public MenuHandler_Armurier(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[64];
		GetMenuItem(menu, param2, info, 64, 0, "", 0);
		if (StrEqual(info, "oui", true))
		{
			jobid[client] = 19;
			rankid[client] = 6;
			CS_SetClientClanTag(client, "Armurier -");
		}
		else
		{
			if (StrEqual(info, "non", true))
			{
				CloseHandle(menu);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public MenuHandler_AArmurier(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[64];
		GetMenuItem(menu, param2, info, 64, 0, "", 0);
		if (StrEqual(info, "oui", true))
		{
			jobid[client] = 20;
			rankid[client] = 6;
			CS_SetClientClanTag(client, "A. Armurier -");
		}
		else
		{
			if (StrEqual(info, "non", true))
			{
				CloseHandle(menu);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public MenuHandler_Loto(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[64];
		GetMenuItem(menu, param2, info, 64, 0, "", 0);
		if (StrEqual(info, "22", true))
		{
			new Handle:menu1 = CreateMenu(MenuHandler_VTicket, MenuAction:28);
			SetMenuTitle(menu1, "Veux-tu devenir Vendeur de Tickets ?");
			AddMenuItem(menu1, "oui", "Oui je veux", 0);
			AddMenuItem(menu1, "non", "Non merci", 0);
			DisplayMenu(menu1, l[client][0][0], 0);
		}
		else
		{
			if (StrEqual(info, "23", true))
			{
				new Handle:menu1 = CreateMenu(MenuHandler_AVTicket, MenuAction:28);
				SetMenuTitle(menu1, "Veux-tu devenir Apprenti Vendeur de Tickets ?");
				AddMenuItem(menu1, "oui", "Oui je veux", 0);
				AddMenuItem(menu1, "non", "Non merci", 0);
				DisplayMenu(menu1, l[client][0][0], 0);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public MenuHandler_VTicket(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[64];
		GetMenuItem(menu, param2, info, 64, 0, "", 0);
		if (StrEqual(info, "oui", true))
		{
			jobid[client] = 22;
			rankid[client] = 7;
			CS_SetClientClanTag(client, "V. Tickets -");
		}
		else
		{
			if (StrEqual(info, "non", true))
			{
				CloseHandle(menu);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public MenuHandler_AVTicket(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[64];
		GetMenuItem(menu, param2, info, 64, 0, "", 0);
		if (StrEqual(info, "oui", true))
		{
			jobid[client] = 23;
			rankid[client] = 7;
			CS_SetClientClanTag(client, "A.V. Tickets -");
		}
		else
		{
			if (StrEqual(info, "non", true))
			{
				CloseHandle(menu);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public Action:Command_Enquete(client, args)
{
	if (IsClientInGame(client))
	{
		if (IsPlayerAlive(client))
		{
			if (GetClientTeam(client) == 3)
			{
				z[client] = GetClientAimTarget(client, true);
				if (z[client][0][0] != -1)
				{
					new String:edictname[128];
					new String:SteamId[32];
					GetClientAuthString(z[client][0][0], SteamId, 32, true);
					new life = GetClientHealth(z[client][0][0]);
					GetEdictClassname(z[client][0][0], edictname, 128);
					if (StrEqual(edictname, "player", true))
					{
						if (IsPlayerAlive(z[client][0][0]))
						{
							CPrintToChat(client, "%s: Pseudo : %N	||	Steam ID : %s", "{red}[CSS-RP] ", z[client], SteamId);
							CPrintToChat(client, "%s: Level CUT : %i	||	HP : %d", "{red}[CSS-RP] ", levelcut[z[client][0][0]], life);
							if (permisleger[z[client][0][0]][0][0] > 0)
							{
								var1 = 85236;
							}
							else
							{
								var1 = 85240;
							}
							if (permislourd[z[client][0][0]][0][0] > 0)
							{
								var2 = 85228;
							}
							else
							{
								var2 = 85232;
							}
							CPrintToChat(client, "%s: Permis Lourd : %s	||	Permis Leger : %s", "{red}[CSS-RP] ", var2, var1);
							CPrintToChat(client, "%s: Temps de prisons : %i", "{red}[CSS-RP] ", g_jailtime[z[client][0][0]]);
						}
					}
					else
					{
						CPrintToChat(client, "%s: Vous devez visé un joueur.", "{red}[CSS-RP] ");
					}
				}
				else
				{
					CPrintToChat(client, "%s: Vous devez visé un joueur.", "{red}[CSS-RP] ");
				}
			}
			else
			{
				CPrintToChat(client, "%s: Vous n'avez pas accès a cette commande.", "{red}[CSS-RP] ");
			}
		}
		CPrintToChat(client, "%s: Vous devez être vivant.", "{red}[CSS-RP] ");
	}
	return Action:0;
}

public Action:Command_Rw(client, args)
{
	if (IsPlayerAlive(client))
	{
		if (GetClientTeam(client) == 3)
		{
			new Ent = GetClientAimTarget(client, false);
			if (Ent != -1)
			{
				new String:Classname[32];
				GetEdictClassname(Ent, Classname, 32);
				if (StrContains(Classname, "weapon_", false) != -1)
				{
					RemoveEdict(Ent);
					CPrintToChat(client, "%s: Vous avez supprimé l'arme au sol.", "{red}[CSS-RP] ");
				}
				else
				{
					CPrintToChat(client, "%s: Ce n'est pas une arme.", "{red}[CSS-RP] ");
				}
			}
		}
		CPrintToChat(client, "%s: Vous n'avez pas accès a cette commande.", "{red}[CSS-RP] ");
	}
	return Action:0;
}

public Action:Command_Roleplay(client, args)
{
	if (IsClientInGame(client))
	{
		if (IsPlayerAlive(client))
		{
			new Handle:menua = CreateMenu(Menu_Rp, MenuAction:28);
			SetMenuTitle(menua, "Commandes du Roleplay :", 1);
			AddMenuItem(menua, "virer", "/virer => viré un joueur", 1);
			AddMenuItem(menua, "engager", "/engager => Engager un joueur", 1);
			AddMenuItem(menua, "vendre", "/vendre => Vendre un item", 1);
			AddMenuItem(menua, "infos", "/infos => Informations sur le Plugin", 1);
			AddMenuItem(menua, "unlock", "/unlock => Dà©verrouillà© une porte", 1);
			AddMenuItem(menua, "lock", "/lock => Verrouillà© une porte", 1);
			AddMenuItem(menua, "civil", "/civil => Se mettre en civil", 1);
			AddMenuItem(menua, "jail", "/jail => Mettre en jail un joueur", 1);
			AddMenuItem(menua, "give", "/give => Donnà© de l'argent a un joueur", 1);
			AddMenuItem(menua, "tazer", "/tazer => Tazà© un joueur", 1);
			AddMenuItem(menua, "vol", "/vol => voler un joueur", 1);
			AddMenuItem(menua, "demission", "/demission => Dà©missionà© de son travail", 1);
			AddMenuItem(menua, "enquete", "/enquete => Faire une enquàªte", 1);
			AddMenuItem(menua, "+force", "/+force => porter un joueur", 1);
			AddMenuItem(menua, "del", "/del => Supprime l'arme au sol visere", 1);
			AddMenuItem(menua, "vis", "/vis => Devenir invisible", 1);
			AddMenuItem(menua, "jobmenu", "/jobmenu => Donnà© un job a un joueur", 1);
			AddMenuItem(menua, "money", "/money => Donnà© de l'argent a un joueur", 1);
			AddMenuItem(menua, "item", "/item => Ouvrir son inventaire", 1);
			AddMenuItem(menua, "perqui", "/perquisition => Faire une perquisition", 1);
			AddMenuItem(menua, "armu", "/armurerie => Ouvrir l'armurerie.", 1);
			AddMenuItem(menua, "changename", "/changename => changà© de pseudo.", 1);
			AddMenuItem(menua, "out", "/out => expulsé de chez vous.", 1);
			AddMenuItem(menua, "jaillist", "/jaillist => Affiche les joueurs en jail.", 1);
			AddMenuItem(menua, "infoscut", "/infoscut => Affiche les informations level cut.", 1);
			AddMenuItem(menua, "salaire", "/salaire => Modifier le salaire.", 1);
			DisplayMenu(menua, client, 0);
			return Action:3;
		}
	}
	return Action:0;
}

public Menu_Rp(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:16)
	{
		CloseHandle(menu);
	}
	return 0;
}

public Action:Command_Perqui(client, args)
{
	if (IsClientInGame(client))
	{
		if (IsPlayerAlive(client))
		{
			if (GetClientTeam(client) == 3)
			{
				CPrintToChatAll("%s: Perquisition de la \x04Police ! \x03Pas de résistance !", "{red}[CSS-RP] ");
				CPrintToChatAll("%s: \x04%N \x03dirige la perquisition !", "{red}[CSS-RP] ", client);
			}
			else
			{
				CPrintToChat(client, "%s: Vous n'avez pas accès a cette commande.", "{red}[CSS-RP] ");
			}
		}
		CPrintToChat(client, "%s: Vous devez être en vie.", "{red}[CSS-RP] ");
	}
	return Action:0;
}

public Action:Command_PerquiOff(client, args)
{
	if (IsClientInGame(client))
	{
		if (IsPlayerAlive(client))
		{
			if (GetClientTeam(client) == 3)
			{
				CPrintToChatAll("%s:La perquisition est terminé.", "{red}[CSS-RP] ");
				CPrintToChatAll("%s:L'opération a été dirigé par \x04%N\x03.", "{red}[CSS-RP] ", client);
			}
			else
			{
				CPrintToChat(client, "%s: Vous n'avez pas accès a cette commande.", "{red}[CSS-RP] ");
			}
		}
		CPrintToChat(client, "%s: Vous devez être en vie pour utiliser cette commande.", "{red}[CSS-RP] ");
	}
	return Action:0;
}

public Action:Command_Armurie(client, args)
{
	if (IsPlayerAlive(client))
	{
		if (GetClientTeam(client) == 3)
		{
			decl String:player_name[68];
			GetClientName(client, player_name, 65);
			new String:SteamId[32];
			GetClientAuthString(client, SteamId, 32, true);
			new Handle:menu = CreateMenu(armu, MenuAction:28);
			SetMenuTitle(menu, "Choisissez ton arme : %s (%s) :", player_name, SteamId);
			if (jobid[client][0][0] == 1)
			{
				AddMenuItem(menu, "awp", "AWP", 0);
				AddMenuItem(menu, "batteuse", "M249", 0);
				AddMenuItem(menu, "m4", "M4A1", 0);
				AddMenuItem(menu, "ak", "AK47", 0);
				AddMenuItem(menu, "aug", "AUG", 0);
				AddMenuItem(menu, "scout", "SCOUT", 0);
				AddMenuItem(menu, "mp5", "MP5", 0);
				AddMenuItem(menu, "p90", "P90", 0);
				AddMenuItem(menu, "ump45", "UMP45", 0);
				AddMenuItem(menu, "tmp", "TMP", 0);
				AddMenuItem(menu, "mac10", "MAC10", 0);
				AddMenuItem(menu, "m3", "M3", 0);
				AddMenuItem(menu, "xm1014", "XM1014", 0);
				AddMenuItem(menu, "galil", "GALIL", 0);
				AddMenuItem(menu, "famas", "FAMAS", 0);
				AddMenuItem(menu, "deagle", "DEAGLE", 0);
				AddMenuItem(menu, "glock", "GLOCK", 0);
				AddMenuItem(menu, "usp", "USP", 0);
				AddMenuItem(menu, "flash", "FLASH", 0);
				AddMenuItem(menu, "grenade", "HE", 0);
			}
			else
			{
				if (jobid[client][0][0] == 2)
				{
					AddMenuItem(menu, "m4", "M4A1", 0);
					AddMenuItem(menu, "ak", "AK47", 0);
					AddMenuItem(menu, "aug", "AUG", 0);
					AddMenuItem(menu, "scout", "SCOUT", 0);
					AddMenuItem(menu, "mp5", "MP5", 0);
					AddMenuItem(menu, "p90", "P90", 0);
					AddMenuItem(menu, "ump45", "UMP45", 0);
					AddMenuItem(menu, "tmp", "TMP", 0);
					AddMenuItem(menu, "mac10", "MAC10", 0);
					AddMenuItem(menu, "m3", "M3", 0);
					AddMenuItem(menu, "xm1014", "XM1014", 0);
					AddMenuItem(menu, "galil", "GALIL", 0);
					AddMenuItem(menu, "famas", "FAMAS", 0);
					AddMenuItem(menu, "deagle", "DEAGLE", 0);
					AddMenuItem(menu, "glock", "GLOCK", 0);
					AddMenuItem(menu, "usp", "USP", 0);
					AddMenuItem(menu, "flash", "FLASH", 0);
					AddMenuItem(menu, "grenade", "HE", 0);
				}
				if (jobid[client][0][0] == 3)
				{
					AddMenuItem(menu, "scout", "SCOUT", 0);
					AddMenuItem(menu, "mp5", "MP5", 0);
					AddMenuItem(menu, "p90", "P90", 0);
					AddMenuItem(menu, "ump45", "UMP45", 0);
					AddMenuItem(menu, "tmp", "TMP", 0);
					AddMenuItem(menu, "mac10", "MAC10", 0);
					AddMenuItem(menu, "m3", "M3", 0);
					AddMenuItem(menu, "xm1014", "XM1014", 0);
					AddMenuItem(menu, "galil", "GALIL", 0);
					AddMenuItem(menu, "famas", "FAMAS", 0);
					AddMenuItem(menu, "deagle", "DEAGLE", 0);
					AddMenuItem(menu, "glock", "GLOCK", 0);
					AddMenuItem(menu, "usp", "USP", 0);
					AddMenuItem(menu, "flash", "FLASH", 0);
					AddMenuItem(menu, "grenade", "HE", 0);
				}
				if (jobid[client][0][0] == 4)
				{
					AddMenuItem(menu, "tmp", "TMP", 0);
					AddMenuItem(menu, "mac10", "MAC10", 0);
					AddMenuItem(menu, "m3", "M3", 0);
					AddMenuItem(menu, "xm1014", "XM1014", 0);
					AddMenuItem(menu, "galil", "GALIL", 0);
					AddMenuItem(menu, "famas", "FAMAS", 0);
					AddMenuItem(menu, "deagle", "DEAGLE", 0);
					AddMenuItem(menu, "glock", "GLOCK", 0);
					AddMenuItem(menu, "usp", "USP", 0);
					AddMenuItem(menu, "flash", "FLASH", 0);
					AddMenuItem(menu, "grenade", "HE", 0);
				}
				if (jobid[client][0][0] == 5)
				{
					AddMenuItem(menu, "xm1014", "XM1014", 0);
					AddMenuItem(menu, "galil", "GALIL", 0);
					AddMenuItem(menu, "famas", "FAMAS", 0);
					AddMenuItem(menu, "deagle", "DEAGLE", 0);
					AddMenuItem(menu, "glock", "GLOCK", 0);
					AddMenuItem(menu, "usp", "USP", 0);
					AddMenuItem(menu, "flash", "FLASH", 0);
					AddMenuItem(menu, "grenade", "HE", 0);
				}
			}
			DisplayMenu(menu, client, 0);
		}
		else
		{
			CPrintToChat(client, "%s: Vous n'avez pas accès a cette commande.", "{red}[CSS-RP] ");
		}
	}
	else
	{
		CPrintToChat(client, "%s: Vous devez être en vie pour utilisé cette commande.", "{red}[CSS-RP] ");
	}
	return Action:0;
}

public armu2(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[32];
		GetMenuItem(menu, param2, info, 32, 0, "", 0);
		if (StrEqual(info, "awp", true))
		{
			if (money[client][0][0] >= 1000)
			{
				GivePlayerItem(client, "weapon_awp", 0);
				var1 = var1[0][0][-250];
			}
			else
			{
				CPrintToChat(client, "%s Vous n'avez pas assez d'argent", "{red}[CSS-RP] ");
			}
		}
		else
		{
			if (StrEqual(info, "batteuse", true))
			{
				if (money[client][0][0] >= 1000)
				{
					GivePlayerItem(client, "weapon_m249", 0);
					var2 = var2[0][0][-250];
				}
				else
				{
					CPrintToChat(client, "%s Vous n'avez pas assez d'argent", "{red}[CSS-RP] ");
				}
			}
			if (StrEqual(info, "m4", true))
			{
				GivePlayerItem(client, "weapon_m4a1", 0);
			}
			if (StrEqual(info, "ak", true))
			{
				GivePlayerItem(client, "weapon_ak47", 0);
			}
			if (StrEqual(info, "aug", true))
			{
				GivePlayerItem(client, "weapon_aug", 0);
			}
			if (StrEqual(info, "scout", true))
			{
				GivePlayerItem(client, "weapon_scout", 0);
			}
			if (StrEqual(info, "mp5", true))
			{
				GivePlayerItem(client, "weapon_mp5navy", 0);
			}
			if (StrEqual(info, "p90", true))
			{
				GivePlayerItem(client, "weapon_p90", 0);
			}
			if (StrEqual(info, "ump45", true))
			{
				GivePlayerItem(client, "weapon_ump45", 0);
			}
			if (StrEqual(info, "tmp", true))
			{
				GivePlayerItem(client, "weapon_tmp", 0);
			}
			if (StrEqual(info, "mac10", true))
			{
				GivePlayerItem(client, "weapon_mac10", 0);
			}
			if (StrEqual(info, "m3", true))
			{
				GivePlayerItem(client, "weapon_m3", 0);
			}
			if (StrEqual(info, "xm1014", true))
			{
				GivePlayerItem(client, "weapon_xm1014", 0);
			}
			if (StrEqual(info, "galil", true))
			{
				GivePlayerItem(client, "weapon_galil", 0);
			}
			if (StrEqual(info, "famas", true))
			{
				GivePlayerItem(client, "weapon_famas", 0);
			}
			if (StrEqual(info, "deagle", true))
			{
				GivePlayerItem(client, "weapon_deagle", 0);
			}
			if (StrEqual(info, "glock", true))
			{
				GivePlayerItem(client, "weapon_glock", 0);
			}
			if (StrEqual(info, "usp", true))
			{
				GivePlayerItem(client, "weapon_usp", 0);
			}
			if (StrEqual(info, "flash", true))
			{
				GivePlayerItem(client, "weapon_flashbang", 0);
			}
			if (StrEqual(info, "grenade", true))
			{
				GivePlayerItem(client, "weapon_hegrenade", 0);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public armu(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[32];
		GetMenuItem(menu, param2, info, 32, 0, "", 0);
		if (StrEqual(info, "awp", true))
		{
			GivePlayerItem(client, "weapon_awp", 0);
		}
		else
		{
			if (StrEqual(info, "batteuse", true))
			{
				GivePlayerItem(client, "weapon_m249", 0);
			}
			if (StrEqual(info, "m4", true))
			{
				GivePlayerItem(client, "weapon_m4a1", 0);
			}
			if (StrEqual(info, "ak", true))
			{
				GivePlayerItem(client, "weapon_ak47", 0);
			}
			if (StrEqual(info, "aug", true))
			{
				GivePlayerItem(client, "weapon_aug", 0);
			}
			if (StrEqual(info, "scout", true))
			{
				GivePlayerItem(client, "weapon_scout", 0);
			}
			if (StrEqual(info, "mp5", true))
			{
				GivePlayerItem(client, "weapon_mp5navy", 0);
			}
			if (StrEqual(info, "p90", true))
			{
				GivePlayerItem(client, "weapon_p90", 0);
			}
			if (StrEqual(info, "ump45", true))
			{
				GivePlayerItem(client, "weapon_ump45", 0);
			}
			if (StrEqual(info, "tmp", true))
			{
				GivePlayerItem(client, "weapon_tmp", 0);
			}
			if (StrEqual(info, "mac10", true))
			{
				GivePlayerItem(client, "weapon_mac10", 0);
			}
			if (StrEqual(info, "m3", true))
			{
				GivePlayerItem(client, "weapon_m3", 0);
			}
			if (StrEqual(info, "xm1014", true))
			{
				GivePlayerItem(client, "weapon_xm1014", 0);
			}
			if (StrEqual(info, "galil", true))
			{
				GivePlayerItem(client, "weapon_galil", 0);
			}
			if (StrEqual(info, "famas", true))
			{
				GivePlayerItem(client, "weapon_famas", 0);
			}
			if (StrEqual(info, "deagle", true))
			{
				GivePlayerItem(client, "weapon_deagle", 0);
			}
			if (StrEqual(info, "glock", true))
			{
				GivePlayerItem(client, "weapon_glock", 0);
			}
			if (StrEqual(info, "usp", true))
			{
				GivePlayerItem(client, "weapon_usp", 0);
			}
			if (StrEqual(info, "flash", true))
			{
				GivePlayerItem(client, "weapon_flashbang", 0);
			}
			if (StrEqual(info, "grenade", true))
			{
				GivePlayerItem(client, "weapon_hegrenade", 0);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public Action:Command_Out(client, args)
{
	if (IsClientInGame(client))
	{
		if (IsPlayerAlive(client))
		{
			new expulser = GetClientAimTarget(client, true);
			if (expulser != -1)
			{
				if (GetClientTeam(client) == 3)
				{
					if (IsInComico(client))
					{
						if (IsInComico(expulser))
						{
							CPrintToChat(client, "%s: Vous avez expulsé %N.", "{red}[CSS-RP] ", expulser);
							CPrintToChat(expulser, "%s: Vous avez été expulsé par %N", "{red}[CSS-RP] ", client);
							TeleportEntity(expulser, 89484, NULL_VECTOR, NULL_VECTOR);
						}
						else
						{
							CPrintToChat(client, "%s: Le joueur %N n'est pas dans votre planque.", "{red}[CSS-RP] ", expulser);
						}
					}
					else
					{
						CPrintToChat(client, "%s: Vous n'êtes pas dans votre planque.", "{red}[CSS-RP] ");
					}
				}
				else
				{
					if (jobid[client][0][0] == 6)
					{
						if (IsInMafia(client))
						{
							if (IsInMafia(expulser))
							{
								CPrintToChat(client, "%s: Vous avez expulsé %N.", "{red}[CSS-RP] ", expulser);
								CPrintToChat(expulser, "%s: Vous avez été expulsé par %N", "{red}[CSS-RP] ", client);
								TeleportEntity(expulser, 89716, NULL_VECTOR, NULL_VECTOR);
							}
							else
							{
								CPrintToChat(client, "%s: Le joueur %N n'est pas dans votre planque.", "{red}[CSS-RP] ", expulser);
							}
						}
						else
						{
							CPrintToChat(client, "%s: Vous n'êtes pas dans votre planque.", "{red}[CSS-RP] ");
						}
					}
					if (jobid[client][0][0] == 9)
					{
						if (IsInDealer(client))
						{
							if (IsInDealer(expulser))
							{
								CPrintToChat(client, "%s: Vous avez expulsé %N.", "{red}[CSS-RP] ", expulser);
								CPrintToChat(expulser, "%s: Vous avez été expulsé par %N", "{red}[CSS-RP] ", client);
								TeleportEntity(expulser, 89948, NULL_VECTOR, NULL_VECTOR);
							}
							else
							{
								CPrintToChat(client, "%s: Le joueur %N n'est pas dans votre planque.", "{red}[CSS-RP] ", expulser);
							}
						}
						else
						{
							CPrintToChat(client, "%s: Vous n'êtes pas dans votre planque.", "{red}[CSS-RP] ");
						}
					}
					if (jobid[client][0][0] == 12)
					{
						if (IsInCoach(client))
						{
							if (IsInCoach(expulser))
							{
								CPrintToChat(client, "%s: Vous avez expulsé %N.", "{red}[CSS-RP] ", expulser);
								CPrintToChat(expulser, "%s: Vous avez été expulsé par %N", "{red}[CSS-RP] ", client);
								TeleportEntity(expulser, 90180, NULL_VECTOR, NULL_VECTOR);
							}
							else
							{
								CPrintToChat(client, "%s: Le joueur %N n'est pas dans votre planque.", "{red}[CSS-RP] ", expulser);
							}
						}
						else
						{
							CPrintToChat(client, "%s: Vous n'êtes pas dans votre planque.", "{red}[CSS-RP] ");
						}
					}
					if (jobid[client][0][0] == 15)
					{
						if (IsInIkea(client))
						{
							if (IsInIkea(expulser))
							{
								CPrintToChat(client, "%s: Vous avez expulsé %N.", "{red}[CSS-RP] ", expulser);
								CPrintToChat(expulser, "%s: Vous avez été expulsé par %N", "{red}[CSS-RP] ", client);
								TeleportEntity(expulser, 90412, NULL_VECTOR, NULL_VECTOR);
							}
							else
							{
								CPrintToChat(client, "%s: Le joueur %N n'est pas dans votre planque.", "{red}[CSS-RP] ", expulser);
							}
						}
						else
						{
							CPrintToChat(client, "%s: Vous n'êtes pas dans votre planque.", "{red}[CSS-RP] ");
						}
					}
					if (jobid[client][0][0] == 18)
					{
						if (IsInArmu(client))
						{
							if (IsInArmu(expulser))
							{
								CPrintToChat(client, "%s: Vous avez expulsé %N.", "{red}[CSS-RP] ", expulser);
								CPrintToChat(expulser, "%s: Vous avez été expulsé par %N", "{red}[CSS-RP] ", client);
								TeleportEntity(expulser, 90644, NULL_VECTOR, NULL_VECTOR);
							}
							else
							{
								CPrintToChat(client, "%s: Le joueur %N n'est pas dans votre planque.", "{red}[CSS-RP] ", expulser);
							}
						}
						else
						{
							CPrintToChat(client, "%s: Vous n'êtes pas dans votre planque.", "{red}[CSS-RP] ");
						}
					}
					if (jobid[client][0][0] == 21)
					{
						if (IsInLoto(client))
						{
							if (IsInLoto(expulser))
							{
								CPrintToChat(client, "%s: Vous avez expulsé %N.", "{red}[CSS-RP] ", expulser);
								CPrintToChat(expulser, "%s: Vous avez été expulsé par %N", "{red}[CSS-RP] ", client);
								TeleportEntity(expulser, 90876, NULL_VECTOR, NULL_VECTOR);
							}
							else
							{
								CPrintToChat(client, "%s: Le joueur %N n'est pas dans votre planque.", "{red}[CSS-RP] ", expulser);
							}
						}
						else
						{
							CPrintToChat(client, "%s: Vous n'êtes pas dans votre planque.", "{red}[CSS-RP] ");
						}
					}
					if (jobid[client][0][0] == 24)
					{
						if (IsInBank(client))
						{
							if (IsInBank(expulser))
							{
								CPrintToChat(client, "%s: Vous avez expulsé %N.", "{red}[CSS-RP] ", expulser);
								CPrintToChat(expulser, "%s: Vous avez été expulsé par %N", "{red}[CSS-RP] ", client);
								TeleportEntity(expulser, 91108, NULL_VECTOR, NULL_VECTOR);
							}
							else
							{
								CPrintToChat(client, "%s: Le joueur %N n'est pas dans votre planque.", "{red}[CSS-RP] ", expulser);
							}
						}
						else
						{
							CPrintToChat(client, "%s: Vous n'êtes pas dans votre planque.", "{red}[CSS-RP] ");
						}
					}
					if (jobid[client][0][0] == 27)
					{
						if (IsInHosto(client))
						{
							if (IsInHosto(expulser))
							{
								CPrintToChat(client, "%s: Vous avez expulsé %N.", "{red}[CSS-RP] ", expulser);
								CPrintToChat(expulser, "%s: Vous avez été expulsé par %N", "{red}[CSS-RP] ", client);
								TeleportEntity(expulser, 91340, NULL_VECTOR, NULL_VECTOR);
							}
							else
							{
								CPrintToChat(client, "%s: Le joueur %N n'est pas dans votre planque.", "{red}[CSS-RP] ", expulser);
							}
						}
						else
						{
							CPrintToChat(client, "%s: Vous n'êtes pas dans votre planque.", "{red}[CSS-RP] ");
						}
					}
					if (jobid[client][0][0] == 31)
					{
						if (IsInEleven(client))
						{
							if (IsInEleven(expulser))
							{
								CPrintToChat(client, "%s: Vous avez expulsé %N.", "{red}[CSS-RP] ", expulser);
								CPrintToChat(expulser, "%s: Vous avez été expulsé par %N", "{red}[CSS-RP] ", client);
								TeleportEntity(expulser, 91572, NULL_VECTOR, NULL_VECTOR);
							}
							else
							{
								CPrintToChat(client, "%s: Le joueur %N n'est pas dans votre planque.", "{red}[CSS-RP] ", expulser);
							}
						}
						else
						{
							CPrintToChat(client, "%s: Vous n'êtes pas dans votre planque.", "{red}[CSS-RP] ");
						}
					}
					if (jobid[client][0][0] == 34)
					{
						if (IsInTueur(client))
						{
							if (IsInTueur(expulser))
							{
								CPrintToChat(client, "%s: Vous avez expulsé %N.", "{red}[CSS-RP] ", expulser);
								CPrintToChat(expulser, "%s: Vous avez été expulsé par %N", "{red}[CSS-RP] ", client);
								TeleportEntity(expulser, 91804, NULL_VECTOR, NULL_VECTOR);
							}
							else
							{
								CPrintToChat(client, "%s: Le joueur %N n'est pas dans votre planque.", "{red}[CSS-RP] ", expulser);
							}
						}
						else
						{
							CPrintToChat(client, "%s: Vous n'êtes pas dans votre planque.", "{red}[CSS-RP] ");
						}
					}
					if (jobid[client][0][0] == 37)
					{
						if (IsInHotel(client))
						{
							if (IsInHotel(expulser))
							{
								CPrintToChat(client, "%s: Vous avez expulsé %N.", "{red}[CSS-RP] ", expulser);
								CPrintToChat(expulser, "%s: Vous avez été expulsé par %N", "{red}[CSS-RP] ", client);
								TeleportEntity(expulser, 92036, NULL_VECTOR, NULL_VECTOR);
							}
							else
							{
								CPrintToChat(client, "%s: Le joueur %N n'est pas dans votre planque.", "{red}[CSS-RP] ", expulser);
							}
						}
						else
						{
							CPrintToChat(client, "%s: Vous n'êtes pas dans votre planque.", "{red}[CSS-RP] ");
						}
					}
					if (jobid[client][0][0])
					{
					}
					else
					{
						CPrintToChat(client, "%s: Vous n'avez pas accès a cette commande.", "{red}[CSS-RP] ");
					}
				}
			}
			else
			{
				CPrintToChat(client, "%s: Vous devez visé un joueur.", "{red}[CSS-RP] ");
			}
		}
	}
	return Action:0;
}

public Action:Command_Save(client, args)
{
	if (jobid[client][0][0] == 1)
	{
		CPrintToChatAll("%s:  Sauvegarde du serveur en cours...", "{red}[CSS-RP] ");
		new i = 1;
		while (i < MaxClients)
		{
			if (IsClientConnected(i))
			{
				i++;
			}
			i++;
		}
	}
	else
	{
		CPrintToChat(client, "%s: Vous n'avez pas accès a cette commande.", "{red}[CSS-RP] ");
	}
	return Action:0;
}

public Action:Command_Bankick(client, args)
{
	if (IsClientInGame(client))
	{
		new String:SteamId[32];
		GetClientAuthString(client, SteamId, 32, true);
		if (GetUserFlagBits(client) & 16384)
		{
			ChercheJoueurs(client);
			return Action:3;
		}
		CPrintToChat(client, "%s: Vous n'avez pas accès a cette commande.", "{red}[CSS-RP] ");
		return Action:3;
	}
	return Action:0;
}

ChercheJoueurs(client)
{
	if (client > 0)
	{
		decl String:sMenuText[64];
		sMenuText[0] = 0;
		new Handle:menu = CreateMenu(Menu_Bankick, MenuAction:28);
		SetMenuTitle(menu, "Choisissez le joueur :");
		SetMenuExitButton(menu, true);
		Addmenu(menu);
		DisplayMenu(menu, client, 0);
	}
	return 0;
}

public Addmenu(Handle:menu)
{
	decl String:user_id[12];
	decl String:name[32];
	decl String:display[48];
	new i = 1;
	while (i <= MaxClients)
	{
		if (IsClientInGame(i))
		{
			IntToString(GetClientUserId(i), user_id, 12);
			GetClientName(i, name, 32);
			Format(display, 47, "%s (%s)", name, user_id);
			AddMenuItem(menu, user_id, display, 0);
			i++;
		}
		i++;
	}
	return 0;
}

public Menu_Bankick(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[64];
		GetMenuItem(menu, param2, info, 64, 0, "", 0);
		new UserID = StringToInt(info, 10);
		banni[client] = GetClientOfUserId(UserID);
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public Action:Command_Vente(client, args)
{
	if (IsClientInGame(client))
	{
		if (IsPlayerAlive(client))
		{
			if (g_IsInJail[client][0][0])
			{
				CPrintToChat(client, "%s: Vous ne pouvez pas vendre en jail.", "{red}[CSS-RP] ");
			}
			else
			{
				new BuyerIndex = GetClientAimTarget(client, true);
				if (BuyerIndex != -1)
				{
					if (BuyerIndex < 1)
					{
						CPrintToChat(client, "%s: Tu dois viser un joueur.", "{red}[CSS-RP] ");
						return Action:3;
					}
					TransactionWith[client] = BuyerIndex;
					TransactionWith[BuyerIndex] = client;
					new Handle:menu = CreateMenu(Menu_Vente, MenuAction:28);
					SetMenuTitle(menu, "Choisissez l'item a vendre :");
					if (jobid[client][0][0] == 9)
					{
						AddMenuItem(menu, "lsd", "LSD 300€", 0);
						AddMenuItem(menu, "exta", "EXTASY 400€", 0);
						AddMenuItem(menu, "coke", "COKE 500€", 0);
						AddMenuItem(menu, "heroine", "HEROINE 700€", 0);
					}
					else
					{
						if (jobid[client][0][0] == 12)
						{
							AddMenuItem(menu, "level", "levels cut au maximum 1000€", 0);
						}
						if (jobid[client][0][0] == 15)
						{
							AddMenuItem(menu, "props1", "CANAPE 1500€", 0);
							AddMenuItem(menu, "props2", "TABLE 1000€", 0);
						}
						if (jobid[client][0][0] == 18)
						{
							AddMenuItem(menu, "awp", "AWP 2500€", 0);
							AddMenuItem(menu, "m249", "M249 1500€", 0);
							AddMenuItem(menu, "ak47", "AK47 1500€", 0);
							AddMenuItem(menu, "m4a1", "M4A1 1500€", 0);
							AddMenuItem(menu, "sg550", "SG550 1300€", 0);
							AddMenuItem(menu, "sg552", "SG552 1300€", 0);
							AddMenuItem(menu, "galil", "GALIL 1200€", 0);
							AddMenuItem(menu, "aug", "AUG 1000€", 0);
							AddMenuItem(menu, "famas", "FAMAS 900€", 0);
							AddMenuItem(menu, "scout", "SCOUT 700€", 0);
							AddMenuItem(menu, "m3", "M3 700€", 0);
							AddMenuItem(menu, "xm1014", "XM1014 700€", 0);
							AddMenuItem(menu, "mp5", "MP5 600€", 0);
							AddMenuItem(menu, "p90", "P90 600€", 0);
							AddMenuItem(menu, "elite", "ELITES 450€", 0);
							AddMenuItem(menu, "tmp", "TMP 500€", 0);
							AddMenuItem(menu, "ump", "UMP 500€", 0);
							AddMenuItem(menu, "mac10", "MAC10 400€", 0);
							AddMenuItem(menu, "deagle", "DEAGLE 300€", 0);
							AddMenuItem(menu, "glock", "GLOCK 100€", 0);
							AddMenuItem(menu, "usp", "USP 100€", 0);
							AddMenuItem(menu, "kartouche", "CARTOUCHE 150€", 0);
							if (!permisleger[BuyerIndex][0][0])
							{
								AddMenuItem(menu, "permis1", "Permis Leger 1000€", 0);
							}
							if (permislourd[BuyerIndex][0][0])
							{
							}
							else
							{
								AddMenuItem(menu, "permis2", "Permis Lourd 2000€", 0);
							}
						}
						if (jobid[client][0][0] == 21)
						{
							AddMenuItem(menu, "ticketdix", "Ticket 10€", 0);
							AddMenuItem(menu, "ticketcent", "Ticket 100€", 0);
							AddMenuItem(menu, "ticketmille", "Ticket 1000€", 0);
						}
						if (jobid[client][0][0] == 24)
						{
							if (!rib[BuyerIndex][0][0])
							{
								AddMenuItem(menu, "rib", "RIB 1500€", 0);
							}
							if (cb[BuyerIndex][0][0])
							{
							}
							else
							{
								AddMenuItem(menu, "cb", "CB 1500€", 0);
							}
						}
						if (jobid[client][0][0] == 27)
						{
							AddMenuItem(menu, "partiel", "Soin Partiel 100€", 0);
							AddMenuItem(menu, "complet", "Soin Complet 300€", 0);
						}
						if (jobid[client][0][0] == 30)
						{
							AddMenuItem(menu, "tete", "Chirurgie du cerveau 1000€", 0);
							AddMenuItem(menu, "coeur", "Chirurgie du coeur 800€", 0);
							AddMenuItem(menu, "bras", "Chirurgie des bras 600€", 0);
							AddMenuItem(menu, "jambe", "Chirurgie des jambes 400€", 0);
						}
						if (jobid[client][0][0] == 31)
						{
							AddMenuItem(menu, "grenade", "Pack de grenade 1000€", 0);
							AddMenuItem(menu, "kevlar", "Kevlar 600€", 0);
						}
						if (jobid[client][0][0])
						{
						}
						else
						{
							CPrintToChat(client, "%s: Vous n'avez pas de travail.", "{red}[CSS-RP] ");
						}
					}
					DisplayMenu(menu, client, 0);
				}
			}
		}
		CPrintToChat(client, "%s: Vous devez être en vie.", "{red}[CSS-RP] ");
	}
	return Action:0;
}

public Menu_Vente(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new buyer = TransactionWith[client][0][0];
		new String:info[32];
		GetMenuItem(menu, param2, info, 32, 0, "", 0);
		if (StrEqual(info, "usp", true))
		{
			new Handle:menua = CreateMenu(Vente_Usp, MenuAction:28);
			SetMenuTitle(menua, "Voulez-vous achetez un USP à  100€?");
			AddMenuItem(menua, "oui", "Oui je veux", 0);
			AddMenuItem(menua, "non", "Non merci", 0);
			DisplayMenu(menua, buyer, 0);
		}
		else
		{
			if (StrEqual(info, "level", true))
			{
				new Handle:menub = CreateMenu(Vente_Level, MenuAction:28);
				SetMenuTitle(menub, "Voulez-vous achetez des levels cut (100) à  1000€?");
				AddMenuItem(menub, "oui", "Oui je veux", 0);
				AddMenuItem(menub, "non", "Non merci", 0);
				DisplayMenu(menub, buyer, 0);
			}
			if (StrEqual(info, "glock", true))
			{
				new Handle:menuc = CreateMenu(Vente_Glock, MenuAction:28);
				SetMenuTitle(menuc, "Voulez-vous achetez un glock à  100€?");
				AddMenuItem(menuc, "oui", "Oui je veux", 0);
				AddMenuItem(menuc, "non", "Non merci", 0);
				DisplayMenu(menuc, buyer, 0);
			}
			if (StrEqual(info, "deagle", true))
			{
				new Handle:menud = CreateMenu(Vente_Deagle, MenuAction:28);
				SetMenuTitle(menud, "Voulez-vous achetez un Deagle à  300€?");
				AddMenuItem(menud, "oui", "Oui je veux", 0);
				AddMenuItem(menud, "non", "Non merci", 0);
				DisplayMenu(menud, buyer, 0);
			}
			if (StrEqual(info, "kartouche", true))
			{
				new Handle:menue = CreateMenu(Vente_Cartouche, MenuAction:28);
				SetMenuTitle(menue, "Voulez-vous achetez  à  100€?");
				AddMenuItem(menue, "oui", "Oui je veux", 0);
				AddMenuItem(menue, "non", "Non merci", 0);
				DisplayMenu(menue, buyer, 0);
			}
			if (StrEqual(info, "mac10", true))
			{
				new Handle:menuf = CreateMenu(Vente_Mac10, MenuAction:28);
				SetMenuTitle(menuf, "Voulez-vous achetez un Mac10 à  400€?");
				AddMenuItem(menuf, "oui", "Oui je veux", 0);
				AddMenuItem(menuf, "non", "Non merci", 0);
				DisplayMenu(menuf, buyer, 0);
			}
			if (StrEqual(info, "ump", true))
			{
				new Handle:menug = CreateMenu(Vente_Ump, MenuAction:28);
				SetMenuTitle(menug, "Voulez-vous achetez un Ump à  500€?");
				AddMenuItem(menug, "oui", "Oui je veux", 0);
				AddMenuItem(menug, "non", "Non merci", 0);
				DisplayMenu(menug, buyer, 0);
			}
			if (StrEqual(info, "tmp", true))
			{
				new Handle:menuh = CreateMenu(Vente_Tmp, MenuAction:28);
				SetMenuTitle(menuh, "Voulez-vous achetez un Tmp à  500€?");
				AddMenuItem(menuh, "oui", "Oui je veux", 0);
				AddMenuItem(menuh, "non", "Non merci", 0);
				DisplayMenu(menuh, buyer, 0);
			}
			if (StrEqual(info, "elite", true))
			{
				new Handle:menui = CreateMenu(Vente_Elite, MenuAction:28);
				SetMenuTitle(menui, "Voulez-vous achetez des à©lites à  450€?");
				AddMenuItem(menui, "oui", "Oui je veux", 0);
				AddMenuItem(menui, "non", "Non merci", 0);
				DisplayMenu(menui, buyer, 0);
			}
			if (StrEqual(info, "p90", true))
			{
				new Handle:menuj = CreateMenu(Vente_P90, MenuAction:28);
				SetMenuTitle(menuj, "Voulez-vous achetez un P90 à  600€?");
				AddMenuItem(menuj, "oui", "Oui je veux", 0);
				AddMenuItem(menuj, "non", "Non merci", 0);
				DisplayMenu(menuj, buyer, 0);
			}
			if (StrEqual(info, "mp5", true))
			{
				new Handle:menuk = CreateMenu(Vente_Mp5, MenuAction:28);
				SetMenuTitle(menuk, "Voulez-vous achetez un Mp5 à  600€?");
				AddMenuItem(menuk, "oui", "Oui je veux", 0);
				AddMenuItem(menuk, "non", "Non merci", 0);
				DisplayMenu(menuk, buyer, 0);
			}
			if (StrEqual(info, "xm1014", true))
			{
				new Handle:menul = CreateMenu(Vente_Xm1014, MenuAction:28);
				SetMenuTitle(menul, "Voulez-vous achetez un Xm1014 à  700€?");
				AddMenuItem(menul, "oui", "Oui je veux", 0);
				AddMenuItem(menul, "non", "Non merci", 0);
				DisplayMenu(menul, buyer, 0);
			}
			if (StrEqual(info, "m3", true))
			{
				new Handle:menum = CreateMenu(Vente_M3, MenuAction:28);
				SetMenuTitle(menum, "Voulez-vous achetez un M3 à  700€?");
				AddMenuItem(menum, "oui", "Oui je veux", 0);
				AddMenuItem(menum, "non", "Non merci", 0);
				DisplayMenu(menum, buyer, 0);
			}
			if (StrEqual(info, "scout", true))
			{
				new Handle:menun = CreateMenu(Vente_Scout, MenuAction:28);
				SetMenuTitle(menun, "Voulez-vous achetez Scout à  700€?");
				AddMenuItem(menun, "oui", "Oui je veux", 0);
				AddMenuItem(menun, "non", "Non merci", 0);
				DisplayMenu(menun, buyer, 0);
			}
			if (StrEqual(info, "famas", true))
			{
				new Handle:menuo = CreateMenu(Vente_Famas, MenuAction:28);
				SetMenuTitle(menuo, "Voulez-vous achetez un Famas à  900€?");
				AddMenuItem(menuo, "oui", "Oui je veux", 0);
				AddMenuItem(menuo, "non", "Non merci", 0);
				DisplayMenu(menuo, buyer, 0);
			}
			if (StrEqual(info, "aug", true))
			{
				new Handle:menup = CreateMenu(Vente_Aug, MenuAction:28);
				SetMenuTitle(menup, "Voulez-vous achetez un Aug à  1000€?");
				AddMenuItem(menup, "oui", "Oui je veux", 0);
				AddMenuItem(menup, "non", "Non merci", 0);
				DisplayMenu(menup, buyer, 0);
			}
			if (StrEqual(info, "galil", true))
			{
				new Handle:menuq = CreateMenu(Vente_Galil, MenuAction:28);
				SetMenuTitle(menuq, "Voulez-vous achetez un Galil à  1200€?");
				AddMenuItem(menuq, "oui", "Oui je veux", 0);
				AddMenuItem(menuq, "non", "Non merci", 0);
				DisplayMenu(menuq, buyer, 0);
			}
			if (StrEqual(info, "sg550", true))
			{
				new Handle:menur = CreateMenu(Vente_Sg550, MenuAction:28);
				SetMenuTitle(menur, "Voulez-vous achetez un Sg550 à  1300€?");
				AddMenuItem(menur, "oui", "Oui je veux", 0);
				AddMenuItem(menur, "non", "Non merci", 0);
				DisplayMenu(menur, buyer, 0);
			}
			if (StrEqual(info, "sg552", true))
			{
				new Handle:menus = CreateMenu(Vente_Sg552, MenuAction:28);
				SetMenuTitle(menus, "Voulez-vous achetez un Sg552 à  1300€?");
				AddMenuItem(menus, "oui", "Oui je veux", 0);
				AddMenuItem(menus, "non", "Non merci", 0);
				DisplayMenu(menus, buyer, 0);
			}
			if (StrEqual(info, "m4a1", true))
			{
				new Handle:menut = CreateMenu(Vente_M4a1, MenuAction:28);
				SetMenuTitle(menut, "Voulez-vous achetez un M4a1 à  1500€?");
				AddMenuItem(menut, "oui", "Oui je veux", 0);
				AddMenuItem(menut, "non", "Non merci", 0);
				DisplayMenu(menut, buyer, 0);
			}
			if (StrEqual(info, "ak47", true))
			{
				new Handle:menuu = CreateMenu(Vente_Ak47, MenuAction:28);
				SetMenuTitle(menuu, "Voulez-vous achetez un Ak47 à  1500€?");
				AddMenuItem(menuu, "oui", "Oui je veux", 0);
				AddMenuItem(menuu, "non", "Non merci", 0);
				DisplayMenu(menuu, buyer, 0);
			}
			if (StrEqual(info, "m249", true))
			{
				new Handle:menuv = CreateMenu(Vente_M249, MenuAction:28);
				SetMenuTitle(menuv, "Voulez-vous achetez un M249 à  1500€?");
				AddMenuItem(menuv, "oui", "Oui je veux", 0);
				AddMenuItem(menuv, "non", "Non merci", 0);
				DisplayMenu(menuv, buyer, 0);
			}
			if (StrEqual(info, "awp", true))
			{
				new Handle:menuw = CreateMenu(Vente_Awp, MenuAction:28);
				SetMenuTitle(menuw, "Voulez-vous achetez un Awp à  2500€?");
				AddMenuItem(menuw, "oui", "Oui je veux", 0);
				AddMenuItem(menuw, "non", "Non merci", 0);
				DisplayMenu(menuw, buyer, 0);
			}
			if (StrEqual(info, "ticketdix", true))
			{
				new Handle:menuabc = CreateMenu(Vente_Ticket10, MenuAction:28);
				SetMenuTitle(menuabc, "Voulez-vous achetez un ticket à  10€?");
				AddMenuItem(menuabc, "oui", "Oui je veux", 0);
				AddMenuItem(menuabc, "non", "Non merci", 0);
				DisplayMenu(menuabc, buyer, 0);
			}
			if (StrEqual(info, "ticketcent", true))
			{
				new Handle:menuabcd = CreateMenu(Vente_Ticket100, MenuAction:28);
				SetMenuTitle(menuabcd, "Voulez-vous achetez un ticket à  100€?");
				AddMenuItem(menuabcd, "oui", "Oui je veux", 0);
				AddMenuItem(menuabcd, "non", "Non merci", 0);
				DisplayMenu(menuabcd, buyer, 0);
			}
			if (StrEqual(info, "ticketmille", true))
			{
				new Handle:menuabcde = CreateMenu(Vente_Ticket1000, MenuAction:28);
				SetMenuTitle(menuabcde, "Voulez-vous achetez un ticket à  1000€?");
				AddMenuItem(menuabcde, "oui", "Oui je veux", 0);
				AddMenuItem(menuabcde, "non", "Non merci", 0);
				DisplayMenu(menuabcde, buyer, 0);
			}
			if (StrEqual(info, "props1", true))
			{
				new Handle:menuab = CreateMenu(Vente_Usp, MenuAction:28);
				SetMenuTitle(menuab, "Voulez-vous un Canapé à  1500€?");
				AddMenuItem(menuab, "oui", "Oui je veux", 0);
				AddMenuItem(menuab, "non", "Non merci", 0);
				DisplayMenu(menuab, buyer, 0);
			}
			if (StrEqual(info, "props2", true))
			{
				new Handle:menuac = CreateMenu(Vente_Usp, MenuAction:28);
				SetMenuTitle(menuac, "Voulez-vous achetez une Table à  1000€?");
				AddMenuItem(menuac, "oui", "Oui je veux", 0);
				AddMenuItem(menuac, "non", "Non merci", 0);
				DisplayMenu(menuac, buyer, 0);
			}
			if (StrEqual(info, "lsd", true))
			{
				new Handle:menuaf = CreateMenu(Vente_Lsd, MenuAction:28);
				SetMenuTitle(menuaf, "Voulez-vous achetez du Lsd à  300€?");
				AddMenuItem(menuaf, "oui", "Oui je veux", 0);
				AddMenuItem(menuaf, "non", "Non merci", 0);
				DisplayMenu(menuaf, buyer, 0);
			}
			if (StrEqual(info, "exta", true))
			{
				new Handle:menuag = CreateMenu(Vente_Exta, MenuAction:28);
				SetMenuTitle(menuag, "Voulez-vous achetez de l'Extasie à  400€?");
				AddMenuItem(menuag, "oui", "Oui je veux", 0);
				AddMenuItem(menuag, "non", "Non merci", 0);
				DisplayMenu(menuag, buyer, 0);
			}
			if (StrEqual(info, "coke", true))
			{
				new Handle:menuah = CreateMenu(Vente_Coke, MenuAction:28);
				SetMenuTitle(menuah, "Voulez-vous achetez de la Coke à  500€?");
				AddMenuItem(menuah, "oui", "Oui je veux", 0);
				AddMenuItem(menuah, "non", "Non merci", 0);
				DisplayMenu(menuah, buyer, 0);
			}
			if (StrEqual(info, "heroine", true))
			{
				new Handle:menuai = CreateMenu(Vente_Heroine, MenuAction:28);
				SetMenuTitle(menuai, "Voulez-vous achetez une héroine à  700€?");
				AddMenuItem(menuai, "oui", "Oui je veux", 0);
				AddMenuItem(menuai, "non", "Non merci", 0);
				DisplayMenu(menuai, buyer, 0);
			}
			if (StrEqual(info, "rib", true))
			{
				new Handle:menuah = CreateMenu(Vente_Rib, MenuAction:28);
				SetMenuTitle(menuah, "Voulez-vous achetez un Rib à  1500€?");
				AddMenuItem(menuah, "oui", "Oui je veux", 0);
				AddMenuItem(menuah, "non", "Non merci", 0);
				DisplayMenu(menuah, buyer, 0);
			}
			if (StrEqual(info, "cb", true))
			{
				new Handle:menuai = CreateMenu(Vente_Cb, MenuAction:28);
				SetMenuTitle(menuai, "Voulez-vous achetez une Carte Bleue à  1500€?");
				AddMenuItem(menuai, "oui", "Oui je veux", 0);
				AddMenuItem(menuai, "non", "Non merci", 0);
				DisplayMenu(menuai, buyer, 0);
			}
			if (StrEqual(info, "permis1", true))
			{
				new Handle:menuah = CreateMenu(Vente_Permis1, MenuAction:28);
				SetMenuTitle(menuah, "Voulez-vous achetez un Permis leger à  1000€?");
				AddMenuItem(menuah, "oui", "Oui je veux", 0);
				AddMenuItem(menuah, "non", "Non merci", 0);
				DisplayMenu(menuah, buyer, 0);
			}
			if (StrEqual(info, "permis2", true))
			{
				new Handle:menuai = CreateMenu(Vente_Permis2, MenuAction:28);
				SetMenuTitle(menuai, "Voulez-vous achetez un Permis lourd à  2000€?");
				AddMenuItem(menuai, "oui", "Oui je veux", 0);
				AddMenuItem(menuai, "non", "Non merci", 0);
				DisplayMenu(menuai, buyer, 0);
			}
			if (StrEqual(info, "partiel", true))
			{
				new Handle:menuai = CreateMenu(Vente_Partiel, MenuAction:28);
				SetMenuTitle(menuai, "Voulez-vous achetez un Soin partiel à  100€?");
				AddMenuItem(menuai, "oui", "Oui je veux", 0);
				AddMenuItem(menuai, "non", "Non merci", 0);
				DisplayMenu(menuai, buyer, 0);
			}
			if (StrEqual(info, "complet", true))
			{
				new Handle:menuai = CreateMenu(Vente_Complet, MenuAction:28);
				SetMenuTitle(menuai, "Voulez-vous achetez un Soin complet à  300€?");
				AddMenuItem(menuai, "oui", "Oui je veux", 0);
				AddMenuItem(menuai, "non", "Non merci", 0);
				DisplayMenu(menuai, buyer, 0);
			}
			if (StrEqual(info, "tete", true))
			{
				new Handle:menuai = CreateMenu(Vente_Tete, MenuAction:28);
				SetMenuTitle(menuai, "Voulez-vous achetez une Chirurgie de la tête à  1000€?");
				AddMenuItem(menuai, "oui", "Oui je veux", 0);
				AddMenuItem(menuai, "non", "Non merci", 0);
				DisplayMenu(menuai, buyer, 0);
			}
			if (StrEqual(info, "coeur", true))
			{
				new Handle:menuai = CreateMenu(Vente_Coeur, MenuAction:28);
				SetMenuTitle(menuai, "Voulez-vous achetez une Chirurgie coeur à  800€?");
				AddMenuItem(menuai, "oui", "Oui je veux", 0);
				AddMenuItem(menuai, "non", "Non merci", 0);
				DisplayMenu(menuai, buyer, 0);
			}
			if (StrEqual(info, "bras", true))
			{
				new Handle:menuai = CreateMenu(Vente_Bras, MenuAction:28);
				SetMenuTitle(menuai, "Voulez-vous achetez une Chirurgie des bras à  600€?");
				AddMenuItem(menuai, "oui", "Oui je veux", 0);
				AddMenuItem(menuai, "non", "Non merci", 0);
				DisplayMenu(menuai, buyer, 0);
			}
			if (StrEqual(info, "jambe", true))
			{
				new Handle:menuai = CreateMenu(Vente_Jambe, MenuAction:28);
				SetMenuTitle(menuai, "Voulez-vous achetez une Chirurgie des jambes à  400€?");
				AddMenuItem(menuai, "oui", "Oui je veux", 0);
				AddMenuItem(menuai, "non", "Non merci", 0);
				DisplayMenu(menuai, buyer, 0);
			}
			if (StrEqual(info, "grenade", true))
			{
				new Handle:menuai = CreateMenu(Vente_Grenade, MenuAction:28);
				SetMenuTitle(menuai, "Voulez-vous achetez un Pack de grenade 1000€?");
				AddMenuItem(menuai, "oui", "Oui je veux", 0);
				AddMenuItem(menuai, "non", "Non merci", 0);
				DisplayMenu(menuai, buyer, 0);
			}
			if (StrEqual(info, "kevlar", true))
			{
				new Handle:menuai = CreateMenu(Vente_Kevlar, MenuAction:28);
				SetMenuTitle(menuai, "Voulez-vous achetez un Gilet pare-balle à  600€?");
				AddMenuItem(menuai, "oui", "Oui je veux", 0);
				AddMenuItem(menuai, "non", "Non merci", 0);
				DisplayMenu(menuai, buyer, 0);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public Vente_Grenade(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[32];
		GetMenuItem(menu, param2, info, 32, 0, "", 0);
		new MoneyOffset = FindSendPropOffs("CCSPlayer", "m_iAccount");
		if (StrEqual(info, "oui", true))
		{
			if (money[client][0][0] >= 1000)
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
				CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
				money[client] = money[client][0][0][-250];
				AdCash(TransactionWith[client][0][0], 500);
				var1 = var1[0][0][0];
				capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][125];
				SetEntData(client, MoneyOffset, money[client][0][0], 4, true);
			}
			else
			{
				if (cb[client][0][0] == 1)
				{
					if (bank[client][0][0] >= 1000)
					{
						CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
						CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
						bank[client] = bank[client][0][0][-250];
						AdCash(TransactionWith[client][0][0], 500);
						var2 = var2[0][0][0];
						capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][125];
					}
					else
					{
						CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
						CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
					}
				}
				CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
				CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
			}
		}
		else
		{
			if (StrEqual(info, "non", true))
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a refusé.", "{red}[CSS-RP] ", client);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public Vente_Kevlar(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[32];
		GetMenuItem(menu, param2, info, 32, 0, "", 0);
		new MoneyOffset = FindSendPropOffs("CCSPlayer", "m_iAccount");
		if (StrEqual(info, "oui", true))
		{
			if (money[client][0][0] >= 600)
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
				CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
				money[client] = money[client][0][0][-150];
				AdCash(TransactionWith[client][0][0], 300);
				var1 = var1[0][0][0];
				capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][75];
				SetEntData(client, MoneyOffset, money[client][0][0], 4, true);
			}
			else
			{
				if (cb[client][0][0] == 1)
				{
					if (bank[client][0][0] >= 600)
					{
						CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
						CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
						bank[client] = bank[client][0][0][-150];
						AdCash(TransactionWith[client][0][0], 300);
						var2 = var2[0][0][0];
						capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][125];
					}
					else
					{
						CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
						CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
					}
				}
				CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
				CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
			}
		}
		else
		{
			if (StrEqual(info, "non", true))
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a refusé.", "{red}[CSS-RP] ", client);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public Vente_Partiel(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[32];
		GetMenuItem(menu, param2, info, 32, 0, "", 0);
		new MoneyOffset = FindSendPropOffs("CCSPlayer", "m_iAccount");
		new health;
		if (StrEqual(info, "oui", true))
		{
			if (money[client][0][0] >= 100)
			{
				health = GetClientHealth(client);
				if (GetClientTeam(client) == 2)
				{
					if (health < 100)
					{
						CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
						CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
						money[client] = money[client][0][0][-25];
						AdCash(TransactionWith[client][0][0], 100);
						SetEntityHealth(client, health + 50);
						capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][12];
						SetEntData(client, MoneyOffset, money[client][0][0], 4, true);
					}
					else
					{
						CPrintToChat(client, "%s: Vous avez déjà  votre vie.", "{red}[CSS-RP] ");
					}
				}
				else
				{
					if (GetClientTeam(client) == 3)
					{
						if (health < 500)
						{
							CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
							CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
							money[client] = money[client][0][0][-25];
							AdCash(TransactionWith[client][0][0], 100);
							SetEntityHealth(client, health + 50);
							capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][12];
							SetEntData(client, MoneyOffset, money[client][0][0], 4, true);
						}
						CPrintToChat(client, "%s: Vous avez déjà  votre vie.", "{red}[CSS-RP] ");
					}
				}
			}
			else
			{
				if (cb[client][0][0] == 1)
				{
					if (bank[client][0][0] >= 100)
					{
						health = GetClientHealth(client);
						if (GetClientTeam(client) == 2)
						{
							if (health < 100)
							{
								CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
								CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
								money[client] = money[client][0][0][-25];
								AdCash(TransactionWith[client][0][0], 100);
								SetEntityHealth(client, health + 50);
								capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][12];
								SetEntData(client, MoneyOffset, money[client][0][0], 4, true);
							}
							else
							{
								CPrintToChat(client, "%s: Vous avez déjà  votre vie.", "{red}[CSS-RP] ");
							}
						}
						else
						{
							if (GetClientTeam(client) == 3)
							{
								if (health < 500)
								{
									CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
									CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
									money[client] = money[client][0][0][-25];
									AdCash(TransactionWith[client][0][0], 100);
									SetEntityHealth(client, health + 50);
									capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][12];
									SetEntData(client, MoneyOffset, money[client][0][0], 4, true);
								}
								CPrintToChat(client, "%s: Vous avez déjà  votre vie.", "{red}[CSS-RP] ");
							}
						}
					}
					else
					{
						CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
						CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
					}
				}
				CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
				CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
			}
		}
		else
		{
			if (StrEqual(info, "non", true))
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a refusé.", "{red}[CSS-RP] ", client);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public Vente_Complet(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[32];
		GetMenuItem(menu, param2, info, 32, 0, "", 0);
		new MoneyOffset = FindSendPropOffs("CCSPlayer", "m_iAccount");
		new health;
		if (StrEqual(info, "oui", true))
		{
			if (money[client][0][0] >= 300)
			{
				health = GetClientHealth(client);
				if (GetClientTeam(client) == 2)
				{
					if (health < 100)
					{
						CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
						CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
						money[client] = money[client][0][0][-75];
						AdCash(TransactionWith[client][0][0], 300);
						SetEntityHealth(client, health + 100);
						capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][37];
						SetEntData(client, MoneyOffset, money[client][0][0], 4, true);
					}
					else
					{
						CPrintToChat(client, "%s: Vous avez déjà  votre vie.", "{red}[CSS-RP] ");
					}
				}
				else
				{
					if (GetClientTeam(client) == 3)
					{
						if (health < 500)
						{
							CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
							CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
							money[client] = money[client][0][0][-75];
							AdCash(TransactionWith[client][0][0], 300);
							SetEntityHealth(client, health + 100);
							capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][37];
							SetEntData(client, MoneyOffset, money[client][0][0], 4, true);
						}
						CPrintToChat(client, "%s: Vous avez déjà  votre vie.", "{red}[CSS-RP] ");
					}
				}
			}
			else
			{
				if (cb[client][0][0] == 1)
				{
					if (bank[client][0][0] >= 100)
					{
						health = GetClientHealth(client);
						if (GetClientTeam(client) == 2)
						{
							if (health < 100)
							{
								CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
								CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
								money[client] = money[client][0][0][-75];
								AdCash(TransactionWith[client][0][0], 300);
								SetEntityHealth(client, health + 100);
								capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][37];
								SetEntData(client, MoneyOffset, money[client][0][0], 4, true);
							}
							else
							{
								CPrintToChat(client, "%s: Vous avez déjà  votre vie.", "{red}[CSS-RP] ");
							}
						}
						else
						{
							if (GetClientTeam(client) == 3)
							{
								if (health < 500)
								{
									CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
									CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
									money[client] = money[client][0][0][-75];
									AdCash(TransactionWith[client][0][0], 300);
									SetEntityHealth(client, health + 100);
									capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][37];
									SetEntData(client, MoneyOffset, money[client][0][0], 4, true);
								}
								CPrintToChat(client, "%s: Vous avez déjà  votre vie.", "{red}[CSS-RP] ");
							}
						}
					}
					else
					{
						CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
						CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
					}
				}
				CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
				CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
			}
		}
		else
		{
			if (StrEqual(info, "non", true))
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a refusé.", "{red}[CSS-RP] ", client);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public Vente_Tete(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[32];
		GetMenuItem(menu, param2, info, 32, 0, "", 0);
		new MoneyOffset = FindSendPropOffs("CCSPlayer", "m_iAccount");
		if (StrEqual(info, "oui", true))
		{
			if (money[client][0][0] >= 1000)
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
				CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
				money[client] = money[client][0][0][-250];
				AdCash(TransactionWith[client][0][0], 500);
				SetEntityGravity(client, 0.5);
				ClientCommand(client, "r_screenoverlay effects/tp_eyefx/tp_eyefx.vmt");
				if (!g_chirurgie[client][0][0])
				{
					CreateTimer(10, StopEffect, client, 0);
				}
				g_chirurgie[client] = 1;
				capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][125];
				SetEntData(client, MoneyOffset, money[client][0][0], 4, true);
			}
			else
			{
				if (cb[client][0][0] == 1)
				{
					if (bank[client][0][0] >= 1000)
					{
						CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
						CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
						money[client] = money[client][0][0][-250];
						AdCash(TransactionWith[client][0][0], 500);
						SetEntityGravity(client, 0.5);
						ClientCommand(client, "r_screenoverlay effects/tp_eyefx/tp_eyefx.vmt");
						g_chirurgie[client] = 1;
						if (!g_chirurgie[client][0][0])
						{
							CreateTimer(10, StopEffect, client, 0);
						}
						capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][125];
						SetEntData(client, MoneyOffset, money[client][0][0], 4, true);
					}
					else
					{
						CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
						CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
					}
				}
				CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
				CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
			}
		}
		else
		{
			if (StrEqual(info, "non", true))
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a refusé.", "{red}[CSS-RP] ", client);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public Vente_Coeur(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[32];
		GetMenuItem(menu, param2, info, 32, 0, "", 0);
		new MoneyOffset = FindSendPropOffs("CCSPlayer", "m_iAccount");
		new health;
		if (StrEqual(info, "oui", true))
		{
			if (money[client][0][0] >= 800)
			{
				health = GetClientHealth(client);
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
				CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
				money[client] = money[client][0][0][-200];
				AdCash(TransactionWith[client][0][0], 400);
				SetEntityHealth(client, health + 300);
				g_chirurgie[client] = 1;
				ClientCommand(client, "r_screenoverlay effects/tp_eyefx/tp_eyefx.vmt");
				if (!g_chirurgie[client][0][0])
				{
					CreateTimer(10, StopEffect, client, 0);
				}
				capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][100];
				SetEntData(client, MoneyOffset, money[client][0][0], 4, true);
			}
			else
			{
				if (cb[client][0][0] == 1)
				{
					if (bank[client][0][0] >= 800)
					{
						health = GetClientHealth(client);
						CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
						CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
						money[client] = money[client][0][0][-200];
						AdCash(TransactionWith[client][0][0], 400);
						SetEntityHealth(client, health + 300);
						ClientCommand(client, "r_screenoverlay effects/tp_eyefx/tp_eyefx.vmt");
						g_chirurgie[client] = 1;
						if (!g_chirurgie[client][0][0])
						{
							CreateTimer(10, StopEffect, client, 0);
						}
						capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][100];
						SetEntData(client, MoneyOffset, money[client][0][0], 4, true);
					}
					else
					{
						CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
						CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
					}
				}
				CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
				CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
			}
		}
		else
		{
			if (StrEqual(info, "non", true))
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a refusé.", "{red}[CSS-RP] ", client);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public Vente_Bras(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[32];
		GetMenuItem(menu, param2, info, 32, 0, "", 0);
		new MoneyOffset = FindSendPropOffs("CCSPlayer", "m_iAccount");
		if (StrEqual(info, "oui", true))
		{
			if (money[client][0][0] >= 600)
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
				CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
				money[client] = money[client][0][0][-150];
				AdCash(TransactionWith[client][0][0], 300);
				SetEntProp(client, PropType:0, "m_ArmorValue", any:100, 1, 0);
				g_chirurgie[client] = 1;
				ClientCommand(client, "r_screenoverlay effects/tp_eyefx/tp_eyefx.vmt");
				if (!g_chirurgie[client][0][0])
				{
					CreateTimer(10, StopEffect, client, 0);
				}
				capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][75];
				SetEntData(client, MoneyOffset, money[client][0][0], 4, true);
			}
			else
			{
				if (cb[client][0][0] == 1)
				{
					if (bank[client][0][0] >= 600)
					{
						CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
						CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
						money[client] = money[client][0][0][-150];
						AdCash(TransactionWith[client][0][0], 300);
						SetEntProp(client, PropType:0, "m_ArmorValue", any:100, 1, 0);
						g_chirurgie[client] = 1;
						ClientCommand(client, "r_screenoverlay effects/tp_eyefx/tp_eyefx.vmt");
						if (!g_chirurgie[client][0][0])
						{
							CreateTimer(10, StopEffect, client, 0);
						}
						capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][75];
						SetEntData(client, MoneyOffset, money[client][0][0], 4, true);
					}
					else
					{
						CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
						CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
					}
				}
				CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
				CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
			}
		}
		else
		{
			if (StrEqual(info, "non", true))
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a refusé.", "{red}[CSS-RP] ", client);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public Vente_Jambe(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[32];
		GetMenuItem(menu, param2, info, 32, 0, "", 0);
		new MoneyOffset = FindSendPropOffs("CCSPlayer", "m_iAccount");
		if (StrEqual(info, "oui", true))
		{
			if (money[client][0][0] >= 400)
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
				CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
				money[client] = money[client][0][0][-100];
				AdCash(TransactionWith[client][0][0], 200);
				SetEntPropFloat(client, PropType:1, "m_flLaggedMovementValue", 1.6, 0);
				g_chirurgie[client] = 1;
				capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][50];
				ClientCommand(client, "r_screenoverlay effects/tp_eyefx/tp_eyefx.vmt");
				if (!g_chirurgie[client][0][0])
				{
					CreateTimer(10, StopEffect, client, 0);
				}
				SetEntData(client, MoneyOffset, money[client][0][0], 4, true);
			}
			else
			{
				if (cb[client][0][0] == 1)
				{
					if (bank[client][0][0] >= 400)
					{
						CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
						CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
						money[client] = money[client][0][0][-100];
						AdCash(TransactionWith[client][0][0], 200);
						SetEntPropFloat(client, PropType:1, "m_flLaggedMovementValue", 1.6, 0);
						ClientCommand(client, "r_screenoverlay effects/tp_eyefx/tp_eyefx.vmt");
						g_chirurgie[client] = 1;
						if (!g_chirurgie[client][0][0])
						{
							CreateTimer(10, StopEffect, client, 0);
						}
						capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][50];
						SetEntData(client, MoneyOffset, money[client][0][0], 4, true);
					}
					else
					{
						CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
						CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
					}
				}
				CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
				CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
			}
		}
		else
		{
			if (StrEqual(info, "non", true))
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a refusé.", "{red}[CSS-RP] ", client);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public Vente_Usp(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[32];
		GetMenuItem(menu, param2, info, 32, 0, "", 0);
		new MoneyOffset = FindSendPropOffs("CCSPlayer", "m_iAccount");
		if (StrEqual(info, "oui", true))
		{
			if (money[client][0][0] >= 100)
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
				CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
				money[client] = money[client][0][0][-25];
				AdCash(TransactionWith[client][0][0], 100);
				var1 = var1[0][0][0];
				capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][12];
				SetEntData(client, MoneyOffset, money[client][0][0], 4, true);
			}
			else
			{
				if (cb[client][0][0] == 1)
				{
					if (bank[client][0][0] >= 100)
					{
						CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
						CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
						bank[client] = bank[client][0][0][-25];
						AdCash(TransactionWith[client][0][0], 100);
						var2 = var2[0][0][0];
						capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][12];
					}
					else
					{
						CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
						CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
					}
				}
				CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
				CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
			}
		}
		else
		{
			if (StrEqual(info, "non", true))
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a refusé.", "{red}[CSS-RP] ", client);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public Vente_Glock(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[32];
		GetMenuItem(menu, param2, info, 32, 0, "", 0);
		new MoneyOffset = FindSendPropOffs("CCSPlayer", "m_iAccount");
		if (StrEqual(info, "oui", true))
		{
			if (money[client][0][0] >= 100)
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
				CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
				money[client] = money[client][0][0][-25];
				AdCash(TransactionWith[client][0][0], 100);
				var1 = var1[0][0][0];
				capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][12];
				SetEntData(client, MoneyOffset, money[client][0][0], 4, true);
			}
			else
			{
				if (cb[client][0][0] == 1)
				{
					if (bank[client][0][0] >= 100)
					{
						CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
						CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
						bank[client] = bank[client][0][0][-25];
						AdCash(TransactionWith[client][0][0], 100);
						var2 = var2[0][0][0];
						capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][12];
					}
					else
					{
						CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
						CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
					}
				}
				CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
				CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
			}
		}
		else
		{
			if (StrEqual(info, "non", true))
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a refusé.", "{red}[CSS-RP] ", client);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public Vente_Level(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[32];
		GetMenuItem(menu, param2, info, 32, 0, "", 0);
		new MoneyOffset = FindSendPropOffs("CCSPlayer", "m_iAccount");
		if (StrEqual(info, "oui", true))
		{
			if (money[client][0][0] >= 1000)
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
				CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
				money[client] = money[client][0][0][-250];
				AdCash(TransactionWith[client][0][0], 1000);
				levelcut[client] = 100;
				capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][125];
				SetEntData(client, MoneyOffset, money[client][0][0], 4, true);
			}
			else
			{
				if (cb[client][0][0] == 1)
				{
					if (bank[client][0][0] >= 1000)
					{
						CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
						CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
						bank[client] = bank[client][0][0][-250];
						AdCash(TransactionWith[client][0][0], 1000);
						levelcut[client] = 100;
						capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][125];
					}
					else
					{
						CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
						CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
					}
				}
				CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
				CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
			}
		}
		else
		{
			if (StrEqual(info, "non", true))
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a refusé.", "{red}[CSS-RP] ", client);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public Vente_Deagle(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[32];
		GetMenuItem(menu, param2, info, 32, 0, "", 0);
		new MoneyOffset = FindSendPropOffs("CCSPlayer", "m_iAccount");
		if (StrEqual(info, "oui", true))
		{
			if (money[client][0][0] >= 300)
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
				CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
				money[client] = money[client][0][0][-75];
				AdCash(TransactionWith[client][0][0], 300);
				var1 = var1[0][0][0];
				capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][37];
				SetEntData(client, MoneyOffset, money[client][0][0], 4, true);
			}
			else
			{
				if (cb[client][0][0] == 1)
				{
					if (bank[client][0][0] >= 300)
					{
						CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
						CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
						bank[client] = bank[client][0][0][-75];
						AdCash(TransactionWith[client][0][0], 300);
						var2 = var2[0][0][0];
						capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][37];
					}
					else
					{
						CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
						CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
					}
				}
				CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
				CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
			}
		}
		else
		{
			if (StrEqual(info, "non", true))
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a refusé.", "{red}[CSS-RP] ", client);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public Vente_Cartouche(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[32];
		GetMenuItem(menu, param2, info, 32, 0, "", 0);
		new MoneyOffset = FindSendPropOffs("CCSPlayer", "m_iAccount");
		if (StrEqual(info, "oui", true))
		{
			if (money[client][0][0] >= 100)
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
				CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
				money[client] = money[client][0][0][-25];
				AdCash(TransactionWith[client][0][0], 100);
				var1 = var1[0][0][0];
				capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][12];
				SetEntData(client, MoneyOffset, money[client][0][0], 4, true);
			}
			else
			{
				if (cb[client][0][0] == 1)
				{
					if (bank[client][0][0] >= 100)
					{
						CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
						CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
						bank[client] = bank[client][0][0][-25];
						AdCash(TransactionWith[client][0][0], 100);
						var2 = var2[0][0][0];
						capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][12];
					}
					else
					{
						CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
						CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
					}
				}
				CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
				CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
			}
		}
		else
		{
			if (StrEqual(info, "non", true))
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a refusé.", "{red}[CSS-RP] ", client);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public Vente_Mac10(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[32];
		GetMenuItem(menu, param2, info, 32, 0, "", 0);
		new MoneyOffset = FindSendPropOffs("CCSPlayer", "m_iAccount");
		if (StrEqual(info, "oui", true))
		{
			if (money[client][0][0] >= 400)
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
				CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
				money[client] = money[client][0][0][-100];
				AdCash(TransactionWith[client][0][0], 400);
				var1 = var1[0][0][0];
				capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][50];
				SetEntData(client, MoneyOffset, money[client][0][0], 4, true);
			}
			else
			{
				if (cb[client][0][0] == 1)
				{
					if (bank[client][0][0] >= 400)
					{
						CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
						CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
						bank[client] = bank[client][0][0][-100];
						AdCash(TransactionWith[client][0][0], 400);
						var2 = var2[0][0][0];
						capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][50];
					}
					else
					{
						CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
						CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
					}
				}
				CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
				CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
			}
		}
		else
		{
			if (StrEqual(info, "non", true))
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a refusé.", "{red}[CSS-RP] ", client);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public Vente_Ump(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[32];
		GetMenuItem(menu, param2, info, 32, 0, "", 0);
		new MoneyOffset = FindSendPropOffs("CCSPlayer", "m_iAccount");
		if (StrEqual(info, "oui", true))
		{
			if (money[client][0][0] >= 500)
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
				CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
				money[client] = money[client][0][0][-125];
				AdCash(TransactionWith[client][0][0], 500);
				var1 = var1[0][0][0];
				capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][62];
				SetEntData(client, MoneyOffset, money[client][0][0], 4, true);
			}
			else
			{
				if (cb[client][0][0] == 1)
				{
					if (bank[client][0][0] >= 500)
					{
						CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
						CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
						bank[client] = bank[client][0][0][-125];
						AdCash(TransactionWith[client][0][0], 500);
						var2 = var2[0][0][0];
						capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][62];
					}
					else
					{
						CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
						CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
					}
				}
				CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
				CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
			}
		}
		else
		{
			if (StrEqual(info, "non", true))
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a refusé.", "{red}[CSS-RP] ", client);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public Vente_Tmp(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[32];
		GetMenuItem(menu, param2, info, 32, 0, "", 0);
		new MoneyOffset = FindSendPropOffs("CCSPlayer", "m_iAccount");
		if (StrEqual(info, "oui", true))
		{
			if (money[client][0][0] >= 500)
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
				CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
				money[client] = money[client][0][0][-125];
				AdCash(TransactionWith[client][0][0], 500);
				var1 = var1[0][0][0];
				capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][62];
				SetEntData(client, MoneyOffset, money[client][0][0], 4, true);
			}
			else
			{
				if (cb[client][0][0] == 1)
				{
					if (bank[client][0][0] >= 500)
					{
						CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
						CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
						bank[client] = bank[client][0][0][-125];
						AdCash(TransactionWith[client][0][0], 500);
						var2 = var2[0][0][0];
						capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][62];
					}
					else
					{
						CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
						CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
					}
				}
				CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
				CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
			}
		}
		else
		{
			if (StrEqual(info, "non", true))
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a refusé.", "{red}[CSS-RP] ", client);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public Vente_Elite(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[32];
		GetMenuItem(menu, param2, info, 32, 0, "", 0);
		new MoneyOffset = FindSendPropOffs("CCSPlayer", "m_iAccount");
		if (StrEqual(info, "oui", true))
		{
			if (money[client][0][0] >= 450)
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
				CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
				money[client] = money[client][0][0][-112];
				AdCash(TransactionWith[client][0][0], 450);
				var1 = var1[0][0][0];
				capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][56];
				SetEntData(client, MoneyOffset, money[client][0][0], 4, true);
			}
			else
			{
				if (cb[client][0][0] == 1)
				{
					if (bank[client][0][0] >= 450)
					{
						CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
						CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
						bank[client] = bank[client][0][0][-112];
						AdCash(TransactionWith[client][0][0], 450);
						var2 = var2[0][0][0];
						capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][56];
					}
					else
					{
						CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
						CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
					}
				}
				CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
				CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
			}
		}
		else
		{
			if (StrEqual(info, "non", true))
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a refusé.", "{red}[CSS-RP] ", client);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public Vente_P90(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[32];
		GetMenuItem(menu, param2, info, 32, 0, "", 0);
		new MoneyOffset = FindSendPropOffs("CCSPlayer", "m_iAccount");
		if (StrEqual(info, "oui", true))
		{
			if (money[client][0][0] >= 600)
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
				CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
				money[client] = money[client][0][0][-150];
				AdCash(TransactionWith[client][0][0], 600);
				var1 = var1[0][0][0];
				capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][75];
				SetEntData(client, MoneyOffset, money[client][0][0], 4, true);
			}
			else
			{
				if (cb[client][0][0] == 1)
				{
					if (bank[client][0][0] >= 600)
					{
						CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
						CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
						bank[client] = bank[client][0][0][-150];
						AdCash(TransactionWith[client][0][0], 600);
						var2 = var2[0][0][0];
						capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][75];
					}
					else
					{
						CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
						CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
					}
				}
				CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
				CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
			}
		}
		else
		{
			if (StrEqual(info, "non", true))
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a refusé.", "{red}[CSS-RP] ", client);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public Vente_Mp5(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[32];
		GetMenuItem(menu, param2, info, 32, 0, "", 0);
		new MoneyOffset = FindSendPropOffs("CCSPlayer", "m_iAccount");
		if (StrEqual(info, "oui", true))
		{
			if (money[client][0][0] >= 600)
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
				CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
				money[client] = money[client][0][0][-150];
				AdCash(TransactionWith[client][0][0], 600);
				var1 = var1[0][0][0];
				capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][75];
				SetEntData(client, MoneyOffset, money[client][0][0], 4, true);
			}
			else
			{
				if (cb[client][0][0] == 1)
				{
					if (bank[client][0][0] >= 600)
					{
						CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
						CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
						bank[client] = bank[client][0][0][-150];
						AdCash(TransactionWith[client][0][0], 600);
						var2 = var2[0][0][0];
						capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][75];
					}
					else
					{
						CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
						CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
					}
				}
				CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
				CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
			}
		}
		else
		{
			if (StrEqual(info, "non", true))
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a refusé.", "{red}[CSS-RP] ", client);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public Vente_Xm1014(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[32];
		GetMenuItem(menu, param2, info, 32, 0, "", 0);
		new MoneyOffset = FindSendPropOffs("CCSPlayer", "m_iAccount");
		if (StrEqual(info, "oui", true))
		{
			if (money[client][0][0] >= 700)
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
				CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
				money[client] = money[client][0][0][-175];
				AdCash(TransactionWith[client][0][0], 700);
				var1 = var1[0][0][0];
				capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][87];
				SetEntData(client, MoneyOffset, money[client][0][0], 4, true);
			}
			else
			{
				if (cb[client][0][0] == 1)
				{
					if (bank[client][0][0] >= 700)
					{
						CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
						CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
						bank[client] = bank[client][0][0][-175];
						AdCash(TransactionWith[client][0][0], 700);
						var2 = var2[0][0][0];
						capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][87];
					}
					else
					{
						CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
						CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
					}
				}
				CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
				CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
			}
		}
		else
		{
			if (StrEqual(info, "non", true))
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a refusé.", "{red}[CSS-RP] ", client);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public Vente_M3(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[32];
		GetMenuItem(menu, param2, info, 32, 0, "", 0);
		new MoneyOffset = FindSendPropOffs("CCSPlayer", "m_iAccount");
		if (StrEqual(info, "oui", true))
		{
			if (money[client][0][0] >= 700)
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
				CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
				money[client] = money[client][0][0][-175];
				AdCash(TransactionWith[client][0][0], 700);
				var1 = var1[0][0][0];
				capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][87];
				SetEntData(client, MoneyOffset, money[client][0][0], 4, true);
			}
			else
			{
				if (cb[client][0][0] == 1)
				{
					if (bank[client][0][0] >= 700)
					{
						CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
						CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
						bank[client] = bank[client][0][0][-175];
						AdCash(TransactionWith[client][0][0], 700);
						var2 = var2[0][0][0];
						capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][87];
					}
					else
					{
						CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
						CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
					}
				}
				CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
				CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
			}
		}
		else
		{
			if (StrEqual(info, "non", true))
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a refusé.", "{red}[CSS-RP] ", client);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public Vente_Scout(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[32];
		GetMenuItem(menu, param2, info, 32, 0, "", 0);
		new MoneyOffset = FindSendPropOffs("CCSPlayer", "m_iAccount");
		if (StrEqual(info, "oui", true))
		{
			if (money[client][0][0] >= 700)
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
				CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
				money[client] = money[client][0][0][-175];
				AdCash(TransactionWith[client][0][0], 700);
				var1 = var1[0][0][0];
				capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][87];
				SetEntData(client, MoneyOffset, money[client][0][0], 4, true);
			}
			else
			{
				if (cb[client][0][0] == 1)
				{
					if (bank[client][0][0] >= 700)
					{
						CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
						CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
						bank[client] = bank[client][0][0][-175];
						AdCash(TransactionWith[client][0][0], 700);
						var2 = var2[0][0][0];
						capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][87];
					}
					else
					{
						CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
						CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
					}
				}
				CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
				CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
			}
		}
		else
		{
			if (StrEqual(info, "non", true))
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a refusé.", "{red}[CSS-RP] ", client);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public Vente_Aug(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[32];
		GetMenuItem(menu, param2, info, 32, 0, "", 0);
		new MoneyOffset = FindSendPropOffs("CCSPlayer", "m_iAccount");
		if (StrEqual(info, "oui", true))
		{
			if (money[client][0][0] >= 1000)
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
				CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
				money[client] = money[client][0][0][-250];
				AdCash(TransactionWith[client][0][0], 1000);
				var1 = var1[0][0][0];
				capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][125];
				SetEntData(client, MoneyOffset, money[client][0][0], 4, true);
			}
			else
			{
				if (cb[client][0][0] == 1)
				{
					if (bank[client][0][0] >= 1000)
					{
						CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
						CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
						bank[client] = bank[client][0][0][-250];
						AdCash(TransactionWith[client][0][0], 1000);
						var2 = var2[0][0][0];
						capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][125];
					}
					else
					{
						CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
						CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
					}
				}
				CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
				CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
			}
		}
		else
		{
			if (StrEqual(info, "non", true))
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a refusé.", "{red}[CSS-RP] ", client);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public Vente_Famas(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[32];
		GetMenuItem(menu, param2, info, 32, 0, "", 0);
		new MoneyOffset = FindSendPropOffs("CCSPlayer", "m_iAccount");
		if (StrEqual(info, "oui", true))
		{
			if (money[client][0][0] >= 900)
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
				CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
				money[client] = money[client][0][0][-225];
				AdCash(TransactionWith[client][0][0], 900);
				var1 = var1[0][0][0];
				capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][112];
				SetEntData(client, MoneyOffset, money[client][0][0], 4, true);
			}
			else
			{
				if (cb[client][0][0] == 1)
				{
					if (bank[client][0][0] >= 900)
					{
						CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
						CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
						bank[client] = bank[client][0][0][-225];
						AdCash(TransactionWith[client][0][0], 900);
						var2 = var2[0][0][0];
						capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][112];
					}
					else
					{
						CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
						CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
					}
				}
				CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
				CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
			}
		}
		else
		{
			if (StrEqual(info, "non", true))
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a refusé.", "{red}[CSS-RP] ", client);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public Vente_Galil(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[32];
		GetMenuItem(menu, param2, info, 32, 0, "", 0);
		new MoneyOffset = FindSendPropOffs("CCSPlayer", "m_iAccount");
		if (StrEqual(info, "oui", true))
		{
			if (money[client][0][0] >= 1200)
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
				CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
				money[client] = money[client][0][0][-300];
				AdCash(TransactionWith[client][0][0], 1200);
				var1 = var1[0][0][0];
				capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][150];
				SetEntData(client, MoneyOffset, money[client][0][0], 4, true);
			}
			else
			{
				if (cb[client][0][0] == 1)
				{
					if (bank[client][0][0] >= 1200)
					{
						CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
						CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
						bank[client] = bank[client][0][0][-300];
						AdCash(TransactionWith[client][0][0], 1200);
						var2 = var2[0][0][0];
						capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][150];
					}
					else
					{
						CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
						CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
					}
				}
				CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
				CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
			}
		}
		else
		{
			if (StrEqual(info, "non", true))
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a refusé.", "{red}[CSS-RP] ", client);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public Vente_Sg550(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[32];
		GetMenuItem(menu, param2, info, 32, 0, "", 0);
		new MoneyOffset = FindSendPropOffs("CCSPlayer", "m_iAccount");
		if (StrEqual(info, "oui", true))
		{
			if (money[client][0][0] >= 1300)
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
				CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
				money[client] = money[client][0][0][-325];
				AdCash(TransactionWith[client][0][0], 1300);
				var1 = var1[0][0][0];
				capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][162];
				SetEntData(client, MoneyOffset, money[client][0][0], 4, true);
			}
			else
			{
				if (cb[client][0][0] == 1)
				{
					if (bank[client][0][0] >= 1300)
					{
						CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
						CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
						bank[client] = bank[client][0][0][-325];
						AdCash(TransactionWith[client][0][0], 1300);
						var2 = var2[0][0][0];
						capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][162];
					}
					else
					{
						CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
						CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
					}
				}
				CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
				CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
			}
		}
		else
		{
			if (StrEqual(info, "non", true))
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a refusé.", "{red}[CSS-RP] ", client);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public Vente_Sg552(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[32];
		GetMenuItem(menu, param2, info, 32, 0, "", 0);
		new MoneyOffset = FindSendPropOffs("CCSPlayer", "m_iAccount");
		if (StrEqual(info, "oui", true))
		{
			if (money[client][0][0] >= 1300)
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
				CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
				money[client] = money[client][0][0][-325];
				AdCash(TransactionWith[client][0][0], 1300);
				var1 = var1[0][0][0];
				capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][162];
				SetEntData(client, MoneyOffset, money[client][0][0], 4, true);
			}
			else
			{
				if (cb[client][0][0] == 1)
				{
					if (bank[client][0][0] >= 1300)
					{
						CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
						CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
						bank[client] = bank[client][0][0][-325];
						AdCash(TransactionWith[client][0][0], 1300);
						var2 = var2[0][0][0];
						capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][162];
					}
					else
					{
						CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
						CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
					}
				}
				CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
				CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
			}
		}
		else
		{
			if (StrEqual(info, "non", true))
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a refusé.", "{red}[CSS-RP] ", client);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public Vente_M4a1(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[32];
		GetMenuItem(menu, param2, info, 32, 0, "", 0);
		new MoneyOffset = FindSendPropOffs("CCSPlayer", "m_iAccount");
		if (StrEqual(info, "oui", true))
		{
			if (money[client][0][0] >= 1500)
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
				CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
				money[client] = money[client][0][0][-375];
				AdCash(TransactionWith[client][0][0], 1500);
				var1 = var1[0][0][0];
				capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][187];
				SetEntData(client, MoneyOffset, money[client][0][0], 4, true);
			}
			else
			{
				if (cb[client][0][0] == 1)
				{
					if (bank[client][0][0] >= 1500)
					{
						CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
						CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
						bank[client] = bank[client][0][0][-375];
						AdCash(TransactionWith[client][0][0], 1500);
						var2 = var2[0][0][0];
						capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][187];
					}
					else
					{
						CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
						CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
					}
				}
				CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
				CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
			}
		}
		else
		{
			if (StrEqual(info, "non", true))
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a refusé.", "{red}[CSS-RP] ", client);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public Vente_Ak47(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[32];
		GetMenuItem(menu, param2, info, 32, 0, "", 0);
		new MoneyOffset = FindSendPropOffs("CCSPlayer", "m_iAccount");
		if (StrEqual(info, "oui", true))
		{
			if (money[client][0][0] >= 1500)
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
				CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
				money[client] = money[client][0][0][-375];
				AdCash(TransactionWith[client][0][0], 1500);
				var1 = var1[0][0][0];
				capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][187];
				SetEntData(client, MoneyOffset, money[client][0][0], 4, true);
			}
			else
			{
				if (cb[client][0][0] == 1)
				{
					if (bank[client][0][0] >= 1500)
					{
						CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
						CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
						bank[client] = bank[client][0][0][-375];
						AdCash(TransactionWith[client][0][0], 1500);
						var2 = var2[0][0][0];
						capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][187];
					}
					else
					{
						CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
						CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
					}
				}
				CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
				CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
			}
		}
		else
		{
			if (StrEqual(info, "non", true))
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a refusé.", "{red}[CSS-RP] ", client);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public Vente_M249(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[32];
		GetMenuItem(menu, param2, info, 32, 0, "", 0);
		new MoneyOffset = FindSendPropOffs("CCSPlayer", "m_iAccount");
		if (StrEqual(info, "oui", true))
		{
			if (money[client][0][0] >= 1500)
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
				CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
				money[client] = money[client][0][0][-375];
				AdCash(TransactionWith[client][0][0], 1500);
				var1 = var1[0][0][0];
				capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][187];
				SetEntData(client, MoneyOffset, money[client][0][0], 4, true);
			}
			else
			{
				if (cb[client][0][0] == 1)
				{
					if (bank[client][0][0] >= 1500)
					{
						CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
						CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
						bank[client] = bank[client][0][0][-375];
						AdCash(TransactionWith[client][0][0], 1500);
						var2 = var2[0][0][0];
						capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][187];
					}
					else
					{
						CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
						CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
					}
				}
				CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
				CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
			}
		}
		else
		{
			if (StrEqual(info, "non", true))
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a refusé.", "{red}[CSS-RP] ", client);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public Vente_Awp(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[32];
		GetMenuItem(menu, param2, info, 32, 0, "", 0);
		new MoneyOffset = FindSendPropOffs("CCSPlayer", "m_iAccount");
		if (StrEqual(info, "oui", true))
		{
			if (money[client][0][0] >= 2500)
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
				CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
				money[client] = money[client][0][0][-625];
				AdCash(TransactionWith[client][0][0], 2500);
				var1 = var1[0][0][0];
				capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][312];
				SetEntData(client, MoneyOffset, money[client][0][0], 4, true);
			}
			else
			{
				if (cb[client][0][0] == 1)
				{
					if (bank[client][0][0] >= 2500)
					{
						CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
						CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
						bank[client] = bank[client][0][0][-625];
						AdCash(TransactionWith[client][0][0], 2500);
						var2 = var2[0][0][0];
						capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][312];
					}
					else
					{
						CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
						CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
					}
				}
				CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
				CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
			}
		}
		else
		{
			if (StrEqual(info, "non", true))
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a refusé.", "{red}[CSS-RP] ", client);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public Vente_Permis1(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[32];
		GetMenuItem(menu, param2, info, 32, 0, "", 0);
		new MoneyOffset = FindSendPropOffs("CCSPlayer", "m_iAccount");
		if (StrEqual(info, "oui", true))
		{
			if (money[client][0][0] >= 1000)
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
				CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
				money[client] = money[client][0][0][-250];
				AdCash(TransactionWith[client][0][0], 500);
				permisleger[client] = 1;
				capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][125];
				SetEntData(client, MoneyOffset, money[client][0][0], 4, true);
			}
			else
			{
				if (cb[client][0][0] == 1)
				{
					if (bank[client][0][0] >= 1000)
					{
						CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
						CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
						bank[client] = bank[client][0][0][-250];
						AdCash(TransactionWith[client][0][0], 500);
						permisleger[client] = 1;
						capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][125];
					}
					else
					{
						CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
						CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
					}
				}
				CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
				CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
			}
		}
		else
		{
			if (StrEqual(info, "non", true))
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a refusé.", "{red}[CSS-RP] ", client);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public Vente_Permis2(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[32];
		GetMenuItem(menu, param2, info, 32, 0, "", 0);
		new MoneyOffset = FindSendPropOffs("CCSPlayer", "m_iAccount");
		if (StrEqual(info, "oui", true))
		{
			if (money[client][0][0] >= 2000)
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
				CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
				money[client] = money[client][0][0][-500];
				AdCash(TransactionWith[client][0][0], 1000);
				permislourd[client] = 1;
				capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][250];
				SetEntData(client, MoneyOffset, money[client][0][0], 4, true);
			}
			else
			{
				if (cb[client][0][0] == 1)
				{
					if (bank[client][0][0] >= 2000)
					{
						CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
						CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
						bank[client] = bank[client][0][0][-500];
						AdCash(TransactionWith[client][0][0], 1000);
						permislourd[client] = 1;
						capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][250];
					}
					else
					{
						CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
						CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
					}
				}
				CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
				CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
			}
		}
		else
		{
			if (StrEqual(info, "non", true))
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a refusé.", "{red}[CSS-RP] ", client);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public Vente_Ticket10(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[32];
		GetMenuItem(menu, param2, info, 32, 0, "", 0);
		new MoneyOffset = FindSendPropOffs("CCSPlayer", "m_iAccount");
		if (StrEqual(info, "oui", true))
		{
			if (money[client][0][0] >= 10)
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
				CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
				money[client] = money[client][0][0][-2];
				AdCash(TransactionWith[client][0][0], 10);
				ticket10[client] = ticket10[client][0][0][0];
				capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][2];
				SetEntData(client, MoneyOffset, money[client][0][0], 4, true);
			}
			else
			{
				if (cb[client][0][0] == 1)
				{
					if (bank[client][0][0] >= 10)
					{
						CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
						CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
						bank[client] = bank[client][0][0][-2];
						AdCash(TransactionWith[client][0][0], 10);
						ticket10[client] = ticket10[client][0][0][0];
						capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][2];
					}
					else
					{
						CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
						CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
					}
				}
				CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
				CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
			}
		}
		else
		{
			if (StrEqual(info, "non", true))
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a refusé.", "{red}[CSS-RP] ", client);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public Vente_Ticket100(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[32];
		GetMenuItem(menu, param2, info, 32, 0, "", 0);
		new MoneyOffset = FindSendPropOffs("CCSPlayer", "m_iAccount");
		if (StrEqual(info, "oui", true))
		{
			if (money[client][0][0] >= 100)
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
				CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
				money[client] = money[client][0][0][-25];
				AdCash(TransactionWith[client][0][0], 50);
				ticket100[client] = ticket100[client][0][0][0];
				capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][12];
				SetEntData(client, MoneyOffset, money[client][0][0], 4, true);
			}
			else
			{
				if (cb[client][0][0] == 1)
				{
					if (bank[client][0][0] >= 100)
					{
						CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
						CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
						bank[client] = bank[client][0][0][-25];
						AdCash(TransactionWith[client][0][0], 50);
						ticket100[client] = ticket100[client][0][0][0];
						capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][12];
					}
					else
					{
						CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
						CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
					}
				}
				CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
				CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
			}
		}
		else
		{
			if (StrEqual(info, "non", true))
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a refusé.", "{red}[CSS-RP] ", client);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public Vente_Ticket1000(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[32];
		GetMenuItem(menu, param2, info, 32, 0, "", 0);
		new MoneyOffset = FindSendPropOffs("CCSPlayer", "m_iAccount");
		if (StrEqual(info, "oui", true))
		{
			if (money[client][0][0] >= 1000)
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
				CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
				money[client] = money[client][0][0][-250];
				AdCash(TransactionWith[client][0][0], 1000);
				ticket1000[client] = ticket1000[client][0][0][0];
				capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][250];
				SetEntData(client, MoneyOffset, money[client][0][0], 4, true);
			}
			else
			{
				if (cb[client][0][0] == 1)
				{
					if (bank[client][0][0] >= 1000)
					{
						CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
						CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
						bank[client] = bank[client][0][0][-250];
						AdCash(TransactionWith[client][0][0], 500);
						ticket1000[client] = ticket1000[client][0][0][0];
						capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][125];
					}
					else
					{
						CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
						CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
					}
				}
				CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
				CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
			}
		}
		else
		{
			if (StrEqual(info, "non", true))
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a refusé.", "{red}[CSS-RP] ", client);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public Vente_Props1(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[32];
		GetMenuItem(menu, param2, info, 32, 0, "", 0);
		new MoneyOffset = FindSendPropOffs("CCSPlayer", "m_iAccount");
		if (StrEqual(info, "oui", true))
		{
			if (money[client][0][0] >= 1500)
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
				CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
				money[client] = money[client][0][0][-375];
				AdCash(TransactionWith[client][0][0], 1500);
				var1 = var1[0][0][0];
				capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][187];
				SetEntData(client, MoneyOffset, money[client][0][0], 4, true);
			}
			else
			{
				if (cb[client][0][0] == 1)
				{
					if (bank[client][0][0] >= 1500)
					{
						CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
						CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
						bank[client] = bank[client][0][0][-375];
						AdCash(TransactionWith[client][0][0], 1500);
						var2 = var2[0][0][0];
						capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][187];
					}
					else
					{
						CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
						CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
					}
				}
				CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
				CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
			}
		}
		else
		{
			if (StrEqual(info, "non", true))
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a refusé.", "{red}[CSS-RP] ", client);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public Vente_Props2(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[32];
		GetMenuItem(menu, param2, info, 32, 0, "", 0);
		new MoneyOffset = FindSendPropOffs("CCSPlayer", "m_iAccount");
		if (StrEqual(info, "oui", true))
		{
			if (money[client][0][0] >= 1000)
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
				CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
				money[client] = money[client][0][0][-250];
				AdCash(TransactionWith[client][0][0], 1000);
				var1 = var1[0][0][0];
				capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][125];
				SetEntData(client, MoneyOffset, money[client][0][0], 4, true);
			}
			else
			{
				if (cb[client][0][0] == 1)
				{
					if (bank[client][0][0] >= 1000)
					{
						CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
						CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
						bank[client] = bank[client][0][0][-250];
						AdCash(TransactionWith[client][0][0], 1000);
						var2 = var2[0][0][0];
						capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][125];
					}
					else
					{
						CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
						CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
					}
				}
				CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
				CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
			}
		}
		else
		{
			if (StrEqual(info, "non", true))
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a refusé.", "{red}[CSS-RP] ", client);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public Vente_Lsd(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[32];
		GetMenuItem(menu, param2, info, 32, 0, "", 0);
		new MoneyOffset = FindSendPropOffs("CCSPlayer", "m_iAccount");
		if (StrEqual(info, "oui", true))
		{
			if (money[client][0][0] >= 300)
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
				CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
				money[client] = money[client][0][0][-75];
				AdCash(TransactionWith[client][0][0], 150);
				var1 = var1[0][0][0];
				capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][37];
				SetEntData(client, MoneyOffset, money[client][0][0], 4, true);
			}
			else
			{
				if (cb[client][0][0] == 1)
				{
					if (bank[client][0][0] >= 300)
					{
						CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
						CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
						bank[client] = bank[client][0][0][-75];
						AdCash(TransactionWith[client][0][0], 150);
						var2 = var2[0][0][0];
						capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][37];
					}
					else
					{
						CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
						CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
					}
				}
				CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
				CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
			}
		}
		else
		{
			if (StrEqual(info, "non", true))
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a refusé.", "{red}[CSS-RP] ", client);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public Vente_Exta(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[32];
		GetMenuItem(menu, param2, info, 32, 0, "", 0);
		new MoneyOffset = FindSendPropOffs("CCSPlayer", "m_iAccount");
		if (StrEqual(info, "oui", true))
		{
			if (money[client][0][0] >= 400)
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
				CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
				money[client] = money[client][0][0][-100];
				AdCash(TransactionWith[client][0][0], 200);
				var1 = var1[0][0][0];
				capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][50];
				SetEntData(client, MoneyOffset, money[client][0][0], 4, true);
			}
			else
			{
				if (cb[client][0][0] == 1)
				{
					if (bank[client][0][0] >= 400)
					{
						CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
						CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
						bank[client] = bank[client][0][0][-100];
						AdCash(TransactionWith[client][0][0], 200);
						var2 = var2[0][0][0];
						capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][50];
					}
					else
					{
						CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
						CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
					}
				}
				CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
				CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
			}
		}
		else
		{
			if (StrEqual(info, "non", true))
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a refusé.", "{red}[CSS-RP] ", client);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public Vente_Coke(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[32];
		GetMenuItem(menu, param2, info, 32, 0, "", 0);
		new MoneyOffset = FindSendPropOffs("CCSPlayer", "m_iAccount");
		if (StrEqual(info, "oui", true))
		{
			if (money[client][0][0] >= 500)
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
				CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
				money[client] = money[client][0][0][-125];
				AdCash(TransactionWith[client][0][0], 250);
				var1 = var1[0][0][0];
				capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][62];
				SetEntData(client, MoneyOffset, money[client][0][0], 4, true);
			}
			else
			{
				if (cb[client][0][0] == 1)
				{
					if (bank[client][0][0] >= 500)
					{
						CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
						CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
						bank[client] = bank[client][0][0][-125];
						AdCash(TransactionWith[client][0][0], 250);
						var2 = var2[0][0][0];
						capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][62];
					}
					else
					{
						CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
						CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
					}
				}
				CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
				CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
			}
		}
		else
		{
			if (StrEqual(info, "non", true))
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a refusé.", "{red}[CSS-RP] ", client);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public Vente_Heroine(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[32];
		GetMenuItem(menu, param2, info, 32, 0, "", 0);
		new MoneyOffset = FindSendPropOffs("CCSPlayer", "m_iAccount");
		if (StrEqual(info, "oui", true))
		{
			if (money[client][0][0] >= 700)
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
				CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
				money[client] = money[client][0][0][-175];
				AdCash(TransactionWith[client][0][0], 350);
				var1 = var1[0][0][0];
				capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][87];
				SetEntData(client, MoneyOffset, money[client][0][0], 4, true);
			}
			else
			{
				if (cb[client][0][0] == 1)
				{
					if (bank[client][0][0] >= 700)
					{
						CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
						CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
						bank[client] = bank[client][0][0][-175];
						AdCash(TransactionWith[client][0][0], 350);
						var2 = var2[0][0][0];
						capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][87];
					}
					else
					{
						CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
						CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
					}
				}
				CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
				CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
			}
		}
		else
		{
			if (StrEqual(info, "non", true))
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a refusé.", "{red}[CSS-RP] ", client);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public Vente_Rib(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[32];
		GetMenuItem(menu, param2, info, 32, 0, "", 0);
		new MoneyOffset = FindSendPropOffs("CCSPlayer", "m_iAccount");
		if (StrEqual(info, "oui", true))
		{
			if (bank[client][0][0] >= 1500)
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
				CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
				bank[client] = bank[client][0][0][-375];
				AdCash(TransactionWith[client][0][0], 750);
				rib[client] = 1;
				capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][187];
				SetEntData(client, MoneyOffset, money[client][0][0], 4, true);
			}
			else
			{
				CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
				CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
			}
		}
		else
		{
			if (StrEqual(info, "non", true))
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a refusé.", "{red}[CSS-RP] ", client);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public Vente_Cb(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[32];
		GetMenuItem(menu, param2, info, 32, 0, "", 0);
		new MoneyOffset = FindSendPropOffs("CCSPlayer", "m_iAccount");
		if (StrEqual(info, "oui", true))
		{
			if (bank[client][0][0] >= 1500)
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
				CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
				bank[client] = bank[client][0][0][-375];
				AdCash(TransactionWith[client][0][0], 750);
				cb[client] = 1;
				capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][187];
				SetEntData(client, MoneyOffset, money[client][0][0], 4, true);
			}
			else
			{
				CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
			}
		}
		else
		{
			if (StrEqual(info, "non", true))
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a refusé.", "{red}[CSS-RP] ", client);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public Action:StopEffect(Handle:timer, client)
{
	ClientCommand(client, "r_screenoverlay 0");
	CPrintToChat(client, "%s: Votre effet de chirurgie est terminé.", "{red}[CSS-RP] ");
	g_chirurgie[client] = 0;
	return Action:0;
}

public Action:Command_Grab(client, args)
{
	if (!IsPlayerAlive(client))
	{
		return Action:3;
	}
	if (g_IsInJail[client][0][0])
	{
		CPrintToChat(client, "%s: Vous ne pouvez pas porter en jail.", "{red}[CSS-RP] ");
	}
	else
	{
		if (grab[client][0][0])
		{
			gObj[client] = -1;
			grab[client] = 0;
			return Action:3;
		}
		new ent = TraceToEntity(client);
		new String:edictname[128];
		GetEdictClassname(ent, edictname, 128);
		if (ent == gObj[client][0][0])
		{
			if (grab[client][0][0])
			{
				gObj[client] = -1;
				grab[client] = 0;
			}
			else
			{
				CPrintToChat(client, "%s: Vous portez aucun objet | personne.", "{red}[CSS-RP] ");
			}
			return Action:3;
		}
		if (!grab[client][0][0])
		{
			if (StrEqual(edictname, "prop_physics", true))
			{
				gObj[client] = ent;
				grab[client] = 1;
			}
			else
			{
				if (StrEqual(edictname, "player", true))
				{
					if (GetClientTeam(client) == 3)
					{
						if (GetClientTeam(ent) == 3)
						{
							CPrintToChat(client, "%s: Vous ne pouvez pas porter un policier", "{red}[CSS-RP] ");
							return Action:3;
						}
						if (jobid[client][0][0] == 6)
						{
							if (IsInMafia(client))
							{
								if (IsInMafia(ent))
								{
									gObj[client] = ent;
									grab[client] = 1;
								}
								else
								{
									CPrintToChat(client, "%s: le joueur cibler est pas dans votre planque.", "{red}[CSS-RP] ");
								}
							}
							else
							{
								CPrintToChat(client, "%s: Vous pouvez porter un joueur que dans votre planque.", "{red}[CSS-RP] ");
							}
						}
						else
						{
							if (jobid[client][0][0] == 9)
							{
								if (IsInDealer(client))
								{
									if (IsInDealer(ent))
									{
										gObj[client] = ent;
										grab[client] = 1;
									}
									else
									{
										CPrintToChat(client, "%s: le joueur cibler est pas dans votre planque.", "{red}[CSS-RP] ");
									}
								}
								else
								{
									CPrintToChat(client, "%s: Vous pouvez porter un joueur que dans votre planque.", "{red}[CSS-RP] ");
								}
							}
							if (jobid[client][0][0] == 12)
							{
								if (IsInCoach(client))
								{
									if (IsInCoach(ent))
									{
										gObj[client] = ent;
										grab[client] = 1;
									}
									else
									{
										CPrintToChat(client, "%s: le joueur cibler est pas dans votre planque.", "{red}[CSS-RP] ");
									}
								}
								else
								{
									CPrintToChat(client, "%s: Vous pouvez porter un joueur que dans votre planque.", "{red}[CSS-RP] ");
								}
							}
							if (jobid[client][0][0] == 15)
							{
								if (IsInIkea(client))
								{
									if (IsInIkea(ent))
									{
										gObj[client] = ent;
										grab[client] = 1;
									}
									else
									{
										CPrintToChat(client, "%s: le joueur cibler est pas dans votre planque.", "{red}[CSS-RP] ");
									}
								}
								else
								{
									CPrintToChat(client, "%s: Vous pouvez porter un joueur que dans votre planque.", "{red}[CSS-RP] ");
								}
							}
							if (jobid[client][0][0] == 18)
							{
								if (IsInArmu(client))
								{
									if (IsInArmu(ent))
									{
										gObj[client] = ent;
										grab[client] = 1;
									}
									else
									{
										CPrintToChat(client, "%s: le joueur cibler est pas dans votre planque.", "{red}[CSS-RP] ");
									}
								}
								else
								{
									CPrintToChat(client, "%s: Vous pouvez porter un joueur que dans votre planque.", "{red}[CSS-RP] ");
								}
							}
							if (jobid[client][0][0] == 21)
							{
								if (IsInLoto(client))
								{
									if (IsInLoto(ent))
									{
										gObj[client] = ent;
										grab[client] = 1;
									}
									else
									{
										CPrintToChat(client, "%s: le joueur cibler est pas dans votre planque.", "{red}[CSS-RP] ");
									}
								}
								else
								{
									CPrintToChat(client, "%s: Vous pouvez porter un joueur que dans votre planque.", "{red}[CSS-RP] ");
								}
							}
							if (jobid[client][0][0] == 24)
							{
								if (IsInBank(client))
								{
									if (IsInBank(ent))
									{
										gObj[client] = ent;
										grab[client] = 1;
									}
									else
									{
										CPrintToChat(client, "%s: le joueur cibler est pas dans votre planque.", "{red}[CSS-RP] ");
									}
								}
								else
								{
									CPrintToChat(client, "%s: Vous pouvez porter un joueur que dans votre planque.", "{red}[CSS-RP] ");
								}
							}
							if (jobid[client][0][0] == 27)
							{
								if (IsInHosto(client))
								{
									if (IsInHosto(ent))
									{
										gObj[client] = ent;
										grab[client] = 1;
									}
									else
									{
										CPrintToChat(client, "%s: le joueur cibler est pas dans votre planque.", "{red}[CSS-RP] ");
									}
								}
								else
								{
									CPrintToChat(client, "%s: Vous pouvez porter un joueur que dans votre planque.", "{red}[CSS-RP] ");
								}
							}
							if (jobid[client][0][0] == 31)
							{
								if (IsInEleven(client))
								{
									if (IsInEleven(ent))
									{
										gObj[client] = ent;
										grab[client] = 1;
									}
									else
									{
										CPrintToChat(client, "%s: le joueur cibler est pas dans votre planque.", "{red}[CSS-RP] ");
									}
								}
								else
								{
									CPrintToChat(client, "%s: Vous pouvez porter un joueur que dans votre planque.", "{red}[CSS-RP] ");
								}
							}
							if (jobid[client][0][0] == 34)
							{
								if (IsInTueur(client))
								{
									if (IsInTueur(ent))
									{
										gObj[client] = ent;
										grab[client] = 1;
									}
									else
									{
										CPrintToChat(client, "%s: le joueur cibler est pas dans votre planque.", "{red}[CSS-RP] ");
									}
								}
								else
								{
									CPrintToChat(client, "%s: Vous pouvez porter un joueur que dans votre planque.", "{red}[CSS-RP] ");
								}
							}
							if (jobid[client][0][0] == 37)
							{
								if (IsInHotel(client))
								{
									if (IsInHotel(ent))
									{
										gObj[client] = ent;
										grab[client] = 1;
									}
									else
									{
										CPrintToChat(client, "%s: le joueur cibler est pas dans votre planque.", "{red}[CSS-RP] ");
									}
								}
								else
								{
									CPrintToChat(client, "%s: Vous pouvez porter un joueur que dans votre planque.", "{red}[CSS-RP] ");
								}
							}
							if (GetClientTeam(client) == 3)
							{
								gObj[client] = ent;
								grab[client] = 1;
							}
						}
					}
					CPrintToChat(client, "%s: Vous ne pouvez pas porter un joueur.", "{red}[CSS-RP] ");
				}
			}
		}
		else
		{
			CPrintToChat(client, "%s: Vous portez déjà  quelque chose.", "{red}[CSS-RP] ");
		}
	}
	return Action:3;
}

public Action:UpdateObjects(Handle:timer)
{
	new Float:vecDir[3] = 0;
	new Float:vecPos[3] = 0;
	new Float:vecVel[3] = 0;
	new Float:viewang[3] = 0;
	new i;
	while (i < 64)
	{
		if (0 < gObj[i][0][0])
		{
			if (IsValidEdict(gObj[i][0][0]))
			{
				GetClientEyeAngles(i, viewang);
				GetAngleVectors(viewang, vecDir, NULL_VECTOR, NULL_VECTOR);
				GetClientEyePosition(i, vecPos);
				vecPos[0] = vecPos[0][vecDir[0] * 100];
				var2 = var2[vecDir[1] * 100];
				var3 = var3[vecDir[2] * 100];
				GetEntPropVector(gObj[i][0][0], PropType:0, "m_vecOrigin", vecDir, 0);
				SubtractVectors(vecPos, vecDir, vecVel);
				ScaleVector(vecVel, 10);
				TeleportEntity(gObj[i][0][0], NULL_VECTOR, NULL_VECTOR, vecVel);
				i++;
			}
			gObj[i] = -1;
			i++;
		}
		i++;
	}
	return Action:0;
}

public TraceToEntity(client)
{
	new Float:vecClientEyePos[3] = 0;
	new Float:vecClientEyeAng[3] = 0;
	GetClientEyePosition(client, vecClientEyePos);
	GetClientEyeAngles(client, vecClientEyeAng);
	TR_TraceRayFilter(vecClientEyePos, vecClientEyeAng, 33636363, RayType:1, TraceRayDontHitSelf, client);
	if (TR_DidHit(Handle:0))
	{
		new TRIndex = TR_GetEntityIndex(Handle:0);
		return TRIndex;
	}
	return -1;
}

public bool:TraceRayDontHitSelf(entity, mask, data)
{
	if (data == entity)
	{
		return false;
	}
	return true;
}

public Action:Command_Virer(client, args)
{
	if (IsClientInGame(client))
	{
		if (IsPlayerAlive(client))
		{
			if (jobid[client][0][0] == 6)
			{
				Showmafia(client);
			}
			else
			{
				if (jobid[client][0][0] == 9)
				{
					ShowDealer(client);
				}
				if (jobid[client][0][0] == 12)
				{
					ShowCoach(client);
				}
				if (jobid[client][0][0] == 15)
				{
					ShowIkea(client);
				}
				if (jobid[client][0][0] == 18)
				{
					ShowArmurie(client);
				}
				if (jobid[client][0][0] == 21)
				{
					ShowLoto(client);
				}
				if (jobid[client][0][0] == 24)
				{
					ShowBank(client);
				}
				if (jobid[client][0][0] == 27)
				{
					ShowHosto(client);
				}
				if (jobid[client][0][0] == 31)
				{
					ShowArti(client);
				}
				if (jobid[client][0][0] == 34)
				{
					ShowTueur(client);
				}
				if (jobid[client][0][0] == 37)
				{
					ShowHotel(client);
				}
				CPrintToChat(client, "%s: Vous devez être chef.", "{red}[CSS-RP] ");
			}
		}
		CPrintToChat(client, "%s: Vous devez être vivant.", "{red}[CSS-RP] ");
	}
	return Action:0;
}

ShowTueur(client)
{
	if (client > 0)
	{
		decl String:sMenuText[64];
		sMenuText[0] = 0;
		new Handle:menu = CreateMenu(Menu_Tueur, MenuAction:28);
		SetMenuTitle(menu, "Choisissez Le joueur :");
		SetMenuExitButton(menu, true);
		AddTueur(menu);
		DisplayMenu(menu, client, 0);
	}
	return 0;
}

public AddTueur(Handle:menu)
{
	decl String:user_id[12];
	decl String:name[32];
	decl String:display[48];
	new i = 1;
	while (i <= MaxClients)
	{
		if (IsClientInGame(i))
		{
			IntToString(GetClientUserId(i), user_id, 12);
			GetClientName(i, name, 32);
			Format(display, 47, "%s (%s)", name, user_id);
			AddMenuItem(menu, user_id, display, 0);
			i++;
		}
		i++;
	}
	return 0;
}

public Menu_Tueur(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[64];
		GetMenuItem(menu, param2, info, 64, 0, "", 0);
		new UserID = StringToInt(info, 10);
		m[client] = GetClientOfUserId(UserID);
		jobid[m[client][0][0]] = 0;
		rankid[m[client][0][0]] = 0;
		salaire[m[client][0][0]] = 50;
		CS_SetClientClanTag(m[client][0][0], "Chômeur -");
		CPrintToChat(m[client][0][0], "%s: Vous avez été viré de votre job.", "{red}[CSS-RP] ");
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

ShowHotel(client)
{
	if (client > 0)
	{
		decl String:sMenuText[64];
		sMenuText[0] = 0;
		new Handle:menu = CreateMenu(Menu_Hotel, MenuAction:28);
		SetMenuTitle(menu, "Choisissez Le joueur :");
		SetMenuExitButton(menu, true);
		AddHotel(menu);
		DisplayMenu(menu, client, 0);
	}
	return 0;
}

public AddHotel(Handle:menu)
{
	decl String:user_id[12];
	decl String:name[32];
	decl String:display[48];
	new i = 1;
	while (i <= MaxClients)
	{
		if (IsClientInGame(i))
		{
			IntToString(GetClientUserId(i), user_id, 12);
			GetClientName(i, name, 32);
			Format(display, 47, "%s (%s)", name, user_id);
			AddMenuItem(menu, user_id, display, 0);
			i++;
		}
		i++;
	}
	return 0;
}

public Menu_Hotel(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[64];
		GetMenuItem(menu, param2, info, 64, 0, "", 0);
		new UserID = StringToInt(info, 10);
		m[client] = GetClientOfUserId(UserID);
		jobid[m[client][0][0]] = 0;
		rankid[m[client][0][0]] = 0;
		salaire[m[client][0][0]] = 50;
		CS_SetClientClanTag(m[client][0][0], "Chômeur -");
		CPrintToChat(m[client][0][0], "%s: Vous avez été viré de votre job.", "{red}[CSS-RP] ");
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

ShowArti(client)
{
	if (client > 0)
	{
		decl String:sMenuText[64];
		sMenuText[0] = 0;
		new Handle:menu = CreateMenu(Menu_Arti, MenuAction:28);
		SetMenuTitle(menu, "Choisissez Le joueur :");
		SetMenuExitButton(menu, true);
		AddArti(menu);
		DisplayMenu(menu, client, 0);
	}
	return 0;
}

public AddArti(Handle:menu)
{
	decl String:user_id[12];
	decl String:name[32];
	decl String:display[48];
	new i = 1;
	while (i <= MaxClients)
	{
		if (IsClientInGame(i))
		{
			IntToString(GetClientUserId(i), user_id, 12);
			GetClientName(i, name, 32);
			Format(display, 47, "%s (%s)", name, user_id);
			AddMenuItem(menu, user_id, display, 0);
			i++;
		}
		i++;
	}
	return 0;
}

public Menu_Arti(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[64];
		GetMenuItem(menu, param2, info, 64, 0, "", 0);
		new UserID = StringToInt(info, 10);
		m[client] = GetClientOfUserId(UserID);
		jobid[m[client][0][0]] = 0;
		rankid[m[client][0][0]] = 0;
		salaire[m[client][0][0]] = 50;
		CS_SetClientClanTag(m[client][0][0], "Chômeur -");
		CPrintToChat(m[client][0][0], "%s: Vous avez été viré de votre job.", "{red}[CSS-RP] ");
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

Showmafia(client)
{
	if (client > 0)
	{
		decl String:sMenuText[64];
		sMenuText[0] = 0;
		new Handle:menu = CreateMenu(Menu_Mafia, MenuAction:28);
		SetMenuTitle(menu, "Choisissez Le joueur :");
		SetMenuExitButton(menu, true);
		AddEmployers(menu);
		DisplayMenu(menu, client, 0);
	}
	return 0;
}

public AddEmployers(Handle:menu)
{
	decl String:user_id[12];
	decl String:name[32];
	decl String:display[48];
	new i = 1;
	while (i <= MaxClients)
	{
		if (IsClientInGame(i))
		{
			IntToString(GetClientUserId(i), user_id, 12);
			GetClientName(i, name, 32);
			Format(display, 47, "%s (%s)", name, user_id);
			AddMenuItem(menu, user_id, display, 0);
			i++;
		}
		i++;
	}
	return 0;
}

public Menu_Mafia(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[64];
		GetMenuItem(menu, param2, info, 64, 0, "", 0);
		new UserID = StringToInt(info, 10);
		m[client] = GetClientOfUserId(UserID);
		jobid[m[client][0][0]] = 0;
		rankid[m[client][0][0]] = 0;
		salaire[m[client][0][0]] = 50;
		CS_SetClientClanTag(m[client][0][0], "Chômeur -");
		CPrintToChat(m[client][0][0], "%s: Vous avez été viré de votre job.", "{red}[CSS-RP] ");
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

ShowHosto(client)
{
	if (client > 0)
	{
		decl String:sMenuText[64];
		sMenuText[0] = 0;
		new Handle:menu = CreateMenu(Menu_Hopital, MenuAction:28);
		SetMenuTitle(menu, "Choisissez Le joueur :");
		SetMenuExitButton(menu, true);
		Addtoubi(menu);
		DisplayMenu(menu, client, 0);
	}
	return 0;
}

public Addtoubi(Handle:menu)
{
	decl String:user_id[12];
	decl String:name[32];
	decl String:display[48];
	new i = 1;
	while (i <= MaxClients)
	{
		if (IsClientInGame(i))
		{
			IntToString(GetClientUserId(i), user_id, 12);
			GetClientName(i, name, 32);
			Format(display, 47, "%s (%s)", name, user_id);
			AddMenuItem(menu, user_id, display, 0);
			i++;
		}
		i++;
	}
	return 0;
}

public Menu_Hopital(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[64];
		GetMenuItem(menu, param2, info, 64, 0, "", 0);
		new UserID = StringToInt(info, 10);
		m[client] = GetClientOfUserId(UserID);
		jobid[m[client][0][0]] = 0;
		rankid[m[client][0][0]] = 0;
		salaire[m[client][0][0]] = 50;
		CS_SetClientClanTag(m[client][0][0], "Chômeur -");
		CPrintToChat(m[client][0][0], "%s: Vous avez été viré de votre job.", "{red}[CSS-RP] ");
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

ShowBank(client)
{
	if (client > 0)
	{
		decl String:sMenuText[64];
		sMenuText[0] = 0;
		new Handle:menu = CreateMenu(Menu_Banque, MenuAction:28);
		SetMenuTitle(menu, "Choisissez Le joueur :");
		SetMenuExitButton(menu, true);
		AddBank(menu);
		DisplayMenu(menu, client, 0);
	}
	return 0;
}

public AddBank(Handle:menu)
{
	decl String:user_id[12];
	decl String:name[32];
	decl String:display[48];
	new i = 1;
	while (i <= MaxClients)
	{
		if (IsClientInGame(i))
		{
			IntToString(GetClientUserId(i), user_id, 12);
			GetClientName(i, name, 32);
			Format(display, 47, "%s (%s)", name, user_id);
			AddMenuItem(menu, user_id, display, 0);
			i++;
		}
		i++;
	}
	return 0;
}

public Menu_Banque(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[64];
		GetMenuItem(menu, param2, info, 64, 0, "", 0);
		new UserID = StringToInt(info, 10);
		m[client] = GetClientOfUserId(UserID);
		jobid[m[client][0][0]] = 0;
		rankid[m[client][0][0]] = 0;
		salaire[m[client][0][0]] = 50;
		CS_SetClientClanTag(m[client][0][0], "Chômeur -");
		CPrintToChat(m[client][0][0], "%s: Vous avez été viré de votre job.", "{red}[CSS-RP] ");
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

ShowDealer(client)
{
	if (client > 0)
	{
		decl String:sMenuText[64];
		sMenuText[0] = 0;
		new Handle:menu = CreateMenu(Menu_Deal, MenuAction:28);
		SetMenuTitle(menu, "Choisissez Le joueur :");
		SetMenuExitButton(menu, true);
		AddDealer(menu);
		DisplayMenu(menu, client, 0);
	}
	return 0;
}

public AddDealer(Handle:menu)
{
	decl String:user_id[12];
	decl String:name[32];
	decl String:display[48];
	new i = 1;
	while (i <= MaxClients)
	{
		if (IsClientInGame(i))
		{
			IntToString(GetClientUserId(i), user_id, 12);
			GetClientName(i, name, 32);
			Format(display, 47, "%s (%s)", name, user_id);
			AddMenuItem(menu, user_id, display, 0);
			i++;
		}
		i++;
	}
	return 0;
}

public Menu_Deal(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[64];
		GetMenuItem(menu, param2, info, 64, 0, "", 0);
		new UserID = StringToInt(info, 10);
		m[client] = GetClientOfUserId(UserID);
		jobid[m[client][0][0]] = 0;
		rankid[m[client][0][0]] = 0;
		salaire[m[client][0][0]] = 50;
		CS_SetClientClanTag(m[client][0][0], "Chômeur -");
		CPrintToChat(m[client][0][0], "%s: Vous avez été viré de votre job.", "{red}[CSS-RP] ");
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

ShowCoach(client)
{
	if (client > 0)
	{
		decl String:sMenuText[64];
		sMenuText[0] = 0;
		new Handle:menu = CreateMenu(Menu_Coach, MenuAction:28);
		SetMenuTitle(menu, "Choisissez Le joueur :");
		SetMenuExitButton(menu, true);
		AddCoach(menu);
		DisplayMenu(menu, client, 0);
	}
	return 0;
}

public AddCoach(Handle:menu)
{
	decl String:user_id[12];
	decl String:name[32];
	decl String:display[48];
	new i = 1;
	while (i <= MaxClients)
	{
		if (IsClientInGame(i))
		{
			IntToString(GetClientUserId(i), user_id, 12);
			GetClientName(i, name, 32);
			Format(display, 47, "%s (%s)", name, user_id);
			AddMenuItem(menu, user_id, display, 0);
			i++;
		}
		i++;
	}
	return 0;
}

public Menu_Coach(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[64];
		GetMenuItem(menu, param2, info, 64, 0, "", 0);
		new UserID = StringToInt(info, 10);
		m[client] = GetClientOfUserId(UserID);
		jobid[m[client][0][0]] = 0;
		rankid[m[client][0][0]] = 0;
		salaire[m[client][0][0]] = 50;
		CS_SetClientClanTag(m[client][0][0], "Chômeur -");
		CPrintToChat(m[client][0][0], "%s: Vous avez été viré de votre job.", "{red}[CSS-RP] ");
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

ShowIkea(client)
{
	if (client > 0)
	{
		decl String:sMenuText[64];
		sMenuText[0] = 0;
		new Handle:menu = CreateMenu(Menu_Ikea, MenuAction:28);
		SetMenuTitle(menu, "Choisissez Le joueur :");
		SetMenuExitButton(menu, true);
		AddIkea(menu);
		DisplayMenu(menu, client, 0);
	}
	return 0;
}

public AddIkea(Handle:menu)
{
	decl String:user_id[12];
	decl String:name[32];
	decl String:display[48];
	new i = 1;
	while (i <= MaxClients)
	{
		if (IsClientInGame(i))
		{
			IntToString(GetClientUserId(i), user_id, 12);
			GetClientName(i, name, 32);
			Format(display, 47, "%s (%s)", name, user_id);
			AddMenuItem(menu, user_id, display, 0);
			i++;
		}
		i++;
	}
	return 0;
}

public Menu_Ikea(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[64];
		GetMenuItem(menu, param2, info, 64, 0, "", 0);
		new UserID = StringToInt(info, 10);
		m[client] = GetClientOfUserId(UserID);
		jobid[m[client][0][0]] = 0;
		rankid[m[client][0][0]] = 0;
		salaire[m[client][0][0]] = 50;
		CS_SetClientClanTag(m[client][0][0], "Chômeur -");
		CPrintToChat(m[client][0][0], "%s: Vous avez été viré de votre job.", "{red}[CSS-RP] ");
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

ShowArmurie(client)
{
	if (client > 0)
	{
		decl String:sMenuText[64];
		sMenuText[0] = 0;
		new Handle:menu = CreateMenu(Menu_Armu, MenuAction:28);
		SetMenuTitle(menu, "Choisissez Le joueur :");
		SetMenuExitButton(menu, true);
		AddArmurier(menu);
		DisplayMenu(menu, client, 0);
	}
	return 0;
}

public AddArmurier(Handle:menu)
{
	decl String:user_id[12];
	decl String:name[32];
	decl String:display[48];
	new i = 1;
	while (i <= MaxClients)
	{
		if (IsClientInGame(i))
		{
			IntToString(GetClientUserId(i), user_id, 12);
			GetClientName(i, name, 32);
			Format(display, 47, "%s (%s)", name, user_id);
			AddMenuItem(menu, user_id, display, 0);
			i++;
		}
		i++;
	}
	return 0;
}

public Menu_Armu(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[64];
		GetMenuItem(menu, param2, info, 64, 0, "", 0);
		new UserID = StringToInt(info, 10);
		m[client] = GetClientOfUserId(UserID);
		jobid[m[client][0][0]] = 0;
		rankid[m[client][0][0]] = 0;
		salaire[m[client][0][0]] = 50;
		CS_SetClientClanTag(m[client][0][0], "Chômeur -");
		CPrintToChat(m[client][0][0], "%s: Vous avez été viré de votre job.", "{red}[CSS-RP] ");
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

ShowLoto(client)
{
	if (client > 0)
	{
		decl String:sMenuText[64];
		sMenuText[0] = 0;
		new Handle:menu = CreateMenu(Menu_Lotoo, MenuAction:28);
		SetMenuTitle(menu, "Choisissez Le joueur :");
		SetMenuExitButton(menu, true);
		AddLoto(menu);
		DisplayMenu(menu, client, 0);
	}
	return 0;
}

public AddLoto(Handle:menu)
{
	decl String:user_id[12];
	decl String:name[32];
	decl String:display[48];
	new i = 1;
	while (i <= MaxClients)
	{
		if (IsClientInGame(i))
		{
			IntToString(GetClientUserId(i), user_id, 12);
			GetClientName(i, name, 32);
			Format(display, 47, "%s (%s)", name, user_id);
			AddMenuItem(menu, user_id, display, 0);
			i++;
		}
		i++;
	}
	return 0;
}

public Menu_Lotoo(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[64];
		GetMenuItem(menu, param2, info, 64, 0, "", 0);
		new UserID = StringToInt(info, 10);
		m[client] = GetClientOfUserId(UserID);
		jobid[m[client][0][0]] = 0;
		rankid[m[client][0][0]] = 0;
		salaire[m[client][0][0]] = 50;
		CS_SetClientClanTag(m[client][0][0], "Chômeur -");
		CPrintToChat(m[client][0][0], "%s: Vous avez été viré de votre job.", "{red}[CSS-RP] ");
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public Action:Command_Vol(client, args)
{
	if (IsPlayerAlive(client))
	{
		new MoneyOffset = FindSendPropOffs("CCSPlayer", "m_iAccount");
		if (jobid[client][0][0] == 6)
		{
			if (g_IsInJail[client][0][0])
			{
				CPrintToChat(client, "%s: Vous ne pouvez pas voler en jail.", "{red}[CSS-RP] ");
			}
			else
			{
				new i = GetClientAimTarget(client, true);
				new String:ClassName[256];
				ClassName[0] = 0;
				new timestamp = GetTime({0,0});
				if (i != -1)
				{
					GetEdictClassname(i, ClassName, 255);
					if (StrEqual(ClassName, "player", true))
					{
						new vol_somme = GetRandomInt(1, 200);
						new Float:entorigin[3] = 0;
						GetEntPropVector(client, PropType:0, "m_vecOrigin", entorigin, 0);
						if (money[i][0][0] < vol_somme)
						{
							CPrintToChat(client, "%s: Le joueur n'a pas d'argent sur lui.", "{red}[CSS-RP] ");
						}
						else
						{
							new Float:origin[3] = 0;
							new Float:clientent[3] = 0;
							GetEntPropVector(i, PropType:0, "m_vecOrigin", origin, 0);
							GetEntPropVector(client, PropType:0, "m_vecOrigin", clientent, 0);
							new Float:distance = GetVectorDistance(origin, clientent, false);
							new Float:vec[3] = 0;
							GetClientAbsOrigin(client, vec);
							var2 = var2[10];
							if (timestamp - g_vol[client][0][0] < 30)
							{
								CPrintToChat(client, "%s: Vous devez attendre %i secondes avant de pouvoir voler.", "{red}[CSS-RP] ", 30 - timestamp - g_vol[client][0][0]);
							}
							else
							{
								if (distance > 1.121039E-43)
								{
									CPrintToChat(client, "%s: Vous êtes trop loin pour voler cette personne.", "{red}[CSS-RP] ");
								}
								g_vol[client] = GetTime({0,0});
								CPrintToChat(client, "%s: Vous avez voler %i€.", "{red}[CSS-RP] ", vol_somme);
								TE_SetupBeamRingPoint(vec, 5, 180, g_BeamSprite, g_modelHalo, 0, 15, 0.6, 15, 0, greenColor, 10, 0);
								TE_SendToAll(0);
								CPrintToChat(i, "%s: Vous avez perdu %i€ suite a un vol.", "{red}[CSS-RP] ", vol_somme);
								money[i] = money[i][0][0] - vol_somme;
								money[client] = money[client][0][0][vol_somme];
								capital[rankid[client][0][0]] = capital[rankid[client][0][0]][0][0][vol_somme];
								SetEntData(client, MoneyOffset, money[client][0][0], 4, true);
								SetEntData(i, MoneyOffset, money[i][0][0], 4, true);
							}
						}
					}
					else
					{
						CPrintToChat(client, "%s: Vous devez visé un joueur.", "{red}[CSS-RP] ");
					}
				}
				else
				{
					CPrintToChat(client, "%s: Vous devez visé un joueur.", "{red}[CSS-RP] ");
				}
			}
		}
		else
		{
			CPrintToChat(client, "%s: Vous n'avez pas accès a cette commande.", "{red}[CSS-RP] ");
		}
	}
	else
	{
		CPrintToChat(client, "%s: Vous devez être en vie pour utilisé cette commande.", "{red}[CSS-RP] ");
	}
	return Action:0;
}

public Action:OnWeaponEquip(client, weapon)
{
	if (IsClientInGame(client))
	{
		if (IsPlayerAlive(client))
		{
			if (M4FBI == weapon)
			{
				countm4 = 10;
				countm4time = CreateTimer(1, Timer_M4fbi, any:0, 1);
			}
			if (DEAGLEFBI == weapon)
			{
				countdeagle = 10;
				countdeagletime = CreateTimer(1, Timer_deaglefbi, any:0, 1);
			}
			if (M3COMICO == weapon)
			{
				countm3 = 10;
				countm3time = CreateTimer(1, Timer_m3comico, any:0, 1);
			}
			if (USPCOMICO == weapon)
			{
				countusp = 10;
				countusptime = CreateTimer(1, Timer_uspcomico, any:0, 1);
			}
		}
	}
	return Action:0;
}

public Action:Timer_M4fbi(Handle:timer)
{
	countm4 = countm4 + -1;
	if (!countm4)
	{
		KillTimer(countm4time, false);
		M4FBI = Weapon_Create("weapon_m4a1", NULL_VECTOR, NULL_VECTOR);
		TeleportEntity(M4FBI, 123856, NULL_VECTOR, NULL_VECTOR);
	}
	return Action:0;
}

public Action:Timer_deaglefbi(Handle:timer)
{
	countdeagle = countdeagle + -1;
	if (!countdeagle)
	{
		KillTimer(countdeagletime, false);
		DEAGLEFBI = Weapon_Create("weapon_deagle", NULL_VECTOR, NULL_VECTOR);
		TeleportEntity(DEAGLEFBI, 123884, NULL_VECTOR, NULL_VECTOR);
	}
	return Action:0;
}

public Action:Timer_m3comico(Handle:timer)
{
	countm3 = countm3 + -1;
	if (!countm3)
	{
		KillTimer(countm3time, false);
		M3COMICO = Weapon_Create("weapon_m3", NULL_VECTOR, NULL_VECTOR);
		TeleportEntity(M3COMICO, 123908, NULL_VECTOR, NULL_VECTOR);
	}
	return Action:0;
}

public Action:Timer_uspcomico(Handle:timer)
{
	countusp = countusp + -1;
	if (!countusp)
	{
		KillTimer(countusptime, false);
		USPCOMICO = Weapon_Create("weapon_usp", NULL_VECTOR, NULL_VECTOR);
		TeleportEntity(USPCOMICO, 123932, NULL_VECTOR, NULL_VECTOR);
	}
	return Action:0;
}

public Action:OnTakeDamagePre(victim, &attacker, &inflictor, &Float:damage, &damagetype)
{
	if (attacker > 0)
	{
		if (IsPlayerAlive(attacker))
		{
			new String:sWeaponName[64];
			GetClientWeapon(attacker, sWeaponName, 64);
			if (g_IsTazed[attacker][0][0])
			{
				damage = damage * 0;
				return Action:1;
			}
			if (GetClientTeam(attacker) == 2)
			{
				if (!StrEqual(sWeaponName, "weapon_knife", true))
				{
					damage = damage * 0.25;
					return Action:1;
				}
				if (StrEqual(sWeaponName, "weapon_knife", true))
				{
					if (0 >= levelcut[attacker][0][0])
					{
						damage = damage * 0;
						return Action:1;
					}
				}
			}
			else
			{
				if (GetClientTeam(attacker) == 3)
				{
					if (!StrEqual(sWeaponName, "weapon_knife", true))
					{
						damage = damage * 0.25;
						return Action:1;
					}
					if (StrEqual(sWeaponName, "weapon_knife", true))
					{
						if (0 >= levelcut[attacker][0][0])
						{
							damage = damage * 0;
							return Action:1;
						}
					}
				}
				if (GetClientTeam(attacker) == 2)
				{
					if (!StrEqual(sWeaponName, "weapon_knife", true))
					{
						damage = damage * 0.75;
						return Action:1;
					}
					if (StrEqual(sWeaponName, "weapon_knife", true))
					{
						if (0 >= levelcut[attacker][0][0])
						{
							damage = damage * 0;
							return Action:1;
						}
					}
				}
				if (GetClientTeam(attacker) == 3)
				{
					if (!StrEqual(sWeaponName, "weapon_knife", true))
					{
						damage = damage * 0.75;
						return Action:1;
					}
					if (StrEqual(sWeaponName, "weapon_knife", true))
					{
						if (0 >= levelcut[attacker][0][0])
						{
							damage = damage * 0;
							return Action:1;
						}
					}
				}
			}
		}
	}
	if (damagetype & 32 == 32)
	{
		return Action:3;
	}
	return Action:0;
}

public Action:OnPlayerRunCmd(client, &buttons, &impulse, Float:vel[3], Float:angles[3], &weapon)
{
	if (IsPlayerAlive(client))
	{
		if (!g_InUse[client][0][0])
		{
			g_InUse[client] = 1;
			if (IsInDistribMafia(client))
			{
				if (0 < rib[client][0][0])
				{
					new Handle:menu = CreateMenu(Menu_Bank, MenuAction:28);
					SetMenuTitle(menu, "Banque de Riverside :");
					AddMenuItem(menu, "Deposit", "Déposer de l'argent", 0);
					AddMenuItem(menu, "Retired", "Retirer de l'argent", 0);
					if (jobid[client][0][0] == 1)
					{
						AddMenuItem(menu, "Capital", "Déposer dans le capital", 0);
					}
					DisplayMenu(menu, client, 0);
				}
				CPrintToChat(client, "%s: Vous devez posséder un RIB.", "{red}[CSS-RP] ");
			}
			new Ent;
			new String:Door[256];
			Ent = GetClientAimTarget(client, false);
			if (Ent == 964)
			{
				new Handle:menu = CreateMenu(armu2, MenuAction:28);
				AddMenuItem(menu, "awp", "AWP", 0);
				AddMenuItem(menu, "batteuse", "M249", 0);
				AddMenuItem(menu, "m4", "M4A1", 0);
				AddMenuItem(menu, "ak", "AK47", 0);
				AddMenuItem(menu, "aug", "AUG", 0);
				AddMenuItem(menu, "scout", "SCOUT", 0);
				AddMenuItem(menu, "mp5", "MP5", 0);
				AddMenuItem(menu, "p90", "P90", 0);
				AddMenuItem(menu, "ump45", "UMP45", 0);
				AddMenuItem(menu, "tmp", "TMP", 0);
				AddMenuItem(menu, "mac10", "MAC10", 0);
				AddMenuItem(menu, "m3", "M3", 0);
				AddMenuItem(menu, "xm1014", "XM1014", 0);
				AddMenuItem(menu, "galil", "GALIL", 0);
				AddMenuItem(menu, "famas", "FAMAS", 0);
				AddMenuItem(menu, "deagle", "DEAGLE", 0);
				AddMenuItem(menu, "glock", "GLOCK", 0);
				AddMenuItem(menu, "usp", "USP", 0);
				AddMenuItem(menu, "flash", "FLASH", 0);
				AddMenuItem(menu, "grenade", "HE", 0);
				SetMenuExitButton(menu, true);
				DisplayMenu(menu, client, 0);
			}
			if (Ent != -1)
			{
				GetEntityClassname(Ent, Door, 255);
				if (StrEqual(Door, "func_door", true))
				{
					if (!Entity_IsLocked(Ent))
					{
						AcceptEntityInput(Ent, "Toggle", client, client, 0);
					}
					CPrintToChat(client, "%s: La porte est fermée a clef.", "{red}[CSS-RP] ");
				}
				if (StrEqual(Door, "func_door_rotating", true))
				{
					if (Entity_IsLocked(Ent))
					{
						CPrintToChat(client, "%s: La porte est fermée a clef.", "{red}[CSS-RP] ");
					}
				}
				if (StrEqual(Door, "prop_door_rotating", true))
				{
					if (Entity_IsLocked(Ent))
					{
						CPrintToChat(client, "%s: La porte est fermée a clef.", "{red}[CSS-RP] ");
					}
				}
			}
			if (IsInSalle(client))
			{
				if (jobid[client][0][0] == 6)
				{
					if (!OnKit[client][0][0])
					{
						if (kitcrochetage[client][0][0] < 20)
						{
							GiveKit = CreateTimer(15, Timer_Kit, client, 0);
							SetEntPropFloat(client, PropType:0, "m_flProgressBarStartTime", GetGameTime(), 0);
							SetEntProp(client, PropType:0, "m_iProgressBarDuration", any:5, 4, 0);
							OnKit[client] = 1;
							SetEntityRenderColor(client, 255, 0, 0, 0);
							SetEntityMoveType(client, MoveType:0);
						}
						else
						{
							CPrintToChat(client, "%s: Vous avez le maximum de kit de crochetage(%i)", "{red}[CSS-RP] ", kitcrochetage[client]);
						}
					}
					else
					{
						CPrintToChat(client, "%s: Vous êtes déjà  en cours de fabrication.", "{red}[CSS-RP] ");
					}
				}
				CPrintToChat(client, "%s: Vous devez être mafieux.", "{red}[CSS-RP] ");
			}
		}
		if (g_InUse[client][0][0])
		{
			g_InUse[client] = 0;
		}
	}
	return Action:0;
}

public Menu_Bank(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[32];
		GetMenuItem(menu, param2, info, 32, 0, "", 0);
		new MoneyOffset = FindSendPropOffs("CCSPlayer", "m_iAccount");
		if (StrEqual(info, "Deposit", true))
		{
			if (rib[client][0][0] == 1)
			{
				money[client] = GetEntData(client, MoneyOffset, 4);
				if (0 >= money[client][0][0])
				{
					CPrintToChat(client, "%s: Vous n'avez pas d'argent a déposer.", "{red}[CSS-RP] ");
				}
				new Handle:menub = CreateMenu(deposit_menu, MenuAction:28);
				SetMenuTitle(menub, "Choisissez la somme :");
				if (money[client][0][0] >= 10)
				{
					AddMenuItem(menub, "10", "10€", 0);
				}
				if (money[client][0][0] >= 50)
				{
					AddMenuItem(menub, "50", "50€", 0);
				}
				if (money[client][0][0] >= 100)
				{
					AddMenuItem(menub, "100", "100€", 0);
				}
				if (money[client][0][0] >= 200)
				{
					AddMenuItem(menub, "200", "200€", 0);
				}
				if (money[client][0][0] >= 500)
				{
					AddMenuItem(menub, "500", "500€", 0);
				}
				if (money[client][0][0] >= 1000)
				{
					AddMenuItem(menub, "1000", "1000€", 0);
				}
				if (money[client][0][0] >= 2000)
				{
					AddMenuItem(menub, "2000", "2000€", 0);
				}
				if (money[client][0][0] >= 5000)
				{
					AddMenuItem(menub, "5000", "5000€", 0);
				}
				if (money[client][0][0] >= 1)
				{
					AddMenuItem(menub, "all", "La totalité de votre argent", 0);
				}
				DisplayMenu(menub, client, 0);
			}
			else
			{
				CPrintToChat(client, "%s: Vous devez posséder un RIB.", "{red}[CSS-RP] ");
			}
		}
		else
		{
			if (StrEqual(info, "Retired", true))
			{
				if (0 >= bank[client][0][0])
				{
					CPrintToChat(client, "%s: Tu n'as pas d'argent à  retirer.", "{red}[CSS-RP] ");
				}
				if (money[client][0][0] >= 60000)
				{
					CPrintToChat(client, "%s: Tu ne peut pas avoir plus d'argent sur toi.", "{red}[CSS-RP] ");
				}
				else
				{
					if (rib[client][0][0] == 1)
					{
						new Handle:menuba = CreateMenu(retired_menu, MenuAction:28);
						SetMenuTitle(menuba, "Choisissez la somme :");
						if (bank[client][0][0] >= 5)
						{
							AddMenuItem(menuba, "5", "5€", 0);
						}
						if (bank[client][0][0] >= 10)
						{
							AddMenuItem(menuba, "10", "10€", 0);
						}
						if (bank[client][0][0] >= 50)
						{
							AddMenuItem(menuba, "50", "50€", 0);
						}
						if (bank[client][0][0] >= 100)
						{
							AddMenuItem(menuba, "100", "100€", 0);
						}
						if (bank[client][0][0] >= 200)
						{
							AddMenuItem(menuba, "200", "200€", 0);
						}
						if (bank[client][0][0] >= 500)
						{
							AddMenuItem(menuba, "500", "500€", 0);
						}
						if (bank[client][0][0] >= 1000)
						{
							AddMenuItem(menuba, "1000", "1000€", 0);
						}
						if (bank[client][0][0] >= 2000)
						{
							AddMenuItem(menuba, "2000", "2000€", 0);
						}
						if (bank[client][0][0] >= 5000)
						{
							AddMenuItem(menuba, "5000", "5000€", 0);
						}
						if (bank[client][0][0] >= 10000)
						{
							AddMenuItem(menuba, "10000", "10000€", 0);
						}
						DisplayMenu(menuba, client, 0);
					}
					CPrintToChat(client, "%s: Vous devez posséder un RIB.", "{red}[CSS-RP] ");
				}
			}
			if (StrEqual(info, "Capital", true))
			{
				if (rib[client][0][0] == 1)
				{
					money[client] = GetEntData(client, MoneyOffset, 4);
					if (0 >= money[client][0][0])
					{
						CPrintToChat(client, "%s: Vous n'avez pas d'argent a déposer.", "{red}[CSS-RP] ");
					}
					new Handle:menuc = CreateMenu(capital_menu, MenuAction:28);
					SetMenuTitle(menuc, "Choisissez la somme :");
					if (money[client][0][0] >= 10)
					{
						AddMenuItem(menuc, "10", "10€", 0);
					}
					if (money[client][0][0] >= 50)
					{
						AddMenuItem(menuc, "50", "50€", 0);
					}
					if (money[client][0][0] >= 100)
					{
						AddMenuItem(menuc, "100", "100€", 0);
					}
					if (money[client][0][0] >= 200)
					{
						AddMenuItem(menuc, "200", "200€", 0);
					}
					if (money[client][0][0] >= 500)
					{
						AddMenuItem(menuc, "500", "500€", 0);
					}
					if (money[client][0][0] >= 1000)
					{
						AddMenuItem(menuc, "1000", "1000€", 0);
					}
					if (money[client][0][0] >= 2000)
					{
						AddMenuItem(menuc, "2000", "2000€", 0);
					}
					if (money[client][0][0] >= 5000)
					{
						AddMenuItem(menuc, "5000", "5000€", 0);
					}
					if (money[client][0][0] >= 1)
					{
						AddMenuItem(menuc, "all", "all", 0);
					}
					DisplayMenu(menuc, client, 0);
				}
				CPrintToChat(client, "%s: Vous devez posséder un RIB.", "{red}[CSS-RP] ");
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public deposit_menu(Handle:menub, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[32];
		GetMenuItem(menub, param2, info, 32, 0, "", 0);
		new MoneyOffset = FindSendPropOffs("CCSPlayer", "m_iAccount");
		money[client] = GetEntData(client, MoneyOffset, 4);
		new deposit_somme = StringToInt(info, 10);
		if (0 > deposit_somme)
		{
			CPrintToChat(client, "%s: Vous ne pouvez pas déposer une somme négative.", "{red}[CSS-RP] ");
		}
		if (StrEqual(info, "all", true))
		{
			CPrintToChat(client, "%s: Vous avez déposer tout votre argent.", "{red}[CSS-RP] ");
			bank[client] = bank[client][0][0][money[client][0][0]];
			money[client] = 0;
			SetEntData(client, MoneyOffset, money[client][0][0], 4, true);
		}
		else
		{
			if (money[client][0][0] >= deposit_somme)
			{
				var1 = var1[0][0][deposit_somme];
				var2 = var2[0][0] - deposit_somme;
				CPrintToChat(client, "%s: Vous avez déposer %i€.", "{red}[CSS-RP] ", deposit_somme);
				SetEntData(client, MoneyOffset, money[client][0][0], 4, true);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menub);
		}
	}
	return 0;
}

public retired_menu(Handle:menuba, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[32];
		GetMenuItem(menuba, param2, info, 32, 0, "", 0);
		new MoneyOffset = FindSendPropOffs("CCSPlayer", "m_iAccount");
		new String:SteamId[32];
		GetClientAuthString(client, SteamId, 32, true);
		new difference = 65535 - money[client][0][0];
		new retired_somme = StringToInt(info, 10);
		if (bank[client][0][0] < retired_somme)
		{
			CPrintToChat(client, "%s: Vous n'avez pas assez d'argent pour cette transaction.", "{red}[CSS-RP] ");
		}
		new final_cash = money[client][0][0][retired_somme];
		if (final_cash <= 65535)
		{
			var1 = var1[0][0] - retired_somme;
			money[client] = final_cash;
			SetEntData(client, MoneyOffset, final_cash, 4, true);
			CPrintToChat(client, "%s: Tu as retiré %i€.", "{red}[CSS-RP] ", retired_somme);
		}
		if (final_cash > 65535)
		{
			var2 = var2[0][0] - difference;
			SetEntData(client, MoneyOffset, money[client][0][0], 4, true);
			CPrintToChat(client, "%s: Tu as retiré %i€.", "{red}[CSS-RP] ", difference);
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menuba);
		}
	}
	return 0;
}

public capital_menu(Handle:menub, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[32];
		GetMenuItem(menub, param2, info, 32, 0, "", 0);
		new MoneyOffset = FindSendPropOffs("CCSPlayer", "m_iAccount");
		money[client] = GetEntData(client, MoneyOffset, 4);
		new deposit_somme = StringToInt(info, 10);
		if (0 > deposit_somme)
		{
			CPrintToChat(client, "%s: Vous ne pouvez pas déposer une somme négative.", "{red}[CSS-RP] ");
		}
		if (StrEqual(info, "all", true))
		{
			CPrintToChat(client, "%s: Vous avez déposer tout votre argent.", "{red}[CSS-RP] ");
			capital[rankid[client][0][0]] = money[client][0][0][capital[rankid[client][0][0]][0][0]];
			money[client] = 0;
			SetEntData(client, MoneyOffset, money[client][0][0], 4, true);
		}
		else
		{
			if (money[client][0][0] >= deposit_somme)
			{
				var1 = var1[0][0][deposit_somme];
				var2 = var2[0][0] - deposit_somme;
				CPrintToChat(client, "%s: Vous avez déposer %i€.", "{red}[CSS-RP] ", deposit_somme);
				SetEntData(client, MoneyOffset, money[client][0][0], 4, true);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menub);
		}
	}
	return 0;
}

public Action:Timer_Kit(Handle:timer, client)
{
	if (IsClientInGame(client))
	{
		new kit = kitcrochetage[client][0][0][0];
		kitcrochetage[client] = kit;
		CPrintToChat(client, "%s: Vous avez pris un kit de crochetage [%i/20].", "{red}[CSS-RP] ", kitcrochetage[client]);
		OnKit[client] = 0;
		SetEntPropFloat(client, PropType:0, "m_flProgressBarStartTime", GetGameTime(), 0);
		SetEntProp(client, PropType:0, "m_iProgressBarDuration", any:0, 4, 0);
		SetEntityRenderColor(client, 255, 255, 255, 255);
		SetEntityMoveType(client, MoveType:2);
	}
	return Action:0;
}

public Action:Command_Infoscut(client, args)
{
	if (IsClientInGame(client))
	{
		if (levelcut[client][0][0] > 0)
		{
			var1 = 126644;
		}
		else
		{
			var1 = 126648;
		}
		CPrintToChat(client, "%s: Vous disposez de %i level%s cut.", "{red}[CSS-RP] ", levelcut[client], var1);
	}
	return Action:0;
}

public Action:Command_Contrat(client, Args)
{
	if (IsClientInGame(client))
	{
		if (IsPlayerAlive(client))
		{
			if (jobid[client][0][0] == 34)
			{
				acheteur[client] = GetClientAimTarget(client, true);
				TransactionWith[acheteur[client][0][0]] = client;
				TransactionWith[client] = acheteur[client][0][0];
				if (acheteur[client][0][0] != -1)
				{
					if (!oncontrat[client][0][0])
					{
						if (IsPlayerAlive(acheteur[client][0][0]))
						{
							if (!oncontrat[acheteur[client][0][0]][0][0])
							{
								CheckTueur(client);
							}
							else
							{
								CPrintToChat(client, "%s: Le joueur %N est déjà  en contrat.", "{red}[CSS-RP] ", TransactionWith[client]);
							}
						}
						else
						{
							CPrintToChat(client, "%s: Le joueur %N est décédé.", "{red}[CSS-RP] ", TransactionWith[client]);
						}
					}
					else
					{
						CPrintToChat(client, "%s: Vous êtes déjà  en contrat.", "{red}[CSS-RP] ");
					}
				}
				else
				{
					CPrintToChat(client, "%s: Vous devez visé un joueur.", "{red}[CSS-RP] ");
				}
			}
			else
			{
				CPrintToChat(client, "%s: Vous n'avez pas accès a cette commande.", "{red}[CSS-RP] ");
			}
		}
		CPrintToChat(client, "%s: Vous devez être en vie.", "{red}[CSS-RP] ");
	}
	return Action:0;
}

CheckTueur(client)
{
	if (client > 0)
	{
		decl String:sMenuText[64];
		sMenuText[0] = 0;
		new Handle:menu = CreateMenu(Menu_CheckTueur, MenuAction:28);
		SetMenuTitle(menu, "Choisissezsez le joueur :");
		SetMenuExitButton(menu, true);
		AddCible(menu);
		DisplayMenu(menu, client, 0);
	}
	return 0;
}

public AddCible(Handle:menu)
{
	decl String:user_id[12];
	decl String:name[32];
	decl String:display[48];
	new i = 1;
	while (i <= MaxClients)
	{
		if (IsClientInGame(i))
		{
			IntToString(GetClientUserId(i), user_id, 12);
			GetClientName(i, name, 32);
			Format(display, 47, "%s (%s)", name, user_id);
			AddMenuItem(menu, user_id, display, 0);
			i++;
		}
		i++;
	}
	return 0;
}

public Menu_CheckTueur(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[64];
		GetMenuItem(menu, param2, info, 64, 0, "", 0);
		new UserID = StringToInt(info, 10);
		cible[client] = GetClientOfUserId(UserID);
		new Handle:menub = CreateMenu(Menu_CibleChoose, MenuAction:28);
		SetMenuTitle(menub, "Voulez vous un contrat sur %N à 800€ ?", cible[client]);
		AddMenuItem(menub, "oui", "Oui je souhaite tuer la personne!", 0);
		AddMenuItem(menub, "non", "Non merci, c'est mon ami !", 0);
		DisplayMenu(menub, acheteur[client][0][0], 0);
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public Menu_CibleChoose(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[64];
		GetMenuItem(menu, param2, info, 64, 0, "", 0);
		new MoneyOffset = FindSendPropOffs("CCSPlayer", "m_iAccount");
		if (StrEqual(info, "oui", true))
		{
			if (money[client][0][0] >= 800)
			{
				if (TransactionWith[client][0][0] != cible[TransactionWith[client][0][0]][0][0])
				{
					if (client != cible[TransactionWith[client][0][0]][0][0])
					{
						CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
						CPrintToChat(client, "%s: Achat réalisé avec succès", "{red}[CSS-RP] ");
						money[client] = money[client][0][0][-200];
						AdCash(TransactionWith[client][0][0], 400);
						capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][100];
						Contrat[TransactionWith[client][0][0]] = CreateTimer(1, UpdateContrat, client, 1);
						GiveItem(TransactionWith[client][0][0]);
						SetEntData(client, MoneyOffset, money[client][0][0], 4, true);
					}
					else
					{
						CPrintToChat(client, "%s: Vous ne pouvez pas choisir vous même.", "{red}[CSS-RP] ");
					}
				}
				else
				{
					CPrintToChat(TransactionWith[client][0][0], "%s: Vous ne pouvez pas choisir vous même.", "{red}[CSS-RP] ");
				}
			}
			else
			{
				if (cb[client][0][0] == 1)
				{
					if (bank[client][0][0] >= 800)
					{
						if (TransactionWith[client][0][0] != cible[TransactionWith[client][0][0]][0][0])
						{
							if (client != cible[TransactionWith[client][0][0]][0][0])
							{
								CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a accepter.", "{red}[CSS-RP] ", client);
								CPrintToChat(client, "%s: Achat réalisé avec succès.", "{red}[CSS-RP] ");
								bank[client] = bank[client][0][0][-200];
								AdCash(TransactionWith[client][0][0], 400);
								capital[rankid[TransactionWith[client][0][0]][0][0]] = capital[rankid[TransactionWith[client][0][0]][0][0]][0][0][100];
								Contrat[TransactionWith[client][0][0]] = CreateTimer(1, UpdateContrat, TransactionWith[client][0][0], 1);
								GiveItem(TransactionWith[client][0][0]);
							}
							else
							{
								CPrintToChat(client, "%s: Vous ne pouvez pas choisir vous même.", "{red}[CSS-RP] ");
							}
						}
						else
						{
							CPrintToChat(TransactionWith[client][0][0], "%s: Vous ne pouvez pas choisir vous même.", "{red}[CSS-RP] ");
						}
					}
					else
					{
						CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
						CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
					}
				}
				CPrintToChat(client, "%s: Vous n'avez pas assez d'argent.", "{red}[CSS-RP] ");
				CPrintToChat(TransactionWith[client][0][0], "%s: Le joueur n'a pas assez d'argent.", "{red}[CSS-RP] ");
			}
		}
		else
		{
			if (StrEqual(info, "non", true))
			{
				CPrintToChat(TransactionWith[client][0][0], "%s: Le client %N a refusé cette achat.", "{red}[CSS-RP] ", client);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public Action:UpdateContrat(Handle:timer, client)
{
	if (IsClientConnected(client))
	{
		if (IsClientConnected(cible[client][0][0]))
		{
			if (g_jailtime[client][0][0])
			{
				fincontrat(client);
				CPrintToChat(client, "%s: Vous avez été mis en prison par un agent de police, contrat échoué.", "{red}[CSS-RP] ");
				CPrintToChat(TransactionWith[client][0][0], "%s: \x03%N ", "{red}[CSS-RP] ", client, cible[client]);
			}
			else
			{
				if (IsPlayerAlive(client))
				{
					oncontrat[client] = 1;
					oncontrat[cible[client][0][0]] = 1;
					new Float:tueur_vec[3] = 0;
					new Float:cible_vec[3] = 0;
					GetClientAbsOrigin(client, tueur_vec);
					GetClientAbsOrigin(cible[client][0][0], cible_vec);
					var1 = var1[45];
					var2 = var2[45];
					TE_SetupBeamPoints(tueur_vec, cible_vec, g_BeamSprite, g_modelHalo, 0, 1, 1, 10, 10, 1, 10, redColor, 50);
					TE_SendToClient(client, 0);
					if (HasKillCible[client][0][0])
					{
						fincontrat(client);
						CPrintToChat(client, "%s: Vous avez réussi votre contrat sur \x03%N", "{red}[CSS-RP] ", cible[client]);
						CPrintToChat(TransactionWith[client][0][0], "%s: \x03%N", "{red}[CSS-RP] ", client, cible[client]);
						ResetPerson(client);
					}
				}
				else
				{
					fincontrat(client);
					CPrintToChat(client, "%s: Vous avez tué pendant votre contrat, contrat échoué.", "{red}[CSS-RP] ");
					CPrintToChat(TransactionWith[client][0][0], "%s: \x03%N ", "{red}[CSS-RP] ", client, cible[client]);
				}
			}
		}
		fincontrat(client);
		CPrintToChat(client, "%s: Votre cible s'est deconnecté, contrat échoué.", "{red}[CSS-RP] ");
		CPrintToChat(TransactionWith[client][0][0], "%s: \x03%N", "{red}[CSS-RP] ", client, cible[client]);
	}
	return Action:0;
}

public fincontrat(client)
{
	if (IsClientInGame(client))
	{
		if (Contrat[client][0][0])
		{
			KillTimer(Contrat[client][0][0], false);
			Contrat[client] = 0;
		}
		oncontrat[client] = 0;
		oncontrat[cible[client][0][0]] = 0;
		HasKillCible[client] = 0;
		disarm(client);
		GivePlayerItem(client, "weapon_knife", 0);
		SetEntPropFloat(client, PropType:1, "m_flLaggedMovementValue", 1, 0);
		SetEntityGravity(client, 1);
	}
	return 0;
}

public GiveItem(client)
{
	new Handle:menub = CreateMenu(Menu_Weapon, MenuAction:28);
	SetMenuTitle(menub, "Choisissezsez votre bonus");
	AddMenuItem(menub, "1", "Deagle + 200 hp", 0);
	AddMenuItem(menub, "2", "Deagle + vitesse", 0);
	AddMenuItem(menub, "3", "Deagle + gravité", 0);
	AddMenuItem(menub, "4", "Tmp + 125 hp", 0);
	AddMenuItem(menub, "5", "Tmp + vitesse", 0);
	AddMenuItem(menub, "6", "Tmp + gravité", 0);
	DisplayMenu(menub, client, 0);
	return 0;
}

public Menu_Weapon(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[64];
		GetMenuItem(menu, param2, info, 64, 0, "", 0);
		if (StrEqual(info, "1", true))
		{
			GivePlayerItem(client, "weapon_deagle", 0);
			SetEntityHealth(client, 200);
		}
		else
		{
			if (StrEqual(info, "2", true))
			{
				GivePlayerItem(client, "weapon_deagle", 0);
				SetEntPropFloat(client, PropType:1, "m_flLaggedMovementValue", 1.5, 0);
			}
			if (StrEqual(info, "3", true))
			{
				GivePlayerItem(client, "weapon_deagle", 0);
				SetEntityGravity(client, 0.5);
			}
			if (StrEqual(info, "4", true))
			{
				GivePlayerItem(client, "weapon_TMP", 0);
				SetEntityHealth(client, 125);
			}
			if (StrEqual(info, "5", true))
			{
				GivePlayerItem(client, "weapon_TMP", 0);
				SetEntPropFloat(client, PropType:1, "m_flLaggedMovementValue", 1.5, 0);
			}
			if (StrEqual(info, "6", true))
			{
				GivePlayerItem(client, "weapon_TMP", 0);
				SetEntityGravity(client, 0.5);
			}
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public Action:TextMsg(UserMsg:msg_id, Handle:bf, players[], playersNum, bool:reliable, bool:init)
{
	decl String:msg[256];
	BfReadString(bf, msg, 256, false);
	if (StrContains(msg, "damage", false) == -1)
	{
		return Action:3;
	}
	return Action:0;
}

public NativeGetClientBank(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	return bank[client][0][0];
}

public NativeSetClientBank(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	new amount = GetNativeCell(2);
	bank[client] = amount;
	return 0;
}

public NativeSetClientMoney(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	new amount = GetNativeCell(2);
	money[client] = amount;
	return 0;
}

public Action:Command_Salaire(client, args)
{
	if (IsClientInGame(client))
	{
		if (IsPlayerAlive(client))
		{
			BuildSalaireMenu(client);
		}
	}
	return Action:0;
}

Handle:BuildSalaireMenu(client)
{
	new Handle:menub = CreateMenu(Menu_Salaire, MenuAction:28);
	SetMenuTitle(menub, "Modifier le salaire de :");
	if (jobid[client][0][0] == 1)
	{
		AddMenuItem(menub, "1", "Chef d'Etat", 0);
		AddMenuItem(menub, "2", "Agent CIA", 0);
		AddMenuItem(menub, "3", "Agent FBI", 0);
		AddMenuItem(menub, "4", "Policier", 0);
		AddMenuItem(menub, "5", "Gardien", 0);
	}
	else
	{
		if (jobid[client][0][0] == 6)
		{
			AddMenuItem(menub, "6", "Chef Mafia", 0);
			AddMenuItem(menub, "7", "Mafieux", 0);
			AddMenuItem(menub, "8", "Apprenti Mafieux", 0);
		}
		if (jobid[client][0][0] == 9)
		{
			AddMenuItem(menub, "9", "Chef Dealer", 0);
			AddMenuItem(menub, "10", "Dealer", 0);
			AddMenuItem(menub, "11", "Apprenti Dealer", 0);
		}
		if (jobid[client][0][0] == 12)
		{
			AddMenuItem(menub, "12", "Chef Coach", 0);
			AddMenuItem(menub, "13", "Coach", 0);
			AddMenuItem(menub, "14", "Apprenti Coach", 0);
		}
		if (jobid[client][0][0] == 15)
		{
			AddMenuItem(menub, "15", "D. Ikea", 0);
			AddMenuItem(menub, "16", "Vendeur Ikea", 0);
			AddMenuItem(menub, "17", "Apprenti Vendeur Ikea", 0);
		}
		if (jobid[client][0][0] == 18)
		{
			AddMenuItem(menub, "18", "Chef Armurerie", 0);
			AddMenuItem(menub, "19", "Armurier", 0);
			AddMenuItem(menub, "20", "Apprenti Armurier", 0);
		}
		if (jobid[client][0][0] == 21)
		{
			AddMenuItem(menub, "21", "Chef Loto", 0);
			AddMenuItem(menub, "22", "Vendeur de Tickets", 0);
			AddMenuItem(menub, "23", "Apprenti Vendeur de Tickets", 0);
		}
		if (jobid[client][0][0] == 24)
		{
			AddMenuItem(menub, "24", "Chef Banquier", 0);
			AddMenuItem(menub, "25", "Banquier", 0);
			AddMenuItem(menub, "26", "Apprenti Banquier", 0);
		}
		if (jobid[client][0][0] == 27)
		{
			AddMenuItem(menub, "27", "D. Hopital", 0);
			AddMenuItem(menub, "28", "Médecin", 0);
			AddMenuItem(menub, "29", "Infirmier", 0);
			AddMenuItem(menub, "30", "Chirurgien", 0);
		}
		if (jobid[client][0][0] == 31)
		{
			AddMenuItem(menub, "31", "Chef Artificier", 0);
			AddMenuItem(menub, "32", "Artificier", 0);
			AddMenuItem(menub, "33", "Apprenti Artificer", 0);
		}
		if (jobid[client][0][0] == 34)
		{
			AddMenuItem(menub, "34", "Chef Tueurs", 0);
			AddMenuItem(menub, "35", "Tueur d'élite", 0);
			AddMenuItem(menub, "36", "Tueur novice", 0);
		}
		if (jobid[client][0][0] == 37)
		{
			AddMenuItem(menub, "37", "D. Immobilier", 0);
			AddMenuItem(menub, "38", "V. Immobilier", 0);
			AddMenuItem(menub, "39", "Apprenti V. Immobilier", 0);
		}
		CPrintToChat(client, "%s: Vous devez être chef.", "{red}[CSS-RP] ");
	}
	DisplayMenu(menub, client, 0);
	return Handle:0;
}

public Menu_Salaire(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[64];
		GetMenuItem(menu, param2, info, 64, 0, "", 0);
		salarychoose[client] = StringToInt(info, 10);
		new Handle:menuc = CreateMenu(Menu_Choice, MenuAction:28);
		SetMenuTitle(menuc, "Nouveau salaire :");
		AddMenuItem(menuc, "500", "500€", 0);
		AddMenuItem(menuc, "400", "400€", 0);
		AddMenuItem(menuc, "300", "300€", 0);
		AddMenuItem(menuc, "200", "200€", 0);
		AddMenuItem(menuc, "100", "100€", 0);
		AddMenuItem(menuc, "50", "50€", 0);
		AddMenuItem(menuc, "0", "0€", 0);
		DisplayMenu(menuc, client, 0);
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public Menu_Choice(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction:4)
	{
		new String:info[64];
		GetMenuItem(menu, param2, info, 64, 0, "", 0);
		new salaryfinal = StringToInt(info, 10);
		new i = 1;
		while (i <= MaxClients)
		{
			if (IsClientInGame(i))
			{
				salaire[i] = salaryfinal;
				i++;
			}
			i++;
		}
		salarychoose[client] = 0;
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public Action:Timer_Pub(Handle:timer)
{
	switch (GetRandomInt(1, 4))
	{
		case 1:
		{
			CPrintToChatAll("%s: Devenez administrateur du serveur RP sur \x03%s", "{red}[CSS-RP] ", "Y04NN.fr");
		}
		case 2:
		{
			CPrintToChatAll("%s: Un problème avec un joueur? N'hésiter pas a utiliser le \x03/report", "{red}[CSS-RP] ");
		}
		case 3:
		{
			CPrintToChatAll("%s: La vente d'euros ou de métiers est interdit.", "{red}[CSS-RP] ");
		}
		case 4:
		{
			CPrintToChatAll("%s: Vous souhaitez acheter le mod roleplay ? Contacter-moi sur steam: \x03azik_56270", "{red}[CSS-RP] ");
		}
		default:
		{
		}
	}
	return Action:0;
}

public Action:Timer_Appart(Handle:timer, client)
{
	if (IsClientInGame(client))
	{
		if (0 < maisontime[client][0][0])
		{
			var1 = var1[0][0][0];
			if (maisontime[client][0][0])
			{
			}
			else
			{
				CPrintToChat(client, "%s: La location de votre appartement a expiré (Appartement N°%i).", "{red}[CSS-RP] ", maison[client]);
				maison[client] = 0;
				maisontime[client] = 0;
				g_appart[client] = 0;
				KillTimer(TimerAppart[client][0][0], false);
			}
		}
	}
	return Action:0;
}

public Action:Command_Time(client, args)
{
	if (IsClientInGame(client))
	{
		if (IsPlayerAlive(client))
		{
			CPrintToChat(client, "%s: Il vous reste %i secondes de location de votre appartement n°%i", "{red}[CSS-RP] ", maisontime[client], maison[client]);
		}
	}
	return Action:0;
}

public Action:Command_Forum(client, args)
{
	if (IsClientInGame(client))
	{
		if (IsPlayerAlive(client))
		{
			CPrintToChat(client, "%s: URL du Forum :\x03 %s", "{red}[CSS-RP] ", "Y04NN.fr");
			return Action:3;
		}
		CPrintToChat(client, "%s: Vous devez être en vie.", "{red}[CSS-RP] ");
		return Action:3;
	}
	return Action:0;
}

public KillLogic()
{
	new maxent = GetMaxEntities();
	new String:szClass[68];
	new i = MaxClients;
	while (i <= maxent)
	{
		if (IsValidEdict(i))
		{
			GetEdictClassname(i, szClass, 65);
			if (StrEqual("logic_auto", szClass, true))
			{
				RemoveEdict(i);
				i++;
			}
			i++;
		}
		i++;
	}
	return 0;
}

public Action:Command_Entity(client, args)
{
	new Ent = GetClientAimTarget(client, false);
	if (Ent != -1)
	{
		new String:classname[200];
		Entity_GetName(Ent, classname, 200);
		if (IsPlayerAlive(client))
		{
			if (0 < GetUserFlagBits(client))
			{
				CPrintToChat(client, "%s: Nom de l'entité <=> %s.", "{red}[CSS-RP] ", classname);
				return Action:3;
			}
			CPrintToChat(client, "%s: Vous n'avez pas accès à cette commande.", "{red}[CSS-RP] ");
		}
		else
		{
			CPrintToChat(client, "%s: Vous devez être en vie pour utiliser cette commande.", "{red}[CSS-RP] ");
		}
	}
	else
	{
		CPrintToChat(client, "%s: Vous devez viser une entité.", "{red}[CSS-RP] ");
	}
	return Action:0;
}

public ResetPerson(client)
{
	if (IsClientInGame(client))
	{
		SetEntPropFloat(client, PropType:1, "m_flLaggedMovementValue", 1, 0);
		SetEntityGravity(client, 1);
	}
	return 0;
}

