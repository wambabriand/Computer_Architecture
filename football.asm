section .data

   sf db "this is the semi-final ."     ;i use that just to print
   s  db "this is the final ."          ;i use that just to print
   w  db "the winner is    ."           ;i use that just to print
   g  db "group   ."
   cg db "final classification of group   ."

   s1 db 'A','1','A','2','A','3'  ; group A : vector of name s
   s2 db 'B','1','B','2','B','3'  ; group B : vector of names
   s3 db 'C','1','C','2','C','3'  ; group C : vector of names
   p1   db 0,0,0                  ; group A : vector of points
   p2   db 0,0,0                  ; group B : vector of points
   p3   db 0,0,0                  ; group C : vector of points
   tmp db '-'                     ; simple variable allows to prints the caracter '-' between two team's name 

aa db 10                          ; varible allowing to print caracter new Line
daa : equ 1                       ; dimension (number of caracter occuped by new line and '-'
dim : equ 3                       ; Number of team ( diemension of ours vectors )

section .bss                      ; in this session I declare without inizialize them 

var resb 8                       ; res( means reseve ) type of type ( b = byte ) 8 numeber of byte(free space ) I want to reserve
score resb 6                     ; res( means reseve ) type of type ( b = byte ) 6 numeber of byte(free space ) I want to reserve  
                                 ; DB, DW, DD, == RESB, RESW, RESD
section .text
 
    global _start:               ; Used to tell the starting point of my program

_start:

  mov byte[g+7],'A'  ; I set the seventh byte pointed by g to A
  mov ecx,g          ; I move the effective address of g in register ecx
  call _printline    ; I call the procedure
  call _newLine      ; I call the procedure

  mov rdi ,s1        ; I move the offset of s1  in register rdi
  mov rsi ,p1        ; I move the offset of p1  in register rsi
  call _scan         ; i call procedure _scan
  mov rdi ,s1        ; I move the effective address of s1  in register rdi
  mov rsi ,p1        ; I move the effective address of p1  in register rsi
  call _sort   
  mov rdi ,s1        ; I move the offset of s1 in register rdi
  mov rsi ,p1        ; I move the offset of p1 in register rsi

  mov byte[cg+31],'A'; I set the seventh byte pointed by cg to 'A'  
  mov ecx,cg         ; I move the effective address of cg in register rcx
  call _printline    ; I call this procedure to print  
  call _newLine
  call _stampagroup  ; I print all information of a group
 

  mov byte[g+7],'B'  ; I set the seventh byte pointed by g to B
  mov ecx,g          ; I move the effective address of g in register ecx
  call _printline    ; I call this procedure to print  
   call _newLine     ; I call this procedure to print  
  mov rdi ,s2        ; I move the offset of s2  in register rdi
  mov rsi ,p2        ; I move the offset of p2  in register rsi
  call _scan         ; Allows to get the scores of the teams of a group
  mov rdi ,s2        ; I move the offset of s2 in register rdi
  mov rsi ,p2        ; I move the offset of p2 in register rsi
  call _sort 
  mov rdi ,s2        ; I move the offset of s2  in register rdi
  mov rsi ,p2        ; I move the offset of p2  in register rsi

  mov byte[cg+31],'B' ; I set the seventh byte pointed by cg to 'B' 
  mov ecx,cg         ; I move the effective address of cg in register rcx
  call _printline    ; I call this procedure to print 
  call _newLine
  call _stampagroup  ; I print all information of a group

  mov byte[g+7],'C'  ; I set the seventh byte pointed by g to C
  mov ecx,g  
  call _printline     ; I call this procedure to print 
   call _newLine      ; I call this procedure to print 

  mov rdi ,s3          ; I move the offset of S3  in register rdi , 
  mov rsi ,p3          ; I move the offset of p3  in register rsi
  call _scan 
  mov rdi ,s3          ; I move the offset of s3 in register rdi
  mov rsi ,p3          ; I move the offset of p3 in register rsi  
  call _sort 
  mov rdi ,s3          ; I move the offset of s3  in register rdi
  mov rsi ,p3          ; I move the offset of p3  in register rsi


  mov byte[cg+31],'C' ; I set the seventh byte pointed by cg in C
  mov ecx,cg         ; I move the effective address of cg in register rcx
  call _printline    ; I call this procedure to print
  call _newLine      ; I call this procedure to print
  call _stampagroup  ; I will print all information of group

                     ; I assume that the second team in rank of group A is the 4th for the semi final

  mov ax,word[s1+2]  ;I load the second element of array s1 ( of words ) into ax
  mov cl,byte[p1+1]  ;I load the second element of array p1 ( of byte ) into cl where p1[1] are the points of the second in rank
  
  cmp cl,byte[p2+1]  ; I compare cl with p2[1] where p2[1] are the points of the 2nd in rank  
  jge nothing11      ; jump to the label "nothing11" if cl >= p2[1]  
  mov ax,word[s2+2]  ;I load the value of the second element of the array s2 into ax,I add 2 because each element(team name) is a word(2 bytes)
  mov cl,byte[p2+1]  ; I load the value of the second element of vector p2 into ax
  nothing11:         ; Label
  cmp cl,byte[p3+1]  ; I compare cl with p3[1] where p3[1] are the points of the 2nd in rank 
  jge nothing22      ; jump to the label "nothing22" if cl >= p3[1]
  mov ax,word[s3+2]  ;I load the value of the second element of the array s3 into ax,I add 2 because each element(team name) is a word(2 bytes)
  nothing22:         ; Label

  mov ecx,sf         ; I load the offset of sf into rcx  
  call _printline    ; i print the message contained in sf
  call _newLine      ; I call this procedure to print new line

  push rax           ; I save into the stack the value of rax (name of the 4th team for the semi final)
  mov ax,word[s1]    ; Load into ax the first element( 1 word) of vector s1 where [s1] is the first in rank of group A
  mov bx,word[s2]    ; Load into bx the first element( 1 word) of vector s1 where [s2] is the first in rank of group B
  call _semi         
  pop rbx            ; I retrieve from the stack name of the 4th team for the semi final  , using the operation pop
  push rax           ; I save into the stack my first team qualified for the final( obtained after calling _semi) 
  mov ax,word[s3]    ; Load into ax the first element( 1 word) of vector s3 where [s3] is the first in rank of group C
  call _semi
  mov bx,ax          ; I put ax into bx
  pop rax            ; I retrieve from the stack the first team qualified for the final

  mov ecx,s          ; I load the offset of sf into ecx  
  call _printline    ; i print the message contained in s
  call _newLine      ; i print the new line

  call _semi      

  mov ecx,w           ; I load the offset of w into ecx
  mov word[w+14],ax  
  call _printline     ; i print the message contained in s 
  call _newLine       ;  i print the new line

                      ; the following 3 instructions  allow to correctly exit the program
   mov eax,1          ; Put the system call number in the EAX register
   mov ebx,0          ; Store the arguments to the system call in the registers ebx
   int 80h            ; sends an interrup to the processor
;******************************

;The procedure _semi takes 2 parameters( the name of 2 teams) into registers rax and rbx and return the winner into rax 
_semi:             

    mov rdx,rax       ; I move rax into rdx 
    push rax          ; I save rax(team name ) into the stack because I  will overwrite the register rax 
    mov rcx,var       ; I move offset of var( temporary variable) into rcx
    mov [rcx],dx      ; I load the value of dx(team name) into the memory location pointed by rcx (var)  
    call _printname   ; I print the name of the team contained in [rcx]
    mov rcx ,tmp      ; I load offset of tmp into rcx ; I want to print the caracter '-'
    call _printchar   ; I print 1 character ('-')
    mov rcx,var       ; I move offset of var( temporary variable) into rcx
    mov [rcx],bx      ; I load the value of bx(team name) into the memory location pointed by rcx (var)
    call _printname   ; I print the name of the team contained in [rcx]

    call _space      ; I call this procedure (_space) to print spaces before asking the score ( just to clean output)
    call _getscore   ; Getscore Stores the match outcome in ah( score of the first team ) and al(score of the  second team ) 

    cmp ah,al        ; I compere AH with AL and store the winner in rax
    jl  w_bx         ; if AH<AL I jump on w_bx( the winner is stored into bx)
    pop rax          ; else the winner is stored into ax  ( I pop rax  )
    jmp end_s        ; I jump to the end of the procedure
w_bx:
    pop rdx           ; I retrieve the value of rdx from the stack
    mov ax,bx         ; I move the value of bx in ax  ( the winner )
end_s:
ret                  ; directive to corectly return to the caller procedure 

; ****************************

;the procedure _sort sorts team names according to their points

_sort:

mov rcx,0             ; I set rcx to 0 ; i(cl) and j (ch) are my indeces
mov rdx,rdi           

ii_i: cmp cl,dim      ; I compare cl with dim
      je end_i        ; If cl is equal to dim I jump to label end_i  of the external cicle 
                      
      mov ch,cl       ; Else  I move into cl ,ch (index j = i )
      inc ch          ; I increment cl (j=j+1) because I want to campare element i with element j=i+1 ... 
      mov bh,[rsi]    ; I load the points of team i in bh 
      mov rdi, rsi    
      inc rdi         ;I increment cl (j=j+1) because I want to campare element i with element j=i+1 

jj_j: cmp ch,dim      ; I compare j (ch) with dim
      je end_j        ; If (ch==dim) they are equal, I stop my cicle end_j
      
      mov bl,[rdi]    ; I load the points of team j in bl 
      cmp bh,bl       ; I compare bh with bl 
      jg  nextt       ; If  bh > bl I jump to the label nextt
      cmp bh,bl       ; I compare bh with bl
      jl  swap        ; If  bh < bl I jump to the label swap
check_name:           ; else bh==bl I compare their names
      push rdi        ;I save rdi into the stack ( points of  team i )
      push rsi        ;I save rsi into the stack ( points of  team j )
      mov rdi,rdx     ;I put rdx into rdi (rdx contains the name of team i )
      mov rsi,rdx     ;I put rdx into rsi (rdx contains the name of team i , I will add the number (j-i) to get name of team j)
      mov rax,0 
      mov al,cl       ; I move  cl into al (al=i)
      add rsi,rax     ; I want to make the displacement  ( rsi=rsi+rax = s1[0+i])
      add rsi,rax     ; I add to rsi , rax 2 times because the vector take 2 bytes(word) for each element ( team name)
      mov al,ch       ; I move ch into al ( al=j)
      add rdi,rax     ; I want to make the displacement  ( rdi=rdi+rax = s1[0+j]) 
      add rdi,rax     ; I add to rdi , rax 2 times because the vector take 2 bytes(word) for each element ( team name)
      mov ax,word[rsi] ; Ax= s1[i] ; 
      
      cmp ax,word[rdi] ; I compare ax ( S1[i]) with  [rdi] (S1[j])
      jl  nothing      ; If ax is less than [rdi] I jump to label nothing
      pop rsi          ; Else I retrieve my value( points of team i) from the stack  
      pop rdi          ; Else I retrieve my value( points of team j) from the stack
      jmp swap         ; I jump to  the label swap
nothing:
       pop rsi         ; I retrieve my value( points of team j) from stack
       pop rdi         ; I retrieve my value( points of team i) from stack
       jmp nextt       ; I jump to the label nextt

swap: push rdi         ; I save the points of team i into the stack
      push rsi         ;I save the points of team j into the stack
      mov rdi,rdx      ; I move offset of the array of the team  names into rdi
      mov rsi,rdx      ; I move offset of the array of the team  names into rsi
      mov rax,0        ;
      mov al,cl        ; into al I put cl (i)
      add rsi,rax      ; I make displacement 
      add rsi,rax      ; I add to rsi , rax 2 time because names are strore  on 2 bytes
      mov rax,0
      mov al,ch        ; into al I put ch (j)
      add rdi,rax      ; I make displacement  
      add rdi,rax      ; I add to rdi , rax 2 time because names are strore  on 2 bytes
      mov ax,word[rsi]  ; I swap their value ( name )
     xchg ax,word[rdi]  ; I swap their value ( name )  
     xchg ax,word[rsi]     
       pop rsi        ; I retrieve  points of  team i
       pop rdi        ; I retrieve  points of  team j
      mov [rdi],bh    ; I swap their value ( points) 
      mov [rsi],bl    ; I swap their value ( points)
      mov bh,bl       
        
nextt:
     inc ch           ; I increment index ch (j) 
     inc rdi          ; I  increment rdi  
     jmp jj_j         ; I jump to loop jj_j  controled   by the index j

end_j:
      inc rsi         ; I  increment rsi 
      inc cl          ; I increment index i
     jmp ii_i         ; I jump to loop ii_i controled  by the index i
     
end_i:
   
ret                   ; directive to corectly return to the caller procedure 

;*****************
_stampagroup:
    push rcx            ;I save into stack the value of rcx
    mov rcx,0           ; I put into rcx value 0 because I will use it like my index

start1:
    cmp cx,dim          ; I compare cx with dim ( number of team ) 
    je end3             ; If (cx==dim)then  I have already printed all teams , I jump on label end3
    push rcx            ; Else I save rcx into the stack (it is my index) 
    mov rcx,rdi         ; I move rdi( offset of team name) into rcx 
    call _printname     ; I print the team name 
    call _space         ; print some space 
    mov rcx,rsi         ; I move rsi( offset of team point ) into rcx
    mov al,byte[rcx]    ; I take the number of points
    mov [score],al      ; I save into tmp variable
    add byte[score],48  ; I add 48 to convert to an ascii char...
    mov rcx,score       ; I put into rcx offset of tmp variable
    call _printchar     ; I call print char
    add rdi,2           ; I add 2 to rdi because  name is 2 byte
    inc rsi             ; I add 1 to rsi because  point is 1 byte
    pop rcx             ; I take my index rcx from the stack
    inc cx              ; I increment it cx = cx+1
    call _newLine       ; semple for presentation
    jmp start1          
end3:
pop rcx                   

ret                   ; directive to corectly return to the caller procedure 
;***********
_space:
push rcx                ;I save into stack the value of rcx 
mov word[score],"  "    ;I put space in score 
mov rcx,score           ; I put offset of score into rcx
call _printname         ; I print 
pop rcx               
ret                    ; directive to corectly return to the caller procedure 
;*********************************

_scan:
mov rcx,0   
mov rbx,rsi              ; in rbx i have offset of ppoint
i_i:
cmp cx,dim               ; I compare cx with dim ( number of teams ) 
    je end1
    push rcx             ; I save rcx into stack .it is my index  i
    
mov rsi,rdi              ; I put rdi into rsi
    add rsi,2            ; I add 2 to rsi to get the next team
    inc cx               ; I increment cx (i=i+1 )

j_j: cmp cx,dim          ; I compare cx with dim ( number of teams ) 
    je end2              ; if I always make all combination of team i with the team j=i+1,i+2, ... dim  , I stop cicle j_j
    push rcx             ; I save rcx into stack .it is my index  J
    mov rcx,rdi          ; I move offset of team name i
    call _printname      ; I print the name of team i
    mov rcx ,tmp         ; tmp contains the character '-'
    call _printchar      ; print '-'
    mov rcx,rsi          ; I move offset of team name j
    call _printname      ; I print the name of team j
    
    call _space          ; just for presentation       
    call _getscore       ; Getscore Stores the match outcome in ah( score of the first team ) and al(score of the  second team ) 
        
    pop rcx              ; I take from stack my index j
    pop r10              ; I take from stack my index i
    push r10             ; I save r10 into stack .it is my index  i
    push rsi             ; I save rsi into stack .it is name of team i
    push rdi             ; I save rdi into stack .it is name of team j
    mov rdi,r10         ; I put i into rdi 
    mov rsi,rcx         ; I put j into rsi 
    add rsi,rbx         ; I add to rsi, rbx  (offset of vector of point) to retrieve points of team i
    add rdi,rbx         ; I add to rdi, rbx (offset of  vector of point) to retrieve points of team j 
    
    cmp ah,al           ; I compare the score 
    je  equall          ; if (ah==al) then I check if is 0-0 or 1-1...
    cmp ah,al           ; else I assign 3 points to the winner
    jg  mark_3_0        ; if team i wins  I jump to label mark3_0 and add 3 points to team i

mark_0_3: add byte[rsi],3           ; Else I add 3 points  to team j
          jmp already_give_mark     ; I jump on already
          
equall: cmp al,'0'                  ; If( al==0)  I check if is 0-0 then I  add 1 point to each
        je mark_1_1                 ; if(al==0 ) I check if is 0-0 then I  add 1 point to each
mark_2_2: add byte[rsi],2           ; Else I add 2 points to each team
          add byte[rdi],2
          jmp already_give_mark
mark_1_1: add byte[rsi],1          ; I add 1 point  to team j
          add byte[rdi],1          ; I add 1 point  to team i
          jmp already_give_mark
mark_3_0: add byte[rdi],3          ;I add 3 point  to team i
          jmp already_give_mark

already_give_mark:
    pop rdi                        ; I retrieve the name of team i from the stack
    pop rsi                        ; I retrieve the name of team j from the stack
    inc cx                         ; I increment j so I pass to team j+1
    add rsi,2                      
    jmp j_j
end2:   
    pop rcx                        ; I retrieve my index i from the stack
    inc cx                         ; I increment i so I pass to team i+1
    add rdi,2                     
    jmp i_i    
end1:

ret                    ; directive to corectly return to the caller procedure 
;*******************

;getscore Stores the match outcome in ah( score of the first team ) and al(score of the  second team ) 

_getscore:
  
   push rdi         ; I save rax into stack because i will use it here
   push rsi         ; I save rax into stack because i will use it here
   push rbx         ; I save rax into stack because i will use it here
   
   mov rax,0        ; I call the system call READ , puting 0 into rax
   mov rdi,0        ; 0 into rdi means standard output keybord
   mov rsi,score    ; I will save into variable score 
   mov rdx,6        ; I will read at most 6 byte
   syscall          ; with the previous intruction I will call  syscall read

   pop rbx          ; I take my value from stack
   pop rsi          ; I take my value from stack
   pop rdi          ; I take my value from stack
   mov ah,[score]   ; put in ah the first character corresponding to the number of goal of first team
   mov al,[score+2] ; put in al the third character corresponding to the number of goal of second team
    
ret               ; directive to correctly return to the caller procedure 

;*****************************
_printname:
call _printchar    ; I print the first character
inc rcx            ; I increment to past to the second character
call _printchar    ; I print the second character
ret                ; directive to correctly return to the caller procedure 

;***************************** put offset of vector in ecx 
_printline:
   push rax                   ; I save rax into stack because i will use it here
   mov al,'.'                 ; I put the end contidion of line here
  ciclo: cmp byte[rcx], al    ; if it is the end condition I stop   
         je fine
         call _printchar      ; else I print the character that offset is in rcx    
         inc rcx              ; I go to the next character
         jmp ciclo            ; I jump to label cicle
  fine: 
    pop rax                   ; I take my value from stack
ret                       ; directive to correctly return to the caller procedure 

;************************* 
; char is stored in ecx
_printchar:
     push rax        ; I save rax into stack because i will use it here
     push rbx        ; I save rax into stack because i will use it here
     push rdx        ; I save rax into stack because i will use it here
      mov eax,4      ;*** system call print    
      mov ebx,1      ;*** where I want to print,  1 = standard output
      mov edx,1      ;*** number of character i want to print
      int 80h        ;*** these are operations to print a character 
    pop rdx           ; I take my value from stack
    pop rbx           ; I take my value from stack
    pop rax           ; I take my value from stack
ret                  ; directive to correctly return to the caller procedure

;***********************

_newLine:             ; I save rax into stack because i will use it here
push rcx            
mov ecx,aa            ; I move offset of aa into ecx ( value of aa is 10 ) equal to character new line
call _printchar       ; print character
pop rcx               ; I take my value from stack
ret                   ; directive to correctly return to the caller procedure


