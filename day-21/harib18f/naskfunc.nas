; naskfunc
; TAB=4

[FORMAT "WCOFF"]				; �I�u�W�F�N�g�t�@�C������郂�[�h	
[INSTRSET "i486p"]				; 486�̖��߂܂Ŏg�������Ƃ����L�q
[BITS 32]						; 32�r�b�g���[�h�p�̋@�B�����点��
[FILE "naskfunc.nas"]			; �\�[�X�t�@�C�������

		GLOBAL	_io_hlt, _io_cli, _io_sti, _io_stihlt
		GLOBAL	_io_in8,  _io_in16,  _io_in32
		GLOBAL	_io_out8, _io_out16, _io_out32
		GLOBAL	_io_load_eflags, _io_store_eflags
		GLOBAL	_load_gdtr, _load_idtr
		GLOBAL	_load_cr0, _store_cr0
		GLOBAL	_load_tr
		GLOBAL	_asm_inthandler20, _asm_inthandler21
		GLOBAL	_asm_inthandler27, _asm_inthandler2c
		GLOBAL	_asm_inthandler0d
		GLOBAL	_memtest_sub
		GLOBAL	_farjmp, _farcall
		GLOBAL	_asm_hrb_api, _start_app
		EXTERN	_inthandler20, _inthandler21
		EXTERN	_inthandler27, _inthandler2c
		EXTERN	_inthandler0d
		EXTERN	_hrb_api

[SECTION .text]

_io_hlt:	; void io_hlt(void);
		HLT
		RET

_io_cli:	; void io_cli(void);
		CLI
		RET

_io_sti:	; void io_sti(void);
		STI
		RET

_io_stihlt:	; void io_stihlt(void);
		STI
		HLT
		RET

_io_in8:	; int io_in8(int port);
		MOV		EDX,[ESP+4]		; port
		MOV		EAX,0
		IN		AL,DX
		RET

_io_in16:	; int io_in16(int port);
		MOV		EDX,[ESP+4]		; port
		MOV		EAX,0
		IN		AX,DX
		RET

_io_in32:	; int io_in32(int port);
		MOV		EDX,[ESP+4]		; port
		IN		EAX,DX
		RET

_io_out8:	; void io_out8(int port, int data);
		MOV		EDX,[ESP+4]		; port
		MOV		AL,[ESP+8]		; data
		OUT		DX,AL
		RET

_io_out16:	; void io_out16(int port, int data);
		MOV		EDX,[ESP+4]		; port
		MOV		EAX,[ESP+8]		; data
		OUT		DX,AX
		RET

_io_out32:	; void io_out32(int port, int data);
		MOV		EDX,[ESP+4]		; port
		MOV		EAX,[ESP+8]		; data
		OUT		DX,EAX
		RET

_io_load_eflags:	; int io_load_eflags(void);
		PUSHFD		; PUSH EFLAGS �Ƃ����Ӗ�
		POP		EAX
		RET

_io_store_eflags:	; void io_store_eflags(int eflags);
		MOV		EAX,[ESP+4]
		PUSH	EAX
		POPFD		; POP EFLAGS �Ƃ����Ӗ�
		RET

_load_gdtr:		; void load_gdtr(int limit, int addr);
		MOV		AX,[ESP+4]		; limit
		MOV		[ESP+6],AX
		LGDT	[ESP+6]
		RET

_load_idtr:		; void load_idtr(int limit, int addr);
		MOV		AX,[ESP+4]		; limit
		MOV		[ESP+6],AX
		LIDT	[ESP+6]
		RET

_load_cr0:		; int load_cr0(void);
		MOV		EAX,CR0
		RET

_store_cr0:		; void store_cr0(int cr0);
		MOV		EAX,[ESP+4]
		MOV		CR0,EAX
		RET

_load_tr:		; void load_tr(int tr);
		LTR		[ESP+4]			; tr
		RET

_asm_inthandler20:
		PUSH	ES
		PUSH	DS
		PUSHAD
		MOV		AX,SS
		CMP		AX,1*8
		JNE		.from_app
;	OS�������Ă���Ƃ��Ɋ��荞�܂ꂽ�̂łقڍ��܂łǂ���
		MOV		EAX,ESP
		PUSH	SS				; ���荞�܂ꂽ�Ƃ���SS��ۑ�
		PUSH	EAX				; ���荞�܂ꂽ�Ƃ���ESP��ۑ�
		MOV		AX,SS
		MOV		DS,AX
		MOV		ES,AX
		CALL	_inthandler20
		ADD		ESP,8
		POPAD
		POP		DS
		POP		ES
		IRETD
.from_app:
;	�A�v���������Ă���Ƃ��Ɋ��荞�܂ꂽ
		MOV		EAX,1*8
		MOV		DS,AX			; �Ƃ肠����DS����OS�p�ɂ���
		MOV		ECX,[0xfe4]		; OS��ESP
		ADD		ECX,-8
		MOV		[ECX+4],SS		; ���荞�܂ꂽ�Ƃ���SS��ۑ�
		MOV		[ECX  ],ESP		; ���荞�܂ꂽ�Ƃ���ESP��ۑ�
		MOV		SS,AX
		MOV		ES,AX
		MOV		ESP,ECX
		CALL	_inthandler20
		POP		ECX
		POP		EAX
		MOV		SS,AX			; SS���A�v���p�ɖ߂�
		MOV		ESP,ECX			; ESP���A�v���p�ɖ߂�
		POPAD
		POP		DS
		POP		ES
		IRETD

_asm_inthandler21:
		PUSH	ES
		PUSH	DS
		PUSHAD
		MOV		AX,SS
		CMP		AX,1*8
		JNE		.from_app
;	OS�������Ă���Ƃ��Ɋ��荞�܂ꂽ�̂łقڍ��܂łǂ���
		MOV		EAX,ESP
		PUSH	SS				; ���荞�܂ꂽ�Ƃ���SS��ۑ�
		PUSH	EAX				; ���荞�܂ꂽ�Ƃ���ESP��ۑ�
		MOV		AX,SS
		MOV		DS,AX
		MOV		ES,AX
		CALL	_inthandler21
		ADD		ESP,8
		POPAD
		POP		DS
		POP		ES
		IRETD
.from_app:
;	�A�v���������Ă���Ƃ��Ɋ��荞�܂ꂽ
		MOV		EAX,1*8
		MOV		DS,AX			; �Ƃ肠����DS����OS�p�ɂ���
		MOV		ECX,[0xfe4]		; OS��ESP
		ADD		ECX,-8
		MOV		[ECX+4],SS		; ���荞�܂ꂽ�Ƃ���SS��ۑ�
		MOV		[ECX  ],ESP		; ���荞�܂ꂽ�Ƃ���ESP��ۑ�
		MOV		SS,AX
		MOV		ES,AX
		MOV		ESP,ECX
		CALL	_inthandler21
		POP		ECX
		POP		EAX
		MOV		SS,AX			; SS���A�v���p�ɖ߂�
		MOV		ESP,ECX			; ESP���A�v���p�ɖ߂�
		POPAD
		POP		DS
		POP		ES
		IRETD

_asm_inthandler27:
		PUSH	ES
		PUSH	DS
		PUSHAD
		MOV		AX,SS
		CMP		AX,1*8
		JNE		.from_app
;	OS�������Ă���Ƃ��Ɋ��荞�܂ꂽ�̂łقڍ��܂łǂ���
		MOV		EAX,ESP
		PUSH	SS				; ���荞�܂ꂽ�Ƃ���SS��ۑ�
		PUSH	EAX				; ���荞�܂ꂽ�Ƃ���ESP��ۑ�
		MOV		AX,SS
		MOV		DS,AX
		MOV		ES,AX
		CALL	_inthandler27
		ADD		ESP,8
		POPAD
		POP		DS
		POP		ES
		IRETD
.from_app:
;	�A�v���������Ă���Ƃ��Ɋ��荞�܂ꂽ
		MOV		EAX,1*8
		MOV		DS,AX			; �Ƃ肠����DS����OS�p�ɂ���
		MOV		ECX,[0xfe4]		; OS��ESP
		ADD		ECX,-8
		MOV		[ECX+4],SS		; ���荞�܂ꂽ�Ƃ���SS��ۑ�
		MOV		[ECX  ],ESP		; ���荞�܂ꂽ�Ƃ���ESP��ۑ�
		MOV		SS,AX
		MOV		ES,AX
		MOV		ESP,ECX
		CALL	_inthandler27
		POP		ECX
		POP		EAX
		MOV		SS,AX			; SS���A�v���p�ɖ߂�
		MOV		ESP,ECX			; ESP���A�v���p�ɖ߂�
		POPAD
		POP		DS
		POP		ES
		IRETD

_asm_inthandler2c:
		PUSH	ES
		PUSH	DS
		PUSHAD
		MOV		AX,SS
		CMP		AX,1*8
		JNE		.from_app
;	OS�������Ă���Ƃ��Ɋ��荞�܂ꂽ�̂łقڍ��܂łǂ���
		MOV		EAX,ESP
		PUSH	SS				; ���荞�܂ꂽ�Ƃ���SS��ۑ�
		PUSH	EAX				; ���荞�܂ꂽ�Ƃ���ESP��ۑ�
		MOV		AX,SS
		MOV		DS,AX
		MOV		ES,AX
		CALL	_inthandler2c
		ADD		ESP,8
		POPAD
		POP		DS
		POP		ES
		IRETD
.from_app:
;	�A�v���������Ă���Ƃ��Ɋ��荞�܂ꂽ
		MOV		EAX,1*8
		MOV		DS,AX			; �Ƃ肠����DS����OS�p�ɂ���
		MOV		ECX,[0xfe4]		; OS��ESP
		ADD		ECX,-8
		MOV		[ECX+4],SS		; ���荞�܂ꂽ�Ƃ���SS��ۑ�
		MOV		[ECX  ],ESP		; ���荞�܂ꂽ�Ƃ���ESP��ۑ�
		MOV		SS,AX
		MOV		ES,AX
		MOV		ESP,ECX
		CALL	_inthandler2c
		POP		ECX
		POP		EAX
		MOV		SS,AX			; SS���A�v���p�ɖ߂�
		MOV		ESP,ECX			; ESP���A�v���p�ɖ߂�
		POPAD
		POP		DS
		POP		ES
		IRETD

_asm_inthandler0d:
		STI
		PUSH	ES
		PUSH	DS
		PUSHAD
		MOV		AX,SS
		CMP		AX,1*8
		JNE		.from_app
;	OS�������Ă���Ƃ��Ɋ��荞�܂ꂽ�̂łقڍ��܂łǂ���
		MOV		EAX,ESP
		PUSH	SS				; ���荞�܂ꂽ�Ƃ���SS��ۑ�
		PUSH	EAX				; ���荞�܂ꂽ�Ƃ���ESP��ۑ�
		MOV		AX,SS
		MOV		DS,AX
		MOV		ES,AX
		CALL	_inthandler0d
		ADD		ESP,8
		POPAD
		POP		DS
		POP		ES
		ADD		ESP,4			; INT 0x0d �ł́A���ꂪ�K�v
		IRETD
.from_app:
;	�A�v���������Ă���Ƃ��Ɋ��荞�܂ꂽ
		CLI
		MOV		EAX,1*8
		MOV		DS,AX			; �Ƃ肠����DS����OS�p�ɂ���
		MOV		ECX,[0xfe4]		; OS��ESP
		ADD		ECX,-8
		MOV		[ECX+4],SS		; ���荞�܂ꂽ�Ƃ���SS��ۑ�
		MOV		[ECX  ],ESP		; ���荞�܂ꂽ�Ƃ���ESP��ۑ�
		MOV		SS,AX
		MOV		ES,AX
		MOV		ESP,ECX
		STI
		CALL	_inthandler0d
		CLI
		CMP		EAX,0
		JNE		.kill
		POP		ECX
		POP		EAX
		MOV		SS,AX			; SS���A�v���p�ɖ߂�
		MOV		ESP,ECX			; ESP���A�v���p�ɖ߂�
		POPAD
		POP		DS
		POP		ES
		ADD		ESP,4			; INT 0x0d �ł́A���ꂪ�K�v
		IRETD
.kill:
;	�A�v�����ُ�I�������邱�Ƃɂ���
		MOV		EAX,1*8			; OS�p��DS/SS
		MOV		ES,AX
		MOV		SS,AX
		MOV		DS,AX
		MOV		FS,AX
		MOV		GS,AX
		MOV		ESP,[0xfe4]		; start_app�̂Ƃ���ESP�ɖ������߂�
		STI			; �؂�ւ������Ȃ̂Ŋ��荞�݉\�ɖ߂�
		POPAD	; �ۑ����Ă��������W�X�^����
		RET

_memtest_sub:	; unsigned int memtest_sub(unsigned int start, unsigned int end)
		PUSH	EDI						; �iEBX, ESI, EDI ���g�������̂Łj
		PUSH	ESI
		PUSH	EBX
		MOV		ESI,0xaa55aa55			; pat0 = 0xaa55aa55;
		MOV		EDI,0x55aa55aa			; pat1 = 0x55aa55aa;
		MOV		EAX,[ESP+12+4]			; i = start;
mts_loop:
		MOV		EBX,EAX
		ADD		EBX,0xffc				; p = i + 0xffc;
		MOV		EDX,[EBX]				; old = *p;
		MOV		[EBX],ESI				; *p = pat0;
		XOR		DWORD [EBX],0xffffffff	; *p ^= 0xffffffff;
		CMP		EDI,[EBX]				; if (*p != pat1) goto fin;
		JNE		mts_fin
		XOR		DWORD [EBX],0xffffffff	; *p ^= 0xffffffff;
		CMP		ESI,[EBX]				; if (*p != pat0) goto fin;
		JNE		mts_fin
		MOV		[EBX],EDX				; *p = old;
		ADD		EAX,0x1000				; i += 0x1000;
		CMP		EAX,[ESP+12+8]			; if (i <= end) goto mts_loop;
		JBE		mts_loop
		POP		EBX
		POP		ESI
		POP		EDI
		RET
mts_fin:
		MOV		[EBX],EDX				; *p = old;
		POP		EBX
		POP		ESI
		POP		EDI
		RET

_farjmp:		; void farjmp(int eip, int cs);
		JMP		FAR	[ESP+4]				; eip, cs
		RET

_farcall:		; void farcall(int eip, int cs);
		CALL	FAR	[ESP+4]				; eip, cs
		RET

_asm_hrb_api:
		; �s���̂������Ƃɍŏ����犄�荞�݋֎~�ɂȂ��Ă���
		PUSH	DS
		PUSH	ES
		PUSHAD		; �ۑ��̂��߂�PUSH
		MOV		EAX,1*8
		MOV		DS,AX			; �Ƃ肠����DS����OS�p�ɂ���
		MOV		ECX,[0xfe4]		; OS��ESP
		ADD		ECX,-40
		MOV		[ECX+32],ESP	; �A�v����ESP��ۑ�
		MOV		[ECX+36],SS		; �A�v����SS��ۑ�

; PUSHAD�����l���V�X�e���̃X�^�b�N�ɃR�s�[����
		MOV		EDX,[ESP   ]
		MOV		EBX,[ESP+ 4]
		MOV		[ECX   ],EDX	; hrb_api�ɓn�����߃R�s�[
		MOV		[ECX+ 4],EBX	; hrb_api�ɓn�����߃R�s�[
		MOV		EDX,[ESP+ 8]
		MOV		EBX,[ESP+12]
		MOV		[ECX+ 8],EDX	; hrb_api�ɓn�����߃R�s�[
		MOV		[ECX+12],EBX	; hrb_api�ɓn�����߃R�s�[
		MOV		EDX,[ESP+16]
		MOV		EBX,[ESP+20]
		MOV		[ECX+16],EDX	; hrb_api�ɓn�����߃R�s�[
		MOV		[ECX+20],EBX	; hrb_api�ɓn�����߃R�s�[
		MOV		EDX,[ESP+24]
		MOV		EBX,[ESP+28]
		MOV		[ECX+24],EDX	; hrb_api�ɓn�����߃R�s�[
		MOV		[ECX+28],EBX	; hrb_api�ɓn�����߃R�s�[

		MOV		ES,AX			; �c��̃Z�O�����g���W�X�^��OS�p�ɂ���
		MOV		SS,AX
		MOV		ESP,ECX
		STI			; ����Ɗ��荞�݋���

		CALL	_hrb_api

		MOV		ECX,[ESP+32]	; �A�v����ESP���v���o��
		MOV		EAX,[ESP+36]	; �A�v����SS���v���o��
		CLI
		MOV		SS,AX
		MOV		ESP,ECX
		POPAD
		POP		ES
		POP		DS
		IRETD		; ���̖��߂�������STI���Ă����

_start_app:		; void start_app(int eip, int cs, int esp, int ds);
		PUSHAD		; 32�r�b�g���W�X�^��S���ۑ����Ă���
		MOV		EAX,[ESP+36]	; �A�v���p��EIP
		MOV		ECX,[ESP+40]	; �A�v���p��CS
		MOV		EDX,[ESP+44]	; �A�v���p��ESP
		MOV		EBX,[ESP+48]	; �A�v���p��DS/SS
		MOV		[0xfe4],ESP		; OS�p��ESP
		CLI			; �؂�ւ����Ɋ��荞�݂��N���Ăق����Ȃ��̂ŋ֎~
		MOV		ES,BX
		MOV		SS,BX
		MOV		DS,BX
		MOV		FS,BX
		MOV		GS,BX
		MOV		ESP,EDX
		STI			; �؂�ւ������Ȃ̂Ŋ��荞�݉\�ɖ߂�
		PUSH	ECX				; far-CALL�̂��߂�PUSH�ics�j
		PUSH	EAX				; far-CALL�̂��߂�PUSH�ieip�j
		CALL	FAR [ESP]		; �A�v�����Ăяo��

;	�A�v�����I������Ƃ����ɋA���Ă���

		MOV		EAX,1*8			; OS�p��DS/SS
		CLI			; �܂��؂�ւ���̂Ŋ��荞�݋֎~
		MOV		ES,AX
		MOV		SS,AX
		MOV		DS,AX
		MOV		FS,AX
		MOV		GS,AX
		MOV		ESP,[0xfe4]
		STI			; �؂�ւ������Ȃ̂Ŋ��荞�݉\�ɖ߂�
		POPAD	; �ۑ����Ă��������W�X�^����
		RET
