/*
 * Ex11.c
 *
 * Created: 12/21/2024 10:22:59 PM
 * Author: ADMIN
 */

#include <io.h>
#include <alcd.h>
#include <delay.h>
#include <stdint.h>
#include <stdio.h>
#include <eeprom.h>

int keypad[3][3] = {0, 1, 2, 3, 4, 5, 6, 7, 8}; // ma tran ban phim
char input_password[4]; // Luu mat khau nhap tu ban phim
char correct_password[4]; // Mat khau dung (luu EEPROM)
int remaining_attempts = 2; // So lan nhap sai con lai
volatile int lock_triggered = 0; // Bien xac dinh trang thai khoa

// Timer0 ngat tran
interrupt [TIM0_OVF] void timer0_ovf_isr(void) {
    static int dem = 0;
    TCNT0 = 0x06;

    if (lock_triggered) {
        dem += 1;
         if (dem % 2000 == 1000){
            PORTD.4 = 1;
            PORTD.6 = 0;
        }
        if(dem % 2000 == 0){
            PORTD.4 = 0;
            PORTD.6 = 1;
        }
    }
}

void BUTTON() {
    int i, j, index;
    char buffer[2];

    index = 0;
    lcd_gotoxy(0, 1);
    while (index < 3) { // Nhap 3 ki tu
        for (j = 0; j < 3; j++) {
            if (j == 0) PORTF = 0b11111101;
            if (j == 1) PORTF = 0b11110111;
            if (j == 2) PORTF = 0b11011111;
            for (i = 0; i < 3; i++) {
                if ((i == 0 && PINF.2 == 0) ||
                    (i == 1 && PINF.4 == 0) ||
                    (i == 2 && PINF.0 == 0)) {
                    input_password[index] = keypad[i][j] + '0'; // Luu ki tu nhap vao
                    buffer[0] = input_password[index];
                    buffer[1] = '\0';
                    lcd_putchar(buffer[0]);
                    delay_ms(300);
                    lcd_gotoxy(index, 1);
                    lcd_putchar('*'); // Hien thi dau *
                    delay_ms(500);
                    index++;
                    break;
                }
            }
        }
        // Xu ly BT2 la so 9
        if (PINB.3 == 0) {
            input_password[index] = '9';
            buffer[0] = input_password[index];
            buffer[1] = '\0';
            lcd_putchar(buffer[0]);
            delay_ms(300);
            lcd_gotoxy(index, 1);
            lcd_putchar('*');
            delay_ms(500);
            index++;
        }
    }
    input_password[3] = '\0'; // Ket thuc chuoi
}

void handle_correct_password() {
    lcd_clear();
    lcd_puts("Mat khau dung!");
    delay_ms(2000);
    remaining_attempts = 2; // Reset lai so lan nhap sai
}

void handle_wrong_password() {
    char buffer[20];

    lcd_clear();
    remaining_attempts--;
    sprintf(buffer, "Sai! Con %d lan", remaining_attempts);
    lcd_puts(buffer);
    delay_ms(2000);

    if (remaining_attempts <= 0) {
        lcd_clear();
        lcd_puts("Bi khoa!");
        PORTC |= (1 << 3); // Bat RELAY1
        lock_triggered = 1; // Kich hoat che do khoa
        ASSR = 0 << AS0;
        TCCR0 = 0x03;
        TCNT0 = 0x06;
        OCR0 = 0x00; // Thuong giu nguyen o cac bai
        TIMSK =0x01; // Thuong giu nguyen o cac bai
        ETIMSK = 0x00; // Thuong giu nguyen o cac bai
        #asm("sei")

        while (1) {
            // LED nhap nhay duoc dieu khien boi timer0
        }
    }
}

int my_strcmp(const char *str1, const char *str2) {
    while (*str1 && (*str1 == *str2)) {
        str1++;
        str2++;
    }
    return *(unsigned char *)str1 - *(unsigned char *)str2;
}

void main() {
    const char *password_to_write = "108";
    DDRF = 0b11101010; // Cai dat huong nhap xuat cho ban phim ma tran
    PORTF = 0b00010101; // Keo len muc cao cho cac hang
    DDRB.3 = 0;; // BT2 la dau vao (PB3)
    PORTB.3 = 1; // Keo len muc cao cho PB3
    DDRC.3 = 1; // RELAY1 PC3 la dau ra
    DDRD.4 = 1; // LED do (PD4), LED xanh nuoc bien (PD6)
    DDRD.6 = 1;

    lcd_init(16); // Khoi tao LCD

    // Khoi tao EEPROM mat khau dung

    eeprom_write_block(password_to_write, (void *)0, 4);
    eeprom_read_block((void *)correct_password, (const void *)0, sizeof(correct_password));

    // Khoi tao timer0
    TCCR0 = (1 << CS02) | (1 << CS00); // Prescaler = 1024
    TCNT0 = 6; // Gia tri khoi tao cho chu ky 1 giay

    while (1) {
        lcd_clear(); // Xoa man hinh hoan toan truoc khi hien thi lai
        lcd_gotoxy(0,0);
        lcd_puts("Nhap mat khau:");
        BUTTON(); // Nhan mat khau
        if (my_strcmp(input_password, correct_password) == 0) {
            handle_correct_password();
        } else {
            handle_wrong_password();
        }
    }
}



