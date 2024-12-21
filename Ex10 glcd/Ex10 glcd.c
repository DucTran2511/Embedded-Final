/*
 * Ex10 glcd.c
 *
 * Created: 12/21/2024 10:21:03 PM
 * Author: ADMIN
 */

#include <io.h>
#include <glcd.h>
#include <delay.h>
#include <stdint.h>
#include <stdio.h>
#include <font5x7.h>

int keypad[3][3] = {0, 1, 2, 3, 4, 5, 6, 7, 8}; // ma tran ban phim
char input_password[4]; // Luu mat khau nhap tu ban phim
char correct_password[4] = "108"; // Mat khau dung

void BUTTON() {
    int i, j, index;
    char buffer[2];
    index = 0;
    glcd_outtextxy(10, 20, "                    "); // Xoa mat khau cu
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
                    glcd_outtextxy(index * 10, 20, buffer);
                    delay_ms(300);
                    glcd_outtextxy(index * 10, 20, "*"); // Hien thi dau *
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
            glcd_outtextxy(index * 10, 20, buffer);
            delay_ms(300);
            glcd_outtextxy(index * 10, 20, "*");
            delay_ms(500);
            index++;
        }
    }
    input_password[3] = '\0'; // Ket thuc chuoi
}

void handle_correct_password() {
    glcd_clear();
    glcd_outtextxy(0, 30, "Mat khau dung!");
    delay_ms(2000);
}

void handle_wrong_password() {
    glcd_clear();
    glcd_outtextxy(0, 30, "Mat khau sai!");
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
    GLCDINIT_t glcd_init_data;
    glcd_init_data.font = font5x7;
    glcd_init_data.temp_coef = 140;
    glcd_init_data.bias = 4;
    glcd_init_data.vlcd = 66;
    glcd_init(&glcd_init_data);

    DDRF = 0b11101010; // Cai dat huong nhap xuat cho ban phim ma tran
    PORTF = 0b00010101; // Keo len muc cao cho cac hang
    DDRB &= ~(1 << 3); // BT2 la dau vao (PB3)
    PORTB |= (1 << 3); // Keo len muc cao cho PB3

    while (1) {
        glcd_clear(); // Xoa man hinh hoan toan truoc khi hien thi lai
        glcd_outtextxy(0, 10, "Nhap mat khau:");
        BUTTON(); // Nhan mat khau
        if (my_strcmp(input_password, correct_password) == 0) {
            handle_correct_password();
        } else {
            handle_wrong_password();
        }
    }
}