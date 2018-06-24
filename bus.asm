section .data


 tab_a dw 080Ah,0900h,092Dh,0A1Eh,0B1Eh,0C1Eh,0D0Fh,0E00h,0F00h,1000h,1100h,1200h
 tab_b dw 070Ah,080Fh,0905h,0A28h,0B00h,0E00h,0E1Eh,0F00h,0F1Eh,100Fh,102Dh,110Fh
 tab_c dw 081Eh,0928h,0A32h,0C00h,0D0Ah,0E14h,0F1Eh,1028h,1132h,1300h,140Ah,1514h
 tab_d dw 0700h,0828h,0928h,0A28h,0B28h,0C1Eh,0D1Eh,0F00h,101Eh,121Eh,141Eh,1500h


sms: db "INSERT DEPARTURE TIME: ."                       ;i use that just to print
sms1: db "THE FIRST AVAILABLE BUS IS AT: ."              ;i use that just to print
sms2: db "first street ."                                ;i use that just to print
sms3: db "I WILL ARRIVED AT SWAP POINT AT : ."           ;i use that just to print
sms4: db "I WILL LEAVE THE SWAP POINT AT : ."            ;i use that just to print
sms5: db "I WILL ARRIVE  AT THE OFFICE AT : ."           ;i use that just to print
sms6: db "second strett ."                               ;i use that just to print
sms7: db "TOTAL DURATION OF TRAVEL IS ."                 ;i use that just to print

  a_to_b dw 16        ; Time for pullman necessary to go from A to B
  b_to_tp dw 29       ; Time for pullman necessary to go from B to TP
  c_to_d dw 4         ; Time for pullman necessary to go from C to D
  d_to_tp dw 45       ; Time for pullman necessary to go from D to tp

aa db 10             ; Just for print new line
dim : equ 12         ; lenght of my tables

section .bss         ; in this session I declare data without inizializing them 
                     
flag1 resb 8         ; res( means reserve ) type of data ( b = byte ) 8 number of byte(free space ) I want to reserve
flag resb 8          ; res( means reserve ) type of data ( b = byte ) 8 number of byte(free space ) I want to reserve
var resb 8           ; res( means reserve ) type of data ( b = byte ) 8 number of byte(free space ) I want to reserve
dure1 resb 8         ; res( means reserve ) type of data ( b = byte ) 8 number of byte(free space ) I want to reserve
dure2 resb 8         ; res( means reserve ) type of data ( b = byte ) 8 number of byte(free space ) I want to reserve
strr resb  10        ; res( means reserve ) type of data ( b = byte ) 10 number of byte(free space ) I want to reserve 
time resb  8         ; res( means reserve ) type of data ( b = byte ) 8 number of byte(free space ) I want to reserve
                     ; I use dure1 and dure2 to make code flexible ( i use it into procedure  )
section .text
 
    global _start:

_start:
    
    mov ecx,sms        ; I move offset of sms into ecx
    call _printline    ; I call this procedure to print it ( look the initialization )    
    call _readHour     ; I read the time with this procedure ,  at the end I will have my departure time into ax

    mov ecx,sms2        ; I move offset of sms into ecx
    call _printline     ; I call this procedure to print it
    call _newLine       ; I call this procedure to print new line
     
    mov bx,ax           ; (bx = ax ) I move ax into bx ( departure time ) 
    push rbx            ; I save departure time in the stack. after I will use it for the calculation of the second path
    mov rdi,tab_a       ; I put offset of tab_a into rdi
    mov rsi,tab_b       ; I put offset of tab_b into rsi
    mov r11w,[a_to_b]   ; I am taking the value saved into a_to_b ( a_to_b contains the address , that is why i use [...] )
    mov [dure1],r11w    ; I save [a_to_b]  into variable dure1
    mov r12w,[b_to_tp]  ; I am taking the value save into [b_to_tp]
    mov [dure2],r12w    ; I save [b_to_tp] into variable dure2
    call _percorso      ; Call this procedure to find the first path
    call _newLine       ; I call this procedure to print new line

    mov ecx,flag           ; I put the address of my flag into  ecx;  
    mov byte[ecx],0        ; I set it to 0 ;    flag=1 if i will arrive the next day
    mov ecx,flag1          ; I put the address of my flag into  ecx ; flag1=1 if I can already print the time with *
    mov byte[ecx],0        ; I set it to 0

    
    mov ecx,sms6       ; I load offset of sms
    call _printline    ; I call this procedure to print it
    call _newLine      ; I call this procedure to print new line

    pop rbx             ; I take from stack my  departure time
    mov rdi,tab_c       ; I put offset of tab_c into rdi
    mov rsi,tab_d       ; I put offset of tab_d into rsi   
    mov r11w,[c_to_d]   ; I am taking the value save into [ c_to_d ]
    mov [dure1],r11w    ; I save [ c_to_d ] into variable dure1
    mov r12w,[d_to_tp]  ; I am taking the value save into [ d_to_tp ]
    mov [dure2],r12w    ; I save [ d_to_tp ] into variable dure2
    call _percorso  
    call _newLine    

                        ; the following 3 instructions  allow to correctly exit the program
   mov eax,1            ; Put the system call number in the EAX register
   mov ebx,0            ; Store the arguments to the system call in the registers
   int 80h              ; sends an interrup to the processor
;*********************************
_readHour:
                   ; Here I will use system call ( rax= system call , rdi = file ,rsi = variable ( data ) rdx= dimension )
   mov rax,0       ; I am calling system call READ , puting 0 into rax  ( if I put 1 I will call WRITE ...)
   mov rdi,0       ; 0 into rdi standard input keyboard ( if rdi = 1 o 2 I will not write it on standard ouput but in a specific file )
   mov rsi,time    ; I will save input from keyboard into variable time ( this is my parameters )
   mov rdx,6       ; I will read at most 6 bytes 
   syscall         ; with the previous instruction I will call  syscall read
   
   mov rbx,10      ; rbx = 10  I set rbx= 10 to make division
   mov ecx,time    ; 

   mov al,byte[ecx] ; I move the first character corresponding to the 1st character of hour
   sub al,48        ; I subtract 48 to convert it to an integer 
   mul rbx          ; I multiply it by 10
   inc ecx
   mov dl,byte[ecx] ; I move the second character corresponding to the 2nd character of hour
   sub dl,48        ; I subtract 48 to convert it to an integer 
   add al,dl        ; now I have my hour time

   add ecx,2        ; I will ignore the charatere 'H' inserted just for presentation
   push rax         ; i save rax(containing hh)  into stack
   
   mov al,byte[ecx] ; I move the 4th character corresponding to the 1st character of minute
   sub al,48        ; I subtract 48 to convert it to an integer
   mul rbx          ; I multiply it by 10
   inc ecx
   mov dl,byte[ecx] ; I move the 5th character corresponding to the 2nd character of minute 
   sub dl,48        ; I subtract 48 to convert it to an integer
   add al,dl        ; now I have my minute time       
   
   pop rdx
   mov ah,dl        ; now I have my departure time into ax like AX=HHmm

ret                 ; directive to correctly return to the caller procedure 

;**************************
                      ; just to understand the content of  reegister
                      ;tab_a =rdi tab_b=rsi  departure =bx ,dure1= a_to_b   dure2=b_to_tp
_percorso:
    push rbx          ;I save into stack the value of rbx (it is my departure time )

    call _find        ;I want to find the first available bus ( I have the offset of vector of hours in rdi)
    mov ecx,sms1      ;I move the offset of sms1 (first available ... ) into rcx
    call _printline   ;I call procedure printline to print my sms where offset is in ecx 
    mov ax,[rdi]      ;I take the time calculated by procedure _find 
    call _print_time  ;I print the time constained in register ax      
    call _addTime     ;This procedure computes the following operation  ax=ax+a_to_b  
    mov ecx,sms3      ;I move the offset of sms3 (I will arrive at ... ) into rcx
    call _printline   ;I call procedure printline to print my sms  
    call _print_time  ;I print the time  contained in register ax 
    
    mov bx,ax         ;I put into bx content of ax 

    mov rdi,rsi       ;I put into rdi content of rsi ( offset of vector tab_b  ) 
    call _find        ;I want to find the first available bus ( I have the offset of vector of hours in rdi)
    mov ecx,sms1      ;I mov the offset of sms1 (first available ... ) into rcx
    call _printline   ;I call procedure printline to print my sms where offset is contained in rex 
    mov ax,[rdi]      ;I take the time calculated by procedure _find
    call _print_time  ;I print the time  constained in register ax
    mov r11w,[dure2]  ; I move in r11w the time necessary for the bus to move from A to B
    mov [dure1],r11   ; I move r11w in dure1 because I use dure1 in procedure _addtime
    call _addTime     ; This procedure computes the following operation  ax=ax+swap_to_office  
    
    mov ecx,flag1     ; I put offset of flag1 into ecx
    mov byte[ecx],1   ; I set my flag1 to 1 ( allows to print the '*' ) 
    mov ecx,sms5      ;I mov the offset of sms5 (i arrive at office at ... ) into rcx
    call _printline   ;I call procedure printline to print my sms5 where offset is contained in ecx     
    call _print_time  ;I print the time  contained in register ax

    pop rbx           ;I take my departure time from the stack 
 
    mov ecx,flag1     ; I put offset of flag1 into ecx
    mov byte[ecx],0   ; I set my flag1 to 0  because if flag1==0 I could not print '*' 
    call _subHour     ; total duration = arriveH - leaveH  +flag*24 ( I have this risutl in ax)
    mov ecx,sms7      ;I move the offset of sms7 (total duration ... ) into rcx
    call _printline   ;I call procedure printline to print my sms5 where offset is in ecx      
    call _print_time  ;I print the time  contained in register ax  
  
ret                   ; directive to correctly return to the caller procedure 

;*********************
                     ;This procedure compute the following calculation  ax=ax-bx = arriveH - leaveH  +flag*24
_subHour: 

mov r10b,1            ;I move 1 into register r10b     
cmp [flag],r10b       ;I compare  flag with r10b 
jne nothing2          ;
add ah,24             ; If flag==1 I add 24 to my total duration
nothing2:

cmp al,bl             ;I compare  bl with al ( minute )
jge nothing1          ; if (bl( departure minute ) <al( arrival minute) ) i subtract al from bl
dec ah                ; Else I subtract  1 hour from ah ( arrival hour ) 
add al,60             ; I add 60 minute to al( arrival minute)   al=al+60
nothing1:             
sub al,bl             ; al = al-bl ( rest of minute)
sub ah,bh             ; ah = ah-bh ( rest of hour ) in ax i have the duration of travel

ret                   ; directive to correctly return to the caller procedure 
;***********************************  
_addTime:  ;This procedure compute the following calculation ax=ax+dure1 where dure1  is the time to travel from A to B

add al,byte[dure1]  ; dure1 is the variable that contains the time necessary for the bus to go from one place to another
cmp al,60           ; if the sum of minutes is greater than 60 , I add 1 hour and I subtract 60 minutes 
jl nothing
inc ah              ; I add 1 hour by incrementing ah  
sub al,60           ; and I sustract 60 minutes
nothing:

ret                 ; directive to correctly return to the caller procedure 

;****************************** n , flag , ecx=vet 
_find:

push rsi                  ; I save rsi into stack 
mov esi,edi               ; I mov edi into esi ( offset of the array of hours )
mov rcx,0                 ; I put 0 into rcx I use  it like my index

ciclo1: cmp cx,dim        ; if (cx==dim ) then I checked into all the table and I didn't find availbale time 
        je next_day       ; then I jump to label next_day ;I could take the bus only the next day  
        cmp [edi],bx      ; I compare bx ( departure time ) with  time i in my hour vector   
        jge stopp         ; If one time in my  hour vector is >=  departure time  => I have found the available time 
        add edi,2         ; Else I move on the next time  edi = edi+2 because hour is represented on 2 byte
        inc cx            ; I increment my index cx=cx+1 
        jmp ciclo1  
        
next_day: mov edi,esi     ; I take the available time in edi
          mov ecx,flag    
          mov byte[ecx],1 ; I set my flag with value 1 
stopp:  mov ax,[edi]      ; I move into ax the time of first available bus
      
pop rsi
ret                        ; directive to correctly return to the caller procedure 
                            ; at the end i have available hour in ax 

;***************************** put offset of line in ecx 
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

; character that I want to print is stored in ecx
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

;*********************
_print_time:        ; i have my time in ax
                    ;exemple  ah=11 and al=30 ( ax=1130) -> i want to have 11H30 on the display 

mov rcx,strr       ; my string (strr) has lenght 8 bytes. I move the offset into rcx
add rcx ,7         ; I move rcx in the 7th position 

mov dl,'.'         ; I put a dot into dl (it  is my end of line )
mov [rcx],dl       ; I then  move dl into strr[7]
dec rcx             

push rax          ; I save rax into stack because i will use it here for arimetic operation
mov ah,0          ; I put 0 into ah so ( I just have now minute into ax )    ** here ax becomes ax=0030

mov rbx,10        ; I put 10 into rbx
mov rdx,0         ; I put 0 into rdx
div rbx           ; rax= rax/rbx ( interger part of division)  and rdx=rax % rbx ( rest of division )
                  ; rax ( 3 )= rax ( 30 ) / rbx (10 ) and rdx (0)= rax(30)% rbx(10)
add rax,48        ; I convert it to the corresponding ascii value
add rdx,48        ; I convert  it to the corresponding ascii value

mov [rcx],dl      ; I put the rest in the last position in strr[6]              strr[6]=0
dec rcx           ; I decrement my position             
mov [rcx],al      ; I put the integer part of  division in strr[5]              strr[5]=3
dec rcx           ; I decrement to the next position 

pop rax           ; I take my time from the stack                          ** here ax become ax=1130
push rax          ; I save it again

mov dl,'H'        ; I put the character H for presention   ..H..
mov [rcx],dl      ; I put H into                        ----strr[4]=H
dec rcx           ; I decrement to the next position        
mov al,ah         ; I put the hours (ah ) into al               ** here ax become ax=1111
mov ah,0          ; I put 0 in  ah                              ** here ax become ax=0011
                  ; I repeat the previows operations that I did on the minute 
mov rdx,0      
div rbx           ; rax ( 1 )= rax ( 11 ) / rbx (10 ) and rdx (1)= rax(11)% rbx(10)  
add rax,48
add rdx,48

mov [rcx],dl               ;---strr[3]=1
dec rcx
mov [rcx],al               ;---strr[2]=1 
dec rcx            

call _printline        ; I print the string strr which constains   11H30.

mov al,1
cmp al,[flag1]         ; Compare flag1 with 1 .  if falg1==1 I have arrived at the office  so  I could print '*'
jne nothing3           ; Else I can not print ; 
cmp al,[flag]          ; Compare flag with 1 if falg==1 then I print the '*'
jne nothing3           ; Else I do nothing
mov byte[ecx],'*'      ; I put the '*' into strr[1] 
call _printchar        ; I print it
nothing3:

call _newLine          ; Just for clean output

pop rax

ret                    ; directive to correctly return to the caller procedure




