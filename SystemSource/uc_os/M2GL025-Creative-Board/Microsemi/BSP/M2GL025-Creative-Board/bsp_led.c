/*
*********************************************************************************************************
*                                            EXAMPLE CODE
*
*               This file is provided as an example on how to use Micrium products.
*
*               Please feel free to use any application code labeled as 'EXAMPLE CODE' in
*               your application products.  Example code may be used as is, in whole or in
*               part, or may be used as a reference only. This file can be modified as
*               required to meet the end-product requirements.
*
*               Please help us continue to provide the Embedded community with the finest
*               software available.  Your honesty is greatly appreciated.
*
*               You can find our product's user manual, API reference, release notes and
*               more information at https://doc.micrium.com.
*               You can contact us at www.micrium.com.
*********************************************************************************************************
*/

/*
*********************************************************************************************************
*
*                                    MICRIUM BOARD SUPPORT PACKAGE
*                                       M2GL025 Creative Board
*
* Filename : bsp_led.c
*********************************************************************************************************
*/

/*
*********************************************************************************************************
*                                            INCLUDE FILES
*********************************************************************************************************
*/

#include  <cpu_core.h>
#include  <hw_platform.h>
#include  <core_gpio.h>

#include  "bsp_led.h"


/*
*********************************************************************************************************
*                                              DEFINES
*********************************************************************************************************
*/

gpio_instance_t  p_gpio_out;


/*
*********************************************************************************************************
*                                      LOCAL FUNCTION PROTOTYPES
*********************************************************************************************************
*/


/*
*********************************************************************************************************
*********************************************************************************************************
**                                         GLOBAL FUNCTIONS
*********************************************************************************************************
*********************************************************************************************************
*/

/*
*********************************************************************************************************
*                                           BSP_LED_Init()
*
* Description : Initializes the required pins that control the LEDs.
*
* Argument(s) : none.
*
* Return(s)   : none.
*
* Note(s)     : none.
*********************************************************************************************************
*/

void  BSP_LED_Init (void)
{
    GPIO_init(&p_gpio_out, COREGPIO_OUT_BASE_ADDR, GPIO_APB_32_BITS_BUS);
    GPIO_config(&p_gpio_out, LED1_RED,   GPIO_OUTPUT_MODE);
    GPIO_config(&p_gpio_out, LED1_GREEN, GPIO_OUTPUT_MODE);
    GPIO_config(&p_gpio_out, LED2_RED,   GPIO_OUTPUT_MODE);
    GPIO_config(&p_gpio_out, LED2_GREEN, GPIO_OUTPUT_MODE);

    BSP_LED_Off(LED_ALL);
}


/*
*********************************************************************************************************
*                                            BSP_LED_On()
*
* Description : Turn ON a specific LED.
*
* Argument(s) : led    The ID of the LED to control.
*
* Return(s)   : none.
*
* Note(s)     : none.
*********************************************************************************************************
*/

void  BSP_LED_On (BSP_LED  led)
{
    CPU_INT32U  port_state;


    port_state = GPIO_get_outputs(&p_gpio_out);
    if (led != LED_ALL) {
        port_state |= (1u << led);
    } else {
        port_state |= 0xFu;                               /* Turn On all LEDs                          */
    }
    GPIO_set_outputs(&p_gpio_out, port_state);
}


/*
*********************************************************************************************************
*                                            BSP_LED_Off()
*
* Description : Turn OFF a specific LED.
*
* Argument(s) : led    The ID of the LED to control.
*
* Return(s)   : none.
*
* Note(s)     : none.
*********************************************************************************************************
*/

void  BSP_LED_Off (BSP_LED  led)
{
    CPU_INT32U  port_state;


    port_state = GPIO_get_outputs(&p_gpio_out);
    if (led != LED_ALL) {
        port_state &= ~(1u << led);
    } else {
        port_state &= ~0xFu;                               /* Turn On all LEDs                          */
    }
    GPIO_set_outputs(&p_gpio_out, port_state);
}


/*
*********************************************************************************************************
*                                          BSP_LED_Toggle()
*
* Description : Toggles a specific LED.
*
* Argument(s) : led    The ID of the LED to control.
*
* Return(s)   : none.
*
* Note(s)     : none.
*********************************************************************************************************
*/

void  BSP_LED_Toggle (BSP_LED  led)
{
    CPU_INT32U  port_state;


    port_state = GPIO_get_outputs(&p_gpio_out);
    if (led != LED_ALL) {
        port_state ^= (1u << led);                        /* Toggle appropriate bit                    */
    } else {
        port_state ^= 0xFu;                               /* Toggle all LED appropriate bits           */
    }
    GPIO_set_outputs(&p_gpio_out, port_state);
}
