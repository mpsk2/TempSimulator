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
	; calculate index - index is width_counter + height_counter * width, we will go 
	; from max to 0
	mov	rdx, [size]		; well it is already calculated
	add	rdx, [fields]		; add fields, so now rdx store address to fields[width*height]
	; iteration - store to counters
	mov	rdi, [height]		; store height in rdi
height_step:
	sub	rdi, 1			; substract 1 from height counter
	mov	rsi, [width]		; store width in rsi
width_step:
	sub	rsi, 1			; substract 1 from height counter
	sub	rdx, 4			; we substract 1 index (64 bits)
	; we will calculate that way
	; mov 0 to [fields + rdx]
	; mov every diff from neighbours to [fields + rdx]
	; mul it by weight
	; move value there
	; go back to width_step if width counter not 0
	fldz				; store 0
	fstp	dword [rdx]
	cmp	rsi, 0			; compare width counter to 0
	jnz	width_step		; jump if not zero
	; go back to height_step if height counter not 0
	cmp	rdi, 0			; compare height counter to 0
	jnz	height_step		; jump if not 0
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

