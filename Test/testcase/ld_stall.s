   .org 0x0
   .global _start
_start:
   ori x1,x0,0x234    # x1 = 0x00000234
   sw  x1,0x0(x0)      # [0x0] = 0x00000234

   ori x2,x0,0x0234    # x2 = 0x00000234
   ori x1,x0,0x0       # x1 = 0x0
   lw  x1,0x0(x0)      # x1 = 0x00000234
   beq x1,x2,Label     

   ori x1,x0,0x567    

Label:
   ori x1,x0,0x7ab    # x1 = 0x00007ab    
    
_loop:
   j _loop
   nop
