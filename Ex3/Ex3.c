/*
 * Ex3.c
 *
 * Created: 12/20/2024 2:41:01 PM
 * Author: ADMIN
 */

#include <stdio.h>
#include <delay.h>
#include <stdbool.h>
#include <stdio.h>
#include <alcd.h>
#include <stdint.h>
#include <glcd.h>
#include <font5x7.h>

void init_glcd(){
    GLCDINIT_t glcd_init_data;
    glcd_init_data.font=font5x7;
    glcd_init_data.temp_coef=140;
    glcd_init_data.bias=4;
    glcd_init_data.vlcd=66;
    glcd_init(&glcd_init_data);
}

void init_alcd(){
    lcd_init(20);
    lcd_clear();
}

void glcd_list(){
    glcd_clear();
    glcd_outtextxy(10, 10, "MAY GIAT");
    glcd_outtextxy(10, 20, "BT1: GIAT");
    glcd_outtextxy(10, 30, "BT2: VAT");
}

void alcd_list(){
    lcd_clear();
    char buffer_1[16];
    char buffer_2[16];
    lcd_gotoxy(0, 0);
    sprintf(buffer_1, "1. GIAT");
    lcd_puts(buffer_1);
    lcd_gotoxy(0, 1);
    sprintf(buffer_2, "2. VAT");    
    lcd_puts(buffer_2);
}

void giat(){
    char buffer[16];
    lcd_clear();
    lcd_gotoxy(0, 0);
    sprintf(buffer, "Cap nuoc");
    lcd_puts(buffer);
    glcd_clear();
    glcd_outtextxy(10, 10, "Cap nuoc");
    delay_ms(2000);
}

void vat(){
    delay_ms(2000);
}
void main(void)
{
bool state_1 = true;
bool state_2 = true;
init_glcd();
init_alcd();
DDRB = 0x00;
PORTB = 0x0C;

while (1)
    {
        glcd_list();
        alcd_list();
        if(PINB.2 == 0){
            state_1 = !state_1;
        }                      
        
        if(PINB.3 == 0){
            state_2 = !state_2;
        }  
        
        if(state_1 == false){ 
            giat();
            state_1 = !state_1;
            
        }          
        
        if(state_2 == false){
            vat();             
            state_2 = !state_2;
        }

    }
}
