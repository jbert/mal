; calling conventions
;
; TODO: sane calling convention
; - arg1 in DE, retval in DE
; - all other regs clobberable, caller saves

; data structures:
;
; - strings are zero terminated

	ORG 0x8000

  DI
main_l:
	LD DE, s_repl_prompt
	CALL f_printstr
	LD DE, heap
	CALL f_rep
	LD A, (b_seen_eof)
	OR A
	JR Z, main_l
  DI
	HALT


; -------------
f_rep:
	CALL f_read

	CALL f_eval
	CALL f_print
	RET

; -------------
f_read:
	PUSH DE
	POP HL

l_read:
	LD BC, 0
	IN A, (C)

	CP 10
	JR Z, l_read_done

	OR A
	JR Z, l_read_eof

	LD (HL), A
	INC HL
	JR l_read

l_read_eof:
	PUSH HL
	LD HL, b_seen_eof
	LD (HL), 1
	POP HL

l_read_done:
	LD (HL), 0
	RET


; -------------
f_eval:
	RET

; -------------
f_print:
	CALL f_printstr
	LD A, 10
	LD BC, 0
	OUT (C), A
	RET


; -------------
f_printstr:
	PUSH DE
	POP HL
	LD BC, 0
f_printstr_loop:
	LD A, (HL)
	OR A
	RET Z
	OUT (C), A
	INC HL
	JR f_printstr_loop
	
; -------------
; RO data
; -------------
s_repl_prompt:
	dz 'user> '

; -------------
; RW data
; -------------
b_seen_eof:
	db 0

heap:
	ds 1024
