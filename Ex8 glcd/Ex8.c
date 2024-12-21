/*
 * Ex8.c
 *
 * Created: 12/21/2024 10:11:47 PM
 * Author: ADMIN
 */

#include <io.h>
#include <glcd.h>
#include <delay.h>
#include <stdio.h>
// I2C Bus functions
#include <i2c.h>
#include <font5x7.h>
#include <stdlib.h>
#include <stdio.h>

// DS1307 Real Time Clock functions
#include <ds1307.h>

unsigned char hour, minute, second;
unsigned char feed_hour = 12, feed_minute = 14; // Thoi gian cho ca an

int d;
unsigned int dem;

void init_glcd() {
    GLCDINIT_t glcd_init_data;
    glcd_init_data.font = font5x7;
    glcd_init_data.temp_coef = 140;
    glcd_init_data.bias = 4;
    glcd_init_data.vlcd = 66;
    glcd_init(&glcd_init_data);
}

interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
    // Reinitialize Timer 0 value
    TCNT0 = 0x06;
    ++dem;
    if (dem == 1000) d = 1;
    if (dem == 2000) {
        dem = 0;
        d = 0; // d = 1/ 0 trong khoang 1s
    }
}

// Hien thi thoi gian hien tai tren GLCD
void display_time_glcd() {
    static unsigned char last_hour = 0xFF, last_minute = 0xFF, last_second = 0xFF;
    if (hour != last_hour || minute != last_minute || second != last_second) {
        char buffer[20];
        sprintf(buffer, "%02d:%02d:%02d", hour, minute, second);
        glcd_outtextxy(10, 10, buffer);
        last_hour = hour;
        last_minute = minute;
        last_second = second;
    }
}

// Hien thi dem nguoc tren GLCD
void countdown_display_glcd(int countdown) {
    char buffer[20];
    sprintf(buffer, "Countdown: %02ds", countdown);
    glcd_outtextxy(0, 25, buffer);
}

void main(void)
{
    ASSR = 0 << AS0;
    TCCR0 = (0 << WGM00) | (0 << COM01) | (0 << COM00) | (0 << WGM01) | (0 << CS02) | (1 << CS01) | (1 << CS00);
    TCNT0 = 0x06;
    OCR0 = 0x00;

    // Timer(s)/Counter(s) Interrupt(s) initialization
    TIMSK = (0 << OCIE2) | (0 << TOIE2) | (0 << TICIE1) | (0 << OCIE1A) | (0 << OCIE1B) | (0 << TOIE1) | (0 << OCIE0) | (1 << TOIE0);
    ETIMSK = (0 << TICIE3) | (0 << OCIE3A) | (0 << OCIE3B) | (0 << TOIE3) | (0 << OCIE3C) | (0 << OCIE1C);

    i2c_init();
    init_glcd();
    rtc_init(3, 1, 0);
    rtc_set_time(12, 13, 50);
    #asm("sei")

    while (1)
    {
        // Lay thoi gian hien tai
        rtc_get_time(&hour, &minute, &second);

        // Hien thi thoi gian hien tai
        display_time_glcd();

        // Kiem tra dem nguoc neu con 2 giay la den gio cho ca an
        if (hour == feed_hour && minute == feed_minute - 1 && second >= 55) {
            int countdown = 60 - second;
            countdown_display_glcd(countdown);

            // Hien thi thong bao "Feed Time!" trong 5 giay va cap nhat thoi gian 
            //lien tuc
            if (second == 59) {
                unsigned char feed_timer = 0;
                delay_ms(1000);
                glcd_outtextxy(0, 25, "                      "); // Xoa dem nguoc


                while (feed_timer < 5) {
                    rtc_get_time(&hour, &minute, &second);
                    display_time_glcd();
                    glcd_outtextxy(5, 24, "Feed Time!");
                    delay_ms(1000); // Cap nhat moi 1 giay
                    feed_timer++;
                }
                glcd_outtextxy(5, 24, "                    ");
            }
        }

        delay_ms(100); // Cho 100ms
    }
}