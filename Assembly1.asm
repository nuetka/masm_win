.386 ; Enable 80386+ instruction set
.model flat, stdcall ; Flat, 32-bit memory model (not used in 64-bit)
option casemap: none ; Case sensitive syntax
; *************************************************************************
; Our Window procedure prototype
; *************************************************************************
WndProc proto :DWORD,:DWORD,:DWORD,:DWORD
; *************************************************************************
; Our main application procedure prototype
; *************************************************************************
WinMain proto :DWORD,:DWORD,:DWORD,:DWORD 
; ************************************************************************* 
include \masm32\include\windows.inc 
include \masm32\include\user32.inc 
include \masm32\include\kernel32.inc 
; ************************************************************************* 
includelib \masm32\lib\user32.lib 
includelib \masm32\lib\kernel32.lib 
; *************************************************************************
; Our initialized data section. Here we declare our strings.
; *************************************************************************
.data 
szClassName DB 'EasyCode2MainWindow', 0
szTitle DB 'Main window', 0 
; *************************************************************************
; Our un-initialized data section. We don't care about the values assigned.
; *************************************************************************
.data?
hInstance HINSTANCE ? 
CommandLine LPSTR ? 
.code
start: 
invoke GetModuleHandle, NULL ; Handle ����������
mov hInstance,eax ; ����������
invoke GetCommandLine ; ��������� �� ��������� ������
mov CommandLine,eax ;
invoke WinMain, hInstance,NULL,
 CommandLine, SW_SHOWDEFAULT 
invoke ExitProcess,eax
; ******************************************************
;��������� �������� WinMain ����������, � ����� ���� ����������� 
;���������� � � ���������������� ����� (SW_MINIMIZE), 
; ����������������� (SW_SHOWMAXIMIZED), ���������������
; (SW_SHOWMINIMIZED)

; ������� ���������
WinMain proc hInst:HINSTANCE,hPrevInst:HINSTANCE,CmdLine:LPSTR,CmdShow:DWORD 
LOCAL wc:WNDCLASSEX 
LOCAL msg:MSG 
LOCAL hWin:HWND
mov wc.cbSize,SIZEOF WNDCLASSEX 
mov wc.style, CS_HREDRAW or CS_VREDRAW or CS_DBLCLKS
mov wc.lpfnWndProc, OFFSET WndProc 
mov wc.cbClsExtra,NULL 
mov wc.cbWndExtra,NULL
push hInst 
pop wc.hInstance 
mov wc.hbrBackground,COLOR_BTNFACE+1 
mov wc.lpszMenuName,NULL
mov wc.lpszClassName,OFFSET szClassName
invoke LoadIcon,NULL,IDI_APPLICATION
mov wc.hIcon,eax 
mov wc.hIconSm,eax
invoke LoadCursor,NULL,IDC_ARROW 
mov wc.hCursor,eax
invoke RegisterClassEx, addr wc
invoke CreateWindowEx,NULL, ADDR szClassName, ADDR szTitle, WS_OVERLAPPEDWINDOW,
 CW_USEDEFAULT,0, CW_USEDEFAULT,0, NULL,NULL,hInstance,NULL
mov hWin,eax 
invoke ShowWindow, hWin,SW_SHOWNORMAL
invoke UpdateWindow, hWin
.WHILE TRUE 
invoke GetMessage, ADDR msg,NULL,0,0 
.BREAK .IF (!eax) 
invoke TranslateMessage, ADDR msg 
invoke DispatchMessage, ADDR msg 
.ENDW 
mov eax,msg.wParam 
ret 
WinMain endp

; ��������� ���� -  ������������ ���������������� ���� � ��� 
; ������� �� ������� � ���������� �����������.
WndProc proc hWnd:DWORD, uMsg:DWORD, wParam:DWORD, lParam:DWORD
.If uMsg == WM_CREATE ; ��������� � �������� ����
L2: Ret    ; ������� ����������
; ���� �� �������� ������� ���
.ElseIf uMsg == WM_NCLBUTTONDBLCLK
; ������������� ����
Invoke ShowWindow, hWnd, SW_MAXIMIZE
Jmp L2
; ���� ������ �������
.ElseIf uMsg == WM_KEYDOWN
; Ÿ �������� A-Z
.If wParam > 040H   ; wParam �������� ����������� ��� �������, �������������� ����������� ��� 
;������������� �������.
.If wParam < 05BH
; ��������������� ������� ����
Invoke ShowWindow, hWnd, SW_RESTORE
.EndIf
.EndIf
Jmp L2
.ElseIf uMsg == WM_DESTROY
;===========
; Final code
;===========
Invoke PostQuitMessage, 0
Jmp L2
.EndIf
;���� ��������� ���� �� ������������ �����-���� ���������, 
;��� �������� DefWindowProc ��� ���������� ��������� �� ���������.
Invoke DefWindowProc, hWnd, uMsg, wParam, lParam
Jmp L2
WndProc endp
end start 
