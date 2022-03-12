section .data
    delim db " ", 10, 0
    sign dd 1
section .bss
    root resd 1

section .text

extern check_atoi
extern print_tree_inorder
extern print_tree_preorder
extern evaluate_tree
extern malloc
extern strtok
extern strdup

global create_tree
global iocla_atoi
global recursiva

recursiva:
;Aloca si tokenizeaza pt un nod recursiv care va completa arborele
    push ebp
    mov ebp, esp
    push 12
    call malloc
    add esp, 4
    push eax
    push 12
    call malloc
    add esp, 4
    pop edi
    mov [edi], eax
    push edi
    xor edx, edx
    push delim
    push edx
    call strtok
    add esp, 8
    push eax
    call strdup
    add esp, 4
    mov [edi], eax
;Aloca noduri nule in left si right
left_null:
    push 12
    call malloc
    add esp, 4
    push eax
    push 12
    call malloc
    add esp, 4
    pop edi
    mov [edi], eax
    push edi
    xor edx, edx
    mov edi, [edi]
    mov [edi], edx
right_null:
    push 12
    call malloc
    add esp, 4
    push eax
    push 12
    call malloc
    add esp, 4
    pop edi
    mov [edi], eax
    push edi
    xor edx, edx
    mov edi, [edi]
    mov [edi], edx
    mov edx, [esp+8]
    mov edx, [edx]
    mov cx, word [edx]
    ;E operator sau nu e?
    cmp cx, "*"
    jl final
    cmp cx, "/"
    jg final
    ;E operator, apeleaza left si right recursiv si se pun cap la cap nodurile
left_recursive:
    mov edx, [esp+8]
    push edx
    call recursiva
    add esp, 4
    xor ecx, ecx
    mov [eax+4], edx
right_recursive:
    xor edx, edx
    mov edx, [esp+8]
    push edx
    call recursiva
    add esp, 4
    xor ecx, ecx
    mov [eax+8], edx
    ;Aici se da outputul functiei 
final:
    mov edx, [esp+8]
    push dword [ebp+8]
    pop eax
    leave 
    ret
iocla_atoi: 
    ; TODO
    push ebp
    mov ebp, esp
    xor eax, eax
    xor ecx, ecx
    mov dword [sign], 1
    push dword [ebp+8]
    pop edx
    movzx ecx, byte [edx]
    ;E negativ?
    cmp ecx, "-"
    je negativ
    jmp pozitiv
negativ:
    mov dword [sign], 0
    add edx, 1
    xor ecx, ecx
    movzx ecx, byte [edx]
    jmp pozitiv
pozitiv:
    ;Se ia inputul si se trece cifra cu cifra, spre baza 10
    cmp ecx, 0
    je ending
    imul eax, 10
    sub ecx, '0'
    add eax, ecx
    add edx, 1
    movzx ecx, byte [edx]
    cmp ecx, 0
    jne pozitiv
ending:
    cmp dword [sign], 0
    je da
    jmp nu
da:
    neg eax
    leave
    ret
nu: 
    leave
    ret

create_tree:
    ; TODO
    enter 0, 0
    xor eax, eax
rootul: 
    ;Alocarea memoriei pt primul nod si trecerea valorii primului caracter in el
    push 12
    call malloc
    add esp, 4
    push eax
    push 12
    call malloc
    add esp, 4
    pop edi
    mov [edi], eax
    push edi
    push delim
    push dword [ebp+8]
    call strtok
    add esp, 8
    push eax
    call strdup
    add esp, 4
    mov [edi], eax
    
left:
    ;Apelul catre functia recursiva pt nodul stang
    xor eax, eax
    mov eax, [esp]
    push eax
    call recursiva
    add esp, 4
    mov [eax+4], edx
right:
    ;Apelul catre functia recursiva pt nodul drept
    xor eax, eax
    mov eax, [esp]
    push eax
    call recursiva
    add esp, 4
    mov [eax+8], edx 
    pop eax
    leave
    ret
