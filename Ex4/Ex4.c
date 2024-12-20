/*
 * Ex4.c
 *
 * Created: 12/20/2024 4:12:20 PM
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
char buffer_1[16];
char buffer_2[16];
bool state_1 = true;
int speed = 0;
init_glcd();
init_alcd();
DDRB = 0x10;
PORTB = 0x0C;
DDRD = 0x80;
PORTD = 0x80;

// Graphic lcd
glcd_clear();
glcd_outtextxy(10, 10, "DANG GIAT");
// LCD
lcd_clear();
lcd_gotoxy(0, 0);
lcd_puts("DANG GIAT");
while (1)
    {
         if(PINB.2 == 0){
            state_1 = !state_1;
        }   
        
        if(state_1 == true){ 
            adjustSpeed(0);
        }else{
            while(1){ 
                speed = speedUpdater(20); 
                // LCD
                lcd_clear();
                lcd_gotoxy(0, 0);
                sprintf(buffer_1, "TOC DO: %02u", speed);
                lcd_puts(buffer_1);
                // Graphic LCD
                sprintf(buffer_2, "SPEED: %d", speed); 
                glcd_outtextxy(10, 20, buffer_2);
                delay_ms(1000);
                
            }      
        }   

    }
}
