/*
 * Ex10.c
 *
 * Created: 12/21/2024 10:18:51 PM
 * Author: ADMIN
 */

#include <io.h>
#include <alcd.h>
#include <delay.h>
#include <stdint.h>
#include <stdio.h>

int keypad[3][3] = {0, 1, 2, 3, 4, 5, 6, 7, 8}; // ma tran ban phim
char input_password[4]; // Luu mat khau nhap tu ban phim
char correct_password[4] = "108"; // Mat khau dung

void BUTTON() {
    int i, j, index = 0;
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
                    lcd_gotoxy(index, 1);
                    lcd_putchar(input_password[index]);
                    delay_ms(300);
                    lcd_gotoxy(index, 1);
                    lcd_puts("*"); // Hien thi dau *
                    delay_ms(500);
                    index++;
                    break;
                }
            }
        }
        // Xu ly BT2 la so 9
        if (PINB.3 == 0) {
            input_password[index] = '9';
            lcd_gotoxy(index, 1);
            lcd_putchar(input_password[index]);
            delay_ms(300);
            lcd_gotoxy(index, 1);
            lcd_puts("*");
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
}

void handle_wrong_password() {
    lcd_clear();
    lcd_puts("Mat khau sai!");
    delay_ms(2000);
}

int my_strcmp(const char *str1, const char *str2) {
    while (*str1 && (*str1 == *str2)) {
        str1++;
        str2++;
    }
    return *(unsigned char *)str1 - *(unsigned char *)str2;
}

void main() {
    lcd_init(16);
    DDRF = 0b11101010; // Cai dat huong nhap xuat cho ban phim ma tran
    PORTF = 0b00010101; // Keo len muc cao cho cac hang
    DDRB &= ~(1 << 3); // BT2 la dau vao (PB3)
    PORTB |= (1 << 3); // Keo len muc cao cho PB3

    while (1) {
        lcd_clear();
        lcd_puts("Nhap mat khau:");
        lcd_gotoxy(0, 1);
        BUTTON(); // Nhan mat khau
        if (my_strcmp(input_password, correct_password) == 0) {
            handle_correct_password();
        } else {
            handle_wrong_password();
        }
    }
}
