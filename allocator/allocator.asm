; Allocator for x86-64 Linux
; This exports: malloc, free

BITS 64
GLOBAL malloc
GLOBAL free

SECTION .data
align 8
free_list:    dq 0        ; pointer to first free block (header)

SECTION .text

; constants
%define HEADER_SIZE 16     ; 8 bytes size+flag, 8 bytes next (when free)
%define ALLOC_FLAG 1

; -------------------------
; void *malloc(size_t size)
; arg: rdi = requested size
; return: rax = pointer to payload or 0 on failure
; -------------------------
malloc:
    push rbx
    push r12
    push r13

    cmp rdi, 0
    jne .have_size
    mov rdi, 1
.have_size:

    ; align requested size to 16 bytes: size = (size + 15) & ~15
    mov rax, rdi
    add rax, 15
    and rax, -16            ; rax = aligned payload size

    add rax, HEADER_SIZE    ; rax = total_size required (including header)
    mov r12, rax

    mov rbx, [rel free_list]
    xor r13, r13            ; prev = 0

.find_loop:
    test rbx, rbx
    jz .need_new_block      ; no free block fits

    mov rcx, [rbx]          ; rcx = block_size_with_flag
    and rcx, -2             ; clear allocation bit to get raw size
    cmp rcx, r12
    jb .next_free

    mov rdx, [rbx + 8]      ; rdx = next pointer
    test r13, r13
    jz .found_at_head
    mov [r13 + 8], rdx      ; prev.next = this.next
    jmp .found_unlinked
.found_at_head:
    mov [rel free_list], rdx
.found_unlinked:

    mov rax, [rbx]
    or  rax, ALLOC_FLAG
    mov [rbx], rax

    lea rax, [rbx + HEADER_SIZE]
    jmp .return_with_saved

.next_free:
    mov r13, rbx
    mov rbx, [rbx + 8]
    jmp .find_loop

.need_new_block:
    ; r12 holds total size
    ; get current brk: rax = brk(0)
    xor rdi, rdi        ; rdi = 0
    mov rax, 12         ; syscall: brk
    syscall             ; returns current break in rax
    mov r13, rax        ; r13 = old_break (address returned)

    ; compute new_brk = old_break + total
    mov rax, r13
    add rax, r12        ; rax = desired new break (new_brk)

    ; call brk(new_brk)
    mov rdi, rax
    mov rax, 12
    syscall

    cmp rax, rdi
    jne .malloc_fail

    mov rcx, r12
    or rcx, ALLOC_FLAG
    mov [r13], rcx

    lea rax, [r13 + HEADER_SIZE]
    jmp .return_with_saved

.malloc_fail:
    xor rax, rax

.return_with_saved:
    pop r13
    pop r12
    pop rbx
    ret

; -------------------------
; void free(void *ptr)
; arg: rdi = pointer to payload (or NULL). Returns void (no return).
; -------------------------
free:
    push rbx
    test rdi, rdi
    je .free_done

    sub rdi, HEADER_SIZE

    mov rax, [rdi]
    and rax, -2         ; clear LSB to mark free
    mov [rdi], rax

    mov rbx, [rel free_list]
    mov [rdi + 8], rbx
    mov [rel free_list], rdi

.free_done:
    pop rbx
    ret

SECTION .note.GNU-stack noalloc noexec nowrite ; makes the compile shut up

