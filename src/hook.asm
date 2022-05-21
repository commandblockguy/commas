include 'capnhook.inc'
include '../../toolchain/src/include/ti84pceg.inc'

section	.text,"ax",@progbits
public _hook

SEPARATOR = ','
DECIMAL = '.'

_hook:
	db	$83
	set	0,(iy-flag_continue)
	or	a,a
	ret	nz

	ld	a,(ti.OP1)
	and	a,$3f
	ret	nz

	push	hl
	scf
	sbc	hl,hl
	ld	(hl),2
	pop	hl

	ld	a,20
	call	ti.FormReal

	ld	e,-1
	ld	hl,ti.OP3-1
.find_period_loop:
	inc	hl
	inc	e
	ld	a,(hl)
	or	a,a
	jr	z,.found
	cp	a,'.'
	jr	nz,.find_period_loop
if DECIMAL <> '.'
	ld	(hl),DECIMAL
end if
	
.found:
	
	ld	a,e
.insert_loop:
	dec	hl
	dec	hl
	dec	hl
	sub	a,3
	jr	z,.done
	jr	c,.done
	push	bc
	ld	bc,24
	add	hl,bc
	push	hl
	pop	de
	dec	hl
	lddr
	pop	bc
	inc	hl
	ld	(hl),SEPARATOR
	ld	b,1
	inc	c
	jr	.insert_loop
.done:
	ld	hl,ti.OP3
	ld	a,b
	ld	b,0
	ld	iy,ti.flags
	call	$21890

	res	0,(iy-flag_continue)
	res	ti.donePrgm,(iy+ti.doneFlags)

	xor	a,a
	inc	a

	ret
