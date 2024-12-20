/*
 * Ex2.c
 *
 * Created: 12/20/2024 1:27:59 PM
 * Author: ADMIN
 */

#include <stdio.h>
#include <delay.h>
#include <stdbool.h>
#include <stdio.h>
#include <alcd.h>
#include <stdint.h>

int curSpeed = 0;

void display_messages(const char *message){
    lcd_clear();
    lcd_gotoxy(0, 0);
    lcd_puts(message);
}

void adjustSpeed(int speed) {
    OCR0 = 255 - speed;
}

int speedUpdater(int option) {
    int newSpeed;
    int flag = 0;
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
            flag += 1;
        }else{
            curSpeed = newSpeed;
        }
    }
    adjustSpeed(curSpeed);
    return flag;
}

        
void dry(){
    int flag = 0;
    while (1) {
        display_messages("DANG SAY");
        flag = speedUpdater(20);
        if (flag == 2)
            break;
        delay_ms(250);
    }
    curSpeed = 0;
    adjustSpeed(0);  
    display_messages("End");
}
void main(void)
{
bool state = true;
DDRB = 0x10;
PORTB = 0x04;
DDRD = 0x80;
PORTD = 0x80;
ASSR=0<<AS0;
TCCR0=(1<<WGM00) | (1<<COM01) | (1<<COM00) | (0<<WGM01) | (1<<CS02) | (0<<CS01) | (0<<CS00);
TCNT0=0x00;
adjustSpeed(0);
lcd_init(16);
while (1)
    {
        if(PINB.2 == 0){
            state = !state;
        }
        
        if(state == true){
            adjustSpeed(0);
            display_messages("Start");
        }else{
            dry();
        } 
        delay_ms(50);
    }
}
