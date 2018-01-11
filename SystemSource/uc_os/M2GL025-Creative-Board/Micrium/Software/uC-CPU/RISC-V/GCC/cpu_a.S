#********************************************************************************************************
#                                                uC/CPU
#                                    CPU CONFIGURATION & PORT LAYER
#
#                          (c) Copyright 2004-2017; Micrium, Inc.; Weston, FL
#
#               All rights reserved.  Protected by international copyright laws.
#
#               uC/CPU is provided in source form to registered licensees ONLY.  It is
#               illegal to distribute this source code to any third party unless you receive
#               written permission by an authorized Micrium representative.  Knowledge of
#               the source code may NOT be used to develop a similar product.
#
#               Please help us continue to provide the Embedded community with the finest
#               software available.  Your honesty is greatly appreciated.
#
#               You can find our product's user manual, API reference, release notes and
#               more information at https://doc.micrium.com.
#               You can contact us at www.micrium.com.
#********************************************************************************************************

#********************************************************************************************************
#
#                                            CPU PORT FILE
#
#                                               RISC-V
#                                           GNU C Compiler
#
# Filename : cpu_a.S
# Version  : V1.31.01
#********************************************************************************************************


#********************************************************************************************************
#                                           PUBLIC FUNCTIONS
#********************************************************************************************************

    .global  CPU_SR_Save
    .global  CPU_SR_Restore

    .global  CPU_IntDis
    .global  CPU_IntEn


#********************************************************************************************************
#                                                EQUATES
#********************************************************************************************************

    .equ  CPU_MSTATUS_MIE,         0x08


#********************************************************************************************************
#                                      CODE GENERATION DIRECTIVES
#********************************************************************************************************

    .section .text


#********************************************************************************************************
#                                      DISABLE/ENABLE INTERRUPTS
#
# Description : Disable/Enable interrupts.
#
#               (1) (a) For CPU_CRITICAL_METHOD_INT_DIS_EN, interrupts are enabled/disabled WITHOUT saving
#                       or restoring the state of the interrupt status.
#
#
# Prototypes  : void  CPU_IntDis(void);
#               void  CPU_IntEn (void);
#********************************************************************************************************

CPU_IntDis:
# Disable global interupt
    li     t0, CPU_MSTATUS_MIE
    csrrc  zero, mstatus, t0
    ret


CPU_IntEn:
# Enable global interupt
    li     t0, CPU_MSTATUS_MIE
    csrrs  zero, mstatus, t0
    ret



#********************************************************************************************************
#                                      CRITICAL SECTION FUNCTIONS
#
# Description : Disable/Enable interrupts by preserving the state of interrupts.  Generally speaking, the
#               state of the interrupt disable flag is stored in the local variable 'cpu_sr' & interrupts
#               are then disabled ('cpu_sr' is allocated in all functions that need to disable interrupts).
#               The previous interrupt state is restored by copying 'cpu_sr' into the CPU's status register.
#
# Prototypes  : CPU_SR  CPU_SR_Save   (void);
#               void    CPU_SR_Restore(CPU_SR  cpu_sr);
#
# Note(s)     : (1) These functions are used in general like this :
#
#                       void  Task (void  *p_arg)
#                       {
#                           CPU_SR_ALLOC();                     /* Allocate storage for CPU status register */
#                               :
#                               :
#                           CPU_CRITICAL_ENTER();               /* cpu_sr = CPU_SR_Save()#                  */
#                               :
#                               :
#                           CPU_CRITICAL_EXIT();                /* CPU_SR_Restore(cpu_sr)#                  */
#                               :
#                       }
#********************************************************************************************************

CPU_SR_Save:
# Save the Machine status register
    csrr   a0, mstatus
# Disable global interupt
    li     t0, CPU_MSTATUS_MIE
    csrrc  zero, mstatus, t0
    ret


CPU_SR_Restore:
# restore the Machine status register previous state
    csrw   mstatus, a0
    ret


#********************************************************************************************************
#                                     CPU ASSEMBLY PORT FILE END
#********************************************************************************************************
