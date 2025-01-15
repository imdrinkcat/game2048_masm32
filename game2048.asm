.386
.model flat, stdcall
option casemap:none

include windows.inc
include msvcrt.inc
includelib msvcrt.lib
include kernel32.inc
includelib kernel32.lib
include user32.inc
includelib user32.lib
includelib gdi32.lib
include gdi32.inc

printf PROTO C :dword,:vararg

;==============================================================
;>> ���ݶ�
;==============================================================
.data

;���
hInstance dd ?
hWinMain dd ?

;�����ʽ
szNumFormat byte "%d", 0

randomSeed dd 0
score dd 0
bestScore dd 0
reached2048 dd 0
infiniteMode dd 0
gameEnd dd 0

movedUp dd 0
movedDown dd 0
movedLeft dd 0
movedRight dd 0

numMat dd 16 dup(?)
numMatCopy dd 16 dup(?)
flag dd 4 dup(?)

isUpPressed db 0
isDownPressed db 0
isLeftPressed db 0
isRightPressed db 0

;==============================================================
;>> �����ʽ
;==============================================================
FONT_CELL_NUM dd ?
FONT_TITLE dd ?
FONT_SCORE_TXT dd ?
FONT_SCORE_NUM dd ?
FONT_RESTART dd ?
FONT_INTRO_TITLE dd ?
FONT_INTRO_TXT dd ?
FONT_CELL_NUM100 dd ?
FONT_CELL_NUM1000 dd ?
FONT_CELL_NUM10000 dd ?

;==============================================================
;>> ���ָ��ӱ�ˢ��ʽ
;==============================================================
BRUSH_CELL_0 dd ?
BRUSH_CELL_2 dd ?
BRUSH_CELL_4 dd ?
BRUSH_CELL_8 dd ?
BRUSH_CELL_16 dd ?
BRUSH_CELL_32 dd ?
BRUSH_CELL_64 dd ?
BRUSH_CELL_128 dd ?
BRUSH_CELL_256 dd ?
BRUSH_CELL_512 dd ?
BRUSH_CELL_1024 dd ?
BRUSH_CELL_2048 dd ?

;==============================================================
;>> ������
;==============================================================
.const

;==============================================================
;>> ��ɫ����
;==============================================================
COLOR_WINDOW_BG equ 0c3aeb0h
COLOR_MATRIX_BG equ 06c7289h

COLOR_TITLE_TXT equ 0ffffffh
COLOR_SCORE_TXT equ 0ffffffh
COLOR_SCORE_NUM equ 0ffffffh

COLOR_BUTTON_TXT equ 0ffffffh

COLOR_INTRO_TITLE equ 0ffffffh
COLOR_INTRO_TXT equ 0ffffffh

COLOR_NUM0_BG equ 0bbc5cfh
COLOR_NUM2_BG equ 0c4dbfbh
COLOR_NUM4_BG equ 0afaed8h
COLOR_NUM8_BG equ 0bca6aeh
COLOR_NUM16_BG equ 0a09199h
COLOR_NUM32_BG equ 073675bh
COLOR_NUM64_BG equ 0d8d0c3h
COLOR_NUM128_BG equ 0c9c7b5h
COLOR_NUM256_BG equ 0c2bc9fh
COLOR_NUM512_BG equ 05f5347h
COLOR_NUM1024_BG equ 045372bh
COLOR_NUM2048_BG equ 08d4277h

COLOR_NUM_DARK equ 0656e77h
COLOR_NUM_LIGHT equ 0f2f6f9h

;==============================================================
;>> �ؼ��ߴ��λ��
;==============================================================
;�ߴ���Ϣ
;���ڳߴ�
WINDOW_WIDTH equ 1000
WINDOW_HEIGHT equ 660
;����ߴ�
WIDGET_MARGIN_SMALL equ 20
WIDGET_MARGIN_LARGE equ 40
;���־���ߴ�
WIDGET_MAT_EDGE equ 580
;���ַ���ߴ�
WIDGET_CELL_EDGE equ 120
;������
WIDGET_TEXT_WIDTH equ 320
;�������
WIDGET_SCORE_WIDTH equ 150
;�߶�
WIDGET_TITLE_HEIGHT equ 100
WIDGET_SCORE_HEIGHT equ 75
WIDGET_RESTART_HEIGHT equ 50
WIDGET_INTRO_HEIGHT equ 235

;�ؼ�λ����Ϣ
;���־���λ��
WIDGET_MAT_START_XY equ 20
WIDGET_MAT_END_XY equ 600
;����λ��
WIDGET_TITLE_START_X equ 640
WIDGET_TITLE_START_Y equ 20
WIDGET_TITLE_END_X equ 960
WIDGET_TITLE_END_Y equ 120
;����λ��
WIDGET_SCORE_START_Y equ 160
WIDGET_SCORE_END_Y equ 235
WIDGET_CURRENT_SCORE_END_X equ 790
WIDGET_MAX_SCORE_START_X equ 810
;�ؿ���ť
WIDGET_RE_START_Y equ 275
WIDGET_RE_END_Y equ 325
;����˵��
WIDGET_INTRO_START_Y equ 365
WIDGET_INTRO_END_Y equ 600

;����λ����Ϣ
;����λ��
TXT_TITLE_START_X equ 720
TXT_TITLE_START_Y equ 30
;����λ��
TXT_CURRENT_SCORE_TXT_START_X equ 643
TXT_MAX_SCORE_TXT_START_X equ 813
TXT_SCORE_TXT_START_Y equ 162
TXT_CURRENT_SCORE_NUM_START_X equ 700
TXT_MAX_SCORE_NUM_START_X equ 870
TXT_SCORE_NUM_START_Y equ 202
;�ؿ���ť����λ��
TXT_RE_START_X equ 640
TXT_RE_START_Y equ 280
;����˵��
TXT_INTRO_TITLE_START_X equ 740
TXT_INTRO_TITLE_START_Y equ 370
TXT_INTRO_INFO_START_X equ 745
TXT_INTRO_INFO_START_Yw equ 425
TXT_INTRO_INFO_START_Ya equ 465
TXT_INTRO_INFO_START_Ys equ 505
TXT_INTRO_INFO_START_Yd equ 545

;���ֵ�ƫ��
OFFSET_CELL_10_X equ 37
OFFSET_CELL_10_Y equ 18
OFFSET_CELL_100_X equ 21
OFFSET_CELL_100_Y equ 18
OFFSET_CELL_1000_X equ 13
OFFSET_CELL_1000_Y equ 24
OFFSET_CELL_10000_X equ 12
OFFSET_CELL_10000_Y equ 31

;==============================================================
;>> ��ʾ�ı�
;==============================================================
szClassName db "MainWindowClass", 0
szTitleMain db "Game 2048", 0
szFontName byte "Clear Sans", 0

TXT_TITLE byte "2048", 0
TXT_CURRENT_SCORE byte "��ǰ�÷�", 0
TXT_BEST_SCORE byte "��ߵ÷�", 0
TXT_INTRO_TITLE byte "����ָ��", 0
TXT_INTRO_TXTw byte "W������", 0
TXT_INTRO_TXTa byte "A������", 0
TXT_INTRO_TXTs byte "S������", 0
TXT_INTRO_TXTd byte "D������", 0

MSG_WIN_TITLE byte "��Ϸʤ����", 0
MSG_WIN byte "���ķ����Ѿ�����2048!", 0
MSG_CONTINUE byte "��ϣ��������Ϸ�𣿣������޾�ģʽ��", 0
MSG_GAME_OVER_TITLE byte "��Ϸ������", 0
MSG_GAME_OVER_TXT byte "�޷������ƶ�����Ϸ������", 0

TXT_BUTTON_RESTART byte "���¿�ʼ", 0

BITMAP1 EQU 101
BITMAP2 EQU 104
lcgMaxNum EQU 16

;==============================================================
;>> �����
;==============================================================
.code

;==============================================================
;>> �ھ����������������
;>> ��������ͬ�����������������λ�á���ֵ
;==============================================================
randomLCG proc     
	local lcg_a, lcg_c, randNum, randPos

	pusha ;�����ֳ�
	mov eax, randomSeed ;��ʼ����

	;==========================================================
	;>> LCG ��������
	;==========================================================
	mov lcg_a, 0343fdh
	mov lcg_c, 269ec3h

lcg:
	;==========================================================
	;>> �������λ��
	;==========================================================
	mul lcg_a
	add eax, lcg_c
	xor edx, edx
	mov ebx, lcgMaxNum
	div ebx
	mov eax, edx
	mov	randPos, eax ;�������λ��

	;==========================================================
	;>> ������λ���Ƿ�Ϊ��
	;==========================================================
	mov eax, randPos
	.if numMat[eax * 4] != 0
		jmp lcg
	.endif

	;==========================================================
	;>> �������ֵ2��4
	;==========================================================
	mul lcg_a ;�ٴμ��������
	add eax, lcg_c
	xor edx, edx
	mov ebx, lcgMaxNum
	div ebx
	mov eax, edx
	xor edx, edx
	mov ebx, 2
	div ebx
	.if edx
		mov randNum, 2
	.else 
		mov randNum, 4
	.endif

	;==========================================================
	;>> �������־���
	;==========================================================
	mov eax, randPos
	mov edx, randNum
	mov numMat[eax * 4], edx
	mov randomSeed, eax

	popa ;��ԭ�ֳ�
	ret
randomLCG Endp

;==============================================================
;>> ���ݵ�ǰ����������߷�
;==============================================================
updateBestScore proc far C
	pushad
	mov eax, score
	.if bestScore < eax
		mov bestScore, eax
	.endif
	popad
	ret
updateBestScore endp

;==============================================================
;>> ���ݾ���ǰ״̬�������
;==============================================================
updateScore proc far C
    pushad
	mov eax, 0
	mov score, 0
	mov edi, 0

	;��������
	mov ecx, 0
	.while ecx < 16
		mov esi, numMat[ecx*4]
		.if esi > edi
			mov edi, esi
		.endif
		inc ecx
	.endw

	;�ж�ʤ������
	.if edi == 2048
		mov reached2048, 1
	.endif
	mov score, edi
	
	popad
    ret
updateScore endp

;==============================================================
;>> ���������ƶ�
;==============================================================
moveUp proc
	local col, row, changed, r
	local currentNum, tmpNum, targetRow
	pushad ;�����ֳ�
	mov changed, 0
	mov movedUp, 0
	mov col, 0
	.while col < 4
		;���flag���
		xor eax, eax
		mov flag[0], eax
		mov flag[4], eax
		mov flag[8], eax
		mov flag[12], eax
		mov row, 1
		.while row < 4
			;��ȡ��ǰλ������
			mov eax, row
			mov ebx, col
			shl eax, 2
			add eax, ebx
			mov edi, numMat[eax*4]
			mov currentNum, edi
			;����targetRowΪ��ǰrow
			mov edi, row
			mov targetRow, edi
			;r = row - 1
			dec edi
			mov r, edi
			.while r >= 0 && currentNum != 0
				;tmpNum = numMat[r][col]
				mov eax, r
				mov ebx, col
				shl eax, 2
				add eax, ebx
				mov edi, numMat[eax*4]
				mov tmpNum, edi
				mov ecx, currentNum
				mov edi, r
				.if tmpNum == 0
					;numMat[r][col] = currentNum;
					mov eax, r
					mov ebx, col
					shl eax, 2
					add eax, ebx
					mov ecx, currentNum
					mov numMat[eax*4], ecx
					;numMat[targetRow][col] = 0;
					mov eax, targetRow
					mov ebx, col
					shl eax, 2
					add eax, ebx
					mov ecx, 0
					mov numMat[eax*4], ecx
					;targetRow = r;
					mov ecx, r
					mov targetRow, ecx
					;changed = 1;
					mov changed, 1
				.elseif tmpNum == ecx && flag[edi*4] == 0
					;numMat[r][col] = currentNum* 2;
					mov eax, r
					mov ebx, col
					shl eax, 2
					add eax, ebx
					mov ecx, currentNum
					shl ecx, 1
					mov numMat[eax*4], ecx
					;numMat[targetRow][col] = 0;
					mov eax, targetRow
					mov ebx, col
					shl eax, 2
					add eax, ebx
					mov ecx, 0
					mov numMat[eax*4], ecx
					;flag[r] = 1;
					mov edi, r
					mov flag[edi*4], 1
					;changed = 1;
					mov changed, 1
					.break
				.else
					.break
				.endif
				.if r == 0
					.break
				.endif
				dec r
			.endw
			inc row
		.endw
		inc col
	.endw
	.if changed == 1
		mov movedUp, 1
	.endif
	popad ;�ָ��ֳ�
	ret
moveUp endp

;==============================================================
;>> ���������ƶ�
;==============================================================
moveDown proc
	local col, row, changed, r
	local currentNum, tmpNum, targetRow
	pushad ;�����ֳ�
	mov changed, 0
	mov movedDown, 0
	mov col, 0
	.while col < 4
		;���flag���
		xor eax, eax
		mov flag[0], eax
		mov flag[4], eax
		mov flag[8], eax
		mov flag[12], eax
		mov row, 2
		.while row >= 0
			;��ȡ��ǰλ������
			mov eax, row
			mov ebx, col
			shl eax, 2
			add eax, ebx
			mov edi, numMat[eax*4]
			mov currentNum, edi
			;����targetRowΪ��ǰrow
			mov edi, row
			mov targetRow, edi
			;r = row + 1
			inc edi
			mov r, edi
			.while r < 4 && currentNum != 0
				;tmpNum = numMat[r][col]
				mov eax, r
				mov ebx, col
				shl eax, 2
				add eax, ebx
				mov edi, numMat[eax*4]
				mov tmpNum, edi
				mov ecx, currentNum
				mov edi, r
				.if tmpNum == 0
					;numMat[r][col] = currentNum;
					mov eax, r
					mov ebx, col
					shl eax, 2
					add eax, ebx
					mov ecx, currentNum
					mov numMat[eax*4], ecx
					;numMat[targetRow][col] = 0;
					mov eax, targetRow
					mov ebx, col
					shl eax, 2
					add eax, ebx
					mov ecx, 0
					mov numMat[eax*4], ecx
					;targetRow = r;
					mov ecx, r
					mov targetRow, ecx
					;changed = 1;
					mov changed, 1
				.elseif tmpNum == ecx && flag[edi*4] == 0
					;numMat[r][col] = currentNum* 2;
					mov eax, r
					mov ebx, col
					shl eax, 2
					add eax, ebx
					mov ecx, currentNum
					shl ecx, 1
					mov numMat[eax*4], ecx
					;numMat[targetRow][col] = 0;
					mov eax, targetRow
					mov ebx, col
					shl eax, 2
					add eax, ebx
					mov ecx, 0
					mov numMat[eax*4], ecx
					;flag[r] = 1;
					mov edi, r
					mov flag[edi*4], 1
					;changed = 1;
					mov changed, 1
					.break
				.else
					.break
				.endif
				inc r
			.endw
			.if row == 0
				.break
			.endif
			dec row
		.endw
		inc col
	.endw
	.if changed == 1
		mov movedDown, 1
	.endif
	popad ;�ָ��ֳ�
	ret
moveDown endp

;==============================================================
;>> ���������ƶ�
;==============================================================
moveLeft proc
	local col, row, changed, co
	local currentNum, tmpNum, targetCol
	pushad ;�����ֳ�
	mov changed, 0
	mov movedLeft, 0
	mov row, 0
	.while row < 4
		;���flag���
		xor eax, eax
		mov flag[0], eax
		mov flag[4], eax
		mov flag[8], eax
		mov flag[12], eax
		mov col, 1
		.while col < 4
			;��ȡ��ǰλ������
			mov eax, row
			mov ebx, col
			shl eax, 2
			add eax, ebx
			mov edi, numMat[eax*4]
			mov currentNum, edi
			;����targetColΪ��ǰcol
			mov edi, col
			mov targetCol, edi
			;co = col - 1
			dec edi
			mov co, edi
			.while co >= 0 && currentNum != 0
				;tmpNum = numMat[row][co]
				mov eax, row
				mov ebx, co
				shl eax, 2
				add eax, ebx
				mov edi, numMat[eax*4]
				mov tmpNum, edi
				mov ecx, currentNum
				mov edi, co
				.if tmpNum == 0
					;numMat[row][co] = currentNum;
					mov eax, row
					mov ebx, co
					shl eax, 2
					add eax, ebx
					mov ecx, currentNum
					mov numMat[eax*4], ecx
					;numMat[row][targetCol] = 0;
					mov eax, row
					mov ebx, targetCol
					shl eax, 2
					add eax, ebx
					mov ecx, 0
					mov numMat[eax*4], ecx
					;targetCol = co;
					mov ecx, co
					mov targetCol, ecx
					;changed = 1;
					mov changed, 1
				.elseif tmpNum == ecx && flag[edi*4] == 0
					;numMat[row][co] = currentNum* 2;
					mov eax, row
					mov ebx, co
					shl eax, 2
					add eax, ebx
					mov ecx, currentNum
					shl ecx, 1
					mov numMat[eax*4], ecx
					;numMat[row][targetCol] = 0;
					mov eax, row
					mov ebx, targetCol
					shl eax, 2
					add eax, ebx
					mov ecx, 0
					mov numMat[eax*4], ecx
					;flag[co] = 1;
					mov edi, co
					mov flag[edi*4], 1
					;changed = 1;
					mov changed, 1
					.break
				.else
					.break
				.endif
				.if co == 0
					.break
				.endif
				dec co
			.endw
			inc col
		.endw
		inc row
	.endw
	.if changed == 1
		mov movedLeft, 1
	.endif
	popad ;�ָ��ֳ�
	ret
moveLeft endp

;==============================================================
;>> ���������ƶ�
;==============================================================
moveRight proc
	local col, row, changed, co
	local currentNum, tmpNum, targetCol
	pushad ;�����ֳ�
	mov changed, 0
	mov movedRight, 0
	mov row, 0
	.while row < 4
		;���flag���
		xor eax, eax
		mov flag[0], eax
		mov flag[4], eax
		mov flag[8], eax
		mov flag[12], eax
		mov col, 2
		.while col >= 0
			;��ȡ��ǰλ������
			mov eax, row
			mov ebx, col
			shl eax, 2
			add eax, ebx
			mov edi, numMat[eax*4]
			mov currentNum, edi
			;����targetColΪ��ǰcol
			mov edi, col
			mov targetCol, edi
			;co = col + 1
			inc edi
			mov co, edi
			.while co < 4 && currentNum != 0
				;tmpNum = numMat[row][co]
				mov eax, row
				mov ebx, co
				shl eax, 2
				add eax, ebx
				mov edi, numMat[eax*4]
				mov tmpNum, edi
				mov ecx, currentNum
				mov edi, co
				.if tmpNum == 0
					;numMat[row][co] = currentNum;
					mov eax, row
					mov ebx, co
					shl eax, 2
					add eax, ebx
					mov ecx, currentNum
					mov numMat[eax*4], ecx
					;numMat[row][targetCol] = 0;
					mov eax, row
					mov ebx, targetCol
					shl eax, 2
					add eax, ebx
					mov ecx, 0
					mov numMat[eax*4], ecx
					;targetCol = co;
					mov ecx, co
					mov targetCol, ecx
					;changed = 1;
					mov changed, 1
				.elseif tmpNum == ecx && flag[edi*4] == 0
					;numMat[row][co] = currentNum* 2;
					mov eax, row
					mov ebx, co
					shl eax, 2
					add eax, ebx
					mov ecx, currentNum
					shl ecx, 1
					mov numMat[eax*4], ecx
					;numMat[row][targetCol] = 0;
					mov eax, row
					mov ebx, targetCol
					shl eax, 2
					add eax, ebx
					mov ecx, 0
					mov numMat[eax*4], ecx
					;flag[co] = 1;
					mov edi, co
					mov flag[edi*4], 1
					;changed = 1;
					mov changed, 1
					.break
				.else
					.break
				.endif
				inc co
			.endw
			.if col == 0
				.break
			.endif
			dec col
		.endw
		inc row
	.endw
	.if changed == 1
		mov movedRight, 1
	.endif
	popad ;�ָ��ֳ�
	ret
moveRight endp

;==============================================================
;>> �ж��Ƿ���Լ����ƶ�
;==============================================================
canMove proc
	pushad ;�����ֳ�
	;����numMat
	mov ecx, 0
	.while ecx < 16
		mov esi, numMat[ecx*4]
		mov numMatCopy[ecx*4], esi
		inc ecx
	.endw

	;���������ƶ�
	invoke moveUp
	;�ָ�numMat
	mov ecx, 0
	.while ecx < 16
		mov esi, numMatCopy[ecx*4]
		mov numMat[ecx*4], esi
		inc ecx
	.endw

	;���������ƶ�
	invoke moveDown
	;�ָ�numMat
	mov ecx, 0
	.while ecx < 16
		mov esi, numMatCopy[ecx*4]
		mov numMat[ecx*4], esi
		inc ecx
	.endw

	;���������ƶ�
	invoke moveLeft
	;�ָ�numMat
	mov ecx, 0
	.while ecx < 16
		mov esi, numMatCopy[ecx*4]
		mov numMat[ecx*4], esi
		inc ecx
	.endw

	;���������ƶ�
	invoke moveRight
	;�ָ�numMat
	mov ecx, 0
	.while ecx < 16
		mov esi, numMatCopy[ecx*4]
		mov numMat[ecx*4], esi
		inc ecx
	.endw

	.if movedUp || movedDown || movedLeft || movedRight
		mov gameEnd, 0
	.else
		mov gameEnd, 1
	.endif

	popad ;�ָ��ֳ�
	ret
canMove endp

;==============================================================
;>> ���´�����ʾ
;==============================================================
updateGameWnd proc far C, hWnd, hDc
    local len
    local szBuffer[10]: byte
    local tmpHandler, _hDc, _cptBmp

	local cellStartX, cellEndX, cellStartY, cellEndY
	local numStartX, numStartY
	local i, j, currentNum
    
    pushad ;�����ֳ�

	;==========================================================
	;>> ���������ĺ�λͼ
	;==========================================================
    invoke CreateCompatibleDC, hDc
    mov _hDc, eax
    invoke CreateCompatibleBitmap, hDc, WINDOW_WIDTH, WINDOW_HEIGHT
    mov _cptBmp, eax
	invoke SelectObject, _hDc, _cptBmp ;��_cptBmpѡ��Ϊ_hDc�Ļ�ͼ����

    ;==========================================================
	;>> �������屳��
	;==========================================================
	;������ˢ
    invoke CreateSolidBrush, COLOR_WINDOW_BG
	;������
    mov tmpHandler, eax
	;ѡ��ˢ
    invoke SelectObject, _hDc, eax
	;���ƾ�����������
    invoke Rectangle, _hDc, -10, -10, WINDOW_WIDTH, WINDOW_HEIGHT
	;ɾ����ˢ����
    invoke DeleteObject, tmpHandler 

	;==========================================================
	;>> ����4*4���־��󱳾�
	;==========================================================
    invoke GetStockObject, NULL_PEN
    invoke SelectObject, _hDc, eax
    invoke CreateSolidBrush, COLOR_MATRIX_BG
    mov tmpHandler, eax
    invoke SelectObject, _hDc, eax
    invoke RoundRect, _hDc, WIDGET_MAT_START_XY, WIDGET_MAT_START_XY, \
			WIDGET_MAT_END_XY, WIDGET_MAT_END_XY, 6, 6
    invoke SetBkMode, _hDc, TRANSPARENT
	
	;==========================================================
	;>> �Ҳ���Ϣ������
	;==========================================================
	;�����
	invoke RoundRect, _hDc, WIDGET_TITLE_START_X, WIDGET_TITLE_START_Y, \
			WIDGET_TITLE_END_X, WIDGET_TITLE_END_Y, 3, 3
    ;��ǰ������
	invoke RoundRect, _hDc, WIDGET_TITLE_START_X, WIDGET_SCORE_START_Y, \
			WIDGET_CURRENT_SCORE_END_X, WIDGET_SCORE_END_Y, 3, 3
    ;��߷�����
	invoke RoundRect, _hDc, WIDGET_MAX_SCORE_START_X, WIDGET_SCORE_START_Y, \
			WIDGET_TITLE_END_X, WIDGET_SCORE_END_Y, 3, 3
	;��Ϸ˵����
	invoke RoundRect, _hDc, WIDGET_TITLE_START_X, WIDGET_INTRO_START_Y, \
			WIDGET_TITLE_END_X, WIDGET_INTRO_END_Y, 3, 3
	;�ؿ���ť
	;invoke RoundRect, _hDc, WIDGET_TITLE_START_X, WIDGET_RE_START_Y, \
	;		WIDGET_TITLE_END_X, WIDGET_RE_END_Y, 3, 3
	invoke DeleteObject, tmpHandler

	;==========================================================
	;>> �Ҳ���Ϣ������
	;==========================================================
	;����
    invoke SelectObject, _hDc, FONT_TITLE
    invoke SetTextColor, _hDc, COLOR_TITLE_TXT
    invoke TextOut, _hDc, TXT_TITLE_START_X, TXT_TITLE_START_Y, \
			addr TXT_TITLE, lengthof TXT_TITLE
	;��ǰ�÷�����
	invoke SelectObject, _hDc, FONT_SCORE_TXT
    invoke SetTextColor, _hDc, COLOR_SCORE_TXT
    invoke TextOut, _hDc, TXT_CURRENT_SCORE_TXT_START_X, TXT_SCORE_TXT_START_Y, \
			addr TXT_CURRENT_SCORE, lengthof TXT_CURRENT_SCORE
	;��ǰ��������
	invoke updateScore ;���µ�ǰ�÷�
    invoke wsprintf, addr szBuffer, addr szNumFormat, score
	mov len, eax ;��¼����
	invoke SelectObject, _hDc, FONT_SCORE_NUM
    invoke SetTextColor, _hDc, COLOR_SCORE_NUM
	invoke TextOut, _hDc, TXT_CURRENT_SCORE_NUM_START_X, TXT_SCORE_NUM_START_Y, \
			addr szBuffer, len
	;��߷�������
	invoke SelectObject, _hDc, FONT_SCORE_TXT
    invoke SetTextColor, _hDc, COLOR_SCORE_TXT
    invoke TextOut, _hDc, TXT_MAX_SCORE_TXT_START_X, TXT_SCORE_TXT_START_Y, \
			addr TXT_BEST_SCORE, lengthof TXT_BEST_SCORE
	;��߷�������
	invoke updateBestScore ;������ߵ÷�
    invoke wsprintf, addr szBuffer, addr szNumFormat, bestScore
	mov len, eax
	invoke SelectObject, _hDc, FONT_SCORE_NUM
    invoke SetTextColor, _hDc, COLOR_SCORE_NUM
    invoke TextOut, _hDc, TXT_MAX_SCORE_NUM_START_X, TXT_SCORE_NUM_START_Y, \
			addr szBuffer, len
	;�������¿�ʼ��ť����
	;invoke SelectObject, _hDc, FONT_RESTART
    ;invoke SetTextColor, _hDc, COLOR_BUTTON_TXT
    ;invoke TextOut, _hDc, TXT_RE_START_X, TXT_RE_START_Y, \
	;		addr TXT_BUTTON_RESTART, lengthof TXT_BUTTON_RESTART
	;����������Ϣ����
	invoke SelectObject, _hDc, FONT_SCORE_NUM
    invoke SetTextColor, _hDc, COLOR_INTRO_TITLE
    invoke TextOut, _hDc, TXT_INTRO_TITLE_START_X, TXT_INTRO_TITLE_START_Y, \
			addr TXT_INTRO_TITLE, lengthof TXT_INTRO_TITLE
	;����������Ϣ����w
	invoke SelectObject, _hDc, FONT_INTRO_TXT
    invoke SetTextColor, _hDc, COLOR_INTRO_TXT
    invoke TextOut, _hDc, TXT_INTRO_INFO_START_X, TXT_INTRO_INFO_START_Yw, \
			addr TXT_INTRO_TXTw, lengthof TXT_INTRO_TXTw
	;����������Ϣ����a
	invoke SelectObject, _hDc, FONT_INTRO_TXT
    invoke SetTextColor, _hDc, COLOR_INTRO_TXT
    invoke TextOut, _hDc, TXT_INTRO_INFO_START_X, TXT_INTRO_INFO_START_Ya, \
			addr TXT_INTRO_TXTa, lengthof TXT_INTRO_TXTa
	;����������Ϣ����s
	invoke SelectObject, _hDc, FONT_INTRO_TXT
    invoke SetTextColor, _hDc, COLOR_INTRO_TXT
    invoke TextOut, _hDc, TXT_INTRO_INFO_START_X, TXT_INTRO_INFO_START_Ys, \
			addr TXT_INTRO_TXTs, lengthof TXT_INTRO_TXTs
	;����������Ϣ����d
	invoke SelectObject, _hDc, FONT_INTRO_TXT
    invoke SetTextColor, _hDc, COLOR_INTRO_TXT
    invoke TextOut, _hDc, TXT_INTRO_INFO_START_X, TXT_INTRO_INFO_START_Yd, \
			addr TXT_INTRO_TXTd, lengthof TXT_INTRO_TXTd

	;==========================================================
	;>> �������ֵ�Ԫ��
	;==========================================================
	;����������
	mov eax, WIDGET_MAT_START_XY
	add eax, WIDGET_MARGIN_SMALL
	mov cellStartY, eax
	add eax, WIDGET_CELL_EDGE
	mov cellEndY, eax

	;ѭ������
    mov i, 0
    .while i < 4
        mov j, 0
		mov eax, WIDGET_MAT_START_XY
		add eax, WIDGET_MARGIN_SMALL
		mov cellStartX, eax
		add eax, WIDGET_CELL_EDGE
		mov cellEndX, eax
        .while j < 4
			;==================================================
			;>> ���㵱ǰ����
			;==================================================
			pushad
			mov eax, i
			shl eax, 2
			add eax, j
			mov ecx, numMat[eax*4]
			mov currentNum, ecx

			;==================================================
			;>> ���ƾ���
			;==================================================
			;��������ѡ���ˢ
			.if currentNum == 0
				invoke SelectObject, _hDc, BRUSH_CELL_0
			.elseif currentNum == 2
				invoke SelectObject, _hDc, BRUSH_CELL_2
			.elseif currentNum == 4
				invoke SelectObject, _hDc, BRUSH_CELL_4
			.elseif currentNum == 8
				invoke SelectObject, _hDc, BRUSH_CELL_8
			.elseif currentNum == 16
				invoke SelectObject, _hDc, BRUSH_CELL_16
			.elseif currentNum == 32
				invoke SelectObject, _hDc, BRUSH_CELL_32
			.elseif currentNum == 64
				invoke SelectObject, _hDc, BRUSH_CELL_64
			.elseif currentNum == 128
				invoke SelectObject, _hDc, BRUSH_CELL_128
			.elseif currentNum == 256
				invoke SelectObject, _hDc, BRUSH_CELL_256
			.elseif currentNum == 512
				invoke SelectObject, _hDc, BRUSH_CELL_512
			.elseif currentNum == 1024
				invoke SelectObject, _hDc, BRUSH_CELL_1024
			.else
				invoke SelectObject, _hDc, BRUSH_CELL_2048
			.endif
			;���ƾ���
			invoke RoundRect, _hDc, cellStartX, cellStartY, cellEndX, cellEndY, 3, 3

			;==================================================
			;>> ��������
			;==================================================
			;����Ϊ0ʱ��������
			.if currentNum == 0
				jmp L1
			.endif
			; ����������ɫ
			.if currentNum < 8
				invoke SetTextColor, _hDc, COLOR_NUM_DARK
			.else
				invoke SetTextColor, _hDc, COLOR_NUM_LIGHT
			.endif
			;ȷ�����ֵĻ���λ�ú�����
			mov eax, cellStartX
			mov numStartX, eax
			mov eax, cellStartY
			mov numStartY, eax
			.if currentNum < 10
				invoke SelectObject, _hDc, FONT_CELL_NUM100
				add numStartX, OFFSET_CELL_10_X
				add numStartY, OFFSET_CELL_10_Y
			.elseif currentNum < 100
				invoke SelectObject, _hDc, FONT_CELL_NUM100
				add numStartX, OFFSET_CELL_100_X
				add numStartY, OFFSET_CELL_100_Y
			.elseif currentNum < 1000
				invoke SelectObject, _hDc, FONT_CELL_NUM1000
				add numStartX, OFFSET_CELL_1000_X
				add numStartY, OFFSET_CELL_1000_Y
			.else
				invoke SelectObject, _hDc, FONT_CELL_NUM10000
				add numStartX, OFFSET_CELL_10000_X
				add numStartY, OFFSET_CELL_10000_Y
			.endif
			;��������
			invoke wsprintf, addr szBuffer, addr szNumFormat, currentNum
			invoke TextOut, _hDc, numStartX, numStartY, addr szBuffer, eax
L1:
			;���±���
			popad
            add cellStartX, WIDGET_CELL_EDGE + WIDGET_MARGIN_SMALL
            add cellEndX, WIDGET_CELL_EDGE + WIDGET_MARGIN_SMALL
            inc j
        .endw
		;���±���
        add cellStartY, WIDGET_CELL_EDGE + WIDGET_MARGIN_SMALL
        add cellEndY, WIDGET_CELL_EDGE + WIDGET_MARGIN_SMALL
		inc i
    .endw

	;==========================================================
	;>> ����UI
	;==========================================================
    invoke BitBlt, hDc, 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT, _hDc, 0, 0, SRCCOPY

	;==========================================================
	;>> �ͷ���Դ
	;==========================================================
    invoke DeleteObject, _cptBmp
    invoke DeleteDC, _hDc

	;==========================================================
	;>> ��Ϸʤ������
	;==========================================================
	.if infiniteMode == 0
		.if reached2048 == 1
			invoke MessageBox, hWinMain, offset MSG_WIN, offset MSG_WIN_TITLE, MB_OK
			.if eax == IDOK
				invoke MessageBox, hWinMain, offset MSG_CONTINUE,offset MSG_WIN_TITLE,MB_YESNO
				.if eax == IDYES
					mov infiniteMode, 1
				.elseif eax == IDNO
					invoke DestroyWindow, hWinMain
				.endif
			.endif
		.endif
	.endif

    popad ;��ԭ�ֳ�
    ret
updateGameWnd endp

;==============================================================
;>> ��ʼ������ͱ�ˢ
;==============================================================
initFonts proc far C
	;==========================================================
	;>> ������ʽ
	;==========================================================
	push eax
	invoke CreateFont, 90, 0, 0, 0, FW_BLACK, FALSE, FALSE, FALSE, DEFAULT_CHARSET, OUT_CHARACTER_PRECIS, CLIP_CHARACTER_PRECIS, DEFAULT_QUALITY, DEFAULT_PITCH or FF_DONTCARE, addr szFontName
	mov FONT_CELL_NUM, eax
	invoke CreateFont, 80, 0, 0, 0, FW_BLACK, FALSE, FALSE, FALSE, DEFAULT_CHARSET, OUT_CHARACTER_PRECIS, CLIP_CHARACTER_PRECIS, DEFAULT_QUALITY, DEFAULT_PITCH or FF_DONTCARE, addr szFontName
	mov FONT_TITLE, eax
	invoke CreateFont, 35, 0, 0, 0, FW_BLACK, FALSE, FALSE, FALSE, DEFAULT_CHARSET, OUT_CHARACTER_PRECIS, CLIP_CHARACTER_PRECIS, DEFAULT_QUALITY, DEFAULT_PITCH or FF_DONTCARE, addr szFontName
	mov FONT_SCORE_TXT, eax
	invoke CreateFont, 30, 0, 0, 0, FW_BLACK, FALSE, FALSE, FALSE, DEFAULT_CHARSET, OUT_CHARACTER_PRECIS, CLIP_CHARACTER_PRECIS, DEFAULT_QUALITY, DEFAULT_PITCH or FF_DONTCARE, addr szFontName
	mov FONT_SCORE_NUM, eax
	invoke CreateFont, 40, 0, 0, 0, FW_BLACK, FALSE, FALSE, FALSE, DEFAULT_CHARSET, OUT_CHARACTER_PRECIS, CLIP_CHARACTER_PRECIS, DEFAULT_QUALITY, DEFAULT_PITCH or FF_DONTCARE, addr szFontName
	mov FONT_RESTART, eax
	invoke CreateFont, 40, 0, 0, 0, FW_BLACK, FALSE, FALSE, FALSE, DEFAULT_CHARSET, OUT_CHARACTER_PRECIS, CLIP_CHARACTER_PRECIS, DEFAULT_QUALITY, DEFAULT_PITCH or FF_DONTCARE, addr szFontName
	mov FONT_INTRO_TITLE, eax
	invoke CreateFont, 30, 0, 0, 0, FW_BLACK, FALSE, FALSE, FALSE, DEFAULT_CHARSET, OUT_CHARACTER_PRECIS, CLIP_CHARACTER_PRECIS, DEFAULT_QUALITY, DEFAULT_PITCH or FF_DONTCARE, addr szFontName
	mov FONT_INTRO_TXT, eax

	;==========================================================
	;>> ����Block������
	;==========================================================
	invoke CreateFont, 72, 0, 0, 0, FW_BLACK, FALSE, FALSE, FALSE, DEFAULT_CHARSET, OUT_CHARACTER_PRECIS, CLIP_CHARACTER_PRECIS, DEFAULT_QUALITY, DEFAULT_PITCH or FF_DONTCARE, addr szFontName
    mov FONT_CELL_NUM100, eax
    invoke CreateFont, 59, 0, 0, 0, FW_BLACK, FALSE, FALSE, FALSE, DEFAULT_CHARSET, OUT_CHARACTER_PRECIS, CLIP_CHARACTER_PRECIS, DEFAULT_QUALITY, DEFAULT_PITCH or FF_DONTCARE, addr szFontName
    mov FONT_CELL_NUM1000, eax
    invoke CreateFont, 46, 0, 0, 0, FW_BLACK, FALSE, FALSE, FALSE, DEFAULT_CHARSET, OUT_CHARACTER_PRECIS, CLIP_CHARACTER_PRECIS, DEFAULT_QUALITY, DEFAULT_PITCH or FF_DONTCARE, addr szFontName
    mov FONT_CELL_NUM10000, eax

	;==========================================================
	;>> ����Block�ı���
	;==========================================================
	invoke CreateSolidBrush, COLOR_NUM0_BG
    mov BRUSH_CELL_0, eax
	invoke CreateSolidBrush, COLOR_NUM2_BG
    mov BRUSH_CELL_2, eax
    invoke CreateSolidBrush, COLOR_NUM4_BG
    mov BRUSH_CELL_4, eax
    invoke CreateSolidBrush, COLOR_NUM8_BG
    mov BRUSH_CELL_8, eax
    invoke CreateSolidBrush, COLOR_NUM16_BG
    mov BRUSH_CELL_16, eax
    invoke CreateSolidBrush, COLOR_NUM32_BG
    mov BRUSH_CELL_32, eax
    invoke CreateSolidBrush, COLOR_NUM64_BG
    mov BRUSH_CELL_64, eax
    invoke CreateSolidBrush, COLOR_NUM128_BG
    mov BRUSH_CELL_128, eax
    invoke CreateSolidBrush, COLOR_NUM256_BG
    mov BRUSH_CELL_256, eax
    invoke CreateSolidBrush, COLOR_NUM512_BG
    mov BRUSH_CELL_512, eax
    invoke CreateSolidBrush, COLOR_NUM1024_BG
    mov BRUSH_CELL_1024, eax
    invoke CreateSolidBrush, COLOR_NUM2048_BG
    mov BRUSH_CELL_2048, eax
	pop eax
	ret
initFonts endp

;==============================================================
;>> ��Ϸ��ʼ������
;==============================================================
initGameData proc far C
	;==========================================================
	;>> ��ʼ������
	;==========================================================
	mov gameEnd, 0
	mov reached2048, 0
	mov infiniteMode, 0
	mov score, 0
	mov esi, 0
	.while esi < 16 ;������־���
		mov numMat[esi * 4], 0
		inc esi
	.endw

	;==========================================================
	;>> ��ʼ�������
	;==========================================================
	invoke GetTickCount
	mov randomSeed, eax

	;==========================================================
	;>> ���������������
	;==========================================================
	invoke randomLCG
	invoke randomLCG

	ret
initGameData endp

;==============================================================
;>> ���ڹ��̺���
;==============================================================
WinMainProc proc, hWnd, uMsg, wParam, lParam
	local paintStruct:PAINTSTRUCT
	local hDc

	;==========================================================
	;>> �رմ���
	;==========================================================
	.if uMsg == WM_CLOSE
		invoke DestroyWindow, hWinMain
		invoke PostQuitMessage, 0
	
	;==========================================================
	;>> ��������
	;==========================================================
	.elseif uMsg == WM_CREATE
		invoke initFonts
		invoke initGameData

	;==========================================================
	;>> ��������Ϣ
	;==========================================================
	.elseif uMsg == WM_KEYDOWN
		
		mov edx, wParam
		;======================================================
		;>> ���ϰ���
		;======================================================
		.if edx == VK_UP || edx == "W" || edx == "w"
			.if isUpPressed == 0
				mov isUpPressed, 1
				invoke moveUp
				.if movedUp == 1
					invoke randomLCG
				.endif
				invoke InvalidateRect, hWnd, NULL, FALSE
			.endif

		;======================================================
		;>> ���°���
		;======================================================
		.elseif edx == VK_DOWN || edx == "S" || edx == "s"
			.if isDownPressed == 0
				mov isDownPressed, 1
				invoke moveDown
				.if movedDown == 1
					invoke randomLCG
				.endif
				invoke InvalidateRect, hWnd, NULL, FALSE
			.endif

		;======================================================
		;>> ���󰴼�
		;======================================================
		.elseif edx == VK_LEFT || edx =="A" || edx == "a"
			.if isLeftPressed == 0
				mov isLeftPressed, 1
				invoke moveLeft
				.if movedLeft == 1
					invoke randomLCG
				.endif
				invoke InvalidateRect, hWnd, NULL, FALSE
			.endif

		;======================================================
		;>> ���Ұ���
		;======================================================
		.elseif edx == VK_RIGHT || edx == "D" || edx == "d"
			.if isRightPressed == 0
				mov isRightPressed, 1
				invoke moveRight
				.if movedRight == 1
					invoke randomLCG
				.endif
				invoke InvalidateRect, hWnd, NULL, FALSE
			.endif
		.endif
		
		;======================================================
		;>> �����Ϸ�Ƿ����
		;======================================================
		invoke canMove
		.if gameEnd == 1
			invoke MessageBox, hWinMain, \
					offset MSG_GAME_OVER_TXT, offset MSG_GAME_OVER_TITLE, MB_OK
			; ���¿�ʼ��Ϸ
			.if eax == IDOK
				invoke initGameData
				invoke InvalidateRect, hWnd, NULL, FALSE
			.endif
		.endif

	;==========================================================
    ;>> �������ͷ�
    ;==========================================================
	.elseif uMsg == WM_KEYUP
    mov edx, wParam
		.if edx == VK_UP || edx == "W" || edx == "w"
			mov isUpPressed, 0
		.elseif edx == VK_DOWN || edx == "S" || edx == "s"
			mov isDownPressed, 0
		.elseif edx == VK_LEFT || edx == "A" || edx == "a"
			mov isLeftPressed, 0
		.elseif edx == VK_RIGHT || edx == "D" || edx == "d"
			mov isRightPressed, 0
		.endif

	;==========================================================
	;>> ���´���
	;==========================================================
	.elseif uMsg == WM_PAINT
		invoke BeginPaint, hWnd, addr paintStruct
		mov hDc, eax
		invoke updateGameWnd, hWnd, hDc
		invoke EndPaint, hWnd, addr paintStruct

	;==========================================================
	;>> Ĭ�ϴ���
	;==========================================================
	.else
		invoke DefWindowProc, hWnd, uMsg, wParam, lParam
		ret
	.endif
	xor eax, eax
	ret
WinMainProc endp

;==============================================================
;>> �����ں���
;==============================================================
WinMain proc
	LOCAL wcex:WNDCLASSEX
	LOCAL msg:MSG

	;==========================================================
	;>> ��ȡģ����
	;==========================================================
	invoke GetModuleHandle, NULL
	mov hInstance, eax

	;==========================================================
	;>> ���ô��������Ϣ
	;==========================================================
	invoke RtlZeroMemory, addr wcex, sizeof wcex
	;���ô�����ṹ��С
	mov wcex.cbSize, sizeof WNDCLASSEX
	;���ô�����������ģ����
	push hInstance
	pop wcex.hInstance
	;���ع��
	invoke LoadCursor, 0, IDC_ARROW
	mov wcex.hCursor, eax
	;���ô�����ʽ
	mov wcex.style, CS_HREDRAW or CS_VREDRAW
	;���ñ�����ɫ
	mov wcex.hbrBackground, COLOR_WINDOW+1
	;���ô�������
	mov wcex.lpszClassName, offset szClassName
	;ָ�����ڹ��̺���
	mov wcex.lpfnWndProc, offset WinMainProc

	;==========================================================
	;>> ��������
	;==========================================================
	;��ʼ������
	invoke initFonts
	;ע�ᴰ����
	invoke RegisterClassEx, addr wcex
	;��������
	invoke CreateWindowEx, WS_EX_CLIENTEDGE, \
			offset szClassName, offset szTitleMain, \
			WS_OVERLAPPED or WS_CAPTION or WS_SYSMENU, \
			400, 50, WINDOW_WIDTH, WINDOW_HEIGHT, NULL, NULL, hInstance, NULL
	
	mov hWinMain, eax  
	;��ʾ����
	invoke ShowWindow, hWinMain, SW_SHOWNORMAL
	invoke UpdateWindow, hWinMain  

	;==========================================================
	;>> ��Ϣѭ��
	;==========================================================
	.while TRUE
		;��ȡ��Ϣ
		invoke GetMessage, addr msg, NULL, 0, 0
		.if eax == 0
			.break
		.endif
		;ת�����ַ���Ϣ
		invoke TranslateMessage, addr msg
		invoke DispatchMessage, addr msg
	.endw
	ret
WinMain endp

;==============================================================
;>> Main����
;==============================================================
main proc
	invoke WinMain ;���ô��ں���
	invoke ExitProcess, NULL ;�˳�
	ret
main endp
end main
