	; Michał Piotr Stankiewicz <ms335789@students.mimuw.edu.pl>
	global start, step
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
	push	r12			; addr of field
	push	r11			; addr of second
	push	r10			; addr of coolers
	
	; calculate and fields/second addr
	mov	r12, [width]
	imul	r12, [height]
	imul	r12, 4
	mov	r11, r12
	add	r11, [second]
	add	r12, [fields]

	; calculate last cooler addr
	mov	r10, 4
	imul	r10, [height]
	add	r10, [coolers]

	; store max width in rax
	mov	rax, [width]
	sub	rax, 1
	
	; store max height in rdi
	mov	rdi, [height]
	sub	rdi, 1
	
	; store last warmers values
	; rsi - upper
	; rdx - lower
	; rcx - line lenght * sizeof (float)
	mov 	rsi, 4
	imul	rsi, [width]
	mov	rcx, rsi
	add	rsi, [warmers]
	mov	rdx, rsi
	
	; loops
	mov	r15, [height]		; mov height to r15
height_loop:				; were to jump at height loop
	sub	r15, 1			; substract 1 from height counter
	mov	r14, [width]		; mov width to r14
	sub	r10, 4			; substract sizeof(float) from warmers add counter
width_loop:				; were to jump at width loop
	sub	r14, 1			; substract 1 from width counter
	sub	r12, 4			; substract sizeof(float) from field addr
	sub	r11, 4			; substract sizeof(float) from second addr

	pxor	xmm0, xmm0		; make xmm0 a 0 value

	; here will be the left one
	; if width counter > 0 then fields[index-1] else coolers[height counter]

	cmp	r14, 0			; compare width counter to 0 - if yes we get value from coolers, if no we get value from fields
	jle	left_zero
	addss	xmm0, [r11-4]
	jmp	left_end
left_zero:
	addss	xmm0, [r10]
left_end:

	; here will be the right one
	; if width < max_width - 1 fields[index+1] else coolers[height counter]

	cmp	r14, rax
	jge	right_max
	addss	xmm0, [r11+4]
	jmp	right_end
right_max:
	addss	xmm0, [r10]
right_end:

	; below we will have up and down situation
	cmp	r15, 0
	jle	up_zero
	sub	r11, rcx
	addss	xmm0, [r11]
	add	r11, rcx
	jmp	up_end
up_zero:
	sub	rsi, 4
	addss	xmm0, [rsi]
up_end:

	cmp	r15, rdi
	jge	down_max
	add	r11, rcx
	addss	xmm0, [r11]
	sub	r11, rcx
	jmp	down_end
down_max:
	sub	rdx, 4
	addss	xmm0, [rdx]
down_end:

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
	pop	r10			; restore r10
	pop	r11			; restore r11
	pop	r12			; restore r12
	pop	r14			; restore r14			
	pop	r15			; restore r15
	ret
