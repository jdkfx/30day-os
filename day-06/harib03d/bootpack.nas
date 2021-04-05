[FORMAT "WCOFF"]
[INSTRSET "i486p"]
[OPTIMIZE 1]
[OPTION 1]
[BITS 32]
	EXTERN	_init_gdtidt
	EXTERN	_init_pic
	EXTERN	_init_palette
	EXTERN	_init_screen
	EXTERN	_init_mouse_cursor8
	EXTERN	_putblock8_8
	EXTERN	_sprintf
	EXTERN	_putfont8_asc
	EXTERN	_io_hlt
[FILE "bootpack.c"]
[SECTION .data]
LC0:
	DB	"(%d, %d)",0x00
[SECTION .text]
	GLOBAL	_HariMain
_HariMain:
	PUSH	EBP
	MOV	EBP,ESP
	PUSH	EDI
	PUSH	ESI
	PUSH	EBX
	LEA	EBX,DWORD [-316+EBP]
	SUB	ESP,304
	CALL	_init_gdtidt
	CALL	_init_pic
	CALL	_init_palette
	MOVSX	EAX,WORD [4086]
	PUSH	EAX
	MOVSX	EAX,WORD [4084]
	PUSH	EAX
	PUSH	DWORD [4088]
	CALL	_init_screen
	MOV	ECX,2
	MOVSX	EAX,WORD [4084]
	LEA	EDX,DWORD [-16+EAX]
	MOV	EAX,EDX
	CDQ
	IDIV	ECX
	MOVSX	EDX,WORD [4086]
	SUB	EDX,44
	MOV	EDI,EAX
	MOV	EAX,EDX
	PUSH	14
	CDQ
	IDIV	ECX
	PUSH	EBX
	MOV	ESI,EAX
	CALL	_init_mouse_cursor8
	PUSH	16
	PUSH	EBX
	LEA	EBX,DWORD [-60+EBP]
	PUSH	ESI
	PUSH	EDI
	PUSH	16
	PUSH	16
	MOVSX	EAX,WORD [4084]
	PUSH	EAX
	PUSH	DWORD [4088]
	CALL	_putblock8_8
	ADD	ESP,52
	PUSH	ESI
	PUSH	EDI
	PUSH	LC0
	PUSH	EBX
	CALL	_sprintf
	PUSH	EBX
	PUSH	7
	PUSH	0
	PUSH	0
	MOVSX	EAX,WORD [4084]
	PUSH	EAX
	PUSH	DWORD [4088]
	CALL	_putfont8_asc
	ADD	ESP,40
L2:
	CALL	_io_hlt
	JMP	L2
