/*
 * Ex9.c
 *
 * Created: 12/21/2024 10:14:46 PM
 * Author: ADMIN
 */

#include <io.h>
#include <delay.h>
#include <alcd.h>
#include <stdlib.h>
#include <stdio.h>

#define BT1 PINB.2     // Tam dung
#define BT2 PINB.3     // Cho ca an

#define DIR PINB4
#define PWM PINB5
#define SERVO PORTC.7

volatile int dem = 0; // Bien dem cho servo
volatile int RC = 10; // Vi tri servo (mac dinh)
volatile int state = 1; // 0: Tam dung, 1: Dang hoat dong, 2: Dang cho ca an

interrupt [TIM0_OVF] void timer0_ovf_isr(void) {
    TCNT0 = 0x9C; // Chu ky 0.1ms
    dem++;
    if (dem > 200) dem = 0; // Reset sau 20ms
    if (dem < RC) {
        SERVO = 1;
    } else {
        SERVO = 0;
    }
}

void init_timer0() {
    ASSR=0<<AS0;
    TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (1<<CS01) | (0<<CS00);
    TCNT0=0x9C;   // chu ki 0.1 ms
    OCR0=0x00;

    TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (1<<TOIE0);
    ETIMSK=(0<<TICIE3) | (0<<OCIE3A) | (0<<OCIE3B) | (0<<TOIE3) | (0<<OCIE3C) | (0<<OCIE1C);
    #asm("sei")
}

void display_mode(const char* mode) {
    lcd_clear();
    lcd_puts(mode);
}

void feed_fish_cycle() {
    int i;
    display_mode("Dang cho ca an...");

    OCR1A = 128; // Toc do 50%
    PORTB.4 = 0; //

    for (i = 0; i < 5; i++) {
        if (BT1 == 0) { // Kiem tra nut BT1 de tam dung
            delay_ms(50); // Debounce
            if (BT1 == 0) {
                while (BT1 == 0); // Doi BT1 nha ra
                state = 0; // Chuyen sang trang thai tam dung
                display_mode("Tam dung");
                OCR1A = 0; // Dong co DC ngung quay
                RC = 10;  // Dua servo ve vi tri 0 do
                return; // Thoat khoi che do cho ca an
            }
        }

        RC = 20;    // Servo xoay góc 180
        delay_ms(1000);
        RC = 10;    // Servo quay ve góc 0
        delay_ms(1000);
    }

    display_mode("Dang hoat dong");
    OCR1A = 128; // Quay lai trang thai hoat dong binh thuong
    state = 1;
}

void main(void) {
    lcd_init(16);

    DDRC.7 = 1; // Servo => dau ra
    DDRB.2 = 0; // BT1,2 => dau vao => pull-up
    DDRB.3 = 0;
    PORTB.2 = 1;
    PORTB.3 = 1;

    // Cau hinh dau ra
    DDRB |= (1 << PWM) | (1 << DIR); // PB5 (PWM) va  PB4 (DIR) la dau ra
    TCCR1A = (1 << WGM10) | (1 << COM1A1);  // Fast PWM 8-bit, non-inverted PWM
    TCCR1B = (1 << WGM12) | (1 << CS11);    // Prescaler = 8
    PORTB.4 = 0;
    OCR1A = 128; // Thiet lap toc do 50% (128/255)

    init_timer0(); //Khoi tao Timer0 cho servo
    RC = 10; // Vi tri 0 do

    lcd_clear();
    display_mode("Dang hoat dong");

    while (1) {
        if (BT1 == 0) {
            delay_ms(50); // Debounce
            if (BT1 == 0) {
                while (BT1 == 0); // Doi BT1 nha ra
                if (state == 1 || state == 2) { // Neu dang hoat dong hoac cho ca an
                    state = 0; // Chuyen sang trang thai tam dung
                    display_mode("Tam dung");
                    OCR1A = 0; // Dong co DC ngung quay
                    RC = 10;  // Dua servo ve vi tri 0 do
                } else if (state == 0) {
                    state = 1; // Chuyen sang trang thai hoat dong
                    display_mode("Dang hoat dong");
                    OCR1A = 128; // Dong co DC quay
                }
            }
        }

        if (BT2 == 0 && state == 1) { // Che do cho ca an chi dc thuc hien khi thiet bi dang hoat dong
            delay_ms(50); // Debounce
            if (BT2 == 0) {
                while (BT2 == 0); // Doi BT2 nha ra
                state = 2; // Chuyen sang trang thai cho ca an
                feed_fish_cycle();
            }
        }
    }
}
