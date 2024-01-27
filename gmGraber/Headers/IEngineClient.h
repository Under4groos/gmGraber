


struct ViewMatrix_t;
struct player_info_t;

class IEngineClient {
public:
	virtual void pad0() = 0;
	virtual void pad1() = 0;
	virtual void pad2() = 0;
	virtual void pad3() = 0;
	virtual void pad4() = 0;
	virtual void GetScreenSize(int& w, int& h) = 0;
	virtual void ServerCmd(const char* szCmdString, bool bReliable) = 0;
	virtual void ClientCmd(const char* szCmdString) = 0;
	virtual bool GetPlayerInfo(int entNum, player_info_t* pInfo) = 0;
	virtual void pad7() = 0;
	virtual void pad8() = 0;
	virtual bool Con_IsVisible() = 0;
	virtual int GetLocalPlayer() = 0;
	virtual void pad9() = 0;
	virtual void pad10() = 0;
	virtual void pad11() = 0;
	virtual void pad12() = 0;
	virtual void pad13() = 0;
	virtual void pad14() = 0;
	//virtual void GetViewAngles(QAngle& va) = 0;
	//virtual void SetViewAngles(QAngle& va) = 0;
	virtual int GetMaxClients() = 0;
	virtual void pad15() = 0;
	virtual void pad16() = 0;
	virtual void pad17() = 0;
	virtual void pad18() = 0;
	virtual bool IsInGame() = 0;
	virtual bool IsConnected() = 0;
	virtual void pad19() = 0;
	virtual void pad20() = 0;
	virtual void pad21() = 0;
	virtual void pad22() = 0;
	virtual void pad23() = 0;
	virtual void pad24() = 0;
	virtual void pad25() = 0;
	virtual void pad26() = 0;
	virtual ViewMatrix_t& WorldToScreenMatrix() = 0;
	virtual ViewMatrix_t& WorldToViewMatrix() = 0;
};