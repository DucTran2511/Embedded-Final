/*
 * Ex8.c
 *
 * Created: 12/21/2024 10:00:57 PM
 * Author: ADMIN
 */

#include <io.h>
#include <alcd.h>
#include <delay.h>
#include <stdio.h>
// I2C Bus functions
#include <i2c.h>

// DS1307 Real Time Clock functions
#include <ds1307.h>

unsigned char hour, minute, second;
unsigned char feed_hour = 12, feed_minute = 14; // Thoi gian cho ca an

int d;
unsigned int dem;

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

// Hien thi thoi gian hien tai tren LCD
void display_time_lcd() {
    lcd_gotoxy(0, 0);
    lcd_putchar((hour / 10) + '0');
    lcd_putchar((hour % 10) + '0');
    lcd_putchar(':');
    lcd_putchar((minute / 10) + '0');
    lcd_putchar((minute % 10) + '0');
    lcd_putchar(':');
    lcd_putchar((second / 10) + '0');
    lcd_putchar((second % 10) + '0');
}

// Hien thi dem nguoc tren LCD
void countdown_display_lcd(int countdown) {
    lcd_gotoxy(0, 1);
    lcd_putsf("Countdown:");
    lcd_putchar((countdown / 10) + '0');
    lcd_putchar((countdown % 10) + '0');
    lcd_putsf(" s");
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
    lcd_init(16);
    rtc_init(3, 1, 0);
    rtc_set_time(12, 13, 50);
    #asm("sei")

    while (1)
    {
        // Lay thoi gian hien tai
        rtc_get_time(&hour, &minute, &second);

        // Hien thi thoi gian hien tai
        display_time_lcd();

        // Kiem tra dem nguoc neu con 2 giay la den gio cho ca an
        if (hour == feed_hour && minute == feed_minute - 1 && second >= 58) {
            int countdown = 60 - second;
            countdown_display_lcd(countdown);
            delay_ms(1000); // Cho 1 giay

            // Hien thi thong bao "Feed Time!" trong 5 giay va cap nhat thoi gian lien tuc
            if (second == 59) {
                unsigned char feed_timer = 0;
                while (feed_timer < 5) {
                    rtc_get_time(&hour, &minute, &second);
                    lcd_clear();
                    display_time_lcd();
                    lcd_gotoxy(0, 1);
                    lcd_putsf("Feed Time!");
                    delay_ms(1000); // Cap nhat moi 1 giay
                    feed_timer++;
                }
                lcd_clear();
            }
        } else {
            // Xoa dem nguoc khi chua den gio cho ca an
            lcd_gotoxy(0, 1);
            lcd_putsf("                 ");
        }

        delay_ms(100); // Cho 100ms
    }
}