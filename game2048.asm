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
;>> 数据段
;==============================================================
.data

;句柄
hInstance dd ?
hWinMain dd ?

;输出格式
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
;>> 字体格式
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
;>> 数字格子笔刷格式
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
;>> 常量段
;==============================================================
.const

;==============================================================
;>> 颜色配置
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
;>> 控件尺寸和位置
;==============================================================
;尺寸信息
;窗口尺寸
WINDOW_WIDTH equ 1000
WINDOW_HEIGHT equ 660
;间隔尺寸
WIDGET_MARGIN_SMALL equ 20
WIDGET_MARGIN_LARGE equ 40
;数字矩阵尺寸
WIDGET_MAT_EDGE equ 580
;数字方块尺寸
WIDGET_CELL_EDGE equ 120
;标题宽度
WIDGET_TEXT_WIDTH equ 320
;分数宽度
WIDGET_SCORE_WIDTH equ 150
;高度
WIDGET_TITLE_HEIGHT equ 100
WIDGET_SCORE_HEIGHT equ 75
WIDGET_RESTART_HEIGHT equ 50
WIDGET_INTRO_HEIGHT equ 235

;控件位置信息
;数字矩阵位置
WIDGET_MAT_START_XY equ 20
WIDGET_MAT_END_XY equ 600
;标题位置
WIDGET_TITLE_START_X equ 640
WIDGET_TITLE_START_Y equ 20
WIDGET_TITLE_END_X equ 960
WIDGET_TITLE_END_Y equ 120
;分数位置
WIDGET_SCORE_START_Y equ 160
WIDGET_SCORE_END_Y equ 235
WIDGET_CURRENT_SCORE_END_X equ 790
WIDGET_MAX_SCORE_START_X equ 810
;重开按钮
WIDGET_RE_START_Y equ 275
WIDGET_RE_END_Y equ 325
;操作说明
WIDGET_INTRO_START_Y equ 365
WIDGET_INTRO_END_Y equ 600

;文字位置信息
;标题位置
TXT_TITLE_START_X equ 720
TXT_TITLE_START_Y equ 30
;分数位置
TXT_CURRENT_SCORE_TXT_START_X equ 643
TXT_MAX_SCORE_TXT_START_X equ 813
TXT_SCORE_TXT_START_Y equ 162
TXT_CURRENT_SCORE_NUM_START_X equ 700
TXT_MAX_SCORE_NUM_START_X equ 870
TXT_SCORE_NUM_START_Y equ 202
;重开按钮文字位置
TXT_RE_START_X equ 640
TXT_RE_START_Y equ 280
;操作说明
TXT_INTRO_TITLE_START_X equ 740
TXT_INTRO_TITLE_START_Y equ 370
TXT_INTRO_INFO_START_X equ 745
TXT_INTRO_INFO_START_Yw equ 425
TXT_INTRO_INFO_START_Ya equ 465
TXT_INTRO_INFO_START_Ys equ 505
TXT_INTRO_INFO_START_Yd equ 545

;数字的偏移
OFFSET_CELL_10_X equ 37
OFFSET_CELL_10_Y equ 18
OFFSET_CELL_100_X equ 21
OFFSET_CELL_100_Y equ 18
OFFSET_CELL_1000_X equ 13
OFFSET_CELL_1000_Y equ 24
OFFSET_CELL_10000_X equ 12
OFFSET_CELL_10000_Y equ 31

;==============================================================
;>> 显示文本
;==============================================================
szClassName db "MainWindowClass", 0
szTitleMain db "Game 2048", 0
szFontName byte "Clear Sans", 0

TXT_TITLE byte "2048", 0
TXT_CURRENT_SCORE byte "当前得分", 0
TXT_BEST_SCORE byte "最高得分", 0
TXT_INTRO_TITLE byte "操作指南", 0
TXT_INTRO_TXTw byte "W：向上", 0
TXT_INTRO_TXTa byte "A：向左", 0
TXT_INTRO_TXTs byte "S：向下", 0
TXT_INTRO_TXTd byte "D：向右", 0

MSG_WIN_TITLE byte "游戏胜利！", 0
MSG_WIN byte "您的分数已经到达2048!", 0
MSG_CONTINUE byte "您希望继续游戏吗？（进入无尽模式）", 0
MSG_GAME_OVER_TITLE byte "游戏结束！", 0
MSG_GAME_OVER_TXT byte "无法继续移动，游戏结束！", 0

TXT_BUTTON_RESTART byte "重新开始", 0

BITMAP1 EQU 101
BITMAP2 EQU 104
lcgMaxNum EQU 16

;==============================================================
;>> 代码段
;==============================================================
.code

;==============================================================
;>> 在矩阵中生成随机数字
;>> 采用线性同余生成器，随机生成位置、数值
;==============================================================
randomLCG proc     
	local lcg_a, lcg_c, randNum, randPos

	pusha ;保存现场
	mov eax, randomSeed ;初始种子

	;==========================================================
	;>> LCG 参数配置
	;==========================================================
	mov lcg_a, 0343fdh
	mov lcg_c, 269ec3h

lcg:
	;==========================================================
	;>> 生成随机位置
	;==========================================================
	mul lcg_a
	add eax, lcg_c
	xor edx, edx
	mov ebx, lcgMaxNum
	div ebx
	mov eax, edx
	mov	randPos, eax ;保存随机位置

	;==========================================================
	;>> 检查随机位置是否为空
	;==========================================================
	mov eax, randPos
	.if numMat[eax * 4] != 0
		jmp lcg
	.endif

	;==========================================================
	;>> 生成随机值2或4
	;==========================================================
	mul lcg_a ;再次计算随机数
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
	;>> 更新数字矩阵
	;==========================================================
	mov eax, randPos
	mov edx, randNum
	mov numMat[eax * 4], edx
	mov randomSeed, eax

	popa ;还原现场
	ret
randomLCG Endp

;==============================================================
;>> 根据当前分数更新最高分
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
;>> 根据矩阵当前状态计算分数
;==============================================================
updateScore proc far C
    pushad
	mov eax, 0
	mov score, 0
	mov edi, 0

	;遍历矩阵
	mov ecx, 0
	.while ecx < 16
		mov esi, numMat[ecx*4]
		.if esi > edi
			mov edi, esi
		.endif
		inc ecx
	.endw

	;判断胜利条件
	.if edi == 2048
		mov reached2048, 1
	.endif
	mov score, edi
	
	popad
    ret
updateScore endp

;==============================================================
;>> 数字向上移动
;==============================================================
moveUp proc
	local col, row, changed, r
	local currentNum, tmpNum, targetRow
	pushad ;保护现场
	mov changed, 0
	mov movedUp, 0
	mov col, 0
	.while col < 4
		;清空flag标记
		xor eax, eax
		mov flag[0], eax
		mov flag[4], eax
		mov flag[8], eax
		mov flag[12], eax
		mov row, 1
		.while row < 4
			;读取当前位置数据
			mov eax, row
			mov ebx, col
			shl eax, 2
			add eax, ebx
			mov edi, numMat[eax*4]
			mov currentNum, edi
			;保存targetRow为当前row
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
	popad ;恢复现场
	ret
moveUp endp

;==============================================================
;>> 数字向下移动
;==============================================================
moveDown proc
	local col, row, changed, r
	local currentNum, tmpNum, targetRow
	pushad ;保护现场
	mov changed, 0
	mov movedDown, 0
	mov col, 0
	.while col < 4
		;清空flag标记
		xor eax, eax
		mov flag[0], eax
		mov flag[4], eax
		mov flag[8], eax
		mov flag[12], eax
		mov row, 2
		.while row >= 0
			;读取当前位置数据
			mov eax, row
			mov ebx, col
			shl eax, 2
			add eax, ebx
			mov edi, numMat[eax*4]
			mov currentNum, edi
			;保存targetRow为当前row
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
	popad ;恢复现场
	ret
moveDown endp

;==============================================================
;>> 数字向左移动
;==============================================================
moveLeft proc
	local col, row, changed, co
	local currentNum, tmpNum, targetCol
	pushad ;保护现场
	mov changed, 0
	mov movedLeft, 0
	mov row, 0
	.while row < 4
		;清空flag标记
		xor eax, eax
		mov flag[0], eax
		mov flag[4], eax
		mov flag[8], eax
		mov flag[12], eax
		mov col, 1
		.while col < 4
			;读取当前位置数据
			mov eax, row
			mov ebx, col
			shl eax, 2
			add eax, ebx
			mov edi, numMat[eax*4]
			mov currentNum, edi
			;保存targetCol为当前col
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
	popad ;恢复现场
	ret
moveLeft endp

;==============================================================
;>> 数字向右移动
;==============================================================
moveRight proc
	local col, row, changed, co
	local currentNum, tmpNum, targetCol
	pushad ;保护现场
	mov changed, 0
	mov movedRight, 0
	mov row, 0
	.while row < 4
		;清空flag标记
		xor eax, eax
		mov flag[0], eax
		mov flag[4], eax
		mov flag[8], eax
		mov flag[12], eax
		mov col, 2
		.while col >= 0
			;读取当前位置数据
			mov eax, row
			mov ebx, col
			shl eax, 2
			add eax, ebx
			mov edi, numMat[eax*4]
			mov currentNum, edi
			;保存targetCol为当前col
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
	popad ;恢复现场
	ret
moveRight endp

;==============================================================
;>> 判断是否可以继续移动
;==============================================================
canMove proc
	pushad ;保护现场
	;保存numMat
	mov ecx, 0
	.while ecx < 16
		mov esi, numMat[ecx*4]
		mov numMatCopy[ecx*4], esi
		inc ecx
	.endw

	;测试向上移动
	invoke moveUp
	;恢复numMat
	mov ecx, 0
	.while ecx < 16
		mov esi, numMatCopy[ecx*4]
		mov numMat[ecx*4], esi
		inc ecx
	.endw

	;测试向下移动
	invoke moveDown
	;恢复numMat
	mov ecx, 0
	.while ecx < 16
		mov esi, numMatCopy[ecx*4]
		mov numMat[ecx*4], esi
		inc ecx
	.endw

	;测试向左移动
	invoke moveLeft
	;恢复numMat
	mov ecx, 0
	.while ecx < 16
		mov esi, numMatCopy[ecx*4]
		mov numMat[ecx*4], esi
		inc ecx
	.endw

	;测试向右移动
	invoke moveRight
	;恢复numMat
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

	popad ;恢复现场
	ret
canMove endp

;==============================================================
;>> 更新窗口显示
;==============================================================
updateGameWnd proc far C, hWnd, hDc
    local len
    local szBuffer[10]: byte
    local tmpHandler, _hDc, _cptBmp

	local cellStartX, cellEndX, cellStartY, cellEndY
	local numStartX, numStartY
	local i, j, currentNum
    
    pushad ;保存现场

	;==========================================================
	;>> 创建上下文和位图
	;==========================================================
    invoke CreateCompatibleDC, hDc
    mov _hDc, eax
    invoke CreateCompatibleBitmap, hDc, WINDOW_WIDTH, WINDOW_HEIGHT
    mov _cptBmp, eax
	invoke SelectObject, _hDc, _cptBmp ;将_cptBmp选择为_hDc的绘图对象

    ;==========================================================
	;>> 绘制整体背景
	;==========================================================
	;创建画刷
    invoke CreateSolidBrush, COLOR_WINDOW_BG
	;保存句柄
    mov tmpHandler, eax
	;选择画刷
    invoke SelectObject, _hDc, eax
	;绘制矩形用作背景
    invoke Rectangle, _hDc, -10, -10, WINDOW_WIDTH, WINDOW_HEIGHT
	;删除画刷对象
    invoke DeleteObject, tmpHandler 

	;==========================================================
	;>> 绘制4*4数字矩阵背景
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
	;>> 右侧信息栏背景
	;==========================================================
	;标题框
	invoke RoundRect, _hDc, WIDGET_TITLE_START_X, WIDGET_TITLE_START_Y, \
			WIDGET_TITLE_END_X, WIDGET_TITLE_END_Y, 3, 3
    ;当前分数框
	invoke RoundRect, _hDc, WIDGET_TITLE_START_X, WIDGET_SCORE_START_Y, \
			WIDGET_CURRENT_SCORE_END_X, WIDGET_SCORE_END_Y, 3, 3
    ;最高分数框
	invoke RoundRect, _hDc, WIDGET_MAX_SCORE_START_X, WIDGET_SCORE_START_Y, \
			WIDGET_TITLE_END_X, WIDGET_SCORE_END_Y, 3, 3
	;游戏说明框
	invoke RoundRect, _hDc, WIDGET_TITLE_START_X, WIDGET_INTRO_START_Y, \
			WIDGET_TITLE_END_X, WIDGET_INTRO_END_Y, 3, 3
	;重开按钮
	;invoke RoundRect, _hDc, WIDGET_TITLE_START_X, WIDGET_RE_START_Y, \
	;		WIDGET_TITLE_END_X, WIDGET_RE_END_Y, 3, 3
	invoke DeleteObject, tmpHandler

	;==========================================================
	;>> 右侧信息栏文字
	;==========================================================
	;标题
    invoke SelectObject, _hDc, FONT_TITLE
    invoke SetTextColor, _hDc, COLOR_TITLE_TXT
    invoke TextOut, _hDc, TXT_TITLE_START_X, TXT_TITLE_START_Y, \
			addr TXT_TITLE, lengthof TXT_TITLE
	;当前得分文字
	invoke SelectObject, _hDc, FONT_SCORE_TXT
    invoke SetTextColor, _hDc, COLOR_SCORE_TXT
    invoke TextOut, _hDc, TXT_CURRENT_SCORE_TXT_START_X, TXT_SCORE_TXT_START_Y, \
			addr TXT_CURRENT_SCORE, lengthof TXT_CURRENT_SCORE
	;当前分数数字
	invoke updateScore ;更新当前得分
    invoke wsprintf, addr szBuffer, addr szNumFormat, score
	mov len, eax ;记录长度
	invoke SelectObject, _hDc, FONT_SCORE_NUM
    invoke SetTextColor, _hDc, COLOR_SCORE_NUM
	invoke TextOut, _hDc, TXT_CURRENT_SCORE_NUM_START_X, TXT_SCORE_NUM_START_Y, \
			addr szBuffer, len
	;最高分数文字
	invoke SelectObject, _hDc, FONT_SCORE_TXT
    invoke SetTextColor, _hDc, COLOR_SCORE_TXT
    invoke TextOut, _hDc, TXT_MAX_SCORE_TXT_START_X, TXT_SCORE_TXT_START_Y, \
			addr TXT_BEST_SCORE, lengthof TXT_BEST_SCORE
	;最高分数数字
	invoke updateBestScore ;更新最高得分
    invoke wsprintf, addr szBuffer, addr szNumFormat, bestScore
	mov len, eax
	invoke SelectObject, _hDc, FONT_SCORE_NUM
    invoke SetTextColor, _hDc, COLOR_SCORE_NUM
    invoke TextOut, _hDc, TXT_MAX_SCORE_NUM_START_X, TXT_SCORE_NUM_START_Y, \
			addr szBuffer, len
	;绘制重新开始按钮文字
	;invoke SelectObject, _hDc, FONT_RESTART
    ;invoke SetTextColor, _hDc, COLOR_BUTTON_TXT
    ;invoke TextOut, _hDc, TXT_RE_START_X, TXT_RE_START_Y, \
	;		addr TXT_BUTTON_RESTART, lengthof TXT_BUTTON_RESTART
	;绘制描述信息标题
	invoke SelectObject, _hDc, FONT_SCORE_NUM
    invoke SetTextColor, _hDc, COLOR_INTRO_TITLE
    invoke TextOut, _hDc, TXT_INTRO_TITLE_START_X, TXT_INTRO_TITLE_START_Y, \
			addr TXT_INTRO_TITLE, lengthof TXT_INTRO_TITLE
	;绘制描述信息内容w
	invoke SelectObject, _hDc, FONT_INTRO_TXT
    invoke SetTextColor, _hDc, COLOR_INTRO_TXT
    invoke TextOut, _hDc, TXT_INTRO_INFO_START_X, TXT_INTRO_INFO_START_Yw, \
			addr TXT_INTRO_TXTw, lengthof TXT_INTRO_TXTw
	;绘制描述信息内容a
	invoke SelectObject, _hDc, FONT_INTRO_TXT
    invoke SetTextColor, _hDc, COLOR_INTRO_TXT
    invoke TextOut, _hDc, TXT_INTRO_INFO_START_X, TXT_INTRO_INFO_START_Ya, \
			addr TXT_INTRO_TXTa, lengthof TXT_INTRO_TXTa
	;绘制描述信息内容s
	invoke SelectObject, _hDc, FONT_INTRO_TXT
    invoke SetTextColor, _hDc, COLOR_INTRO_TXT
    invoke TextOut, _hDc, TXT_INTRO_INFO_START_X, TXT_INTRO_INFO_START_Ys, \
			addr TXT_INTRO_TXTs, lengthof TXT_INTRO_TXTs
	;绘制描述信息内容d
	invoke SelectObject, _hDc, FONT_INTRO_TXT
    invoke SetTextColor, _hDc, COLOR_INTRO_TXT
    invoke TextOut, _hDc, TXT_INTRO_INFO_START_X, TXT_INTRO_INFO_START_Yd, \
			addr TXT_INTRO_TXTd, lengthof TXT_INTRO_TXTd

	;==========================================================
	;>> 绘制数字单元格
	;==========================================================
	;计算绘制起点
	mov eax, WIDGET_MAT_START_XY
	add eax, WIDGET_MARGIN_SMALL
	mov cellStartY, eax
	add eax, WIDGET_CELL_EDGE
	mov cellEndY, eax

	;循环绘制
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
			;>> 计算当前数字
			;==================================================
			pushad
			mov eax, i
			shl eax, 2
			add eax, j
			mov ecx, numMat[eax*4]
			mov currentNum, ecx

			;==================================================
			;>> 绘制矩形
			;==================================================
			;根据数字选择笔刷
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
			;绘制矩形
			invoke RoundRect, _hDc, cellStartX, cellStartY, cellEndX, cellEndY, 3, 3

			;==================================================
			;>> 绘制数字
			;==================================================
			;数字为0时跳过绘制
			.if currentNum == 0
				jmp L1
			.endif
			; 设置数字颜色
			.if currentNum < 8
				invoke SetTextColor, _hDc, COLOR_NUM_DARK
			.else
				invoke SetTextColor, _hDc, COLOR_NUM_LIGHT
			.endif
			;确定数字的绘制位置和字体
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
			;绘制数字
			invoke wsprintf, addr szBuffer, addr szNumFormat, currentNum
			invoke TextOut, _hDc, numStartX, numStartY, addr szBuffer, eax
L1:
			;更新变量
			popad
            add cellStartX, WIDGET_CELL_EDGE + WIDGET_MARGIN_SMALL
            add cellEndX, WIDGET_CELL_EDGE + WIDGET_MARGIN_SMALL
            inc j
        .endw
		;更新变量
        add cellStartY, WIDGET_CELL_EDGE + WIDGET_MARGIN_SMALL
        add cellEndY, WIDGET_CELL_EDGE + WIDGET_MARGIN_SMALL
		inc i
    .endw

	;==========================================================
	;>> 更新UI
	;==========================================================
    invoke BitBlt, hDc, 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT, _hDc, 0, 0, SRCCOPY

	;==========================================================
	;>> 释放资源
	;==========================================================
    invoke DeleteObject, _cptBmp
    invoke DeleteDC, _hDc

	;==========================================================
	;>> 游戏胜利弹窗
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

    popad ;还原现场
    ret
updateGameWnd endp

;==============================================================
;>> 初始化字体和笔刷
;==============================================================
initFonts proc far C
	;==========================================================
	;>> 字体样式
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
	;>> 数字Block的字体
	;==========================================================
	invoke CreateFont, 72, 0, 0, 0, FW_BLACK, FALSE, FALSE, FALSE, DEFAULT_CHARSET, OUT_CHARACTER_PRECIS, CLIP_CHARACTER_PRECIS, DEFAULT_QUALITY, DEFAULT_PITCH or FF_DONTCARE, addr szFontName
    mov FONT_CELL_NUM100, eax
    invoke CreateFont, 59, 0, 0, 0, FW_BLACK, FALSE, FALSE, FALSE, DEFAULT_CHARSET, OUT_CHARACTER_PRECIS, CLIP_CHARACTER_PRECIS, DEFAULT_QUALITY, DEFAULT_PITCH or FF_DONTCARE, addr szFontName
    mov FONT_CELL_NUM1000, eax
    invoke CreateFont, 46, 0, 0, 0, FW_BLACK, FALSE, FALSE, FALSE, DEFAULT_CHARSET, OUT_CHARACTER_PRECIS, CLIP_CHARACTER_PRECIS, DEFAULT_QUALITY, DEFAULT_PITCH or FF_DONTCARE, addr szFontName
    mov FONT_CELL_NUM10000, eax

	;==========================================================
	;>> 数字Block的背景
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
;>> 游戏初始化函数
;==============================================================
initGameData proc far C
	;==========================================================
	;>> 初始化变量
	;==========================================================
	mov gameEnd, 0
	mov reached2048, 0
	mov infiniteMode, 0
	mov score, 0
	mov esi, 0
	.while esi < 16 ;清空数字矩阵
		mov numMat[esi * 4], 0
		inc esi
	.endw

	;==========================================================
	;>> 初始化随机数
	;==========================================================
	invoke GetTickCount
	mov randomSeed, eax

	;==========================================================
	;>> 随机生成两个数字
	;==========================================================
	invoke randomLCG
	invoke randomLCG

	ret
initGameData endp

;==============================================================
;>> 窗口过程函数
;==============================================================
WinMainProc proc, hWnd, uMsg, wParam, lParam
	local paintStruct:PAINTSTRUCT
	local hDc

	;==========================================================
	;>> 关闭窗口
	;==========================================================
	.if uMsg == WM_CLOSE
		invoke DestroyWindow, hWinMain
		invoke PostQuitMessage, 0
	
	;==========================================================
	;>> 创建窗口
	;==========================================================
	.elseif uMsg == WM_CREATE
		invoke initFonts
		invoke initGameData

	;==========================================================
	;>> 处理按键消息
	;==========================================================
	.elseif uMsg == WM_KEYDOWN
		
		mov edx, wParam
		;======================================================
		;>> 向上按键
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
		;>> 向下按键
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
		;>> 向左按键
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
		;>> 向右按键
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
		;>> 检查游戏是否结束
		;======================================================
		invoke canMove
		.if gameEnd == 1
			invoke MessageBox, hWinMain, \
					offset MSG_GAME_OVER_TXT, offset MSG_GAME_OVER_TITLE, MB_OK
			; 重新开始游戏
			.if eax == IDOK
				invoke initGameData
				invoke InvalidateRect, hWnd, NULL, FALSE
			.endif
		.endif

	;==========================================================
    ;>> 处理按键释放
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
	;>> 更新窗口
	;==========================================================
	.elseif uMsg == WM_PAINT
		invoke BeginPaint, hWnd, addr paintStruct
		mov hDc, eax
		invoke updateGameWnd, hWnd, hDc
		invoke EndPaint, hWnd, addr paintStruct

	;==========================================================
	;>> 默认处理
	;==========================================================
	.else
		invoke DefWindowProc, hWnd, uMsg, wParam, lParam
		ret
	.endif
	xor eax, eax
	ret
WinMainProc endp

;==============================================================
;>> 主窗口函数
;==============================================================
WinMain proc
	LOCAL wcex:WNDCLASSEX
	LOCAL msg:MSG

	;==========================================================
	;>> 获取模块句柄
	;==========================================================
	invoke GetModuleHandle, NULL
	mov hInstance, eax

	;==========================================================
	;>> 设置窗口类的信息
	;==========================================================
	invoke RtlZeroMemory, addr wcex, sizeof wcex
	;设置窗口类结构大小
	mov wcex.cbSize, sizeof WNDCLASSEX
	;设置窗口类所属的模块句柄
	push hInstance
	pop wcex.hInstance
	;加载光标
	invoke LoadCursor, 0, IDC_ARROW
	mov wcex.hCursor, eax
	;设置窗口样式
	mov wcex.style, CS_HREDRAW or CS_VREDRAW
	;设置背景颜色
	mov wcex.hbrBackground, COLOR_WINDOW+1
	;设置窗口类名
	mov wcex.lpszClassName, offset szClassName
	;指定窗口过程函数
	mov wcex.lpfnWndProc, offset WinMainProc

	;==========================================================
	;>> 创建窗口
	;==========================================================
	;初始化字体
	invoke initFonts
	;注册窗口类
	invoke RegisterClassEx, addr wcex
	;创建窗口
	invoke CreateWindowEx, WS_EX_CLIENTEDGE, \
			offset szClassName, offset szTitleMain, \
			WS_OVERLAPPED or WS_CAPTION or WS_SYSMENU, \
			400, 50, WINDOW_WIDTH, WINDOW_HEIGHT, NULL, NULL, hInstance, NULL
	
	mov hWinMain, eax  
	;显示窗口
	invoke ShowWindow, hWinMain, SW_SHOWNORMAL
	invoke UpdateWindow, hWinMain  

	;==========================================================
	;>> 消息循环
	;==========================================================
	.while TRUE
		;获取消息
		invoke GetMessage, addr msg, NULL, 0, 0
		.if eax == 0
			.break
		.endif
		;转换并分发消息
		invoke TranslateMessage, addr msg
		invoke DispatchMessage, addr msg
	.endw
	ret
WinMain endp

;==============================================================
;>> Main函数
;==============================================================
main proc
	invoke WinMain ;调用窗口函数
	invoke ExitProcess, NULL ;退出
	ret
main endp
end main
