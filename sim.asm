	; Michał Piotr Stankiewicz <ms335789@students.mimuw.edu.pl>
	global start, step, get_width, get_height, get_fields, get_warmers, get_coolers, get_weight, get_second
	extern malloc, memcpy
	section .data
width	dq	0
height	dq	0
fields	dq	0
warmers	dq	0
coolers	dq	0
weight	dd	0
second	dq	0			; array used to make simulation
size	dq	0			; size of second array, used by memcpy
	section .text

start:
	mov	[width], rdi		; store width
	mov	[height], rsi		; store height
	mov	[fields], rdx		; store fields array
	mov	[warmers], rcx		; store warmers array
	mov	[coolers], r8		; store coolers array
	movd	[weight], xmm0		; store weight array
	; calculate width * height * sizeof(float) and allocate such memory
	mov	rax, 4			; store sizeof(float) in rax
	mul	rdi			; mul width by sizeof(float)
	mul	rsi			; mul width * sizeof(float) by height
	mov	rdi, rax		; move value to rdx, so it is first argument
	mov	[size], rdi		; store size
	call 	malloc			; allocate sizeof(float) * width * height
	mov	[second], rax		; store pointer to allocated memory in second	
	ret
step:
	; copy values to second array, operations will be made on fields array, but we need 
	; second to store old values
	mov	rdi, [second]		; first  argument - destination
	mov	rsi, [fields]		; second argument - source
	mov	rdx, [size]		; third  argument - size
	call	memcpy			; copy data from fields to second
	push	r15			; counter for height
	push	r14			; counter for width
	push	r13			; counter for arrays
	push	r12			; addr of field
	push	r11			; addr of second
	
	; calculate array index and fields/second addr
	mov	r13, [width]
	imul	r13, [height]
	mov	r12, r13
	imul	r12, 4
	mov	r11, r12
	add	r11, [second]
	add	r12, [fields]
	
	; loops
	mov	r15, [height]		; mov height to r15
height_loop:				; were to jump at height loop
	sub	r15, 1			; substract 1 from height counter
	mov	r14, [width]		; mov width to r14
width_loop:				; were to jump at width loop
	sub	r14, 1			; substract 1 from width counter
	sub	r13, 1			; substract 1 from arrays counter
	sub	r12, 4			; substract sizeof(float) from field addr
	sub	r11, 4			; substract sizeof(float) from second addr

	pxor	xmm0, xmm0		; make xmm0 a 0 value

	; here will be the left one
	; if width counter > 0 then fields[index-1] else warmer[height counter]

	subss	xmm0, [r11]
	subss	xmm0, [r11]
	subss	xmm0, [r11]
	subss	xmm0, [r11]

	mulss	xmm0, [weight]		; multiply change by weight

	addss	xmm0, [r11]		; at finale we add old value
	movd	[r12], xmm0		; move calculated value to fields

	cmp	r14, 0			; compare width counter to 0
	jnz	width_loop		; if yes make one more iteration of width loop
	cmp	r15, 0			; compare height counter to 0
	jnz	height_loop		; if yes make one more iteration of height loop
	pop	r11			; restore r11
	pop	r12			; restore r12
	pop	r13			; restore r13
	pop	r14			; restore r14			
	pop	r15			; restore r15
	ret
get_width:
	mov	rax, [width]
	ret
get_height:
	mov	rax, [height]
	ret
get_fields:
	mov	rax, [fields]
	ret
get_warmers:
	mov	rax, [warmers]
	ret
get_coolers:
	mov	rax, [coolers]
	ret
get_weight:
	movq	xmm0, [weight]
	ret
get_second:
	mov	rax, [second]
	ret

