data segment
    ; form numbers     
    dataform db '1'   
    
    firstnumber db 0h
    secondnumber db 0h
    ;titles
    
    ; main menu
    
    firsStatemnt db     "                               ---- Main Menu ----",13,10,"* To Select the data format for input and output Press 1"
    secondStatemnt db   13,10,"* To Perform an ALU function Press 2"
    theeredStatemnt db  13,10,"* To Exit the simulator Press 3"
    enterYourOptionMsg db 13,10,"Enter Your Option: $"
        
        ; changing format
    firstFormChange db  "                          ---- Changin Format ----",13,10,"* To select Binary Data Press 1"
    secondFormChange db 13,10,"* To select Hexadecimal Data Press 2 ",13,10,"Enter Your Option: $"
    
        ;   numbers allowed
    HexaChoiceMsg db       13,10,"You selected the Hexadecimal numbers you have 0-9 and A-F numbers to select$"
    BinaryChoiceMsg db   13,10,"You selected Bainary you have 0-1 number to select from$"
    
    insertmsg db 13,10,"insert the first number:$"
    insertsecondmsg db 13,10, "insert the second number:$"
    
    enterFirstNumberMsg db  "Enter First  Number: $"
    enterSecondNumberMsg db "Enter Second Number: $"
        ; ALU op 
    ; when using  10 and 13 that means move curour to next line first place    
    firstALU db   "                          ---- ALU Operations ----",13,10,"1.F=AB",13,10,"2.F=A+B",  13,10,"3.F=A'+ B'",  13,10,"4.F=A Minus 1", 13,10, "5.F=A Plus AB'", 13,10, "6.F=(AB) Plus AB'", 13,10, "7.F=A Minus B", 13,10, "8.F=A Plus B", 13,10, "9.F=A Plus A",13,10, "Enter Your Option: $"
    
        ;error
    errormsg db     "you inserted an invalid number$"       
    formaterror db  "you didn't enter an number format please select one of the formats below:$"


    ; result
        result db 0h
    resultMsg db 13,10,"Your Result F= $" 
    
    returnToMainMenueMsg db 13,10,"Enter any key to go back to main menu$" 
    enterYourChoiceMsg db 13,10,"Enter your choice: $"
    ; Carry MSG
    CarryMassage db "  ( There's a Carry! )$" 
    CarryResult db 0
data ends


stack segment
    dw   128  dup(0)
stack ends









   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   





























code segment
start:  

    mov al,'1'       ; default binary !
    mov dataform,al  
    
    ; preparing the program
    mov ax, data
    mov ds, ax
    mov ax, 0B800h
    mov es, ax 
    mov di, 0
     

        
    Mainminu:
           ; clear the vram 
          call ClearScreen
          
           ; print the options
          lea dx,firsStatemnt
          mov ah,9
          int 21h   
         
          
          
          
          ; wait to the user to insert a number
          mov ah,1
          int 21h          
                                                   
          cmp al,'1'
          JE ChangingDataFormat
                    
          cmp al,'2'
          JE oporations
          
          cmp al,'3'
          JE Exitprog
          
          call PrintNewLine
              
           ; print a error msg if the user try to insert numbers not in the mian minu
          lea dx,errormsg 
          mov ah,9
          int 21h
         
          call PrintNewLine 
          
          JMP Mainminu
                   
          
    ChangingDataFormat: ;1
          
         
           ; clear the vram 
          call ClearScreen
        
           ; print the first option
          lea dx,firstFormChange 
          mov ah,9
          int 21h
          
          
          ; wait to the user to insert a number part 1
          ; check if the user insert a corect number
          ; if the user insert any number insted of 1 he will jump to the second check 
          ; if the user insert the number 1 it will be stored                 
          
          ReadingPart_ChangingDataFormat: ; to enhance UX instead of printing again 
              mov ah,1
              int 21h
              cmp al,'1'          
              JNE CheckChangingInputFormat
    
              mov dataform, al
              JMP PrintBinaryChoiceMsg
              
            
    CheckChangingInputFormat:   
           ; check if the user insert a corect number  part 2
           ; if the user insert any number insted of 1 and 2 he will jump to the error handling
           ; if the user insert the number 2 it will be stored
          cmp al,'2'
          JNE InvalidDataFormatInput
          
          mov dataform, al          
          
          JMP PrintHexaChoiceMsg
          
    InvalidDataFormatInput:
        call removeinvalid
        JMP ReadingPart_ChangingDataFormat              

      
    oporations:   
           ; clear the vram 
          call ClearScreen
           
           ;print the oporations
          lea Dx, firstALU 
          mov ah,9
          int 21h
          Operations_Reading_Part: ;to enhance UX instead of repeating print msg
              mov ah,1
              int 21h
              
              mov bl, al
                
              CMP al, '0'
              JE Reread_Operations
              
              CMP al, '9'
              JG Reread_Operations
              
              cmp dataform,'1'
              JNE hexa
              binary:  
                call ReadBinaryInputs  
                JMP print_opp
              hexa:  
                CALL ReadHexInputs
              
             print_opp: 
                
               
                mov al, bl  ; to keep al value same          
                            
                
                mov ah, 0
                CMP al, '1'
                JE AandB_ALU
                
                CMP al, '2'
                JE AorB_ALU
                
                CMP al, '3'
                JE NotA_OR_NotB_ALU
                
                CMP al, '4'
                JE Aminus1_ALU
                
                CMP al, '5'
                JE AplusA_AND_NotB_ALU
                
                CMP al, '6'
                JE (AB)plusANotB
                
                CMP al, '7'
                JE AminusB
                
                CMP al, '8'
                JE AplusB
                
                CMP al, '9'
                JE AplusA
                
    Reread_Operations:
        call removeinvalid
        JMP  Operations_Reading_Part                       
        
           
    PrintResult:
        ;print msg
        lea dx, resultMsg
        mov ah,9
        int 21h
    
    
        JNO PrintNumberResult
   
    PrintNumberResult:
        CMP dataform, '1'
        JNE PrintResultInHexa 
        mov cx,4
        JMP PrintResultInBainary
        
        mov ah, 8
        int 21h
        
        call ClearScreen
        
        JMP Mainminu        
    
    
                   
    Exitprog: ;3
          call ClearScreen
          
          mov ax, 4C00h
          int 21h  
          

    
    
    
   
    ReadHexInputs:
        mov firstNumber, 0
        mov secondNumber, 0
        mov result, 0

        call ReadFirstHexa
        call ReadSecondHexa

        ret
    
    
    ReadBinaryInputs:
        mov firstNumber, 0
        mov secondNumber, 0
        mov result, 0
        
        mov cx,4
        call ReadingBainary
        
        mov cx,4
        call readinSecondBainary
        
        ret
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
     ReadFirstHexa:
        call PrintNewLine
        ; print reading message
        lea DX, enterFirstNumberMsg
        mov ah, 9
        int 21h
        
        ReadingPartForFirstHexaInput: ;just for enhace UX instead of repeating 
            ;read from user
            mov ah,1
            int 21h
            
            ;make input in hexa
            mov ah, 0
            SUB ax, 30h
            
            CMP ax, 10h
            JB StoreHexaFirstInput_LessThan10
            
            ; ascii value of letters starting from 41h and I already sub 30h 
            ; so i need to sub '1'
            SUB ax, 1 
            CMP ax, 16h
            JB StoreHexaFirstInput_LessThan16
            
            JMP RereadFirstInput
             
            ret
        
     
     StoreHexaFirstInput_LessThan10:
        ADD firstnumber, al 
        ret
     StoreHexaFirstInput_LessThan16:
        ; preparing
        mov dl, 0
        mov dl, al
        ; if user enter 'F' then the number in al will be 15 
        ; the algorithem that i create is as the following
        ; 1- take first part (from right) which is 5 by using Mask
        ; 2- Add it to the label in data segment 
        ; 3- take the second part which is '1' by using Shift right operation
        ; 4- mask it
        ; 5- Add 10 
        ; 6- add it to the label in data segment
        
        ;1
        AND dl, 0Fh ; mask 1
        ;2
        ADD firstnumber,dl
        ;3
        mov dl, al ; restore original val
        SHR dl, 4
        ;4
        AND dl, 0Fh ;mask 2
        ;5
        ADD dl, 9
        ;6
        ADD firstnumber, dl
        
        ret    
     RereadFirstInput:
        call removeinvalid
        JMP ReadingPartForFirstHexaInput    
        
    
    
    
     ReadSecondHexa:
        call PrintNewLine
        ; print reading message
        lea DX, enterSecondNumberMsg
        mov ah, 9
        int 21h
        
        ReadingPartForSecondHexaInput: ;just for enhace UX instead of repeating 
            ;read from user
            mov ah,1
            int 21h
            
            ;make input in hexa
            mov ah, 0
            SUB ax, 30h
            
            CMP ax, 10h
            JB StoreHexaSecondInput_LessThan10
            
            ; ascii value of letters starting from 41h and I already sub 30h 
            ; so i need to sub '1'
            SUB ax, 1 
            CMP ax, 16h
            JB StoreHexaSecondInput_LessThan16
            
            JMP RereadSecondInput
             
            ret
        
     
     StoreHexaSecondInput_LessThan10:
        ADD Secondnumber, al 
        ret
     StoreHexaSecondInput_LessThan16:
        ; preparing
        mov dl, 0
        mov dl, al
        ; if user enter 'F' then the number in al will be 15 
        ; the algorithem that i create is as the following
        ; 1- take first part (from right) which is 5 by using Mask
        ; 2- Add it to the label in data segment 
        ; 3- take the second part which is '1' by using Shift right operation
        ; 4- mask it
        ; 5- Add 10 
        ; 6- add it to the label in data segment
        
        ;1
        AND dl, 0Fh ; mask 1
        ;2
        ADD Secondnumber,dl
        ;3
        mov dl, al ; restore original val
        SHR dl, 4
        ;4
        AND dl, 0Fh ;mask 2
        ;5
        ADD dl, 9
        ;6
        ADD Secondnumber, dl
        
        ret    
     RereadSecondInput:
        call removeinvalid
        JMP ReadingPartForSecondHexaInput    
        
    
    
    
    
    
    
    
    
    
    
    
    
    
    removeinvalid:
           ; if the user try to insert an invalid number it will be removed
           mov ah,2
           mov dl,8h ;backspace
           int 21h
           mov dl,0020h ;space
           int 21h
           mov dl,8h  ;backspace
           int 21h
           ret
           
    PrintNewLine:
           ; new line 
          mov ah,2
             ;DL 13 means Carriage Return which return cursour to the beginning of the line   
          mov dl, 13     
          int 21h 
                                                               
          mov ah,2                                                     
          mov dl,10      ;move the coursor to the next line            
          int 21h
           ; when using dl 10 and dl 13 that means move curour to next line first place
          ret
        
       
    HandelChangingInputFormatError: 
         
          call PrintNewLine
          
           ; print a error msg if the user didn'n select a number format
          lea dx,errormsg 
          mov ah,9
          int 21h
          
           ; new line 
          call PrintNewLine
          
           ; send the user to select a number format
          JMP ChangingDataFormat
           
     readingbainary:
        call PrintNewLine
        lea DX, enterFirstNumberMsg
        mov ah, 9
        int 21h
           
    ReadAndStore_FirstBinaryInput:
           
           mov ah,1
           int 21h 
           mov ah, 0       
           
           sub ax, 30h
           
           cmp ax, 0
           JE StoreInfirstNumber
           
           cmp ax, 1
           JE StoreInfirstNumber
           
           call removeinvalid
           jmp ReadAndStore_FirstBinaryInput
          
    storeInfirstNumber:
           sub di, 2   
          
         ; user input stored at AX
         ; 1- we have to do left shift for FirstNumber
         ; 2- then do OR between FirstNumber and AX
          
           SHL firstnumber, 1
           OR firstnumber, al
           loop ReadAndStore_FirstBinaryInput
                      
           ret
           
     readinsecondbainary:
        call PrintNewLine
        ; print reading message
        lea DX, EnterSecondNumberMsg
        mov ah, 9
        int 21h
        
           
    ReadAndStore_SecondBinaryInput:
           
           mov ah,1
           int 21h 
           mov ah, 0       
           
           sub ax, 30h
           
           cmp ax, 0
           JE StoreInSecondNumber
           
           cmp ax, 1
           JE StoreInSecondNumber
          
           call removeinvalid
           jmp ReadAndStore_SecondBinaryInput
     
          storeInSecondNumber:
           ADD di, 2   
          
         ; user input stored at AX
         ; 1- we have to do left shift for FirstNumber
         ; 2- then do OR between FirstNumber and AX
          
           SHL SecondNumber, 1
           OR SecondNumber, al
           loop ReadAndStore_SecondBinaryInput
           
           call printnewline
           
           ret
          

     
     
     
     
     
     
     
     
     
     
     
     ; ---------- ALU CODE ----------;
     
     
     
     
     ;1. F=AB
     AandB_ALU:
        mov al, firstnumber
        and al, secondnumber
        and al, 0Fh ; ensure only 4-bits
        mov result, al
        JMP PrintResult
     ;2. F=A+B
     AorB_ALU:
        mov al, firstnumber
        OR  al, secondnumber
        and al, 0Fh ; ensure only 4-bits
        mov result, al
        JMP PrintResult 
     ;3. 3. F=A`+B`
     NotA_OR_NotB_ALU:
        mov al, firstnumber
        NOT al
        mov bl, secondnumber
        NOT bl
        OR  al, bl
        and al, 0Fh ; ensure only 4-bits
        mov result, al
        JMP PrintResult
     ;4. F=A Minus 1
     Aminus1_ALU:
        mov al, firstnumber
        SUB  al, 1
        and al, 0Fh ; ensure only 4-bits
        mov result, al
        JMP PrintResult  
     ;5. F=A plus AB`
     AplusA_AND_NotB_ALU:
        mov al, firstNumber
        mov bl, firstNumber
        mov bh, secondNumber
        NOT bh
        AND bl, bh
        AND bl, 0Fh  ; ensure 4-bits ->  here I got AB`
        
        ADD al, bl
        call CheckCarry
        AND al, 0Fh  ; ensure 4-bits ->  here I got A plus AB`
        mov result, al
        JMP PrintResult
        
      ; 6,F=(AB)plusAB'
    (AB)plusANotB:
          ;1 anded the second on the first 
          ;2 preper the B
          ;3 take the complment of B
          ;4 preper the A
          ;5 anded the tow numbers after the pluse
          ;6 add the tow numbers
          ;7 store the result
          
          ;1
          mov al,firstnumber
          and al,secondnumber  
          ;2
          mov bl,secondnumber 
          not bl 
          ;3
          mov bh,firstnumber  
          ;4
          and bh,bl ; 
          ;5
          add al,bh
          ;6
          call CheckCarry
          and al,0Fh
          ;7
          mov result,al
          
          JMP PrintResult
    ;7.F=AminusB
    AminusB:
          
          mov al,firstnumber
          sub al,secondnumber ; sub the second from the first
          and al,0Fh
          mov result,al
          JMP PrintResult
    ;8.F=AplusB
    AplusB:
          
          mov al,firstnumber
          add al,secondnumber ; add the second on the first 
          call CheckCarry
          and al,0Fh
          mov result,al
          JMP PrintResult
    
    ;9.F=AplusA
    AplusA:
          mov al,firstnumber
          add al,firstnumber ; add the number on it silfe
          call CheckCarry
          and al,0Fh
          mov result,al
          JMP PrintResult
          
          
          
          
          
           
    PrintResultInBainary:   
          mov al,result 
          
          mov cx,4 ;prepar the cx for the loop
          SHL al,4 ; shift the number to the most 4 digit before it look like this (00001101) after (1101000) to print it in the right order
    PrintCommand:
        
          mov dl,0 
          SHL al,1    ; push the first from the lift number to the carry flag         
          mov bl, Al     ; store the value in the bl to not get messed up
          
          ADC dl,0    ; add the carry flag to dl 
          add dl,30h  ; prepar the character   
         
        
          mov ah,2    ; print the character
          int 21h
          
          mov al, bl      ; return the value from the bl for the next loop
          loop PrintCommand
          
          CMP CarryResult, 1b
          JE PrintThereIsAcarry
          
          JMP EnterAnyKeyToReturnToMainMenue
        
    PrintResultInHexa:
        mov al,result
        CMP al, 9
        JNA PrintHexaLessThan10
        ADD al, 7 
    
    PrintHexaLessThan10:
        ADD al, 30h
        
        mov dx, 0
        mov dl, al
        mov ah, 2
        int 21h
        

        CMP CarryResult, 1b
        JE PrintThereIsAcarry
        JMP EnterAnyKeyToReturnToMainMenue
        
        
    EnterAnyKeyToReturnToMainMenue:
        
        lea dx, returnToMainMenueMsg
        mov ah, 9
        int 21h
        
        mov ah, 8
        int 21h
           
        JMP Mainminu
           
     CarryMSG:
        call PrintNewLine
        lea dx,CarryMassage
        mov ah,9
        int 21h
        call PrintNewLine
        mov AH,0
        and AH,AH ; to clear the overflow flag         
        
     ClearScreen:
        
        mov ah,00h 
        mov al,03h  ;Clears the screen and sets the cursor position to the top-left corner
        int 10h   

        ret
        
     CheckCarry:
        mov bl, al
        AND bl, 00010000b ; check fifth bit
        CMP bl, 00010000b ; if equal then fifth bit is one
        JE SetCarry
        mov CarryResult, 0
        ret
     SetCarry:
        mov CarryResult, 1
        ret
      
     PrintThereIsAcarry:
        lea dx,CarryMassage
        mov ah,9
        int 21h
        JMP EnterAnyKeyToReturnToMainMenue
           
     PrintHexaChoiceMsg:
        lea dx, HexaChoiceMsg
        mov ah, 9
        int 21h   
        JMP EnterAnyKeyToReturnToMainMenue
        
     PrintBinaryChoiceMsg:
        lea dx, BinaryChoiceMsg
        mov ah, 9
        int 21h 
        JMP EnterAnyKeyToReturnToMainMenue
code ends

end start