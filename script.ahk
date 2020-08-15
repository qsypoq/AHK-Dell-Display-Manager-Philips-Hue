Run, %comspec% /c ""C:\Program Files (x86)\Dell\Dell Display Manager\ddm.exe" "/SetBrightnessLevel 70"", , Hide
DellBri := 70

FormatTime, TimeString, hh, Time
ActualTime := SubStr(TimeString, 1, 2)
if ActualTime between 8 and 15
{
    LampOn := "false"
}
else
{
    LampOn := "true"
}
Boot := ComObjCreate("WinHttp.WinHttpRequest.5.1")
Boot.Open("PUT", "http://$bridgeIP/api/$userID/lights/$lampID/state", 0)
body = {"on":%LampOn%, "bri":178}
Boot.Send(body)


StringBetween( String, NeedleStart, NeedleEnd="" ) {
    StringGetPos, pos, String, % NeedleStart
    If ( ErrorLevel )

         Return ""
    StringTrimLeft, String, String, pos + StrLen( NeedleStart )
    If ( NeedleEnd = "" )
        Return String
    StringGetPos, pos, String, % NeedleEnd
    If ( ErrorLevel )
        Return ""
    StringLeft, String, String, pos
    Return String
}


LWin & F1::
DellBri -= 10
FormatTime, TimeString, hh, Time
ActualTime := SubStr(TimeString, 1, 2)
if ActualTime between 8 and 15
{
    LampOn := "false"
}
else
{
    LampOn := "true"
}
if DellBri <= 0
{
    DellBri = 0
    Run, %comspec% /c ""C:\Program Files (x86)\Dell\Dell Display Manager\ddm.exe" "/SetBrightnessLevel 0"", , Hide
    SendBri := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    SendBri.Open("PUT", "http://$bridgeIP/api/$userID/lights/$lampID/state", 0)
    body = {"on":%LampOn%, "bri":0}
    SendBri.Send(body)
}
else
{
    Run, %comspec% /c ""C:\Program Files (x86)\Dell\Dell Display Manager\ddm.exe" "/SetBrightnessLevel %DellBri%"", , Hide
    GetBri := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    GetBri.Open("GET", "http://$bridgeIP/api/$userID/lights/$lampID/", 0)
    GetBri.Send()
    FullResponse := GetBri.ResponseText
    start = bri":
    end = ,"hue"
    ActualBri := StringBetween( FullResponse, start, end )
    NewBri := ActualBri - 25
    SendBri := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    SendBri.Open("PUT", "http://$bridgeIP/api/$userID/lights/$lampID/state", 0)
    body = {"on":%LampOn%, "bri":%NewBri%}
    SendBri.Send(body)
}
Return


LWin & F2::
DellBri += 10
FormatTime, TimeString, hh, Time
ActualTime := SubStr(TimeString, 1, 2)
if ActualTime between 8 and 15
{
    LampOn := "false"
}
else
{
    LampOn := "true"
}
if DellBri >= 100
{
    DellBri = 100
    Run, %comspec% /c ""C:\Program Files (x86)\Dell\Dell Display Manager\ddm.exe" "/SetBrightnessLevel 100"", , Hide
    SendBri := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    SendBri.Open("PUT", "http://$bridgeIP/api/$userID/lights/$lampID/state", 0)
    body = {"on":%LampOn%, "bri":255}
    SendBri.Send(body)
}
else
{
    Run, %comspec% /c ""C:\Program Files (x86)\Dell\Dell Display Manager\ddm.exe" "/SetBrightnessLevel %DellBri%"", , Hide
    GetBri := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    GetBri.Open("GET", "http://$bridgeIP/api/$userID/lights/$lampID/", 0)
    GetBri.Send()
    FullResponse := GetBri.ResponseText
    start = bri":
    end = ,"hue"
    ActualBri := StringBetween( FullResponse, start, end )
    NewBri := ActualBri + 25
    SendBri := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    SendBri.Open("PUT", "http://$bridgeIP/api/$userID/lights/$lampID/state", 0)
    body = {"on":%LampOn%, "bri":%NewBri%}
    SendBri.Send(body)
}
Return