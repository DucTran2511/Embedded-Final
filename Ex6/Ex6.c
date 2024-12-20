/*
 * Ex6.c
 *
 * Created: 12/20/2024 4:21:47 PM
 * Author: ADMIN
 */

#include <stdio.h>
#include <delay.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdint.h>
#include <glcd.h>
#include <font5x7.h>

int dem = 0;
char what[8];
char buffer_1[16];
char buffer_2[16];
int keypad[3][3] = {0, 1, 2, 3, 4, 5, 6, 7, 8};
bool order[9] = {false, false, false, false, false, false, false, false, false};
bool len = true;
int currentLevel = 1;

int read() {
    char a, i, j;    
    for(j = 0; j < 3; j++ ){
        if (j == 0) PORTF = 0b11111101;
        if (j == 1) PORTF = 0b11110111;
        if (j == 2) PORTF = 0b11011111;
        for(i = 0; i < 3; i++){
            if (i == 0){
                a = PINF&0x04;
                if(a != 0x04) {
                    return keypad[i][j];
                }
            }
            if (i == 1){
                a = PINF&0x10;
                if (a != 0x10) {
                    return keypad[i][j];
                }
            }
            if (i == 2){
                a = PINF&0x01;
                if (a != 0x01) {
                    return keypad[i][j]; 
                }
            }
        }
    }
    return -1;
}

interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
    int input;
    // Reinitialize Timer1 value
    TCNT1H=0xFCE0 >> 8;
    TCNT1L=0xFCE0 & 0xff;
    
    // servo
    dem++;
    if(dem >= 200) 
        dem = 0;
    
    // ~ delay 199 ms ban phim ma tran   
    if (dem == 199) {
        input = read();
        if (input != -1){
            order[input] = true;
            sprintf(buffer_1, "TAR: %d", input + 1); 
            glcd_outtextxy(10, 20, buffer_2); 
        }
    }
}


void thang_may() {
    int i;
    int flag = 0; 
    flag = currentLevel; 
    sprintf(buffer_1, "STAND: %d", flag + 1); 
    glcd_outtextxy(10, 10, buffer_1);
    // neu ko co tang nao dc bam thi thoi ko lam gi ca
    for (i = 0; i <= 8; i++)
         if (order[i] == true){
            break;             
         }
         if (i == 8)
            return;
            
    // thiet lap trang thai len/xuong
    if (len) {
        for (i = currentLevel; i <= 8; i++) {
            // neu len tang 8 roi ma ko co yeu cau thi chuyen che do cho di xuong
            if (i == 8 && order[i] == false) {
                len = false;
            }
            else if (order[i] == true) {
                break;
            }
        }        
    }
    if (!len) {
        for (i = currentLevel; i >= 0; i--) {
            // tuong tu voi doan di len. neu da o tang 0
            if (i == 0 && order[i] == false) {
                len = true;
                return;
            }
            else if (order[i] == true) {
                break;
            }
        }
    }    
              
    while (order[currentLevel] == false) {      
        if (len)
            currentLevel++;
        else
            currentLevel--;
            
        sprintf(what, "CURRENT: %d", currentLevel + 1);    
        glcd_outtextxy(10, 30, what);
        delay_ms(1000);
    }
    
    order[currentLevel] = false;    
}

void init_glcd(){
    GLCDINIT_t glcd_init_data;
    glcd_init_data.font=font5x7;
    glcd_init_data.temp_coef=140;
    glcd_init_data.bias=4;
    glcd_init_data.vlcd=66;
    glcd_init(&glcd_init_data);
}

void main(void)
{
DDRF = 0b11101010;

TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<COM1C1) | (0<<COM1C0) | (0<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (1<<CS10);
TCNT1H=0xFC;
TCNT1L=0xE0;
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (1<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
ETIMSK=(0<<TICIE3) | (0<<OCIE3A) | (0<<OCIE3B) | (0<<TOIE3) | (0<<OCIE3C) | (0<<OCIE1C);
#asm("sei")
    
init_glcd();
glcd_clear();
glcd_outtextxy(10, 0, "THANG MAY");
while (1)
    {
        thang_may();
    }
}
