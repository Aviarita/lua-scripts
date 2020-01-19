local ffi = require("ffi")

ffi.cdef[[
	typedef struct {
		void* steam_client; // 0
		void* steam_user; // 1
		void* steam_friends; // 2
		void* steam_utils; // 3
		void* steam_matchmaking; // 4
		void* steam_user_stats; // 5
		void* steam_apps; // 6
		void* steam_matchmakingservers; // 7
		void* steam_networking; // 8
		void* steam_remotestorage; // 9
		void* steam_screenshots; // 10
		void* steam_http; // 11		
        void* steam_unidentifiedmessages; // 12
        void* steam_controller; // 13
        void* steam_ugc; // 14
        void* steam_applist; // 15
        void* steam_music; // 16
        void* steam_musicremote; // 17
        void* steam_htmlsurface; // 18
        void* steam_inventory; // 19
        void* steam_video; // 20
    } steam_api_ctx_t;

    typedef unsigned char uint8;
    typedef uint16_t uint16;
    typedef uint32_t uint32;
    typedef uint64_t uint64;
    typedef signed char int8;
    typedef int16_t int16;
    typedef int32_t int32;
    typedef int64_t int64;

	typedef int EUniverse;
	typedef int ENotificationPosition;
	typedef int ESteamAPICallFailure;
	typedef int EGamepadTextInputMode;
	typedef int EGamepadTextInputLineMode;
	typedef int ELobbyComparison;
	typedef int ELobbyDistanceFilter;
	typedef int ELobbyType;
	typedef int EChatEntryType;
	typedef int EVoiceResult;
	typedef int EBeginAuthSessionResult;
	typedef int EUserHasLicenseForAppResult;
	typedef int ELeaderboardSortMethod;
	typedef int ELeaderboardDisplayType;
	typedef int ELeaderboardDataRequest;
	typedef int ELeaderboardUploadScoreMethod;
	typedef int EPersonaState;
	typedef int EFriendRelationship;
	typedef int EActivateGameOverlayToWebPageMode;
	typedef int EOverlayToStoreFlag;
	typedef int EP2PSend;
	typedef int ESNetSocketConnectionType;
	typedef int ERemoteStoragePlatform;
	typedef int EUGCReadAction;
	typedef int ERemoteStoragePublishedFileVisibility;
	typedef int EWorkshopFileType;
	typedef int EWorkshopVideoProvider;
	typedef int EWorkshopFileAction;
	typedef int EWorkshopEnumerationType;
	typedef int EVRScreenshotType;
	typedef int EHTTPMethod;
	typedef int EControllerActionOrigin;
	typedef int ESteamControllerPad;
	typedef int ESteamInputType;
	typedef int EXboxOrigin;
	typedef int EUserUGCList;
	typedef int EUGCMatchingUGCType;
	typedef int EUserUGCListSortOrder;
	typedef int EUGCQuery;
	typedef int EResult;
	typedef int EItemStatistic;
	typedef int EItemPreviewType;
	typedef int EItemUpdateStatus;
	typedef int AudioPlayback_Status;
	typedef int EHTMLMouseButton;
	typedef int EHTMLKeyModifiers;
	typedef int HServerQuery;

	typedef int16 FriendsGroupID_t;

	typedef int32 SteamInventoryResult_t;
	typedef int32 SteamItemDef_t;

	typedef uint32 HSteamPipe;
	typedef uint32 HSteamUser;
	typedef uint32 HAuthTicket;
	typedef uint32 HHTMLBrowser;
	typedef uint32 DepotId_t;
	typedef uint32 AccountID_t;
	typedef uint32 RTime32;
	typedef uint32 AppId_t;
	typedef uint32 SNetSocket_t;
	typedef uint32 SNetListenSocket_t;
	typedef uint32 ScreenshotHandle;
	typedef uint32 HTTPRequestHandle;
	typedef uint32 HTTPCookieContainerHandle;

	typedef uint64 SteamAPICall_t;
	typedef uint64 SteamLeaderboard_t;
	typedef uint64 SteamLeaderboardEntries_t;
	typedef uint64 UGCHandle_t;
	typedef uint64 UGCQueryHandle_t;
	typedef uint64 UGCUpdateHandle_t;
	typedef uint64 UGCFileWriteStreamHandle_t;
	typedef uint64 PublishedFileUpdateHandle_t;
	typedef uint64 PublishedFileId_t;
	typedef uint64 ControllerHandle_t;
	typedef uint64 ControllerActionSetHandle_t;
	typedef uint64 ControllerDigitalActionHandle_t;
	typedef uint64 ControllerAnalogActionHandle_t;
	typedef uint64 SteamItemInstanceID_t;
	typedef uint64 SteamInventoryUpdateHandle_t;

	typedef void* CSteamID;
	typedef void* CGameID;
	typedef void* HServerListRequest;
	typedef void* ISteamMatchmakingServerListResponse;
	typedef void* ISteamMatchmakingPingResponse;
	typedef void* ISteamMatchmakingPlayersResponse;
	typedef void* ISteamMatchmakingRulesResponse;
	typedef void* gameserveritem_t;

    typedef void (__cdecl *SteamAPIWarningMessageHook_t)(int, const char *);

    struct MatchMakingKeyValuePair_t
    {
        char m_szKey[ 256 ];
        char m_szValue[ 256 ];
    };

    struct FriendGameInfo_t
    {
    	CGameID m_gameID;
    	uint32 m_unGameIP;
    	uint16 m_usGamePort;
    	uint16 m_usQueryPort;
    	CSteamID m_steamIDLobby;
    };

    struct P2PSessionState_t
    {
    	uint8 m_bConnectionActive;		
    	uint8 m_bConnecting;			
    	uint8 m_eP2PSessionError;		
    	uint8 m_bUsingRelay;			
    	int32 m_nBytesQueuedForSend;
    	int32 m_nPacketsQueuedForSend;
    	uint32 m_nRemoteIP;				
    	uint16 m_nRemotePort;			
    };

    struct SteamParamStringArray_t
    {
        const char ** m_ppStrings;
        int32 m_nNumStrings;
    };

    struct InputMotionData_t
    {
    	// Sensor-fused absolute rotation; will drift in heading
    	float rotQuatX;
    	float rotQuatY;
    	float rotQuatZ;
    	float rotQuatW;
    
    	// Positional acceleration
    	float posAccelX;
    	float posAccelY;
    	float posAccelZ;

    	// Angular velocity
    	float rotVelX;
    	float rotVelY;
    	float rotVelZ;
    };

    typedef struct InputMotionData_t ControllerMotionData_t;

    struct SteamUGCDetails_t
    {
        PublishedFileId_t m_nPublishedFileId;
        EResult m_eResult;												// The result of the operation.	
        EWorkshopFileType m_eFileType;									// Type of the file
        AppId_t m_nCreatorAppID;										// ID of the app that created this file.
        AppId_t m_nConsumerAppID;										// ID of the app that will consume this file.
        char m_rgchTitle[129];				// title of document
        char m_rgchDescription[8000];	// description of document
        uint64 m_ulSteamIDOwner;										// Steam ID of the user who created this content.
        uint32 m_rtimeCreated;											// time when the published file was created
        uint32 m_rtimeUpdated;											// time when the published file was last updated
        uint32 m_rtimeAddedToUserList;									// time when the user added the published file to their list (not always applicable)
        ERemoteStoragePublishedFileVisibility m_eVisibility;			// visibility
        bool m_bBanned;													// whether the file was banned
        bool m_bAcceptedForUse;											// developer has specifically flagged this item as accepted in the Workshop
        bool m_bTagsTruncated;											// whether the list of tags was too long to be returned in the provided buffer
        char m_rgchTags[1025];								// comma separated list of all tags associated with this file	
        // file/url information
        UGCHandle_t m_hFile;											// The handle of the primary file
        UGCHandle_t m_hPreviewFile;										// The handle of the preview file
        char m_pchFileName[260];							// The cloud filename of the primary file
        int32 m_nFileSize;												// Size of the primary file
        int32 m_nPreviewFileSize;										// Size of the preview file
        char m_rgchURL[256];						// URL (for a video or a website)
        // voting information
        uint32 m_unVotesUp;												// number of votes up
        uint32 m_unVotesDown;											// number of votes down
        float m_flScore;												// calculated score
        // collection details
        uint32 m_unNumChildren;							
    };

]]

-- credits sapphyrus
local function vmt_entry(instance, index, type)
    return ffi.cast(type, (ffi.cast("void***", instance)[0])[index])
end
local function vmt_thunk(index, typestring)
    local t = ffi.typeof(typestring)
    return function(instance, ...)
        assert(instance ~= nil)
        if instance then
            return vmt_entry(instance, index, t)(instance, ...)
        end
    end
end
-- 

local steam_ctx_match = client.find_signature("client_panorama.dll", "\xFF\x15\xCC\xCC\xCC\xCC\xB9\xCC\xCC\xCC\xCC\xE8\xCC\xCC\xCC\xCC\x6A") or error("steam_ctx")
local steam_ctx = ffi.cast("steam_api_ctx_t**", ffi.cast("char*", steam_ctx_match) + 7)[0] or error("steam_ctx not found")

local ISteamUtils_mt =  {
	this_ptr = ffi.cast("void***", steam_ctx.steam_utils),
	GetSecondsSinceAppActive = function(self)
		return vmt_thunk(0, "uint32(__thiscall*)(void*)")(self.this_ptr)
	end,
	GetSecondsSinceComputerActive = function(self)
		return vmt_thunk(1, "uint32(__thiscall*)(void*)")(self.this_ptr)
	end,
	GetConnectedUniverse = function(self)
		return vmt_thunk(2, "EUniverse(__thiscall*)(void*)")(self.this_ptr)
	end,
	GetServerRealTime = function(self)
		return vmt_thunk(3, "uint32(__thiscall*)(void*)")(self.this_ptr)
	end,
	GetIPCountry = function(self)
		return vmt_thunk(4, "const char*(__thiscall*)(void*)")(self.this_ptr)
	end,
	GetImageSize = function(self,  iImage, pnWidth, pnHeight)
		return vmt_thunk(5, "bool(__thiscall*)(void*, int, uint32*, uint32*)")(self.this_ptr,  iImage, pnWidth, pnHeight)
	end,
	GetImageRGBA = function(self,  iImage, pubDest, nDestBufferSize)
		return vmt_thunk(6, "bool(__thiscall*)(void*, int, uint8*, int)")(self.this_ptr,  iImage, pubDest, nDestBufferSize)
	end,
	GetCSERIPPort = function(self,  unIP, usPort)
		return vmt_thunk(7, "bool(__thiscall*)(void*, uint32*, uint16*)")(self.this_ptr,  unIP, usPort)
	end,
	GetCurrentBatteryPower = function(self)
		return vmt_thunk(8, "uint8(__thiscall*)(void*)")(self.this_ptr)
	end,
	GetAppID = function(self)
		return vmt_thunk(9, "uint32(__thiscall*)(void*)")(self.this_ptr)
	end,
	SetOverlayNotificationPosition = function(self,  eNotificationPosition)
		return vmt_thunk(10, "void(__thiscall*)(void*, ENotificationPosition)")(self.this_ptr,  eNotificationPosition)
	end,
	IsAPICallCompleted = function(self,  hSteamAPICall, pbFailed)
		return vmt_thunk(11, "bool(__thiscall*)(void*, SteamAPICall_t, bool*)")(self.this_ptr,  hSteamAPICall, pbFailed)
	end,
	GetAPICallFailureReason = function(self,  hSteamAPICall)
		return vmt_thunk(12, "ESteamAPICallFailure(__thiscall*)(void*, SteamAPICall_t)")(self.this_ptr,  hSteamAPICall)
	end,
	GetAPICallResult = function(self,  hSteamAPICall, pCallback, cubCallback, iCallbackExpected, pbFailed)
		return vmt_thunk(13, "bool(__thiscall*)(void*, SteamAPICall_t, void*, int, int, bool*)")(self.this_ptr,  hSteamAPICall, pCallback, cubCallback, iCallbackExpected, pbFailed)
	end,
	GetIPCCallCount = function(self)
		return vmt_thunk(14, "uint32(__thiscall*)(void*)")(self.this_ptr)
	end,
	SetWarningMessageHook = function(self,  pFunction)
		return vmt_thunk(15, "void(__thiscall*)(void*, SteamAPIWarningMessageHook_t)")(self.this_ptr,  pFunction)
	end,
	IsOverlayEnabled = function(self)
		return vmt_thunk(16, "bool(__thiscall*)(void*)")(self.this_ptr)
	end,
	BOverlayNeedsPresent = function(self)
		return vmt_thunk(17, "bool(__thiscall*)(void*)")(self.this_ptr)
	end,
	CheckFileSignature = function(self,  szFileName)
		return vmt_thunk(18, "SteamAPICall_t(__thiscall*)(void*, const char*)")(self.this_ptr,  szFileName)
	end,
	ShowGamepadTextInput = function(self,  eInputMode, eLineInputMode, pchDescription, unCharMax, pchExistingText)
		return vmt_thunk(19, "bool(__thiscall*)(void*, EGamepadTextInputMode, EGamepadTextInputLineMode, const char*, uint32, const char*)")(self.this_ptr,  eInputMode, eLineInputMode, pchDescription, unCharMax, pchExistingText)
	end,
	GetEnteredGamepadTextLength = function(self)
		return vmt_thunk(20, "uint32(__thiscall*)(void*)")(self.this_ptr)
	end,
	GetEnteredGamepadTextInput = function(self,  pchText, cchText)
		return vmt_thunk(21, "bool(__thiscall*)(void*, char*, uint32)")(self.this_ptr,  pchText, cchText)
	end,
	GetSteamUILanguage = function(self)
		return vmt_thunk(22, "const char*(__thiscall*)(void*)")(self.this_ptr)
	end,
	IsSteamRunningInVR = function(self)
		return vmt_thunk(23, "bool(__thiscall*)(void*)")(self.this_ptr)
	end,
	SetOverlayNotificationInset = function(self,  nHorizontalInset, nVerticalInset)
		return vmt_thunk(24, "void(__thiscall*)(void*, int, int)")(self.this_ptr,  nHorizontalInset, nVerticalInset)
	end,
	IsSteamInBigPictureMode = function(self)
		return vmt_thunk(25, "bool(__thiscall*)(void*)")(self.this_ptr)
	end,
	StartVRDashboard = function(self)
		return vmt_thunk(26, "void(__thiscall*)(void*)")(self.this_ptr)
	end,
	IsVRHeadsetStreamingEnabled = function(self)
		return vmt_thunk(27, "bool(__thiscall*)(void*)")(self.this_ptr)
	end,
	SetVRHeadsetStreamingEnabled = function(self,  bEnabled)
		return vmt_thunk(28, "void(__thiscall*)(void*, bool)")(self.this_ptr,  bEnabled)
	end,
}
local ISteamMatchmaking_mt =  {
	this_ptr = ffi.cast("void***", steam_ctx.steam_matchmaking),
	GetFavoriteGameCount = function(self)
		return vmt_thunk(0, "int(__thiscall*)(void*)")(self.this_ptr)
	end,
	GetFavoriteGame = function(self,  iGame, pnAppID, pnIP, pnConnPort, pnQueryPort, punFlags, pRTime32LastPlayedOnServer)
		return vmt_thunk(1, "bool(__thiscall*)(void*, int, AppId_t*, uint32*, uint16*, uint16*, uint32*, uint32*)")(self.this_ptr,  iGame, pnAppID, pnIP, pnConnPort, pnQueryPort, punFlags, pRTime32LastPlayedOnServer)
	end,
	AddFavoriteGame = function(self,  nAppID, nIP, nConnPort, nQueryPort, unFlags, rTime32LastPlayedOnServer)
		return vmt_thunk(2, "int(__thiscall*)(void*, AppId_t, uint32, uint16, uint16, uint32, uint32)")(self.this_ptr,  nAppID, nIP, nConnPort, nQueryPort, unFlags, rTime32LastPlayedOnServer)
	end,
	RemoveFavoriteGame = function(self,  nAppID, nIP, nConnPort, nQueryPort, unFlags)
		return vmt_thunk(3, "bool(__thiscall*)(void*, AppId_t, uint32, uint16, uint16, uint32)")(self.this_ptr,  nAppID, nIP, nConnPort, nQueryPort, unFlags)
	end,
	RequestLobbyList = function(self)
		return vmt_thunk(4, "SteamAPICall_t(__thiscall*)(void*)")(self.this_ptr)
	end,
	AddRequestLobbyListStringFilter = function(self,  pchKeyToMatch, pchValueToMatch, eComparisonType)
		return vmt_thunk(5, "void(__thiscall*)(void*, const char*, const char*, ELobbyComparison)")(self.this_ptr,  pchKeyToMatch, pchValueToMatch, eComparisonType)
	end,
	AddRequestLobbyListNumericalFilter = function(self,  pchKeyToMatch, nValueToMatch, eComparisonType)
		return vmt_thunk(6, "void(__thiscall*)(void*, const char*, int, ELobbyComparison)")(self.this_ptr,  pchKeyToMatch, nValueToMatch, eComparisonType)
	end,
	AddRequestLobbyListNearValueFilter = function(self,  pchKeyToMatch, nValueToBeCloseTo)
		return vmt_thunk(7, "void(__thiscall*)(void*, const char*, int)")(self.this_ptr,  pchKeyToMatch, nValueToBeCloseTo)
	end,
	AddRequestLobbyListFilterSlotsAvailable = function(self,  nSlotsAvailable)
		return vmt_thunk(8, "void(__thiscall*)(void*, int)")(self.this_ptr,  nSlotsAvailable)
	end,
	AddRequestLobbyListDistanceFilter = function(self,  eLobbyDistanceFilter)
		return vmt_thunk(9, "void(__thiscall*)(void*, ELobbyDistanceFilter)")(self.this_ptr,  eLobbyDistanceFilter)
	end,
	AddRequestLobbyListResultCountFilter = function(self,  cMaxResults)
		return vmt_thunk(10, "void(__thiscall*)(void*, int)")(self.this_ptr,  cMaxResults)
	end,
	AddRequestLobbyListCompatibleMembersFilter = function(self,  steamIDLobby)
		return vmt_thunk(11, "void(__thiscall*)(void*, CSteamID)")(self.this_ptr,  steamIDLobby)
	end,
	GetLobbyByIndex = function(self,  iLobby)
		return vmt_thunk(12, "CSteamID(__thiscall*)(void*, int)")(self.this_ptr,  iLobby)
	end,
	CreateLobby = function(self,  eLobbyType, cMaxMembers)
		return vmt_thunk(13, "SteamAPICall_t(__thiscall*)(void*, ELobbyType, int)")(self.this_ptr,  eLobbyType, cMaxMembers)
	end,
	JoinLobby = function(self,  steamIDLobby)
		return vmt_thunk(14, "SteamAPICall_t(__thiscall*)(void*, CSteamID)")(self.this_ptr,  steamIDLobby)
	end,
	LeaveLobby = function(self,  steamIDLobby)
		return vmt_thunk(15, "void(__thiscall*)(void*, CSteamID)")(self.this_ptr,  steamIDLobby)
	end,
	InviteUserToLobby = function(self,  steamIDLobby, steamIDInvitee)
		return vmt_thunk(16, "bool(__thiscall*)(void*, CSteamID, CSteamID)")(self.this_ptr,  steamIDLobby, steamIDInvitee)
	end,
	GetNumLobbyMembers = function(self,  steamIDLobby)
		return vmt_thunk(17, "int(__thiscall*)(void*, CSteamID)")(self.this_ptr,  steamIDLobby)
	end,
	GetLobbyMemberByIndex = function(self,  steamIDLobby, iMember)
		return vmt_thunk(18, "CSteamID(__thiscall*)(void*, CSteamID, int)")(self.this_ptr,  steamIDLobby, iMember)
	end,
	GetLobbyData = function(self,  steamIDLobby, pchKey)
		return vmt_thunk(19, "const char*(__thiscall*)(void*, CSteamID, const char*)")(self.this_ptr,  steamIDLobby, pchKey)
	end,
	SetLobbyData = function(self,  steamIDLobby, pchKey, pchValue)
		return vmt_thunk(20, "bool(__thiscall*)(void*, CSteamID, const char*, const char*)")(self.this_ptr,  steamIDLobby, pchKey, pchValue)
	end,
	GetLobbyDataCount = function(self,  steamIDLobby)
		return vmt_thunk(21, "int(__thiscall*)(void*, CSteamID)")(self.this_ptr,  steamIDLobby)
	end,
	GetLobbyDataByIndex = function(self,  steamIDLobby, iLobbyData, pchKey, cchKeyBufferSize, pchValue, cchValueBufferSize)
		return vmt_thunk(22, "bool(__thiscall*)(void*, CSteamID, int, char*, int, char*, int)")(self.this_ptr,  steamIDLobby, iLobbyData, pchKey, cchKeyBufferSize, pchValue, cchValueBufferSize)
	end,
	DeleteLobbyData = function(self,  steamIDLobby, pchKey)
		return vmt_thunk(23, "bool(__thiscall*)(void*, CSteamID, const char*)")(self.this_ptr,  steamIDLobby, pchKey)
	end,
	GetLobbyMemberData = function(self,  steamIDLobby, steamIDUser, pchKey)
		return vmt_thunk(24, "const char*(__thiscall*)(void*, CSteamID, CSteamID, const char*)")(self.this_ptr,  steamIDLobby, steamIDUser, pchKey)
	end,
	SetLobbyMemberData = function(self,  steamIDLobby, pchKey, pchValue)
		return vmt_thunk(25, "void(__thiscall*)(void*, CSteamID, const char*, const char*)")(self.this_ptr,  steamIDLobby, pchKey, pchValue)
	end,
	SendLobbyChatMsg = function(self,  steamIDLobby, pvMsgBody, cubMsgBody)
		return vmt_thunk(26, "bool(__thiscall*)(void*, CSteamID, const void*, int)")(self.this_ptr,  steamIDLobby, pvMsgBody, cubMsgBody)
	end,
	GetLobbyChatEntry = function(self,  steamIDLobby, iChatID, pSteamIDUser, pvData, cubData, peChatEntryType)
		return vmt_thunk(27, "int(__thiscall*)(void*, CSteamID, int, CSteamID*, void*, int, EChatEntryType*)")(self.this_ptr,  steamIDLobby, iChatID, pSteamIDUser, pvData, cubData, peChatEntryType)
	end,
	RequestLobbyData = function(self,  steamIDLobby)
		return vmt_thunk(28, "bool(__thiscall*)(void*, CSteamID)")(self.this_ptr,  steamIDLobby)
	end,
	SetLobbyGameServer = function(self,  steamIDLobby, unGameServerIP, unGameServerPort, steamIDGameServer)
		return vmt_thunk(29, "void(__thiscall*)(void*, CSteamID, uint32, uint16, CSteamID)")(self.this_ptr,  steamIDLobby, unGameServerIP, unGameServerPort, steamIDGameServer)
	end,
	GetLobbyGameServer = function(self,  steamIDLobby, punGameServerIP, punGameServerPort, psteamIDGameServer)
		return vmt_thunk(30, "bool(__thiscall*)(void*, CSteamID, uint32*, uint16*, CSteamID*)")(self.this_ptr,  steamIDLobby, punGameServerIP, punGameServerPort, psteamIDGameServer)
	end,
	SetLobbyMemberLimit = function(self,  steamIDLobby, cMaxMembers)
		return vmt_thunk(31, "bool(__thiscall*)(void*, CSteamID, int)")(self.this_ptr,  steamIDLobby, cMaxMembers)
	end,
	GetLobbyMemberLimit = function(self,  steamIDLobby)
		return vmt_thunk(32, "int(__thiscall*)(void*, CSteamID)")(self.this_ptr,  steamIDLobby)
	end,
	SetLobbyType = function(self,  steamIDLobby, eLobbyType)
		return vmt_thunk(33, "bool(__thiscall*)(void*, CSteamID, ELobbyType)")(self.this_ptr,  steamIDLobby, eLobbyType)
	end,
	SetLobbyJoinable = function(self,  steamIDLobby, bLobbyJoinable)
		return vmt_thunk(34, "bool(__thiscall*)(void*, CSteamID, bool)")(self.this_ptr,  steamIDLobby, bLobbyJoinable)
	end,
	GetLobbyOwner = function(self,  steamIDLobby)
		return vmt_thunk(35, "CSteamID(__thiscall*)(void*, CSteamID)")(self.this_ptr,  steamIDLobby)
	end,
}
local ISteamUser_mt =  {
	this_ptr = ffi.cast("void***", steam_ctx.steam_user),
	GetHSteamUser = function(self)
		return vmt_thunk(0, "HSteamUser(__thiscall*)(void*)")(self.this_ptr)
	end,
	BLoggedOn = function(self)
		return vmt_thunk(1, "bool(__thiscall*)(void*)")(self.this_ptr)
	end,
	GetSteamID = function(self)
		return vmt_thunk(2, "CSteamID(__thiscall*)(void*)")(self.this_ptr)
	end,
	InitiateGameConnection = function(self,  pAuthBlob, cbMaxAuthBlob, steamIDGameServer, unIPServer, usPortServer, bSecure)
		return vmt_thunk(3, "int(__thiscall*)(void*, void*, int, CSteamID, uint32, uint16, bool)")(self.this_ptr,  pAuthBlob, cbMaxAuthBlob, steamIDGameServer, unIPServer, usPortServer, bSecure)
	end,
	TerminateGameConnection = function(self,  unIPServer, usPortServer)
		return vmt_thunk(4, "void(__thiscall*)(void*, uint32, uint16)")(self.this_ptr,  unIPServer, usPortServer)
	end,
	TrackAppUsageEvent = function(self,  gameID, eAppUsageEvent, pchExtraInfo)
		return vmt_thunk(5, "void(__thiscall*)(void*, CGameID, int, const char*)")(self.this_ptr,  gameID, eAppUsageEvent, pchExtraInfo)
	end,
	GetUserDataFolder = function(self,  pchBuffer, cubBuffer)
		return vmt_thunk(6, "bool(__thiscall*)(void*, char*, int)")(self.this_ptr,  pchBuffer, cubBuffer)
	end,
	StartVoiceRecording = function(self)
		return vmt_thunk(7, "void(__thiscall*)(void*)")(self.this_ptr)
	end,
	StopVoiceRecording = function(self)
		return vmt_thunk(8, "void(__thiscall*)(void*)")(self.this_ptr)
	end,
	GetAvailableVoice = function(self,  pcbCompressed, pcbUncompressed_Deprecated, nUncompressedVoiceDesiredSampleRate_Deprecated)
		return vmt_thunk(9, "EVoiceResult(__thiscall*)(void*, uint32*, uint32*, uint32)")(self.this_ptr,  pcbCompressed, pcbUncompressed_Deprecated, nUncompressedVoiceDesiredSampleRate_Deprecated)
	end,
	GetVoice = function(self,  bWantCompressed, pDestBuffer, cbDestBufferSize, nBytesWritten, bWantUncompressed_Deprecated, pUncompressedDestBuffer_Deprecated, cbUncompressedDestBufferSize_Deprecated, nUncompressBytesWritten_Deprecated, nUncompressedVoiceDesiredSampleRate_Deprecated)
		return vmt_thunk(10, "EVoiceResult(__thiscall*)(void*, bool, void*, uint32, uint32*, bool, void*, uint32, uint32*, uint32)")(self.this_ptr,  bWantCompressed, pDestBuffer, cbDestBufferSize, nBytesWritten, bWantUncompressed_Deprecated, pUncompressedDestBuffer_Deprecated, cbUncompressedDestBufferSize_Deprecated, nUncompressBytesWritten_Deprecated, nUncompressedVoiceDesiredSampleRate_Deprecated)
	end,
	DecompressVoice = function(self,  pCompressed, cbCompressed, pDestBuffer, cbDestBufferSize, nBytesWritten, nDesiredSampleRate)
		return vmt_thunk(11, "EVoiceResult(__thiscall*)(void*, const void*, uint32, void*, uint32, uint32*, uint32)")(self.this_ptr,  pCompressed, cbCompressed, pDestBuffer, cbDestBufferSize, nBytesWritten, nDesiredSampleRate)
	end,
	GetVoiceOptimalSampleRate = function(self)
		return vmt_thunk(12, "uint32(__thiscall*)(void*)")(self.this_ptr)
	end,
	GetAuthSessionTicket = function(self,  pTicket, cbMaxTicket, pcbTicket)
		return vmt_thunk(13, "HAuthTicket(__thiscall*)(void*, void*, int, uint32*)")(self.this_ptr,  pTicket, cbMaxTicket, pcbTicket)
	end,
	BeginAuthSession = function(self,  pAuthTicket, cbAuthTicket, steamID)
		return vmt_thunk(14, "EBeginAuthSessionResult(__thiscall*)(void*, const void*, int, CSteamID)")(self.this_ptr,  pAuthTicket, cbAuthTicket, steamID)
	end,
	EndAuthSession = function(self,  steamID)
		return vmt_thunk(15, "void(__thiscall*)(void*, CSteamID)")(self.this_ptr,  steamID)
	end,
	CancelAuthTicket = function(self,  hAuthTicket)
		return vmt_thunk(16, "void(__thiscall*)(void*, HAuthTicket)")(self.this_ptr,  hAuthTicket)
	end,
	UserHasLicenseForApp = function(self,  steamID, appID)
		return vmt_thunk(17, "EUserHasLicenseForAppResult(__thiscall*)(void*, CSteamID, AppId_t)")(self.this_ptr,  steamID, appID)
	end,
	BIsBehindNAT = function(self)
		return vmt_thunk(18, "bool(__thiscall*)(void*)")(self.this_ptr)
	end,
	AdvertiseGame = function(self,  steamIDGameServer, unIPServer, usPortServer)
		return vmt_thunk(19, "void(__thiscall*)(void*, CSteamID, uint32, uint16)")(self.this_ptr,  steamIDGameServer, unIPServer, usPortServer)
	end,
	RequestEncryptedAppTicket = function(self,  pDataToInclude, cbDataToInclude)
		return vmt_thunk(20, "SteamAPICall_t(__thiscall*)(void*, void*, int)")(self.this_ptr,  pDataToInclude, cbDataToInclude)
	end,
	GetEncryptedAppTicket = function(self,  pTicket, cbMaxTicket, pcbTicket)
		return vmt_thunk(21, "bool(__thiscall*)(void*, void*, int, uint32*)")(self.this_ptr,  pTicket, cbMaxTicket, pcbTicket)
	end,
	GetGameBadgeLevel = function(self,  nSeries, bFoil)
		return vmt_thunk(22, "int(__thiscall*)(void*, int, bool)")(self.this_ptr,  nSeries, bFoil)
	end,
	GetPlayerSteamLevel = function(self)
		return vmt_thunk(23, "int(__thiscall*)(void*)")(self.this_ptr)
	end,
	RequestStoreAuthURL = function(self,  pchRedirectURL)
		return vmt_thunk(24, "SteamAPICall_t(__thiscall*)(void*, const char*)")(self.this_ptr,  pchRedirectURL)
	end,
	BIsPhoneVerified = function(self)
		return vmt_thunk(25, "bool(__thiscall*)(void*)")(self.this_ptr)
	end,
	BIsTwoFactorEnabled = function(self)
		return vmt_thunk(26, "bool(__thiscall*)(void*)")(self.this_ptr)
	end,
	BIsPhoneIdentifying = function(self)
		return vmt_thunk(27, "bool(__thiscall*)(void*)")(self.this_ptr)
	end,
	BIsPhoneRequiringVerification = function(self)
		return vmt_thunk(28, "bool(__thiscall*)(void*)")(self.this_ptr)
	end,
	GetMarketEligibility = function(self)
		return vmt_thunk(29, "SteamAPICall_t(__thiscall*)(void*)")(self.this_ptr)
	end,
	BIsPhoneRequiringVerification
 = function(self)
		return vmt_thunk(30, "bool(__thiscall*)(void*)")(self.this_ptr)
	end,
}
local ISteamUserStats_mt =  {
	this_ptr = ffi.cast("void***", steam_ctx.steam_user_stats),
	RequestCurrentStats = function(self)
		return vmt_thunk(0, "bool(__thiscall*)(void*)")(self.this_ptr)
	end,
	GetStat = function(self,  pchName, pData)
		return vmt_thunk(1, "bool(__thiscall*)(void*, const char*, int32*)")(self.this_ptr,  pchName, pData)
	end,
	GetStat = function(self,  pchName, pData)
		return vmt_thunk(2, "bool(__thiscall*)(void*, const char*, float*)")(self.this_ptr,  pchName, pData)
	end,
	SetStat = function(self,  pchName, nData)
		return vmt_thunk(3, "bool(__thiscall*)(void*, const char*, int32)")(self.this_ptr,  pchName, nData)
	end,
	SetStat = function(self,  pchName, fData)
		return vmt_thunk(4, "bool(__thiscall*)(void*, const char*, float)")(self.this_ptr,  pchName, fData)
	end,
	UpdateAvgRateStat = function(self,  pchName, flCountThisSession, dSessionLength)
		return vmt_thunk(5, "bool(__thiscall*)(void*, const char*, float, double)")(self.this_ptr,  pchName, flCountThisSession, dSessionLength)
	end,
	GetAchievement = function(self,  pchName, pbAchieved)
		return vmt_thunk(6, "bool(__thiscall*)(void*, const char*, bool*)")(self.this_ptr,  pchName, pbAchieved)
	end,
	SetAchievement = function(self,  pchName)
		return vmt_thunk(7, "bool(__thiscall*)(void*, const char*)")(self.this_ptr,  pchName)
	end,
	ClearAchievement = function(self,  pchName)
		return vmt_thunk(8, "bool(__thiscall*)(void*, const char*)")(self.this_ptr,  pchName)
	end,
	GetAchievementAndUnlockTime = function(self,  pchName, pbAchieved, punUnlockTime)
		return vmt_thunk(9, "bool(__thiscall*)(void*, const char*, bool*, uint32*)")(self.this_ptr,  pchName, pbAchieved, punUnlockTime)
	end,
	StoreStats = function(self)
		return vmt_thunk(10, "bool(__thiscall*)(void*)")(self.this_ptr)
	end,
	GetAchievementIcon = function(self,  pchName)
		return vmt_thunk(11, "int(__thiscall*)(void*, const char*)")(self.this_ptr,  pchName)
	end,
	GetAchievementDisplayAttribute = function(self,  pchName, pchKey)
		return vmt_thunk(12, "const char*(__thiscall*)(void*, const char*, const char*)")(self.this_ptr,  pchName, pchKey)
	end,
	IndicateAchievementProgress = function(self,  pchName, nCurProgress, nMaxProgress)
		return vmt_thunk(13, "bool(__thiscall*)(void*, const char*, uint32, uint32)")(self.this_ptr,  pchName, nCurProgress, nMaxProgress)
	end,
	GetNumAchievements = function(self)
		return vmt_thunk(14, "uint32(__thiscall*)(void*)")(self.this_ptr)
	end,
	GetAchievementName = function(self,  iAchievement)
		return vmt_thunk(15, "const char*(__thiscall*)(void*, uint32)")(self.this_ptr,  iAchievement)
	end,
	RequestUserStats = function(self,  steamIDUser)
		return vmt_thunk(16, "SteamAPICall_t(__thiscall*)(void*, CSteamID)")(self.this_ptr,  steamIDUser)
	end,
	GetUserStat = function(self,  steamIDUser, pchName, pData)
		return vmt_thunk(17, "bool(__thiscall*)(void*, CSteamID, const char*, int32*)")(self.this_ptr,  steamIDUser, pchName, pData)
	end,
	GetUserStat = function(self,  steamIDUser, pchName, pData)
		return vmt_thunk(18, "bool(__thiscall*)(void*, CSteamID, const char*, float*)")(self.this_ptr,  steamIDUser, pchName, pData)
	end,
	GetUserAchievement = function(self,  steamIDUser, pchName, pbAchieved)
		return vmt_thunk(19, "bool(__thiscall*)(void*, CSteamID, const char*, bool*)")(self.this_ptr,  steamIDUser, pchName, pbAchieved)
	end,
	GetUserAchievementAndUnlockTime = function(self,  steamIDUser, pchName, pbAchieved, punUnlockTime)
		return vmt_thunk(20, "bool(__thiscall*)(void*, CSteamID, const char*, bool*, uint32*)")(self.this_ptr,  steamIDUser, pchName, pbAchieved, punUnlockTime)
	end,
	ResetAllStats = function(self,  bAchievementsToo)
		return vmt_thunk(21, "bool(__thiscall*)(void*, bool)")(self.this_ptr,  bAchievementsToo)
	end,
	FindOrCreateLeaderboard = function(self,  pchLeaderboardName, eLeaderboardSortMethod, eLeaderboardDisplayType)
		return vmt_thunk(22, "SteamAPICall_t(__thiscall*)(void*, const char*, ELeaderboardSortMethod, ELeaderboardDisplayType)")(self.this_ptr,  pchLeaderboardName, eLeaderboardSortMethod, eLeaderboardDisplayType)
	end,
	FindLeaderboard = function(self,  pchLeaderboardName)
		return vmt_thunk(23, "SteamAPICall_t(__thiscall*)(void*, const char*)")(self.this_ptr,  pchLeaderboardName)
	end,
	GetLeaderboardName = function(self,  hSteamLeaderboard)
		return vmt_thunk(24, "const char*(__thiscall*)(void*, SteamLeaderboard_t)")(self.this_ptr,  hSteamLeaderboard)
	end,
	GetLeaderboardEntryCount = function(self,  hSteamLeaderboard)
		return vmt_thunk(25, "int(__thiscall*)(void*, SteamLeaderboard_t)")(self.this_ptr,  hSteamLeaderboard)
	end,
	GetLeaderboardSortMethod = function(self,  hSteamLeaderboard)
		return vmt_thunk(26, "ELeaderboardSortMethod(__thiscall*)(void*, SteamLeaderboard_t)")(self.this_ptr,  hSteamLeaderboard)
	end,
	GetLeaderboardDisplayType = function(self,  hSteamLeaderboard)
		return vmt_thunk(27, "ELeaderboardDisplayType(__thiscall*)(void*, SteamLeaderboard_t)")(self.this_ptr,  hSteamLeaderboard)
	end,
	DownloadLeaderboardEntries = function(self,  hSteamLeaderboard, eLeaderboardDataRequest, nRangeStart, nRangeEnd)
		return vmt_thunk(28, "SteamAPICall_t(__thiscall*)(void*, SteamLeaderboard_t, ELeaderboardDataRequest, int, int)")(self.this_ptr,  hSteamLeaderboard, eLeaderboardDataRequest, nRangeStart, nRangeEnd)
	end,
	DownloadLeaderboardEntriesForUsers = function(self,  hSteamLeaderboard)
		return vmt_thunk(29, "SteamAPICall_t(__thiscall*)(void*, SteamLeaderboard_t)")(self.this_ptr,  hSteamLeaderboard)
	end,
	GetDownloadedLeaderboardEntry = function(self,  hSteamLeaderboardEntries, index, pLeaderboardEntry, pDetails, cDetailsMax)
		return vmt_thunk(30, "bool(__thiscall*)(void*, SteamLeaderboardEntries_t, int, LeaderboardEntry_t*, int32*, int)")(self.this_ptr,  hSteamLeaderboardEntries, index, pLeaderboardEntry, pDetails, cDetailsMax)
	end,
	UploadLeaderboardScore = function(self,  hSteamLeaderboard, eLeaderboardUploadScoreMethod, nScore, pScoreDetails, cScoreDetailsCount)
		return vmt_thunk(31, "SteamAPICall_t(__thiscall*)(void*, SteamLeaderboard_t, ELeaderboardUploadScoreMethod, int32, const int32*, int)")(self.this_ptr,  hSteamLeaderboard, eLeaderboardUploadScoreMethod, nScore, pScoreDetails, cScoreDetailsCount)
	end,
	AttachLeaderboardUGC = function(self,  hSteamLeaderboard, hUGC)
		return vmt_thunk(32, "SteamAPICall_t(__thiscall*)(void*, SteamLeaderboard_t, UGCHandle_t)")(self.this_ptr,  hSteamLeaderboard, hUGC)
	end,
	GetNumberOfCurrentPlayers = function(self)
		return vmt_thunk(33, "SteamAPICall_t(__thiscall*)(void*)")(self.this_ptr)
	end,
	RequestGlobalAchievementPercentages = function(self)
		return vmt_thunk(34, "SteamAPICall_t(__thiscall*)(void*)")(self.this_ptr)
	end,
	GetMostAchievedAchievementInfo = function(self,  pchName, unNameBufLen, pflPercent, pbAchieved)
		return vmt_thunk(35, "int(__thiscall*)(void*, char*, uint32, float*, bool*)")(self.this_ptr,  pchName, unNameBufLen, pflPercent, pbAchieved)
	end,
	GetNextMostAchievedAchievementInfo = function(self,  iIteratorPrevious, pchName, unNameBufLen, pflPercent, pbAchieved)
		return vmt_thunk(36, "int(__thiscall*)(void*, int, char*, uint32, float*, bool*)")(self.this_ptr,  iIteratorPrevious, pchName, unNameBufLen, pflPercent, pbAchieved)
	end,
	GetAchievementAchievedPercent = function(self,  pchName, pflPercent)
		return vmt_thunk(37, "bool(__thiscall*)(void*, const char*, float*)")(self.this_ptr,  pchName, pflPercent)
	end,
	RequestGlobalStats = function(self,  nHistoryDays)
		return vmt_thunk(38, "SteamAPICall_t(__thiscall*)(void*, int)")(self.this_ptr,  nHistoryDays)
	end,
	GetGlobalStat = function(self,  pchStatName, pData)
		return vmt_thunk(39, "bool(__thiscall*)(void*, const char*, int64*)")(self.this_ptr,  pchStatName, pData)
	end,
	GetGlobalStat = function(self,  pchStatName, pData)
		return vmt_thunk(40, "bool(__thiscall*)(void*, const char*, double*)")(self.this_ptr,  pchStatName, pData)
	end,
	GetGlobalStatHistory = function(self,  pchStatName, pData, cubData)
		return vmt_thunk(41, "int32(__thiscall*)(void*, const char*, int64*, uint32)")(self.this_ptr,  pchStatName, pData, cubData)
	end,
	GetGlobalStatHistory = function(self,  pchStatName, pData, cubData)
		return vmt_thunk(42, "int32(__thiscall*)(void*, const char*, double*, uint32)")(self.this_ptr,  pchStatName, pData, cubData)
	end,
}
local ISteamFriends_mt =  {
	this_ptr = ffi.cast("void***", steam_ctx.steam_friends),
	GetPersonaName = function(self)
		return vmt_thunk(0, "const char*(__thiscall*)(void*)")(self.this_ptr)
	end,
	SetPersonaName = function(self,  pchPersonaName)
		return vmt_thunk(1, "SteamAPICall_t(__thiscall*)(void*, const char*)")(self.this_ptr,  pchPersonaName)
	end,
	GetPersonaState = function(self)
		return vmt_thunk(2, "EPersonaState(__thiscall*)(void*)")(self.this_ptr)
	end,
	GetFriendCount = function(self,  iFriendFlags)
		return vmt_thunk(3, "int(__thiscall*)(void*, int)")(self.this_ptr,  iFriendFlags)
	end,
	GetFriendByIndex = function(self,  iFriend, iFriendFlags)
		return vmt_thunk(4, "CSteamID(__thiscall*)(void*, int, int)")(self.this_ptr,  iFriend, iFriendFlags)
	end,
	GetFriendRelationship = function(self,  steamIDFriend)
		return vmt_thunk(5, "EFriendRelationship(__thiscall*)(void*, CSteamID)")(self.this_ptr,  steamIDFriend)
	end,
	GetFriendPersonaState = function(self,  steamIDFriend)
		return vmt_thunk(6, "EPersonaState(__thiscall*)(void*, CSteamID)")(self.this_ptr,  steamIDFriend)
	end,
	GetFriendPersonaName = function(self,  steamIDFriend)
		return vmt_thunk(7, "const char*(__thiscall*)(void*, CSteamID)")(self.this_ptr,  steamIDFriend)
	end,
	GetFriendGamePlayed = function(self,  steamIDFriend, pFriendGameInfo)
		return vmt_thunk(8, "bool(__thiscall*)(void*, CSteamID, FriendGameInfo_t*)")(self.this_ptr,  steamIDFriend, pFriendGameInfo)
	end,
	GetFriendPersonaNameHistory = function(self,  steamIDFriend, iPersonaName)
		return vmt_thunk(9, "const char*(__thiscall*)(void*, CSteamID, int)")(self.this_ptr,  steamIDFriend, iPersonaName)
	end,
	GetFriendSteamLevel = function(self,  steamIDFriend)
		return vmt_thunk(10, "int(__thiscall*)(void*, CSteamID)")(self.this_ptr,  steamIDFriend)
	end,
	GetPlayerNickname = function(self,  steamIDPlayer)
		return vmt_thunk(11, "const char*(__thiscall*)(void*, CSteamID)")(self.this_ptr,  steamIDPlayer)
	end,
	GetFriendsGroupCount = function(self)
		return vmt_thunk(12, "int(__thiscall*)(void*)")(self.this_ptr)
	end,
	GetFriendsGroupIDByIndex = function(self,  iFG)
		return vmt_thunk(13, "FriendsGroupID_t(__thiscall*)(void*, int)")(self.this_ptr,  iFG)
	end,
	GetFriendsGroupName = function(self,  friendsGroupID)
		return vmt_thunk(14, "const char*(__thiscall*)(void*, FriendsGroupID_t)")(self.this_ptr,  friendsGroupID)
	end,
	GetFriendsGroupMembersCount = function(self,  friendsGroupID)
		return vmt_thunk(15, "int(__thiscall*)(void*, FriendsGroupID_t)")(self.this_ptr,  friendsGroupID)
	end,
	GetFriendsGroupMembersList = function(self,  friendsGroupID, pOutSteamIDMembers, nMembersCount)
		return vmt_thunk(16, "void(__thiscall*)(void*, FriendsGroupID_t, CSteamID*, int)")(self.this_ptr,  friendsGroupID, pOutSteamIDMembers, nMembersCount)
	end,
	HasFriend = function(self,  steamIDFriend, iFriendFlags)
		return vmt_thunk(17, "bool(__thiscall*)(void*, CSteamID, int)")(self.this_ptr,  steamIDFriend, iFriendFlags)
	end,
	GetClanCount = function(self)
		return vmt_thunk(18, "int(__thiscall*)(void*)")(self.this_ptr)
	end,
	GetClanByIndex = function(self,  iClan)
		return vmt_thunk(19, "CSteamID(__thiscall*)(void*, int)")(self.this_ptr,  iClan)
	end,
	GetClanName = function(self,  steamIDClan)
		return vmt_thunk(20, "const char*(__thiscall*)(void*, CSteamID)")(self.this_ptr,  steamIDClan)
	end,
	GetClanTag = function(self,  steamIDClan)
		return vmt_thunk(21, "const char*(__thiscall*)(void*, CSteamID)")(self.this_ptr,  steamIDClan)
	end,
	GetClanActivityCounts = function(self,  steamIDClan, pnOnline, pnInGame, pnChatting)
		return vmt_thunk(22, "bool(__thiscall*)(void*, CSteamID, int*, int*, int*)")(self.this_ptr,  steamIDClan, pnOnline, pnInGame, pnChatting)
	end,
	DownloadClanActivityCounts = function(self,  psteamIDClans, cClansToRequest)
		return vmt_thunk(23, "SteamAPICall_t(__thiscall*)(void*, CSteamID*, int)")(self.this_ptr,  psteamIDClans, cClansToRequest)
	end,
	GetFriendCountFromSource = function(self,  steamIDSource)
		return vmt_thunk(24, "int(__thiscall*)(void*, CSteamID)")(self.this_ptr,  steamIDSource)
	end,
	GetFriendFromSourceByIndex = function(self,  steamIDSource, iFriend)
		return vmt_thunk(25, "CSteamID(__thiscall*)(void*, CSteamID, int)")(self.this_ptr,  steamIDSource, iFriend)
	end,
	IsUserInSource = function(self,  steamIDUser, steamIDSource)
		return vmt_thunk(26, "bool(__thiscall*)(void*, CSteamID, CSteamID)")(self.this_ptr,  steamIDUser, steamIDSource)
	end,
	SetInGameVoiceSpeaking = function(self,  steamIDUser, bSpeaking)
		return vmt_thunk(27, "void(__thiscall*)(void*, CSteamID, bool)")(self.this_ptr,  steamIDUser, bSpeaking)
	end,
	ActivateGameOverlay = function(self,  pchDialog)
		return vmt_thunk(28, "void(__thiscall*)(void*, const char*)")(self.this_ptr,  pchDialog)
	end,
	ActivateGameOverlayToUser = function(self,  pchDialog, steamID)
		return vmt_thunk(29, "void(__thiscall*)(void*, const char*, CSteamID)")(self.this_ptr,  pchDialog, steamID)
	end,
	ActivateGameOverlayToWebPage = function(self,  pchURL, eMode)
		return vmt_thunk(30, "void(__thiscall*)(void*, const char*, EActivateGameOverlayToWebPageMode)")(self.this_ptr,  pchURL, eMode)
	end,
	ActivateGameOverlayToStore = function(self,  nAppID, eFlag)
		return vmt_thunk(31, "void(__thiscall*)(void*, AppId_t, EOverlayToStoreFlag)")(self.this_ptr,  nAppID, eFlag)
	end,
	SetPlayedWith = function(self,  steamIDUserPlayedWith)
		return vmt_thunk(32, "void(__thiscall*)(void*, CSteamID)")(self.this_ptr,  steamIDUserPlayedWith)
	end,
	ActivateGameOverlayInviteDialog = function(self,  steamIDLobby)
		return vmt_thunk(33, "void(__thiscall*)(void*, CSteamID)")(self.this_ptr,  steamIDLobby)
	end,
	GetSmallFriendAvatar = function(self,  steamIDFriend)
		return vmt_thunk(34, "int(__thiscall*)(void*, CSteamID)")(self.this_ptr,  steamIDFriend)
	end,
	GetMediumFriendAvatar = function(self,  steamIDFriend)
		return vmt_thunk(35, "int(__thiscall*)(void*, CSteamID)")(self.this_ptr,  steamIDFriend)
	end,
	GetLargeFriendAvatar = function(self,  steamIDFriend)
		return vmt_thunk(36, "int(__thiscall*)(void*, CSteamID)")(self.this_ptr,  steamIDFriend)
	end,
	RequestUserInformation = function(self,  steamIDUser, bRequireNameOnly)
		return vmt_thunk(37, "bool(__thiscall*)(void*, CSteamID, bool)")(self.this_ptr,  steamIDUser, bRequireNameOnly)
	end,
	RequestClanOfficerList = function(self,  steamIDClan)
		return vmt_thunk(38, "SteamAPICall_t(__thiscall*)(void*, CSteamID)")(self.this_ptr,  steamIDClan)
	end,
	GetClanOwner = function(self,  steamIDClan)
		return vmt_thunk(39, "CSteamID(__thiscall*)(void*, CSteamID)")(self.this_ptr,  steamIDClan)
	end,
	GetClanOfficerCount = function(self,  steamIDClan)
		return vmt_thunk(40, "int(__thiscall*)(void*, CSteamID)")(self.this_ptr,  steamIDClan)
	end,
	GetClanOfficerByIndex = function(self,  steamIDClan, iOfficer)
		return vmt_thunk(41, "CSteamID(__thiscall*)(void*, CSteamID, int)")(self.this_ptr,  steamIDClan, iOfficer)
	end,
	GetUserRestrictions = function(self)
		return vmt_thunk(42, "uint32(__thiscall*)(void*)")(self.this_ptr)
	end,
	SetRichPresence = function(self,  pchKey, pchValue)
		return vmt_thunk(43, "bool(__thiscall*)(void*, const char*, const char*)")(self.this_ptr,  pchKey, pchValue)
	end,
	ClearRichPresence = function(self)
		return vmt_thunk(44, "void(__thiscall*)(void*)")(self.this_ptr)
	end,
	GetFriendRichPresence = function(self,  steamIDFriend, pchKey)
		return vmt_thunk(45, "const char*(__thiscall*)(void*, CSteamID, const char*)")(self.this_ptr,  steamIDFriend, pchKey)
	end,
	GetFriendRichPresenceKeyCount = function(self,  steamIDFriend)
		return vmt_thunk(46, "int(__thiscall*)(void*, CSteamID)")(self.this_ptr,  steamIDFriend)
	end,
	GetFriendRichPresenceKeyByIndex = function(self,  steamIDFriend, iKey)
		return vmt_thunk(47, "const char*(__thiscall*)(void*, CSteamID, int)")(self.this_ptr,  steamIDFriend, iKey)
	end,
	RequestFriendRichPresence = function(self,  steamIDFriend)
		return vmt_thunk(48, "void(__thiscall*)(void*, CSteamID)")(self.this_ptr,  steamIDFriend)
	end,
	InviteUserToGame = function(self,  steamIDFriend, pchConnectString)
		return vmt_thunk(49, "bool(__thiscall*)(void*, CSteamID, const char*)")(self.this_ptr,  steamIDFriend, pchConnectString)
	end,
	GetCoplayFriendCount = function(self)
		return vmt_thunk(50, "int(__thiscall*)(void*)")(self.this_ptr)
	end,
	GetCoplayFriend = function(self,  iCoplayFriend)
		return vmt_thunk(51, "CSteamID(__thiscall*)(void*, int)")(self.this_ptr,  iCoplayFriend)
	end,
	GetFriendCoplayTime = function(self,  steamIDFriend)
		return vmt_thunk(52, "int(__thiscall*)(void*, CSteamID)")(self.this_ptr,  steamIDFriend)
	end,
	GetFriendCoplayGame = function(self,  steamIDFriend)
		return vmt_thunk(53, "AppId_t(__thiscall*)(void*, CSteamID)")(self.this_ptr,  steamIDFriend)
	end,
	JoinClanChatRoom = function(self,  steamIDClan)
		return vmt_thunk(54, "SteamAPICall_t(__thiscall*)(void*, CSteamID)")(self.this_ptr,  steamIDClan)
	end,
	LeaveClanChatRoom = function(self,  steamIDClan)
		return vmt_thunk(55, "bool(__thiscall*)(void*, CSteamID)")(self.this_ptr,  steamIDClan)
	end,
	GetClanChatMemberCount = function(self,  steamIDClan)
		return vmt_thunk(56, "int(__thiscall*)(void*, CSteamID)")(self.this_ptr,  steamIDClan)
	end,
	GetChatMemberByIndex = function(self,  steamIDClan, iUser)
		return vmt_thunk(57, "CSteamID(__thiscall*)(void*, CSteamID, int)")(self.this_ptr,  steamIDClan, iUser)
	end,
	SendClanChatMessage = function(self,  steamIDClanChat, pchText)
		return vmt_thunk(58, "bool(__thiscall*)(void*, CSteamID, const char*)")(self.this_ptr,  steamIDClanChat, pchText)
	end,
	GetClanChatMessage = function(self,  steamIDClanChat, iMessage, prgchText, cchTextMax, peChatEntryType, psteamidChatter)
		return vmt_thunk(59, "int(__thiscall*)(void*, CSteamID, int, void*, int, EChatEntryType*, CSteamID*)")(self.this_ptr,  steamIDClanChat, iMessage, prgchText, cchTextMax, peChatEntryType, psteamidChatter)
	end,
	IsClanChatAdmin = function(self,  steamIDClanChat, steamIDUser)
		return vmt_thunk(60, "bool(__thiscall*)(void*, CSteamID, CSteamID)")(self.this_ptr,  steamIDClanChat, steamIDUser)
	end,
	IsClanChatWindowOpenInSteam = function(self,  steamIDClanChat)
		return vmt_thunk(61, "bool(__thiscall*)(void*, CSteamID)")(self.this_ptr,  steamIDClanChat)
	end,
	OpenClanChatWindowInSteam = function(self,  steamIDClanChat)
		return vmt_thunk(62, "bool(__thiscall*)(void*, CSteamID)")(self.this_ptr,  steamIDClanChat)
	end,
	CloseClanChatWindowInSteam = function(self,  steamIDClanChat)
		return vmt_thunk(63, "bool(__thiscall*)(void*, CSteamID)")(self.this_ptr,  steamIDClanChat)
	end,
	SetListenForFriendsMessages = function(self,  bInterceptEnabled)
		return vmt_thunk(64, "bool(__thiscall*)(void*, bool)")(self.this_ptr,  bInterceptEnabled)
	end,
	ReplyToFriendMessage = function(self,  steamIDFriend, pchMsgToSend)
		return vmt_thunk(65, "bool(__thiscall*)(void*, CSteamID, const char*)")(self.this_ptr,  steamIDFriend, pchMsgToSend)
	end,
	GetFriendMessage = function(self,  steamIDFriend, iMessageID, pvData, cubData, peChatEntryType)
		return vmt_thunk(66, "int(__thiscall*)(void*, CSteamID, int, void*, int, EChatEntryType*)")(self.this_ptr,  steamIDFriend, iMessageID, pvData, cubData, peChatEntryType)
	end,
	GetFollowerCount = function(self,  steamID)
		return vmt_thunk(67, "SteamAPICall_t(__thiscall*)(void*, CSteamID)")(self.this_ptr,  steamID)
	end,
	IsFollowing = function(self,  steamID)
		return vmt_thunk(68, "SteamAPICall_t(__thiscall*)(void*, CSteamID)")(self.this_ptr,  steamID)
	end,
	EnumerateFollowingList = function(self,  unStartIndex)
		return vmt_thunk(69, "SteamAPICall_t(__thiscall*)(void*, uint32)")(self.this_ptr,  unStartIndex)
	end,
	IsClanPublic = function(self,  steamIDClan)
		return vmt_thunk(70, "bool(__thiscall*)(void*, CSteamID)")(self.this_ptr,  steamIDClan)
	end,
	IsClanOfficialGameGroup = function(self,  steamIDClan)
		return vmt_thunk(71, "bool(__thiscall*)(void*, CSteamID)")(self.this_ptr,  steamIDClan)
	end,
	GetNumChatsWithUnreadPriorityMessages = function(self)
		return vmt_thunk(72, "int(__thiscall*)(void*)")(self.this_ptr)
	end,
}
local ISteamApps_mt =  {
	this_ptr = ffi.cast("void***", steam_ctx.steam_apps),
	BIsSubscribed = function(self)
		return vmt_thunk(0, "bool(__thiscall*)(void*)")(self.this_ptr)
	end,
	BIsLowViolence = function(self)
		return vmt_thunk(1, "bool(__thiscall*)(void*)")(self.this_ptr)
	end,
	BIsCybercafe = function(self)
		return vmt_thunk(2, "bool(__thiscall*)(void*)")(self.this_ptr)
	end,
	BIsVACBanned = function(self)
		return vmt_thunk(3, "bool(__thiscall*)(void*)")(self.this_ptr)
	end,
	GetCurrentGameLanguage = function(self)
		return vmt_thunk(4, "const char*(__thiscall*)(void*)")(self.this_ptr)
	end,
	GetAvailableGameLanguages = function(self)
		return vmt_thunk(5, "const char*(__thiscall*)(void*)")(self.this_ptr)
	end,
	BIsSubscribedApp = function(self,  appID)
		return vmt_thunk(6, "bool(__thiscall*)(void*, AppId_t)")(self.this_ptr,  appID)
	end,
	BIsDlcInstalled = function(self,  appID)
		return vmt_thunk(7, "bool(__thiscall*)(void*, AppId_t)")(self.this_ptr,  appID)
	end,
	GetEarliestPurchaseUnixTime = function(self,  nAppID)
		return vmt_thunk(8, "uint32(__thiscall*)(void*, AppId_t)")(self.this_ptr,  nAppID)
	end,
	BIsSubscribedFromFreeWeekend = function(self)
		return vmt_thunk(9, "bool(__thiscall*)(void*)")(self.this_ptr)
	end,
	GetDLCCount = function(self)
		return vmt_thunk(10, "int(__thiscall*)(void*)")(self.this_ptr)
	end,
	BGetDLCDataByIndex = function(self,  iDLC, pAppID, pbAvailable, pchName, cchNameBufferSize)
		return vmt_thunk(11, "bool(__thiscall*)(void*, int, AppId_t*, bool*, char*, int)")(self.this_ptr,  iDLC, pAppID, pbAvailable, pchName, cchNameBufferSize)
	end,
	InstallDLC = function(self,  nAppID)
		return vmt_thunk(12, "void(__thiscall*)(void*, AppId_t)")(self.this_ptr,  nAppID)
	end,
	UninstallDLC = function(self,  nAppID)
		return vmt_thunk(13, "void(__thiscall*)(void*, AppId_t)")(self.this_ptr,  nAppID)
	end,
	RequestAppProofOfPurchaseKey = function(self,  nAppID)
		return vmt_thunk(14, "void(__thiscall*)(void*, AppId_t)")(self.this_ptr,  nAppID)
	end,
	GetCurrentBetaName = function(self,  pchName, cchNameBufferSize)
		return vmt_thunk(15, "bool(__thiscall*)(void*, char*, int)")(self.this_ptr,  pchName, cchNameBufferSize)
	end,
	MarkContentCorrupt = function(self,  bMissingFilesOnly)
		return vmt_thunk(16, "bool(__thiscall*)(void*, bool)")(self.this_ptr,  bMissingFilesOnly)
	end,
	GetInstalledDepots = function(self,  appID, pvecDepots, cMaxDepots)
		return vmt_thunk(17, "uint32(__thiscall*)(void*, AppId_t, DepotId_t*, uint32)")(self.this_ptr,  appID, pvecDepots, cMaxDepots)
	end,
	GetAppInstallDir = function(self,  appID, pchFolder, cchFolderBufferSize)
		return vmt_thunk(18, "uint32(__thiscall*)(void*, AppId_t, char*, uint32)")(self.this_ptr,  appID, pchFolder, cchFolderBufferSize)
	end,
	BIsAppInstalled = function(self,  appID)
		return vmt_thunk(19, "bool(__thiscall*)(void*, AppId_t)")(self.this_ptr,  appID)
	end,
	GetAppOwner = function(self)
		return vmt_thunk(20, "CSteamID(__thiscall*)(void*)")(self.this_ptr)
	end,
	GetLaunchQueryParam = function(self,  pchKey)
		return vmt_thunk(21, "const char*(__thiscall*)(void*, const char*)")(self.this_ptr,  pchKey)
	end,
	GetDlcDownloadProgress = function(self,  nAppID, punBytesDownloaded, punBytesTotal)
		return vmt_thunk(22, "bool(__thiscall*)(void*, AppId_t, uint64*, uint64*)")(self.this_ptr,  nAppID, punBytesDownloaded, punBytesTotal)
	end,
	GetAppBuildId = function(self)
		return vmt_thunk(23, "int(__thiscall*)(void*)")(self.this_ptr)
	end,
	RequestAllProofOfPurchaseKeys = function(self)
		return vmt_thunk(24, "void(__thiscall*)(void*)")(self.this_ptr)
	end,
	GetFileDetails = function(self,  pszFileName)
		return vmt_thunk(25, "SteamAPICall_t(__thiscall*)(void*, const char*)")(self.this_ptr,  pszFileName)
	end,
	GetLaunchCommandLine = function(self,  pszCommandLine, cubCommandLine)
		return vmt_thunk(26, "int(__thiscall*)(void*, char*, int)")(self.this_ptr,  pszCommandLine, cubCommandLine)
	end,
	BIsSubscribedFromFamilySharing = function(self)
		return vmt_thunk(27, "bool(__thiscall*)(void*)")(self.this_ptr)
	end,
}
local ISteamMatchmakingServers_mt =  {
	this_ptr = ffi.cast("void***", steam_ctx.steam_matchmakingservers),
	RequestInternetServerList = function(self,  iApp, ppchFilters, nFilters, pRequestServersResponse)
		return vmt_thunk(0, "HServerListRequest(__thiscall*)(void*, AppId_t, MatchMakingKeyValuePair_t*, uint32, ISteamMatchmakingServerListResponse*)")(self.this_ptr,  iApp, ppchFilters, nFilters, pRequestServersResponse)
	end,
	RequestLANServerList = function(self,  iApp, pRequestServersResponse)
		return vmt_thunk(1, "HServerListRequest(__thiscall*)(void*, AppId_t, ISteamMatchmakingServerListResponse*)")(self.this_ptr,  iApp, pRequestServersResponse)
	end,
	RequestFriendsServerList = function(self,  iApp, ppchFilters, nFilters, pRequestServersResponse)
		return vmt_thunk(2, "HServerListRequest(__thiscall*)(void*, AppId_t, MatchMakingKeyValuePair_t*, uint32, ISteamMatchmakingServerListResponse*)")(self.this_ptr,  iApp, ppchFilters, nFilters, pRequestServersResponse)
	end,
	RequestFavoritesServerList = function(self,  iApp, ppchFilters, nFilters, pRequestServersResponse)
		return vmt_thunk(3, "HServerListRequest(__thiscall*)(void*, AppId_t, MatchMakingKeyValuePair_t*, uint32, ISteamMatchmakingServerListResponse*)")(self.this_ptr,  iApp, ppchFilters, nFilters, pRequestServersResponse)
	end,
	RequestHistoryServerList = function(self,  iApp, ppchFilters, nFilters, pRequestServersResponse)
		return vmt_thunk(4, "HServerListRequest(__thiscall*)(void*, AppId_t, MatchMakingKeyValuePair_t*, uint32, ISteamMatchmakingServerListResponse*)")(self.this_ptr,  iApp, ppchFilters, nFilters, pRequestServersResponse)
	end,
	RequestSpectatorServerList = function(self,  iApp, ppchFilters, nFilters, pRequestServersResponse)
		return vmt_thunk(5, "HServerListRequest(__thiscall*)(void*, AppId_t, MatchMakingKeyValuePair_t*, uint32, ISteamMatchmakingServerListResponse*)")(self.this_ptr,  iApp, ppchFilters, nFilters, pRequestServersResponse)
	end,
	ReleaseRequest = function(self,  hServerListRequest)
		return vmt_thunk(6, "void(__thiscall*)(void*, HServerListRequest)")(self.this_ptr,  hServerListRequest)
	end,
	GetServerDetails = function(self,  hRequest, iServer)
		return vmt_thunk(7, "gameserveritem_t*(__thiscall*)(void*, HServerListRequest, int)")(self.this_ptr,  hRequest, iServer)
	end,
	CancelQuery = function(self,  hRequest)
		return vmt_thunk(8, "void(__thiscall*)(void*, HServerListRequest)")(self.this_ptr,  hRequest)
	end,
	RefreshQuery = function(self,  hRequest)
		return vmt_thunk(9, "void(__thiscall*)(void*, HServerListRequest)")(self.this_ptr,  hRequest)
	end,
	IsRefreshing = function(self,  hRequest)
		return vmt_thunk(10, "bool(__thiscall*)(void*, HServerListRequest)")(self.this_ptr,  hRequest)
	end,
	GetServerCount = function(self,  hRequest)
		return vmt_thunk(11, "int(__thiscall*)(void*, HServerListRequest)")(self.this_ptr,  hRequest)
	end,
	RefreshServer = function(self,  hRequest, iServer)
		return vmt_thunk(12, "void(__thiscall*)(void*, HServerListRequest, int)")(self.this_ptr,  hRequest, iServer)
	end,
	PingServer = function(self,  unIP, usPort, pRequestServersResponse)
		return vmt_thunk(13, "HServerQuery(__thiscall*)(void*, uint32, uint16, ISteamMatchmakingPingResponse*)")(self.this_ptr,  unIP, usPort, pRequestServersResponse)
	end,
	PlayerDetails = function(self,  unIP, usPort, pRequestServersResponse)
		return vmt_thunk(14, "HServerQuery(__thiscall*)(void*, uint32, uint16, ISteamMatchmakingPlayersResponse*)")(self.this_ptr,  unIP, usPort, pRequestServersResponse)
	end,
	ServerRules = function(self,  unIP, usPort, pRequestServersResponse)
		return vmt_thunk(15, "HServerQuery(__thiscall*)(void*, uint32, uint16, ISteamMatchmakingRulesResponse*)")(self.this_ptr,  unIP, usPort, pRequestServersResponse)
	end,
	CancelServerQuery = function(self,  hServerQuery)
		return vmt_thunk(16, "void(__thiscall*)(void*, HServerQuery)")(self.this_ptr,  hServerQuery)
	end,
}
local ISteamNetworking_mt =  {
	this_ptr = ffi.cast("void***", steam_ctx.steam_networking),
	SendP2PPacket = function(self,  steamIDRemote, pubData, cubData, eP2PSendType, nChannel)
		return vmt_thunk(0, "bool(__thiscall*)(void*, CSteamID, const void*, uint32, EP2PSend, int)")(self.this_ptr,  steamIDRemote, pubData, cubData, eP2PSendType, nChannel)
	end,
	IsP2PPacketAvailable = function(self,  pcubMsgSize, nChannel)
		return vmt_thunk(1, "bool(__thiscall*)(void*, uint32*, int)")(self.this_ptr,  pcubMsgSize, nChannel)
	end,
	ReadP2PPacket = function(self,  pubDest, cubDest, pcubMsgSize, psteamIDRemote, nChannel)
		return vmt_thunk(2, "bool(__thiscall*)(void*, void*, uint32, uint32*, CSteamID*, int)")(self.this_ptr,  pubDest, cubDest, pcubMsgSize, psteamIDRemote, nChannel)
	end,
	AcceptP2PSessionWithUser = function(self,  steamIDRemote)
		return vmt_thunk(3, "bool(__thiscall*)(void*, CSteamID)")(self.this_ptr,  steamIDRemote)
	end,
	CloseP2PSessionWithUser = function(self,  steamIDRemote)
		return vmt_thunk(4, "bool(__thiscall*)(void*, CSteamID)")(self.this_ptr,  steamIDRemote)
	end,
	CloseP2PChannelWithUser = function(self,  steamIDRemote, nChannel)
		return vmt_thunk(5, "bool(__thiscall*)(void*, CSteamID, int)")(self.this_ptr,  steamIDRemote, nChannel)
	end,
	GetP2PSessionState = function(self,  steamIDRemote, pConnectionState)
		return vmt_thunk(6, "bool(__thiscall*)(void*, CSteamID, P2PSessionState_t*)")(self.this_ptr,  steamIDRemote, pConnectionState)
	end,
	AllowP2PPacketRelay = function(self,  bAllow)
		return vmt_thunk(7, "bool(__thiscall*)(void*, bool)")(self.this_ptr,  bAllow)
	end,
	CreateListenSocket = function(self,  nVirtualP2PPort, nIP, nPort, bAllowUseOfPacketRelay)
		return vmt_thunk(8, "SNetListenSocket_t(__thiscall*)(void*, int, uint32, uint16, bool)")(self.this_ptr,  nVirtualP2PPort, nIP, nPort, bAllowUseOfPacketRelay)
	end,
	CreateP2PConnectionSocket = function(self,  steamIDTarget, nVirtualPort, nTimeoutSec, bAllowUseOfPacketRelay)
		return vmt_thunk(9, "SNetSocket_t(__thiscall*)(void*, CSteamID, int, int, bool)")(self.this_ptr,  steamIDTarget, nVirtualPort, nTimeoutSec, bAllowUseOfPacketRelay)
	end,
	CreateConnectionSocket = function(self,  nIP, nPort, nTimeoutSec)
		return vmt_thunk(10, "SNetSocket_t(__thiscall*)(void*, uint32, uint16, int)")(self.this_ptr,  nIP, nPort, nTimeoutSec)
	end,
	DestroySocket = function(self,  hSocket, bNotifyRemoteEnd)
		return vmt_thunk(11, "bool(__thiscall*)(void*, SNetSocket_t, bool)")(self.this_ptr,  hSocket, bNotifyRemoteEnd)
	end,
	DestroyListenSocket = function(self,  hSocket, bNotifyRemoteEnd)
		return vmt_thunk(12, "bool(__thiscall*)(void*, SNetListenSocket_t, bool)")(self.this_ptr,  hSocket, bNotifyRemoteEnd)
	end,
	SendDataOnSocket = function(self,  hSocket, pubData, cubData, bReliable)
		return vmt_thunk(13, "bool(__thiscall*)(void*, SNetSocket_t, void*, uint32, bool)")(self.this_ptr,  hSocket, pubData, cubData, bReliable)
	end,
	IsDataAvailableOnSocket = function(self,  hSocket, pcubMsgSize)
		return vmt_thunk(14, "bool(__thiscall*)(void*, SNetSocket_t, uint32*)")(self.this_ptr,  hSocket, pcubMsgSize)
	end,
	RetrieveDataFromSocket = function(self,  hSocket, pubDest, cubDest, pcubMsgSize)
		return vmt_thunk(15, "bool(__thiscall*)(void*, SNetSocket_t, void*, uint32, uint32*)")(self.this_ptr,  hSocket, pubDest, cubDest, pcubMsgSize)
	end,
	IsDataAvailable = function(self,  hListenSocket, pcubMsgSize, phSocket)
		return vmt_thunk(16, "bool(__thiscall*)(void*, SNetListenSocket_t, uint32*, SNetSocket_t*)")(self.this_ptr,  hListenSocket, pcubMsgSize, phSocket)
	end,
	RetrieveData = function(self,  hListenSocket, pubDest, cubDest, pcubMsgSize, phSocket)
		return vmt_thunk(17, "bool(__thiscall*)(void*, SNetListenSocket_t, void*, uint32, uint32*, SNetSocket_t*)")(self.this_ptr,  hListenSocket, pubDest, cubDest, pcubMsgSize, phSocket)
	end,
	GetSocketInfo = function(self,  hSocket, pSteamIDRemote, peSocketStatus, punIPRemote, punPortRemote)
		return vmt_thunk(18, "bool(__thiscall*)(void*, SNetSocket_t, CSteamID*, int*, uint32*, uint16*)")(self.this_ptr,  hSocket, pSteamIDRemote, peSocketStatus, punIPRemote, punPortRemote)
	end,
	GetListenSocketInfo = function(self,  hListenSocket, pnIP, pnPort)
		return vmt_thunk(19, "bool(__thiscall*)(void*, SNetListenSocket_t, uint32*, uint16*)")(self.this_ptr,  hListenSocket, pnIP, pnPort)
	end,
	GetSocketConnectionType = function(self,  hSocket)
		return vmt_thunk(20, "ESNetSocketConnectionType(__thiscall*)(void*, SNetSocket_t)")(self.this_ptr,  hSocket)
	end,
	GetMaxPacketSize = function(self,  hSocket)
		return vmt_thunk(21, "int(__thiscall*)(void*, SNetSocket_t)")(self.this_ptr,  hSocket)
	end,
}
local ISteamRemoteStorage_mt =  {
	this_ptr = ffi.cast("void***", steam_ctx.steam_remotestorage),
	FileWrite = function(self,  pchFile, pvData, cubData)
		return vmt_thunk(0, "bool(__thiscall*)(void*, const char*, const void*, int32)")(self.this_ptr,  pchFile, pvData, cubData)
	end,
	FileRead = function(self,  pchFile, pvData, cubDataToRead)
		return vmt_thunk(1, "int32(__thiscall*)(void*, const char*, void*, int32)")(self.this_ptr,  pchFile, pvData, cubDataToRead)
	end,
	FileWriteAsync = function(self,  pchFile, pvData, cubData)
		return vmt_thunk(2, "SteamAPICall_t(__thiscall*)(void*, const char*, const void*, uint32)")(self.this_ptr,  pchFile, pvData, cubData)
	end,
	FileReadAsync = function(self,  pchFile, nOffset, cubToRead)
		return vmt_thunk(3, "SteamAPICall_t(__thiscall*)(void*, const char*, uint32, uint32)")(self.this_ptr,  pchFile, nOffset, cubToRead)
	end,
	FileReadAsyncComplete = function(self,  hReadCall, pvBuffer, cubToRead)
		return vmt_thunk(4, "bool(__thiscall*)(void*, SteamAPICall_t, void*, uint32)")(self.this_ptr,  hReadCall, pvBuffer, cubToRead)
	end,
	FileForget = function(self,  pchFile)
		return vmt_thunk(5, "bool(__thiscall*)(void*, const char*)")(self.this_ptr,  pchFile)
	end,
	FileDelete = function(self,  pchFile)
		return vmt_thunk(6, "bool(__thiscall*)(void*, const char*)")(self.this_ptr,  pchFile)
	end,
	FileShare = function(self,  pchFile)
		return vmt_thunk(7, "SteamAPICall_t(__thiscall*)(void*, const char*)")(self.this_ptr,  pchFile)
	end,
	SetSyncPlatforms = function(self,  pchFile, eRemoteStoragePlatform)
		return vmt_thunk(8, "bool(__thiscall*)(void*, const char*, ERemoteStoragePlatform)")(self.this_ptr,  pchFile, eRemoteStoragePlatform)
	end,
	FileWriteStreamOpen = function(self,  pchFile)
		return vmt_thunk(9, "UGCFileWriteStreamHandle_t(__thiscall*)(void*, const char*)")(self.this_ptr,  pchFile)
	end,
	FileWriteStreamWriteChunk = function(self,  writeHandle, pvData, cubData)
		return vmt_thunk(10, "bool(__thiscall*)(void*, UGCFileWriteStreamHandle_t, const void*, int32)")(self.this_ptr,  writeHandle, pvData, cubData)
	end,
	FileWriteStreamClose = function(self,  writeHandle)
		return vmt_thunk(11, "bool(__thiscall*)(void*, UGCFileWriteStreamHandle_t)")(self.this_ptr,  writeHandle)
	end,
	FileWriteStreamCancel = function(self,  writeHandle)
		return vmt_thunk(12, "bool(__thiscall*)(void*, UGCFileWriteStreamHandle_t)")(self.this_ptr,  writeHandle)
	end,
	FileExists = function(self,  pchFile)
		return vmt_thunk(13, "bool(__thiscall*)(void*, const char*)")(self.this_ptr,  pchFile)
	end,
	FilePersisted = function(self,  pchFile)
		return vmt_thunk(14, "bool(__thiscall*)(void*, const char*)")(self.this_ptr,  pchFile)
	end,
	GetFileSize = function(self,  pchFile)
		return vmt_thunk(15, "int32(__thiscall*)(void*, const char*)")(self.this_ptr,  pchFile)
	end,
	GetFileTimestamp = function(self,  pchFile)
		return vmt_thunk(16, "int64(__thiscall*)(void*, const char*)")(self.this_ptr,  pchFile)
	end,
	GetSyncPlatforms = function(self,  pchFile)
		return vmt_thunk(17, "ERemoteStoragePlatform(__thiscall*)(void*, const char*)")(self.this_ptr,  pchFile)
	end,
	GetFileCount = function(self)
		return vmt_thunk(18, "int32(__thiscall*)(void*)")(self.this_ptr)
	end,
	GetFileNameAndSize = function(self,  iFile, pnFileSizeInBytes)
		return vmt_thunk(19, "const char*(__thiscall*)(void*, int, int32*)")(self.this_ptr,  iFile, pnFileSizeInBytes)
	end,
	GetQuota = function(self,  pnTotalBytes, puAvailableBytes)
		return vmt_thunk(20, "bool(__thiscall*)(void*, uint64*, uint64*)")(self.this_ptr,  pnTotalBytes, puAvailableBytes)
	end,
	IsCloudEnabledForAccount = function(self)
		return vmt_thunk(21, "bool(__thiscall*)(void*)")(self.this_ptr)
	end,
	IsCloudEnabledForApp = function(self)
		return vmt_thunk(22, "bool(__thiscall*)(void*)")(self.this_ptr)
	end,
	SetCloudEnabledForApp = function(self,  bEnabled)
		return vmt_thunk(23, "void(__thiscall*)(void*, bool)")(self.this_ptr,  bEnabled)
	end,
	UGCDownload = function(self,  hContent, unPriority)
		return vmt_thunk(24, "SteamAPICall_t(__thiscall*)(void*, UGCHandle_t, uint32)")(self.this_ptr,  hContent, unPriority)
	end,
	GetUGCDownloadProgress = function(self,  hContent, pnBytesDownloaded, pnBytesExpected)
		return vmt_thunk(25, "bool(__thiscall*)(void*, UGCHandle_t, int32*, int32*)")(self.this_ptr,  hContent, pnBytesDownloaded, pnBytesExpected)
	end,
	GetUGCDetails = function(self,  hContent, pnAppID, ppchName, pnFileSizeInBytes, pSteamIDOwner)
		return vmt_thunk(26, "bool(__thiscall*)(void*, UGCHandle_t, AppId_t*, char*, int32*, CSteamID*)")(self.this_ptr,  hContent, pnAppID, ppchName, pnFileSizeInBytes, pSteamIDOwner)
	end,
	UGCRead = function(self,  hContent, pvData, cubDataToRead, cOffset, eAction)
		return vmt_thunk(27, "int32(__thiscall*)(void*, UGCHandle_t, void*, int32, uint32, EUGCReadAction)")(self.this_ptr,  hContent, pvData, cubDataToRead, cOffset, eAction)
	end,
	GetCachedUGCCount = function(self)
		return vmt_thunk(28, "int32(__thiscall*)(void*)")(self.this_ptr)
	end,
	PublishWorkshopFile = function(self,  pchFile, pchPreviewFile, nConsumerAppId, pchTitle, pchDescription, eVisibility, pTags, eWorkshopFileType)
		return vmt_thunk(30, "SteamAPICall_t(__thiscall*)(void*, const char*, const char*, AppId_t, const char*, const char*, ERemoteStoragePublishedFileVisibility, SteamParamStringArray_t*, EWorkshopFileType)")(self.this_ptr,  pchFile, pchPreviewFile, nConsumerAppId, pchTitle, pchDescription, eVisibility, pTags, eWorkshopFileType)
	end,
	CreatePublishedFileUpdateRequest = function(self,  unPublishedFileId)
		return vmt_thunk(31, "PublishedFileUpdateHandle_t(__thiscall*)(void*, PublishedFileId_t)")(self.this_ptr,  unPublishedFileId)
	end,
	UpdatePublishedFileFile = function(self,  updateHandle, pchFile)
		return vmt_thunk(32, "bool(__thiscall*)(void*, PublishedFileUpdateHandle_t, const char*)")(self.this_ptr,  updateHandle, pchFile)
	end,
	UpdatePublishedFilePreviewFile = function(self,  updateHandle, pchPreviewFile)
		return vmt_thunk(33, "bool(__thiscall*)(void*, PublishedFileUpdateHandle_t, const char*)")(self.this_ptr,  updateHandle, pchPreviewFile)
	end,
	UpdatePublishedFileTitle = function(self,  updateHandle, pchTitle)
		return vmt_thunk(34, "bool(__thiscall*)(void*, PublishedFileUpdateHandle_t, const char*)")(self.this_ptr,  updateHandle, pchTitle)
	end,
	UpdatePublishedFileDescription = function(self,  updateHandle, pchDescription)
		return vmt_thunk(35, "bool(__thiscall*)(void*, PublishedFileUpdateHandle_t, const char*)")(self.this_ptr,  updateHandle, pchDescription)
	end,
	UpdatePublishedFileVisibility = function(self,  updateHandle, eVisibility)
		return vmt_thunk(36, "bool(__thiscall*)(void*, PublishedFileUpdateHandle_t, ERemoteStoragePublishedFileVisibility)")(self.this_ptr,  updateHandle, eVisibility)
	end,
	UpdatePublishedFileTags = function(self,  updateHandle, pTags)
		return vmt_thunk(37, "bool(__thiscall*)(void*, PublishedFileUpdateHandle_t, SteamParamStringArray_t*)")(self.this_ptr,  updateHandle, pTags)
	end,
	CommitPublishedFileUpdate = function(self,  updateHandle)
		return vmt_thunk(38, "SteamAPICall_t(__thiscall*)(void*, PublishedFileUpdateHandle_t)")(self.this_ptr,  updateHandle)
	end,
	GetPublishedFileDetails = function(self,  unPublishedFileId, unMaxSecondsOld)
		return vmt_thunk(39, "SteamAPICall_t(__thiscall*)(void*, PublishedFileId_t, uint32)")(self.this_ptr,  unPublishedFileId, unMaxSecondsOld)
	end,
	DeletePublishedFile = function(self,  unPublishedFileId)
		return vmt_thunk(40, "SteamAPICall_t(__thiscall*)(void*, PublishedFileId_t)")(self.this_ptr,  unPublishedFileId)
	end,
	EnumerateUserPublishedFiles = function(self,  unStartIndex)
		return vmt_thunk(41, "SteamAPICall_t(__thiscall*)(void*, uint32)")(self.this_ptr,  unStartIndex)
	end,
	SubscribePublishedFile = function(self,  unPublishedFileId)
		return vmt_thunk(42, "SteamAPICall_t(__thiscall*)(void*, PublishedFileId_t)")(self.this_ptr,  unPublishedFileId)
	end,
	EnumerateUserSubscribedFiles = function(self,  unStartIndex)
		return vmt_thunk(43, "SteamAPICall_t(__thiscall*)(void*, uint32)")(self.this_ptr,  unStartIndex)
	end,
	UnsubscribePublishedFile = function(self,  unPublishedFileId)
		return vmt_thunk(44, "SteamAPICall_t(__thiscall*)(void*, PublishedFileId_t)")(self.this_ptr,  unPublishedFileId)
	end,
	UpdatePublishedFileSetChangeDescription = function(self,  updateHandle, pchChangeDescription)
		return vmt_thunk(45, "bool(__thiscall*)(void*, PublishedFileUpdateHandle_t, const char*)")(self.this_ptr,  updateHandle, pchChangeDescription)
	end,
	GetPublishedItemVoteDetails = function(self,  unPublishedFileId)
		return vmt_thunk(46, "SteamAPICall_t(__thiscall*)(void*, PublishedFileId_t)")(self.this_ptr,  unPublishedFileId)
	end,
	UpdateUserPublishedItemVote = function(self,  unPublishedFileId, bVoteUp)
		return vmt_thunk(47, "SteamAPICall_t(__thiscall*)(void*, PublishedFileId_t, bool)")(self.this_ptr,  unPublishedFileId, bVoteUp)
	end,
	GetUserPublishedItemVoteDetails = function(self,  unPublishedFileId)
		return vmt_thunk(48, "SteamAPICall_t(__thiscall*)(void*, PublishedFileId_t)")(self.this_ptr,  unPublishedFileId)
	end,
	EnumerateUserSharedWorkshopFiles = function(self,  steamId, unStartIndex, pRequiredTags, pExcludedTags)
		return vmt_thunk(49, "SteamAPICall_t(__thiscall*)(void*, CSteamID, uint32, SteamParamStringArray_t*, SteamParamStringArray_t*)")(self.this_ptr,  steamId, unStartIndex, pRequiredTags, pExcludedTags)
	end,
	PublishVideo = function(self,  eVideoProvider, pchVideoAccount, pchVideoIdentifier, pchPreviewFile, nConsumerAppId, pchTitle, pchDescription, eVisibility, pTags)
		return vmt_thunk(50, "SteamAPICall_t(__thiscall*)(void*, EWorkshopVideoProvider, const char*, const char*, const char*, AppId_t, const char*, const char*, ERemoteStoragePublishedFileVisibility, SteamParamStringArray_t*)")(self.this_ptr,  eVideoProvider, pchVideoAccount, pchVideoIdentifier, pchPreviewFile, nConsumerAppId, pchTitle, pchDescription, eVisibility, pTags)
	end,
	SetUserPublishedFileAction = function(self,  unPublishedFileId, eAction)
		return vmt_thunk(51, "SteamAPICall_t(__thiscall*)(void*, PublishedFileId_t, EWorkshopFileAction)")(self.this_ptr,  unPublishedFileId, eAction)
	end,
	EnumeratePublishedFilesByUserAction = function(self,  eAction, unStartIndex)
		return vmt_thunk(52, "SteamAPICall_t(__thiscall*)(void*, EWorkshopFileAction, uint32)")(self.this_ptr,  eAction, unStartIndex)
	end,
	EnumeratePublishedWorkshopFiles = function(self,  eEnumerationType, unStartIndex, unCount, unDays, pTags, pUserTags)
		return vmt_thunk(53, "SteamAPICall_t(__thiscall*)(void*, EWorkshopEnumerationType, uint32, uint32, uint32, SteamParamStringArray_t*, SteamParamStringArray_t*)")(self.this_ptr,  eEnumerationType, unStartIndex, unCount, unDays, pTags, pUserTags)
	end,
	UGCDownloadToLocation = function(self,  hContent, pchLocation, unPriority)
		return vmt_thunk(54, "SteamAPICall_t(__thiscall*)(void*, UGCHandle_t, const char*, uint32)")(self.this_ptr,  hContent, pchLocation, unPriority)
	end,
}
local ISteamScreenshots_mt =  {
	this_ptr = ffi.cast("void***", steam_ctx.steam_screenshots),
	WriteScreenshot = function(self,  pubRGB, cubRGB, nWidth, nHeight)
		return vmt_thunk(0, "ScreenshotHandle(__thiscall*)(void*, void*, uint32, int, int)")(self.this_ptr,  pubRGB, cubRGB, nWidth, nHeight)
	end,
	AddScreenshotToLibrary = function(self,  pchFilename, pchThumbnailFilename, nWidth, nHeight)
		return vmt_thunk(1, "ScreenshotHandle(__thiscall*)(void*, const char*, const char*, int, int)")(self.this_ptr,  pchFilename, pchThumbnailFilename, nWidth, nHeight)
	end,
	TriggerScreenshot = function(self)
		return vmt_thunk(2, "void(__thiscall*)(void*)")(self.this_ptr)
	end,
	HookScreenshots = function(self,  bHook)
		return vmt_thunk(3, "void(__thiscall*)(void*, bool)")(self.this_ptr,  bHook)
	end,
	SetLocation = function(self,  hScreenshot, pchLocation)
		return vmt_thunk(4, "bool(__thiscall*)(void*, ScreenshotHandle, const char*)")(self.this_ptr,  hScreenshot, pchLocation)
	end,
	TagUser = function(self,  hScreenshot, steamID)
		return vmt_thunk(5, "bool(__thiscall*)(void*, ScreenshotHandle, CSteamID)")(self.this_ptr,  hScreenshot, steamID)
	end,
	TagPublishedFile = function(self,  hScreenshot, unPublishedFileID)
		return vmt_thunk(6, "bool(__thiscall*)(void*, ScreenshotHandle, PublishedFileId_t)")(self.this_ptr,  hScreenshot, unPublishedFileID)
	end,
	IsScreenshotsHooked = function(self)
		return vmt_thunk(7, "bool(__thiscall*)(void*)")(self.this_ptr)
	end,
	AddVRScreenshotToLibrary = function(self,  eType, pchFilename, pchVRFilename)
		return vmt_thunk(8, "ScreenshotHandle(__thiscall*)(void*, EVRScreenshotType, const char*, const char*)")(self.this_ptr,  eType, pchFilename, pchVRFilename)
	end,
}
local ISteamHTTP_mt =  {
	this_ptr = ffi.cast("void***", steam_ctx.steam_http),
	CreateHTTPRequest = function(self,  eHTTPRequestMethod, pchAbsoluteURL)
		return vmt_thunk(0, "HTTPRequestHandle(__thiscall*)(void*, EHTTPMethod, const char*)")(self.this_ptr,  eHTTPRequestMethod, pchAbsoluteURL)
	end,
	SetHTTPRequestContextValue = function(self,  hRequest, ulContextValue)
		return vmt_thunk(1, "bool(__thiscall*)(void*, HTTPRequestHandle, uint64)")(self.this_ptr,  hRequest, ulContextValue)
	end,
	SetHTTPRequestNetworkActivityTimeout = function(self,  hRequest, unTimeoutSeconds)
		return vmt_thunk(2, "bool(__thiscall*)(void*, HTTPRequestHandle, uint32)")(self.this_ptr,  hRequest, unTimeoutSeconds)
	end,
	SetHTTPRequestHeaderValue = function(self,  hRequest, pchHeaderName, pchHeaderValue)
		return vmt_thunk(3, "bool(__thiscall*)(void*, HTTPRequestHandle, const char*, const char*)")(self.this_ptr,  hRequest, pchHeaderName, pchHeaderValue)
	end,
	SetHTTPRequestGetOrPostParameter = function(self,  hRequest, pchParamName, pchParamValue)
		return vmt_thunk(4, "bool(__thiscall*)(void*, HTTPRequestHandle, const char*, const char*)")(self.this_ptr,  hRequest, pchParamName, pchParamValue)
	end,
	SendHTTPRequest = function(self,  hRequest, pCallHandle)
		return vmt_thunk(5, "bool(__thiscall*)(void*, HTTPRequestHandle, SteamAPICall_t*)")(self.this_ptr,  hRequest, pCallHandle)
	end,
	SendHTTPRequestAndStreamResponse = function(self,  hRequest, pCallHandle)
		return vmt_thunk(6, "bool(__thiscall*)(void*, HTTPRequestHandle, SteamAPICall_t*)")(self.this_ptr,  hRequest, pCallHandle)
	end,
	DeferHTTPRequest = function(self,  hRequest)
		return vmt_thunk(7, "bool(__thiscall*)(void*, HTTPRequestHandle)")(self.this_ptr,  hRequest)
	end,
	PrioritizeHTTPRequest = function(self,  hRequest)
		return vmt_thunk(8, "bool(__thiscall*)(void*, HTTPRequestHandle)")(self.this_ptr,  hRequest)
	end,
	GetHTTPResponseHeaderSize = function(self,  hRequest, pchHeaderName, unResponseHeaderSize)
		return vmt_thunk(9, "bool(__thiscall*)(void*, HTTPRequestHandle, const char*, uint32*)")(self.this_ptr,  hRequest, pchHeaderName, unResponseHeaderSize)
	end,
	GetHTTPResponseHeaderValue = function(self,  hRequest, pchHeaderName, pHeaderValueBuffer, unBufferSize)
		return vmt_thunk(10, "bool(__thiscall*)(void*, HTTPRequestHandle, const char*, uint8*, uint32)")(self.this_ptr,  hRequest, pchHeaderName, pHeaderValueBuffer, unBufferSize)
	end,
	GetHTTPResponseBodySize = function(self,  hRequest, unBodySize)
		return vmt_thunk(11, "bool(__thiscall*)(void*, HTTPRequestHandle, uint32*)")(self.this_ptr,  hRequest, unBodySize)
	end,
	GetHTTPResponseBodyData = function(self,  hRequest, pBodyDataBuffer, unBufferSize)
		return vmt_thunk(12, "bool(__thiscall*)(void*, HTTPRequestHandle, uint8*, uint32)")(self.this_ptr,  hRequest, pBodyDataBuffer, unBufferSize)
	end,
	GetHTTPStreamingResponseBodyData = function(self,  hRequest, cOffset, pBodyDataBuffer, unBufferSize)
		return vmt_thunk(13, "bool(__thiscall*)(void*, HTTPRequestHandle, uint32, uint8*, uint32)")(self.this_ptr,  hRequest, cOffset, pBodyDataBuffer, unBufferSize)
	end,
	ReleaseHTTPRequest = function(self,  hRequest)
		return vmt_thunk(14, "bool(__thiscall*)(void*, HTTPRequestHandle)")(self.this_ptr,  hRequest)
	end,
	GetHTTPDownloadProgressPct = function(self,  hRequest, pflPercentOut)
		return vmt_thunk(15, "bool(__thiscall*)(void*, HTTPRequestHandle, float*)")(self.this_ptr,  hRequest, pflPercentOut)
	end,
	SetHTTPRequestRawPostBody = function(self,  hRequest, pchContentType, pubBody, unBodyLen)
		return vmt_thunk(16, "bool(__thiscall*)(void*, HTTPRequestHandle, const char*, uint8*, uint32)")(self.this_ptr,  hRequest, pchContentType, pubBody, unBodyLen)
	end,
	CreateCookieContainer = function(self,  bAllowResponsesToModify)
		return vmt_thunk(17, "HTTPCookieContainerHandle(__thiscall*)(void*, bool)")(self.this_ptr,  bAllowResponsesToModify)
	end,
	ReleaseCookieContainer = function(self,  hCookieContainer)
		return vmt_thunk(18, "bool(__thiscall*)(void*, HTTPCookieContainerHandle)")(self.this_ptr,  hCookieContainer)
	end,
	SetCookie = function(self,  hCookieContainer, pchHost, pchUrl, pchCookie)
		return vmt_thunk(19, "bool(__thiscall*)(void*, HTTPCookieContainerHandle, const char*, const char*, const char*)")(self.this_ptr,  hCookieContainer, pchHost, pchUrl, pchCookie)
	end,
	SetHTTPRequestCookieContainer = function(self,  hRequest, hCookieContainer)
		return vmt_thunk(20, "bool(__thiscall*)(void*, HTTPRequestHandle, HTTPCookieContainerHandle)")(self.this_ptr,  hRequest, hCookieContainer)
	end,
	SetHTTPRequestUserAgentInfo = function(self,  hRequest, pchUserAgentInfo)
		return vmt_thunk(21, "bool(__thiscall*)(void*, HTTPRequestHandle, const char*)")(self.this_ptr,  hRequest, pchUserAgentInfo)
	end,
	SetHTTPRequestRequiresVerifiedCertificate = function(self,  hRequest, bRequireVerifiedCertificate)
		return vmt_thunk(22, "bool(__thiscall*)(void*, HTTPRequestHandle, bool)")(self.this_ptr,  hRequest, bRequireVerifiedCertificate)
	end,
	SetHTTPRequestAbsoluteTimeoutMS = function(self,  hRequest, unMilliseconds)
		return vmt_thunk(23, "bool(__thiscall*)(void*, HTTPRequestHandle, uint32)")(self.this_ptr,  hRequest, unMilliseconds)
	end,
	GetHTTPRequestWasTimedOut = function(self,  hRequest, pbWasTimedOut)
		return vmt_thunk(24, "bool(__thiscall*)(void*, HTTPRequestHandle, bool*)")(self.this_ptr,  hRequest, pbWasTimedOut)
	end,
}
local ISteamController_mt =  {
	this_ptr = ffi.cast("void***", steam_ctx.steam_controller),
	Init = function(self)
		return vmt_thunk(0, "bool(__thiscall*)(void*)")(self.this_ptr)
	end,
	Shutdown = function(self)
		return vmt_thunk(1, "bool(__thiscall*)(void*)")(self.this_ptr)
	end,
	RunFrame = function(self)
		return vmt_thunk(2, "void(__thiscall*)(void*)")(self.this_ptr)
	end,
	GetConnectedControllers = function(self,  handlesOut)
		return vmt_thunk(3, "int(__thiscall*)(void*, ControllerHandle_t*)")(self.this_ptr,  handlesOut)
	end,
	GetActionSetHandle = function(self,  pszActionSetName)
		return vmt_thunk(4, "ControllerActionSetHandle_t(__thiscall*)(void*, const char*)")(self.this_ptr,  pszActionSetName)
	end,
	ActivateActionSet = function(self,  controllerHandle, actionSetHandle)
		return vmt_thunk(5, "void(__thiscall*)(void*, ControllerHandle_t, ControllerActionSetHandle_t)")(self.this_ptr,  controllerHandle, actionSetHandle)
	end,
	GetCurrentActionSet = function(self,  controllerHandle)
		return vmt_thunk(6, "ControllerActionSetHandle_t(__thiscall*)(void*, ControllerHandle_t)")(self.this_ptr,  controllerHandle)
	end,
	ActivateActionSetLayer = function(self,  controllerHandle, actionSetLayerHandle)
		return vmt_thunk(7, "void(__thiscall*)(void*, ControllerHandle_t, ControllerActionSetHandle_t)")(self.this_ptr,  controllerHandle, actionSetLayerHandle)
	end,
	DeactivateActionSetLayer = function(self,  controllerHandle, actionSetLayerHandle)
		return vmt_thunk(8, "void(__thiscall*)(void*, ControllerHandle_t, ControllerActionSetHandle_t)")(self.this_ptr,  controllerHandle, actionSetLayerHandle)
	end,
	DeactivateAllActionSetLayers = function(self,  controllerHandle)
		return vmt_thunk(9, "void(__thiscall*)(void*, ControllerHandle_t)")(self.this_ptr,  controllerHandle)
	end,
	GetActiveActionSetLayers = function(self,  controllerHandle, handlesOut)
		return vmt_thunk(10, "int(__thiscall*)(void*, ControllerHandle_t, ControllerActionSetHandle_t*)")(self.this_ptr,  controllerHandle, handlesOut)
	end,
	GetDigitalActionHandle = function(self,  pszActionName)
		return vmt_thunk(11, "ControllerDigitalActionHandle_t(__thiscall*)(void*, const char*)")(self.this_ptr,  pszActionName)
	end,
	GetDigitalActionData = function(self,  controllerHandle, digitalActionHandle)
		return vmt_thunk(12, "ControllerDigitalActionData_t(__thiscall*)(void*, ControllerHandle_t, ControllerDigitalActionHandle_t)")(self.this_ptr,  controllerHandle, digitalActionHandle)
	end,
	GetDigitalActionOrigins = function(self,  controllerHandle, actionSetHandle, digitalActionHandle, originsOut)
		return vmt_thunk(13, "int(__thiscall*)(void*, ControllerHandle_t, ControllerActionSetHandle_t, ControllerDigitalActionHandle_t, EControllerActionOrigin*)")(self.this_ptr,  controllerHandle, actionSetHandle, digitalActionHandle, originsOut)
	end,
	GetAnalogActionHandle = function(self,  pszActionName)
		return vmt_thunk(14, "ControllerAnalogActionHandle_t(__thiscall*)(void*, const char*)")(self.this_ptr,  pszActionName)
	end,
	GetAnalogActionData = function(self,  controllerHandle, analogActionHandle)
		return vmt_thunk(15, "ControllerAnalogActionData_t(__thiscall*)(void*, ControllerHandle_t, ControllerAnalogActionHandle_t)")(self.this_ptr,  controllerHandle, analogActionHandle)
	end,
	GetAnalogActionOrigins = function(self,  controllerHandle, actionSetHandle, analogActionHandle, originsOut)
		return vmt_thunk(16, "int(__thiscall*)(void*, ControllerHandle_t, ControllerActionSetHandle_t, ControllerAnalogActionHandle_t, EControllerActionOrigin*)")(self.this_ptr,  controllerHandle, actionSetHandle, analogActionHandle, originsOut)
	end,
	GetGlyphForActionOrigin = function(self,  eOrigin)
		return vmt_thunk(17, "const char*(__thiscall*)(void*, EControllerActionOrigin)")(self.this_ptr,  eOrigin)
	end,
	GetStringForActionOrigin = function(self,  eOrigin)
		return vmt_thunk(18, "const char*(__thiscall*)(void*, EControllerActionOrigin)")(self.this_ptr,  eOrigin)
	end,
	StopAnalogActionMomentum = function(self,  controllerHandle, eAction)
		return vmt_thunk(19, "void(__thiscall*)(void*, ControllerHandle_t, ControllerAnalogActionHandle_t)")(self.this_ptr,  controllerHandle, eAction)
	end,
	GetMotionData = function(self,  controllerHandle)
		return vmt_thunk(20, "ControllerMotionData_t(__thiscall*)(void*, ControllerHandle_t)")(self.this_ptr,  controllerHandle)
	end,
	TriggerHapticPulse = function(self,  controllerHandle, eTargetPad, usDurationMicroSec)
		return vmt_thunk(21, "void(__thiscall*)(void*, ControllerHandle_t, ESteamControllerPad, unsigned short)")(self.this_ptr,  controllerHandle, eTargetPad, usDurationMicroSec)
	end,
	TriggerRepeatedHapticPulse = function(self,  controllerHandle, eTargetPad, usDurationMicroSec, usOffMicroSec, unRepeat, nFlags)
		return vmt_thunk(22, "void(__thiscall*)(void*, ControllerHandle_t, ESteamControllerPad, unsigned short, unsigned short, unsigned short, unsigned int)")(self.this_ptr,  controllerHandle, eTargetPad, usDurationMicroSec, usOffMicroSec, unRepeat, nFlags)
	end,
	TriggerVibration = function(self,  controllerHandle, usLeftSpeed, usRightSpeed)
		return vmt_thunk(23, "void(__thiscall*)(void*, ControllerHandle_t, unsigned short, unsigned short)")(self.this_ptr,  controllerHandle, usLeftSpeed, usRightSpeed)
	end,
	SetLEDColor = function(self,  controllerHandle, nColorR, nColorG, nColorB, nFlags)
		return vmt_thunk(24, "void(__thiscall*)(void*, ControllerHandle_t, uint8, uint8, uint8, unsigned int)")(self.this_ptr,  controllerHandle, nColorR, nColorG, nColorB, nFlags)
	end,
	ShowBindingPanel = function(self,  controllerHandle)
		return vmt_thunk(25, "bool(__thiscall*)(void*, ControllerHandle_t)")(self.this_ptr,  controllerHandle)
	end,
	GetInputTypeForHandle = function(self,  controllerHandle)
		return vmt_thunk(26, "ESteamInputType(__thiscall*)(void*, ControllerHandle_t)")(self.this_ptr,  controllerHandle)
	end,
	GetControllerForGamepadIndex = function(self,  nIndex)
		return vmt_thunk(27, "ControllerHandle_t(__thiscall*)(void*, int)")(self.this_ptr,  nIndex)
	end,
	GetGamepadIndexForController = function(self,  ulControllerHandle)
		return vmt_thunk(28, "int(__thiscall*)(void*, ControllerHandle_t)")(self.this_ptr,  ulControllerHandle)
	end,
	GetStringForXboxOrigin = function(self,  eOrigin)
		return vmt_thunk(29, "const char*(__thiscall*)(void*, EXboxOrigin)")(self.this_ptr,  eOrigin)
	end,
	GetGlyphForXboxOrigin = function(self,  eOrigin)
		return vmt_thunk(30, "const char*(__thiscall*)(void*, EXboxOrigin)")(self.this_ptr,  eOrigin)
	end,
	GetActionOriginFromXboxOrigin = function(self,  controllerHandle, eOrigin)
		return vmt_thunk(31, "EControllerActionOrigin(__thiscall*)(void*, ControllerHandle_t, EXboxOrigin)")(self.this_ptr,  controllerHandle, eOrigin)
	end,
	TranslateActionOrigin = function(self,  eDestinationInputType, eSourceOrigin)
		return vmt_thunk(32, "EControllerActionOrigin(__thiscall*)(void*, ESteamInputType, EControllerActionOrigin)")(self.this_ptr,  eDestinationInputType, eSourceOrigin)
	end,
}
local ISteamUGC_mt =  {
	this_ptr = ffi.cast("void***", steam_ctx.steam_ugc),
	CreateQueryUserUGCRequest = function(self,  unAccountID, eListType, eMatchingUGCType, eSortOrder, nCreatorAppID, nConsumerAppID, unPage)
		return vmt_thunk(0, "UGCQueryHandle_t(__thiscall*)(void*, AccountID_t, EUserUGCList, EUGCMatchingUGCType, EUserUGCListSortOrder, AppId_t, AppId_t, uint32)")(self.this_ptr,  unAccountID, eListType, eMatchingUGCType, eSortOrder, nCreatorAppID, nConsumerAppID, unPage)
	end,
	CreateQueryAllUGCRequest = function(self,  eQueryType, eMatchingeMatchingUGCTypeFileType, nCreatorAppID, nConsumerAppID, unPage)
		return vmt_thunk(1, "UGCQueryHandle_t(__thiscall*)(void*, EUGCQuery, EUGCMatchingUGCType, AppId_t, AppId_t, uint32)")(self.this_ptr,  eQueryType, eMatchingeMatchingUGCTypeFileType, nCreatorAppID, nConsumerAppID, unPage)
	end,
	CreateQueryAllUGCRequest = function(self,  eQueryType, eMatchingeMatchingUGCTypeFileType, nCreatorAppID, nConsumerAppID, pchCursor)
		return vmt_thunk(2, "UGCQueryHandle_t(__thiscall*)(void*, EUGCQuery, EUGCMatchingUGCType, AppId_t, AppId_t, const char*)")(self.this_ptr,  eQueryType, eMatchingeMatchingUGCTypeFileType, nCreatorAppID, nConsumerAppID, pchCursor)
	end,
	CreateQueryUGCDetailsRequest = function(self,  pvecPublishedFileID, unNumPublishedFileIDs)
		return vmt_thunk(3, "UGCQueryHandle_t(__thiscall*)(void*, PublishedFileId_t*, uint32)")(self.this_ptr,  pvecPublishedFileID, unNumPublishedFileIDs)
	end,
	SendQueryUGCRequest = function(self,  handle)
		return vmt_thunk(4, "SteamAPICall_t(__thiscall*)(void*, UGCQueryHandle_t)")(self.this_ptr,  handle)
	end,
	GetQueryUGCResult = function(self,  handle, index, pDetails)
		return vmt_thunk(5, "bool(__thiscall*)(void*, UGCQueryHandle_t, uint32, SteamUGCDetails_t*)")(self.this_ptr,  handle, index, pDetails)
	end,
	GetQueryUGCPreviewURL = function(self,  handle, index, pchURL, cchURLSize)
		return vmt_thunk(6, "bool(__thiscall*)(void*, UGCQueryHandle_t, uint32, char*, uint32)")(self.this_ptr,  handle, index, pchURL, cchURLSize)
	end,
	GetQueryUGCMetadata = function(self,  handle, index, pchMetadata, cchMetadatasize)
		return vmt_thunk(7, "bool(__thiscall*)(void*, UGCQueryHandle_t, uint32, char*, uint32)")(self.this_ptr,  handle, index, pchMetadata, cchMetadatasize)
	end,
	GetQueryUGCChildren = function(self,  handle, index, pvecPublishedFileID, cMaxEntries)
		return vmt_thunk(8, "bool(__thiscall*)(void*, UGCQueryHandle_t, uint32, PublishedFileId_t*, uint32)")(self.this_ptr,  handle, index, pvecPublishedFileID, cMaxEntries)
	end,
	GetQueryUGCStatistic = function(self,  handle, index, eStatType, pStatValue)
		return vmt_thunk(9, "bool(__thiscall*)(void*, UGCQueryHandle_t, uint32, EItemStatistic, uint64*)")(self.this_ptr,  handle, index, eStatType, pStatValue)
	end,
	GetQueryUGCNumAdditionalPreviews = function(self,  handle, index)
		return vmt_thunk(10, "uint32(__thiscall*)(void*, UGCQueryHandle_t, uint32)")(self.this_ptr,  handle, index)
	end,
	GetQueryUGCAdditionalPreview = function(self,  handle, index, previewIndex, pchOriginalFileName, cchOriginalFileNameSize, pPreviewType)
		return vmt_thunk(11, "bool(__thiscall*)(void*, UGCQueryHandle_t, uint32, uint32, char*, uint32, EItemPreviewType*)")(self.this_ptr,  handle, index, previewIndex, pchOriginalFileName, cchOriginalFileNameSize, pPreviewType)
	end,
	GetQueryUGCNumKeyValueTags = function(self,  handle, index)
		return vmt_thunk(12, "uint32(__thiscall*)(void*, UGCQueryHandle_t, uint32)")(self.this_ptr,  handle, index)
	end,
	GetQueryUGCKeyValueTag = function(self,  handle, index, keyValueTagIndex, pchValue, cchValueSize)
		return vmt_thunk(13, "bool(__thiscall*)(void*, UGCQueryHandle_t, uint32, uint32, char*, uint32)")(self.this_ptr,  handle, index, keyValueTagIndex, pchValue, cchValueSize)
	end,
	ReleaseQueryUGCRequest = function(self,  handle)
		return vmt_thunk(14, "bool(__thiscall*)(void*, UGCQueryHandle_t)")(self.this_ptr,  handle)
	end,
	AddRequiredTag = function(self,  handle, pTagName)
		return vmt_thunk(15, "bool(__thiscall*)(void*, UGCQueryHandle_t, const char*)")(self.this_ptr,  handle, pTagName)
	end,
	AddExcludedTag = function(self,  handle, pTagName)
		return vmt_thunk(16, "bool(__thiscall*)(void*, UGCQueryHandle_t, const char*)")(self.this_ptr,  handle, pTagName)
	end,
	SetReturnOnlyIDs = function(self,  handle, bReturnOnlyIDs)
		return vmt_thunk(17, "bool(__thiscall*)(void*, UGCQueryHandle_t, bool)")(self.this_ptr,  handle, bReturnOnlyIDs)
	end,
	SetReturnKeyValueTags = function(self,  handle, bReturnKeyValueTags)
		return vmt_thunk(18, "bool(__thiscall*)(void*, UGCQueryHandle_t, bool)")(self.this_ptr,  handle, bReturnKeyValueTags)
	end,
	SetReturnLongDescription = function(self,  handle, bReturnLongDescription)
		return vmt_thunk(19, "bool(__thiscall*)(void*, UGCQueryHandle_t, bool)")(self.this_ptr,  handle, bReturnLongDescription)
	end,
	SetReturnMetadata = function(self,  handle, bReturnMetadata)
		return vmt_thunk(20, "bool(__thiscall*)(void*, UGCQueryHandle_t, bool)")(self.this_ptr,  handle, bReturnMetadata)
	end,
	SetReturnChildren = function(self,  handle, bReturnChildren)
		return vmt_thunk(21, "bool(__thiscall*)(void*, UGCQueryHandle_t, bool)")(self.this_ptr,  handle, bReturnChildren)
	end,
	SetReturnAdditionalPreviews = function(self,  handle, bReturnAdditionalPreviews)
		return vmt_thunk(22, "bool(__thiscall*)(void*, UGCQueryHandle_t, bool)")(self.this_ptr,  handle, bReturnAdditionalPreviews)
	end,
	SetReturnTotalOnly = function(self,  handle, bReturnTotalOnly)
		return vmt_thunk(23, "bool(__thiscall*)(void*, UGCQueryHandle_t, bool)")(self.this_ptr,  handle, bReturnTotalOnly)
	end,
	SetReturnPlaytimeStats = function(self,  handle, unDays)
		return vmt_thunk(24, "bool(__thiscall*)(void*, UGCQueryHandle_t, uint32)")(self.this_ptr,  handle, unDays)
	end,
	SetLanguage = function(self,  handle, pchLanguage)
		return vmt_thunk(25, "bool(__thiscall*)(void*, UGCQueryHandle_t, const char*)")(self.this_ptr,  handle, pchLanguage)
	end,
	SetAllowCachedResponse = function(self,  handle, unMaxAgeSeconds)
		return vmt_thunk(26, "bool(__thiscall*)(void*, UGCQueryHandle_t, uint32)")(self.this_ptr,  handle, unMaxAgeSeconds)
	end,
	SetCloudFileNameFilter = function(self,  handle, pMatchCloudFileName)
		return vmt_thunk(27, "bool(__thiscall*)(void*, UGCQueryHandle_t, const char*)")(self.this_ptr,  handle, pMatchCloudFileName)
	end,
	SetMatchAnyTag = function(self,  handle, bMatchAnyTag)
		return vmt_thunk(28, "bool(__thiscall*)(void*, UGCQueryHandle_t, bool)")(self.this_ptr,  handle, bMatchAnyTag)
	end,
	SetSearchText = function(self,  handle, pSearchText)
		return vmt_thunk(29, "bool(__thiscall*)(void*, UGCQueryHandle_t, const char*)")(self.this_ptr,  handle, pSearchText)
	end,
	SetRankedByTrendDays = function(self,  handle, unDays)
		return vmt_thunk(30, "bool(__thiscall*)(void*, UGCQueryHandle_t, uint32)")(self.this_ptr,  handle, unDays)
	end,
	AddRequiredKeyValueTag = function(self,  handle, pKey, pValue)
		return vmt_thunk(31, "bool(__thiscall*)(void*, UGCQueryHandle_t, const char*, const char*)")(self.this_ptr,  handle, pKey, pValue)
	end,
	RequestUGCDetails = function(self,  nPublishedFileID, unMaxAgeSeconds)
		return vmt_thunk(32, "SteamAPICall_t(__thiscall*)(void*, PublishedFileId_t, uint32)")(self.this_ptr,  nPublishedFileID, unMaxAgeSeconds)
	end,
	CreateItem = function(self,  nConsumerAppId, eFileType)
		return vmt_thunk(33, "SteamAPICall_t(__thiscall*)(void*, AppId_t, EWorkshopFileType)")(self.this_ptr,  nConsumerAppId, eFileType)
	end,
	StartItemUpdate = function(self,  nConsumerAppId, nPublishedFileID)
		return vmt_thunk(34, "UGCUpdateHandle_t(__thiscall*)(void*, AppId_t, PublishedFileId_t)")(self.this_ptr,  nConsumerAppId, nPublishedFileID)
	end,
	SetItemTitle = function(self,  handle, pchTitle)
		return vmt_thunk(35, "bool(__thiscall*)(void*, UGCUpdateHandle_t, const char*)")(self.this_ptr,  handle, pchTitle)
	end,
	SetItemDescription = function(self,  handle, pchDescription)
		return vmt_thunk(36, "bool(__thiscall*)(void*, UGCUpdateHandle_t, const char*)")(self.this_ptr,  handle, pchDescription)
	end,
	SetItemUpdateLanguage = function(self,  handle, pchLanguage)
		return vmt_thunk(37, "bool(__thiscall*)(void*, UGCUpdateHandle_t, const char*)")(self.this_ptr,  handle, pchLanguage)
	end,
	SetItemMetadata = function(self,  handle, pchMetaData)
		return vmt_thunk(38, "bool(__thiscall*)(void*, UGCUpdateHandle_t, const char*)")(self.this_ptr,  handle, pchMetaData)
	end,
	SetItemVisibility = function(self,  handle, eVisibility)
		return vmt_thunk(39, "bool(__thiscall*)(void*, UGCUpdateHandle_t, ERemoteStoragePublishedFileVisibility)")(self.this_ptr,  handle, eVisibility)
	end,
	SetItemTags = function(self,  updateHandle, pTags)
		return vmt_thunk(40, "bool(__thiscall*)(void*, UGCUpdateHandle_t, const SteamParamStringArray_t*)")(self.this_ptr,  updateHandle, pTags)
	end,
	SetItemContent = function(self,  handle, pszContentFolder)
		return vmt_thunk(41, "bool(__thiscall*)(void*, UGCUpdateHandle_t, const char*)")(self.this_ptr,  handle, pszContentFolder)
	end,
	SetItemPreview = function(self,  handle, pszPreviewFile)
		return vmt_thunk(42, "bool(__thiscall*)(void*, UGCUpdateHandle_t, const char*)")(self.this_ptr,  handle, pszPreviewFile)
	end,
	SetAllowLegacyUpload = function(self,  handle, bAllowLegacyUpload)
		return vmt_thunk(43, "bool(__thiscall*)(void*, UGCUpdateHandle_t, bool)")(self.this_ptr,  handle, bAllowLegacyUpload)
	end,
	RemoveItemKeyValueTags = function(self,  handle, pchKey)
		return vmt_thunk(44, "bool(__thiscall*)(void*, UGCUpdateHandle_t, const char*)")(self.this_ptr,  handle, pchKey)
	end,
	AddItemKeyValueTag = function(self,  handle, pchKey, pchValue)
		return vmt_thunk(45, "bool(__thiscall*)(void*, UGCUpdateHandle_t, const char*, const char*)")(self.this_ptr,  handle, pchKey, pchValue)
	end,
	AddItemPreviewFile = function(self,  handle, pszPreviewFile, type)
		return vmt_thunk(46, "bool(__thiscall*)(void*, UGCUpdateHandle_t, const char*, EItemPreviewType)")(self.this_ptr,  handle, pszPreviewFile, type)
	end,
	AddItemPreviewVideo = function(self,  handle, pszVideoID)
		return vmt_thunk(47, "bool(__thiscall*)(void*, UGCUpdateHandle_t, const char*)")(self.this_ptr,  handle, pszVideoID)
	end,
	UpdateItemPreviewFile = function(self,  handle, index, pszPreviewFile)
		return vmt_thunk(48, "bool(__thiscall*)(void*, UGCUpdateHandle_t, uint32, const char*)")(self.this_ptr,  handle, index, pszPreviewFile)
	end,
	UpdateItemPreviewVideo = function(self,  handle, index, pszVideoID)
		return vmt_thunk(49, "bool(__thiscall*)(void*, UGCUpdateHandle_t, uint32, const char*)")(self.this_ptr,  handle, index, pszVideoID)
	end,
	RemoveItemPreview = function(self,  handle, index)
		return vmt_thunk(50, "bool(__thiscall*)(void*, UGCUpdateHandle_t, uint32)")(self.this_ptr,  handle, index)
	end,
	SubmitItemUpdate = function(self,  handle, pchChangeNote)
		return vmt_thunk(51, "SteamAPICall_t(__thiscall*)(void*, UGCUpdateHandle_t, const char*)")(self.this_ptr,  handle, pchChangeNote)
	end,
	GetItemUpdateProgress = function(self,  handle, punBytesProcessed, punBytesTotal)
		return vmt_thunk(52, "EItemUpdateStatus(__thiscall*)(void*, UGCUpdateHandle_t, uint64*, uint64*)")(self.this_ptr,  handle, punBytesProcessed, punBytesTotal)
	end,
	SetUserItemVote = function(self,  nPublishedFileID, bVoteUp)
		return vmt_thunk(53, "SteamAPICall_t(__thiscall*)(void*, PublishedFileId_t, bool)")(self.this_ptr,  nPublishedFileID, bVoteUp)
	end,
	GetUserItemVote = function(self,  nPublishedFileID)
		return vmt_thunk(54, "SteamAPICall_t(__thiscall*)(void*, PublishedFileId_t)")(self.this_ptr,  nPublishedFileID)
	end,
	AddItemToFavorites = function(self,  nAppId, nPublishedFileID)
		return vmt_thunk(55, "SteamAPICall_t(__thiscall*)(void*, AppId_t, PublishedFileId_t)")(self.this_ptr,  nAppId, nPublishedFileID)
	end,
	RemoveItemFromFavorites = function(self,  nAppId, nPublishedFileID)
		return vmt_thunk(56, "SteamAPICall_t(__thiscall*)(void*, AppId_t, PublishedFileId_t)")(self.this_ptr,  nAppId, nPublishedFileID)
	end,
	SubscribeItem = function(self,  nPublishedFileID)
		return vmt_thunk(57, "SteamAPICall_t(__thiscall*)(void*, PublishedFileId_t)")(self.this_ptr,  nPublishedFileID)
	end,
	UnsubscribeItem = function(self,  nPublishedFileID)
		return vmt_thunk(58, "SteamAPICall_t(__thiscall*)(void*, PublishedFileId_t)")(self.this_ptr,  nPublishedFileID)
	end,
	GetNumSubscribedItems = function(self)
		return vmt_thunk(59, "uint32(__thiscall*)(void*)")(self.this_ptr)
	end,
	GetSubscribedItems = function(self,  pvecPublishedFileID, cMaxEntries)
		return vmt_thunk(60, "uint32(__thiscall*)(void*, PublishedFileId_t*, uint32)")(self.this_ptr,  pvecPublishedFileID, cMaxEntries)
	end,
	GetItemState = function(self,  nPublishedFileID)
		return vmt_thunk(61, "uint32(__thiscall*)(void*, PublishedFileId_t)")(self.this_ptr,  nPublishedFileID)
	end,
	GetItemInstallInfo = function(self,  nPublishedFileID, punSizeOnDisk, pchFolder, cchFolderSize, punTimeStamp)
		return vmt_thunk(62, "bool(__thiscall*)(void*, PublishedFileId_t, uint64*, char*, uint32, uint32*)")(self.this_ptr,  nPublishedFileID, punSizeOnDisk, pchFolder, cchFolderSize, punTimeStamp)
	end,
	GetItemDownloadInfo = function(self,  nPublishedFileID, punBytesDownloaded, punBytesTotal)
		return vmt_thunk(63, "bool(__thiscall*)(void*, PublishedFileId_t, uint64*, uint64*)")(self.this_ptr,  nPublishedFileID, punBytesDownloaded, punBytesTotal)
	end,
	DownloadItem = function(self,  nPublishedFileID, bHighPriority)
		return vmt_thunk(64, "bool(__thiscall*)(void*, PublishedFileId_t, bool)")(self.this_ptr,  nPublishedFileID, bHighPriority)
	end,
	BInitWorkshopForGameServer = function(self,  unWorkshopDepotID, pszFolder)
		return vmt_thunk(65, "bool(__thiscall*)(void*, DepotId_t, const char*)")(self.this_ptr,  unWorkshopDepotID, pszFolder)
	end,
	SuspendDownloads = function(self,  bSuspend)
		return vmt_thunk(66, "void(__thiscall*)(void*, bool)")(self.this_ptr,  bSuspend)
	end,
	StartPlaytimeTracking = function(self,  pvecPublishedFileID, unNumPublishedFileIDs)
		return vmt_thunk(67, "SteamAPICall_t(__thiscall*)(void*, PublishedFileId_t*, uint32)")(self.this_ptr,  pvecPublishedFileID, unNumPublishedFileIDs)
	end,
	StopPlaytimeTracking = function(self,  pvecPublishedFileID, unNumPublishedFileIDs)
		return vmt_thunk(68, "SteamAPICall_t(__thiscall*)(void*, PublishedFileId_t*, uint32)")(self.this_ptr,  pvecPublishedFileID, unNumPublishedFileIDs)
	end,
	StopPlaytimeTrackingForAllItems = function(self)
		return vmt_thunk(69, "SteamAPICall_t(__thiscall*)(void*)")(self.this_ptr)
	end,
	AddDependency = function(self,  nParentPublishedFileID, nChildPublishedFileID)
		return vmt_thunk(70, "SteamAPICall_t(__thiscall*)(void*, PublishedFileId_t, PublishedFileId_t)")(self.this_ptr,  nParentPublishedFileID, nChildPublishedFileID)
	end,
	RemoveDependency = function(self,  nParentPublishedFileID, nChildPublishedFileID)
		return vmt_thunk(71, "SteamAPICall_t(__thiscall*)(void*, PublishedFileId_t, PublishedFileId_t)")(self.this_ptr,  nParentPublishedFileID, nChildPublishedFileID)
	end,
	AddAppDependency = function(self,  nPublishedFileID, nAppID)
		return vmt_thunk(72, "SteamAPICall_t(__thiscall*)(void*, PublishedFileId_t, AppId_t)")(self.this_ptr,  nPublishedFileID, nAppID)
	end,
	RemoveAppDependency = function(self,  nPublishedFileID, nAppID)
		return vmt_thunk(73, "SteamAPICall_t(__thiscall*)(void*, PublishedFileId_t, AppId_t)")(self.this_ptr,  nPublishedFileID, nAppID)
	end,
	GetAppDependencies = function(self,  nPublishedFileID)
		return vmt_thunk(74, "SteamAPICall_t(__thiscall*)(void*, PublishedFileId_t)")(self.this_ptr,  nPublishedFileID)
	end,
	DeleteItem = function(self,  nPublishedFileID)
		return vmt_thunk(75, "SteamAPICall_t(__thiscall*)(void*, PublishedFileId_t)")(self.this_ptr,  nPublishedFileID)
	end,
}
local ISteamAppList_mt =  {
	this_ptr = ffi.cast("void***", steam_ctx.steam_applist),
	GetNumInstalledApps = function(self)
		return vmt_thunk(0, "uint32(__thiscall*)(void*)")(self.this_ptr)
	end,
	GetInstalledApps = function(self,  pvecAppID, unMaxAppIDs)
		return vmt_thunk(1, "uint32(__thiscall*)(void*, AppId_t*, uint32)")(self.this_ptr,  pvecAppID, unMaxAppIDs)
	end,
	GetAppName = function(self,  nAppID, pchName, cchNameMax)
		return vmt_thunk(2, "int(__thiscall*)(void*, AppId_t, char*, int)")(self.this_ptr,  nAppID, pchName, cchNameMax)
	end,
	GetAppInstallDir = function(self,  nAppID, pchDirectory, cchNameMax)
		return vmt_thunk(3, "int(__thiscall*)(void*, AppId_t, char*, int)")(self.this_ptr,  nAppID, pchDirectory, cchNameMax)
	end,
	GetAppBuildId = function(self,  nAppID)
		return vmt_thunk(4, "int(__thiscall*)(void*, AppId_t)")(self.this_ptr,  nAppID)
	end,
}
local ISteamMusic_mt =  {
	this_ptr = ffi.cast("void***", steam_ctx.steam_music),
	BIsEnabled = function(self)
		return vmt_thunk(0, "bool(__thiscall*)(void*)")(self.this_ptr)
	end,
	BIsPlaying = function(self)
		return vmt_thunk(1, "bool(__thiscall*)(void*)")(self.this_ptr)
	end,
	GetPlaybackStatus = function(self)
		return vmt_thunk(2, "AudioPlayback_Status(__thiscall*)(void*)")(self.this_ptr)
	end,
	Play = function(self)
		return vmt_thunk(3, "void(__thiscall*)(void*)")(self.this_ptr)
	end,
	Pause = function(self)
		return vmt_thunk(4, "void(__thiscall*)(void*)")(self.this_ptr)
	end,
	PlayPrevious = function(self)
		return vmt_thunk(5, "void(__thiscall*)(void*)")(self.this_ptr)
	end,
	PlayNext = function(self)
		return vmt_thunk(6, "void(__thiscall*)(void*)")(self.this_ptr)
	end,
	SetVolume = function(self,  flVolume)
		return vmt_thunk(7, "void(__thiscall*)(void*, float)")(self.this_ptr,  flVolume)
	end,
	GetVolume = function(self)
		return vmt_thunk(8, "float(__thiscall*)(void*)")(self.this_ptr)
	end,
}
local ISteamMusicRemote_mt =  {
	this_ptr = ffi.cast("void***", steam_ctx.steam_musicremote),
	RegisterSteamMusicRemote = function(self,  pchName)
		return vmt_thunk(0, "bool(__thiscall*)(void*, const char*)")(self.this_ptr,  pchName)
	end,
	DeregisterSteamMusicRemote = function(self)
		return vmt_thunk(1, "bool(__thiscall*)(void*)")(self.this_ptr)
	end,
	BIsCurrentMusicRemote = function(self)
		return vmt_thunk(2, "bool(__thiscall*)(void*)")(self.this_ptr)
	end,
	BActivationSuccess = function(self,  bValue)
		return vmt_thunk(3, "bool(__thiscall*)(void*, bool)")(self.this_ptr,  bValue)
	end,
	SetDisplayName = function(self,  pchDisplayName)
		return vmt_thunk(4, "bool(__thiscall*)(void*, const char*)")(self.this_ptr,  pchDisplayName)
	end,
	SetPNGIcon_64x64 = function(self,  pvBuffer, cbBufferLength)
		return vmt_thunk(5, "bool(__thiscall*)(void*, void*, uint32)")(self.this_ptr,  pvBuffer, cbBufferLength)
	end,
	EnablePlayPreviousbool = function(self)
		return vmt_thunk(6, "bool(__thiscall*)(void*, bValue)")(self.this_ptr)
	end,
	EnablePlayNext = function(self,  bValue)
		return vmt_thunk(7, "bool(__thiscall*)(void*, bool)")(self.this_ptr,  bValue)
	end,
	EnableShuffled = function(self,  bValue)
		return vmt_thunk(8, "bool(__thiscall*)(void*, bool)")(self.this_ptr,  bValue)
	end,
	EnableLooped = function(self,  bValue)
		return vmt_thunk(9, "bool(__thiscall*)(void*, bool)")(self.this_ptr,  bValue)
	end,
	EnableQueue = function(self,  bValue)
		return vmt_thunk(10, "bool(__thiscall*)(void*, bool)")(self.this_ptr,  bValue)
	end,
	EnablePlaylists = function(self,  bValue)
		return vmt_thunk(11, "bool(__thiscall*)(void*, bool)")(self.this_ptr,  bValue)
	end,
	UpdatePlaybackStatus = function(self,  nStatus)
		return vmt_thunk(12, "bool(__thiscall*)(void*, AudioPlayback_Status)")(self.this_ptr,  nStatus)
	end,
	UpdateShuffled = function(self,  bValue)
		return vmt_thunk(13, "bool(__thiscall*)(void*, bool)")(self.this_ptr,  bValue)
	end,
	UpdateLooped = function(self,  bValue)
		return vmt_thunk(14, "bool(__thiscall*)(void*, bool)")(self.this_ptr,  bValue)
	end,
	UpdateVolume = function(self,  flValue)
		return vmt_thunk(15, "bool(__thiscall*)(void*, float)")(self.this_ptr,  flValue)
	end,
	CurrentEntryWillChange = function(self)
		return vmt_thunk(16, "bool(__thiscall*)(void*)")(self.this_ptr)
	end,
	CurrentEntryIsAvailable = function(self,  bAvailable)
		return vmt_thunk(17, "bool(__thiscall*)(void*, bool)")(self.this_ptr,  bAvailable)
	end,
	UpdateCurrentEntryText = function(self,  pchText)
		return vmt_thunk(18, "bool(__thiscall*)(void*, const char*)")(self.this_ptr,  pchText)
	end,
	UpdateCurrentEntryElapsedSeconds = function(self,  nValue)
		return vmt_thunk(19, "bool(__thiscall*)(void*, int)")(self.this_ptr,  nValue)
	end,
	UpdateCurrentEntryCoverArt = function(self,  pvBuffer, cbBufferLength)
		return vmt_thunk(20, "bool(__thiscall*)(void*, void*, uint32)")(self.this_ptr,  pvBuffer, cbBufferLength)
	end,
	CurrentEntryDidChange = function(self)
		return vmt_thunk(21, "bool(__thiscall*)(void*)")(self.this_ptr)
	end,
	QueueWillChange = function(self)
		return vmt_thunk(22, "bool(__thiscall*)(void*)")(self.this_ptr)
	end,
	ResetQueueEntries = function(self)
		return vmt_thunk(23, "bool(__thiscall*)(void*)")(self.this_ptr)
	end,
	SetQueueEntry = function(self,  nID, nPosition, pchEntryText)
		return vmt_thunk(24, "bool(__thiscall*)(void*, int, int, const char*)")(self.this_ptr,  nID, nPosition, pchEntryText)
	end,
	SetCurrentQueueEntry = function(self,  nID)
		return vmt_thunk(25, "bool(__thiscall*)(void*, int)")(self.this_ptr,  nID)
	end,
	QueueDidChange = function(self)
		return vmt_thunk(26, "bool(__thiscall*)(void*)")(self.this_ptr)
	end,
	PlaylistWillChange = function(self)
		return vmt_thunk(27, "bool(__thiscall*)(void*)")(self.this_ptr)
	end,
	ResetPlaylistEntries = function(self)
		return vmt_thunk(28, "bool(__thiscall*)(void*)")(self.this_ptr)
	end,
	SetPlaylistEntry = function(self,  nID, nPosition, pchEntryText)
		return vmt_thunk(29, "bool(__thiscall*)(void*, int, int, const char*)")(self.this_ptr,  nID, nPosition, pchEntryText)
	end,
	SetCurrentPlaylistEntry = function(self,  nID)
		return vmt_thunk(30, "bool(__thiscall*)(void*, int)")(self.this_ptr,  nID)
	end,
	PlaylistDidChange = function(self)
		return vmt_thunk(31, "bool(__thiscall*)(void*)")(self.this_ptr)
	end,
}
local ISteamHTMLSurface_mt =  {
	this_ptr = ffi.cast("void***", steam_ctx.steam_htmlsurface),
	Init = function(self)
		return vmt_thunk(1, "bool(__thiscall*)(void*)")(self.this_ptr)
	end,
	Shutdown = function(self)
		return vmt_thunk(2, "bool(__thiscall*)(void*)")(self.this_ptr)
	end,
	CreateBrowser = function(self,  pchUserAgent, pchUserCSS)
		return vmt_thunk(3, "SteamAPICall_t(__thiscall*)(void*, const char*, const char*)")(self.this_ptr,  pchUserAgent, pchUserCSS)
	end,
	RemoveBrowser = function(self,  unBrowserHandle)
		return vmt_thunk(4, "void(__thiscall*)(void*, HHTMLBrowser)")(self.this_ptr,  unBrowserHandle)
	end,
	LoadURL = function(self,  unBrowserHandle, pchURL, pchPostData)
		return vmt_thunk(5, "void(__thiscall*)(void*, HHTMLBrowser, const char*, const char*)")(self.this_ptr,  unBrowserHandle, pchURL, pchPostData)
	end,
	SetSize = function(self,  unBrowserHandle, unWidth, unHeight)
		return vmt_thunk(6, "void(__thiscall*)(void*, HHTMLBrowser, uint32, uint32)")(self.this_ptr,  unBrowserHandle, unWidth, unHeight)
	end,
	StopLoad = function(self,  unBrowserHandle)
		return vmt_thunk(7, "void(__thiscall*)(void*, HHTMLBrowser)")(self.this_ptr,  unBrowserHandle)
	end,
	Reload = function(self,  unBrowserHandle)
		return vmt_thunk(8, "void(__thiscall*)(void*, HHTMLBrowser)")(self.this_ptr,  unBrowserHandle)
	end,
	GoBack = function(self,  unBrowserHandle)
		return vmt_thunk(9, "void(__thiscall*)(void*, HHTMLBrowser)")(self.this_ptr,  unBrowserHandle)
	end,
	GoForward = function(self,  unBrowserHandle)
		return vmt_thunk(10, "void(__thiscall*)(void*, HHTMLBrowser)")(self.this_ptr,  unBrowserHandle)
	end,
	AddHeader = function(self,  unBrowserHandle, pchKey, pchValue)
		return vmt_thunk(11, "void(__thiscall*)(void*, HHTMLBrowser, const char*, const char*)")(self.this_ptr,  unBrowserHandle, pchKey, pchValue)
	end,
	ExecuteJavascript = function(self,  unBrowserHandle, pchScript)
		return vmt_thunk(12, "void(__thiscall*)(void*, HHTMLBrowser, const char*)")(self.this_ptr,  unBrowserHandle, pchScript)
	end,
	MouseUp = function(self,  unBrowserHandle, eMouseButton)
		return vmt_thunk(13, "void(__thiscall*)(void*, HHTMLBrowser, EHTMLMouseButton)")(self.this_ptr,  unBrowserHandle, eMouseButton)
	end,
	MouseDown = function(self,  unBrowserHandle, eMouseButton)
		return vmt_thunk(14, "void(__thiscall*)(void*, HHTMLBrowser, EHTMLMouseButton)")(self.this_ptr,  unBrowserHandle, eMouseButton)
	end,
	MouseDoubleClick = function(self,  unBrowserHandle, eMouseButton)
		return vmt_thunk(15, "void(__thiscall*)(void*, HHTMLBrowser, EHTMLMouseButton)")(self.this_ptr,  unBrowserHandle, eMouseButton)
	end,
	MouseMove = function(self,  unBrowserHandle, x, y)
		return vmt_thunk(16, "void(__thiscall*)(void*, HHTMLBrowser, int, int)")(self.this_ptr,  unBrowserHandle, x, y)
	end,
	MouseWheel = function(self,  unBrowserHandle, nDelta)
		return vmt_thunk(17, "void(__thiscall*)(void*, HHTMLBrowser, int32)")(self.this_ptr,  unBrowserHandle, nDelta)
	end,
	KeyDown = function(self,  unBrowserHandle, nNativeKeyCode, eHTMLKeyModifiers, bIsSystemKey)
		return vmt_thunk(18, "void(__thiscall*)(void*, HHTMLBrowser, uint32, EHTMLKeyModifiers, bool)")(self.this_ptr,  unBrowserHandle, nNativeKeyCode, eHTMLKeyModifiers, bIsSystemKey)
	end,
	KeyUp = function(self,  unBrowserHandle, nNativeKeyCode, eHTMLKeyModifiers)
		return vmt_thunk(19, "void(__thiscall*)(void*, HHTMLBrowser, uint32, EHTMLKeyModifiers)")(self.this_ptr,  unBrowserHandle, nNativeKeyCode, eHTMLKeyModifiers)
	end,
	KeyChar = function(self,  unBrowserHandle, cUnicodeChar, eHTMLKeyModifiers)
		return vmt_thunk(20, "void(__thiscall*)(void*, HHTMLBrowser, uint32, EHTMLKeyModifiers)")(self.this_ptr,  unBrowserHandle, cUnicodeChar, eHTMLKeyModifiers)
	end,
	SetHorizontalScroll = function(self,  unBrowserHandle, nAbsolutePixelScroll)
		return vmt_thunk(21, "void(__thiscall*)(void*, HHTMLBrowser, uint32)")(self.this_ptr,  unBrowserHandle, nAbsolutePixelScroll)
	end,
	SetVerticalScroll = function(self,  unBrowserHandle, nAbsolutePixelScroll)
		return vmt_thunk(22, "void(__thiscall*)(void*, HHTMLBrowser, uint32)")(self.this_ptr,  unBrowserHandle, nAbsolutePixelScroll)
	end,
	SetKeyFocus = function(self,  unBrowserHandle, bHasKeyFocus)
		return vmt_thunk(23, "void(__thiscall*)(void*, HHTMLBrowser, bool)")(self.this_ptr,  unBrowserHandle, bHasKeyFocus)
	end,
	ViewSource = function(self,  unBrowserHandle)
		return vmt_thunk(24, "void(__thiscall*)(void*, HHTMLBrowser)")(self.this_ptr,  unBrowserHandle)
	end,
	CopyToClipboard = function(self,  unBrowserHandle)
		return vmt_thunk(25, "void(__thiscall*)(void*, HHTMLBrowser)")(self.this_ptr,  unBrowserHandle)
	end,
	PasteFromClipboard = function(self,  unBrowserHandle)
		return vmt_thunk(26, "void(__thiscall*)(void*, HHTMLBrowser)")(self.this_ptr,  unBrowserHandle)
	end,
	Find = function(self,  unBrowserHandle, pchSearchStr, bCurrentlyInFind, bReverse)
		return vmt_thunk(27, "void(__thiscall*)(void*, HHTMLBrowser, const char*, bool, bool)")(self.this_ptr,  unBrowserHandle, pchSearchStr, bCurrentlyInFind, bReverse)
	end,
	StopFind = function(self,  unBrowserHandle)
		return vmt_thunk(28, "void(__thiscall*)(void*, HHTMLBrowser)")(self.this_ptr,  unBrowserHandle)
	end,
	GetLinkAtPosition = function(self,  unBrowserHandle, x, y)
		return vmt_thunk(29, "void(__thiscall*)(void*, HHTMLBrowser, int, int)")(self.this_ptr,  unBrowserHandle, x, y)
	end,
	SetCookie = function(self,  pchHostname, pchKey, pchValue, pchPath, nExpires, bSecure, bHTTPOnly)
		return vmt_thunk(30, "void(__thiscall*)(void*, const char*, const char*, const char*, const char*, RTime32, bool, bool)")(self.this_ptr,  pchHostname, pchKey, pchValue, pchPath, nExpires, bSecure, bHTTPOnly)
	end,
	SetPageScaleFactor = function(self,  unBrowserHandle, flZoom, nPointX, nPointY)
		return vmt_thunk(31, "void(__thiscall*)(void*, HHTMLBrowser, float, int, int)")(self.this_ptr,  unBrowserHandle, flZoom, nPointX, nPointY)
	end,
	SetBackgroundMode = function(self,  unBrowserHandle, bBackgroundMode)
		return vmt_thunk(32, "void(__thiscall*)(void*, HHTMLBrowser, bool)")(self.this_ptr,  unBrowserHandle, bBackgroundMode)
	end,
	SetDPIScalingFactor = function(self,  unBrowserHandle, flDPIScaling)
		return vmt_thunk(33, "void(__thiscall*)(void*, HHTMLBrowser, float)")(self.this_ptr,  unBrowserHandle, flDPIScaling)
	end,
	OpenDeveloperTools = function(self,  unBrowserHandle)
		return vmt_thunk(34, "void(__thiscall*)(void*, HHTMLBrowser)")(self.this_ptr,  unBrowserHandle)
	end,
	AllowStartRequest = function(self,  unBrowserHandle, bAllowed)
		return vmt_thunk(35, "void(__thiscall*)(void*, HHTMLBrowser, bool)")(self.this_ptr,  unBrowserHandle, bAllowed)
	end,
	JSDialogResponse = function(self,  unBrowserHandle, bResult)
		return vmt_thunk(36, "void(__thiscall*)(void*, HHTMLBrowser, bool)")(self.this_ptr,  unBrowserHandle, bResult)
	end,
	FileLoadDialogResponse = function(self,  unBrowserHandle, pchSelectedFiles)
		return vmt_thunk(37, "void(__thiscall*)(void*, HHTMLBrowser, const char*)")(self.this_ptr,  unBrowserHandle, pchSelectedFiles)
	end,
}
local ISteamInventory_mt =  {
	this_ptr = ffi.cast("void***", steam_ctx.steam_inventory),
	GetResultStatus = function(self,  resultHandle)
		return vmt_thunk(0, "EResult(__thiscall*)(void*, SteamInventoryResult_t)")(self.this_ptr,  resultHandle)
	end,
	GetResultItems = function(self,  resultHandle)
		return vmt_thunk(1, "bool(__thiscall*)(void*, SteamInventoryResult_t)")(self.this_ptr,  resultHandle)
	end,
	GetResultItemProperty = function(self,  resultHandle)
		return vmt_thunk(2, "bool(__thiscall*)(void*, SteamInventoryResult_t)")(self.this_ptr,  resultHandle)
	end,
	GetResultTimestamp = function(self,  resultHandle)
		return vmt_thunk(3, "uint32(__thiscall*)(void*, SteamInventoryResult_t)")(self.this_ptr,  resultHandle)
	end,
	CheckResultSteamID = function(self,  resultHandle, steamIDExpected)
		return vmt_thunk(4, "bool(__thiscall*)(void*, SteamInventoryResult_t, CSteamID)")(self.this_ptr,  resultHandle, steamIDExpected)
	end,
	DestroyResult = function(self,  resultHandle)
		return vmt_thunk(5, "void(__thiscall*)(void*, SteamInventoryResult_t)")(self.this_ptr,  resultHandle)
	end,
	GetAllItems = function(self,  pResultHandle)
		return vmt_thunk(6, "bool(__thiscall*)(void*, SteamInventoryResult_t*)")(self.this_ptr,  pResultHandle)
	end,
	GetItemsByID = function(self,  pResultHandle, pInstanceIDs, unCountInstanceIDs)
		return vmt_thunk(7, "bool(__thiscall*)(void*, SteamInventoryResult_t*, const SteamItemInstanceID_t*, uint32)")(self.this_ptr,  pResultHandle, pInstanceIDs, unCountInstanceIDs)
	end,
	SerializeResult = function(self,  resultHandle, pOutBuffer, punOutBufferSize)
		return vmt_thunk(8, "bool(__thiscall*)(void*, SteamInventoryResult_t, void*, uint32*)")(self.this_ptr,  resultHandle, pOutBuffer, punOutBufferSize)
	end,
	DeserializeResult = function(self,  pOutResultHandle, pBuffer, unBufferSize, bRESERVED_MUST_BE_FALSE)
		return vmt_thunk(9, "bool(__thiscall*)(void*, SteamInventoryResult_t*, const void*, uint32, bool)")(self.this_ptr,  pOutResultHandle, pBuffer, unBufferSize, bRESERVED_MUST_BE_FALSE)
	end,
	GenerateItems = function(self,  pResultHandle, punArrayQuantity, unArrayLength)
		return vmt_thunk(10, "bool(__thiscall*)(void*, SteamInventoryResult_t*, const uint32*, uint32)")(self.this_ptr,  pResultHandle, punArrayQuantity, unArrayLength)
	end,
	GrantPromoItems = function(self,  pResultHandle)
		return vmt_thunk(11, "bool(__thiscall*)(void*, SteamInventoryResult_t*)")(self.this_ptr,  pResultHandle)
	end,
	AddPromoItem = function(self,  pResultHandle, itemDef)
		return vmt_thunk(12, "bool(__thiscall*)(void*, SteamInventoryResult_t*, SteamItemDef_t)")(self.this_ptr,  pResultHandle, itemDef)
	end,
	AddPromoItems = function(self,  pResultHandle, pArrayItemDefs, unArrayLength)
		return vmt_thunk(13, "bool(__thiscall*)(void*, SteamInventoryResult_t*, const SteamItemDef_t*, uint32)")(self.this_ptr,  pResultHandle, pArrayItemDefs, unArrayLength)
	end,
	ConsumeItem = function(self,  pResultHandle, itemConsume, unQuantity)
		return vmt_thunk(14, "bool(__thiscall*)(void*, SteamInventoryResult_t*, SteamItemInstanceID_t, uint32)")(self.this_ptr,  pResultHandle, itemConsume, unQuantity)
	end,
	ExchangeItems = function(self,  pResultHandle)
		return vmt_thunk(15, "bool(__thiscall*)(void*, SteamInventoryResult_t*)")(self.this_ptr,  pResultHandle)
	end,
	TransferItemQuantity = function(self,  pResultHandle, itemIdSource, unQuantity, itemIdDest)
		return vmt_thunk(16, "bool(__thiscall*)(void*, SteamInventoryResult_t*, SteamItemInstanceID_t, uint32, SteamItemInstanceID_t)")(self.this_ptr,  pResultHandle, itemIdSource, unQuantity, itemIdDest)
	end,
	SendItemDropHeartbeat = function(self)
		return vmt_thunk(17, "void(__thiscall*)(void*)")(self.this_ptr)
	end,
	TriggerItemDrop = function(self,  pResultHandle, dropListDefinition)
		return vmt_thunk(18, "bool(__thiscall*)(void*, SteamInventoryResult_t*, SteamItemDef_t)")(self.this_ptr,  pResultHandle, dropListDefinition)
	end,
	TradeItems = function(self,  pResultHandle, steamIDTradePartner)
		return vmt_thunk(19, "bool(__thiscall*)(void*, SteamInventoryResult_t*, CSteamID)")(self.this_ptr,  pResultHandle, steamIDTradePartner)
	end,
	LoadItemDefinitions = function(self)
		return vmt_thunk(20, "bool(__thiscall*)(void*)")(self.this_ptr)
	end,
	GetItemDefinitionIDs = function(self)
		return vmt_thunk(21, "bool(__thiscall*)(void*)")(self.this_ptr)
	end,
	GetItemDefinitionProperty = function(self,  iDefinition, pchPropertyName)
		return vmt_thunk(22, "bool(__thiscall*)(void*, SteamItemDef_t, const char*)")(self.this_ptr,  iDefinition, pchPropertyName)
	end,
	RequestEligiblePromoItemDefinitionsIDs = function(self,  steamID)
		return vmt_thunk(23, "SteamAPICall_t(__thiscall*)(void*, CSteamID)")(self.this_ptr,  steamID)
	end,
	GetEligiblePromoItemDefinitionIDs = function(self)
		return vmt_thunk(24, "bool(__thiscall*)(void*)")(self.this_ptr)
	end,
	StartPurchase = function(self,  punArrayQuantity, unArrayLength)
		return vmt_thunk(25, "SteamAPICall_t(__thiscall*)(void*, const uint32*, uint32)")(self.this_ptr,  punArrayQuantity, unArrayLength)
	end,
	RequestPrices = function(self)
		return vmt_thunk(26, "SteamAPICall_t(__thiscall*)(void*)")(self.this_ptr)
	end,
	GetNumItemsWithPrices = function(self)
		return vmt_thunk(27, "uint32(__thiscall*)(void*)")(self.this_ptr)
	end,
	GetItemsWithPrices = function(self,  pArrayItemDefs, pCurrentPrices, pBasePrices, unArrayLength)
		return vmt_thunk(28, "bool(__thiscall*)(void*, SteamItemDef_t*, uint64*, uint64* uint32)")(self.this_ptr, pArrayItemDefs, pCurrentPrices, pBasePrices, unArrayLength)
	end,
	GetItemPrice = function(self,  iDefinition, pCurrentPrice, pBasePrice)
		return vmt_thunk(29, "bool(__thiscall*)(void*, SteamItemDef_t, uint64*, uint64*)")(self.this_ptr,  iDefinition, pCurrentPrice, pBasePrice)
	end,
	StartUpdateProperties = function(self)
		return vmt_thunk(30, "SteamInventoryUpdateHandle_t(__thiscall*)(void*)")(self.this_ptr)
	end,
	RemoveProperty = function(self,  handle, nItemID, pchPropertyName)
		return vmt_thunk(31, "bool(__thiscall*)(void*, SteamInventoryUpdateHandle_t, SteamItemInstanceID_t, const char*)")(self.this_ptr,  handle, nItemID, pchPropertyName)
	end,
	SetProperty = function(self,  handle, nItemID, pchPropertyName, pchPropertyValue)
		return vmt_thunk(32, "bool(__thiscall*)(void*, SteamInventoryUpdateHandle_t, SteamItemInstanceID_t, const char*, const char*)")(self.this_ptr,  handle, nItemID, pchPropertyName, pchPropertyValue)
	end,
	SetProperty = function(self,  handle, nItemID, pchPropertyName, bValue)
		return vmt_thunk(33, "bool(__thiscall*)(void*, SteamInventoryUpdateHandle_t, SteamItemInstanceID_t, const char*, bool)")(self.this_ptr,  handle, nItemID, pchPropertyName, bValue)
	end,
	SetProperty = function(self,  handle, nItemID, pchPropertyName, nValue)
		return vmt_thunk(34, "bool(__thiscall*)(void*, SteamInventoryUpdateHandle_t, SteamItemInstanceID_t, const char*, int64)")(self.this_ptr,  handle, nItemID, pchPropertyName, nValue)
	end,
	SetProperty = function(self,  handle, nItemID, pchPropertyName, flValue)
		return vmt_thunk(35, "bool(__thiscall*)(void*, SteamInventoryUpdateHandle_t, SteamItemInstanceID_t, const char*, float)")(self.this_ptr,  handle, nItemID, pchPropertyName, flValue)
	end,
	SubmitUpdateProperties = function(self,  handle, pResultHandle)
		return vmt_thunk(36, "bool(__thiscall*)(void*, SteamInventoryUpdateHandle_t, SteamInventoryResult_t*)")(self.this_ptr,  handle, pResultHandle)
	end,
}
local ISteamVideo_mt =  {
	this_ptr = ffi.cast("void***", steam_ctx.steam_video),
	GetVideoURL = function(self,  unVideoAppID)
		return vmt_thunk(0, "void(__thiscall*)(void*, AppId_t)")(self.this_ptr,  unVideoAppID)
	end,
	IsBroadcasting = function(self,  pnNumViewers)
		return vmt_thunk(1, "bool(__thiscall*)(void*, int*)")(self.this_ptr,  pnNumViewers)
	end,
	GetOPFSettings = function(self,  unVideoAppID)
		return vmt_thunk(2, "void(__thiscall*)(void*, AppId_t)")(self.this_ptr,  unVideoAppID)
	end,
	GetOPFStringForApp = function(self,  unVideoAppID, pchBuffer, pnBufferSize)
		return vmt_thunk(3, "bool(__thiscall*)(void*, AppId_t, char*, int32*)")(self.this_ptr,  unVideoAppID, pchBuffer, pnBufferSize)
	end,
}

return {
    ISteamAppList = ISteamAppList_mt,
    ISteamApps = ISteamApps_mt,
    ISteamController = ISteamController_mt,
    ISteamFriends = ISteamFriends_mt,
    ISteamHTMLSurface = ISteamHTMLSurface_mt,
    ISteamHTTP = ISteamHTTP_mt,
    ISteamInventory = ISteamInventory_mt,
    ISteamMatchmaking = ISteamMatchmaking_mt,
    ISteamMatchmakingServers = ISteamMatchmakingServers_mt,
    ISteamMusic = ISteamMusic_mt,
    ISteamMusicRemote = ISteamMusicRemote_mt,
    ISteamNetworking = ISteamNetworking_mt,
    ISteamRemoteStorage = ISteamRemoteStorage_mt,
    ISteamScreenshots = ISteamScreenshots_mt,
    ISteamUGC = ISteamUGC_mt,
    ISteamUser = ISteamUser_mt,
    ISteamUserStats = ISteamUserStats_mt,
    ISteamUtils = ISteamUtils_mt,
    ISteamVideo = ISteamVideo_mt,
}
