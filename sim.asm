	; Michał Piotr Stankiewicz <ms335789@students.mimuw.edu.pl>
	global start, step, get_width, get_height, get_fields, get_warmers, get_coolers, get_weight, get_second
	extern malloc, memcpy
	section .data
width	dq	0
height	dq	0
fields	dq	0
warmers	dq	0
coolers	dq	0
weight	dq	0
second	dq	0			; array used to make simulation
size	dq	0			; size of second array, used by memcpy
	section .text

start:
	mov	[width], rdi		; store width
	mov	[height], rsi		; store height
	mov	[fields], rdx		; store fields array
	mov	[warmers], rcx		; store warmers array
	mov	[coolers], r8		; store coolers array
	movq	[weight], xmm0		; store weight array
	; calculate width * height * sizeof(int64_t) and allocate such memory
	mov	rax, 8			; store sizeof(int64_t) in rax
	mul	rdi			; mul width by sizeof(int64_t)
	mul	rsi			; mul width * sizeof(int64_t) by height
	mov	rdi, rax		; move value to rdx, so it is first argument
	mov	[size], rdi		; store size
	call 	malloc			; allocate sizeof(int64_t) * width * height
	mov	[second], rax		; store pointer to allocated memory in second
	; allocate second array
	
	ret
step:
	; copy values to second array, operations will be made on fields array, but we need 
	; second to store old values
	mov	rdi, [second]		; first  argument - destination
	mov	rsi, [fields]		; second argument - source
	mov	rdx, [size]		; third  argument - size
	call	memcpy			; copy data from fields to second
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

