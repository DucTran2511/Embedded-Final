/*
 * Ex5.c
 *
 * Created: 12/20/2024 5:45:36 PM
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

int curSpeed = 0;
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
void adjustSpeed(int speed) {
    OCR0 = 255 - speed;
}

int speedUpdater(int option) {
    int newSpeed;
    if (curSpeed == 0) {
        curSpeed = 63;
    }
    else {
        if (option == 20)
            newSpeed = curSpeed + curSpeed / 5;
        else if (option == 100)
            newSpeed = curSpeed * 2;
            
        if (newSpeed > 255){
            curSpeed = 255; 
        }else{
            curSpeed = newSpeed;
        }
    }
    adjustSpeed(curSpeed);
    return curSpeed;
}
void main(void)
{
int speed = 0;
init_glcd();
init_alcd();
DDRD.7 = 1;
DDRB.4 = 1;
PORTD.7 = 1;
// khoi tao timer 0 cho dong co
ASSR=0<<AS0;
TCCR0=(1<<WGM00) | (1<<COM01) | (1<<COM00) | (0<<WGM01) | (1<<CS02) | (0<<CS01) | (0<<CS00);
TCNT0=0x00;
adjustSpeed(0);
while (1)
    {
        speed = speedUpdater(20);
        if(speed == 255){
            // Graphic LCD
            glcd_clear();
            glcd_outtextxy(0, 20, "VAT TOC DO CAO");
            // LCD
            lcd_clear();
            lcd_gotoxy(0, 0);
            lcd_puts("VAT TOC DO CAO"); 
            
            // Ending the wash cycle
            delay_ms(2000);
            adjustSpeed(0);
            // Graphic LCD
            glcd_clear();
            glcd_outtextxy(0, 10, "HOAN THANH CHU"); 
            glcd_outtextxy(10, 30, "TRINH GIAT");
            // LCD
            lcd_clear();
            lcd_gotoxy(0, 0);
            lcd_puts("HOAN THANH CHU");
            lcd_gotoxy(0, 1); 
            lcd_puts("TRINH GIAT");
            break;
        }       

    }
}
