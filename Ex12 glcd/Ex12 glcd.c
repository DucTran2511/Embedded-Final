/*
 * Ex12 glcd.c
 *
 * Created: 12/21/2024 10:28:43 PM
 * Author: ADMIN
 */

#include <io.h>
#include <glcd.h>
#include <delay.h>
#include <stdint.h>
#include <stdio.h>
#include <font5x7.h>
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
    int i;
    int j;
    int index;
    char buffer[2];

    index = 0;
    glcd_outtextxy(0, 30, "                    "); // Xoa noi dung truoc do
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
                    glcd_outtextxy(index * 10, 30, buffer);
                    delay_ms(300);
                    glcd_outtextxy(index * 10, 30, "*"); // Hien thi dau *
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
            glcd_outtextxy(index * 10, 30, buffer);
            delay_ms(300);
            glcd_outtextxy(index * 10, 30, "*");
            delay_ms(500);
            index++;
        }
    }
    input_password[3] = '\0'; // Ket thuc chuoi
}

void handle_correct_password() {
    glcd_clear();
    glcd_outtextxy(0, 20, "Mat khau dung!");
    delay_ms(2000);
    remaining_attempts = 2; // Reset lai so lan nhap sai

    glcd_clear();
    glcd_outtextxy(0, 20, "Doi mat khau: Y/N");
    delay_ms(2000);

    // Kiem tra lua chon cua nguoi dung
    while (1) {
        if (PINB.2 == 0) { // BT1: Y (Yes)
            glcd_clear();
            glcd_outtextxy(0, 20, "Nhap MK moi:");
            BUTTON(); // Nhan mat khau moi

            // Luu mat khau moi vao EEPROM
            eeprom_write_block((void *)input_password, (void *)0, 4);
            glcd_clear();
            glcd_outtextxy(0, 20, "MK da luu!");
            delay_ms(2000);
            eeprom_read_block((void *)correct_password, (const void *)0, sizeof(correct_password));
            break;
        }
        if (PINB.0 == 0) { // BT3: N (No)
            glcd_clear();
            glcd_outtextxy(0, 20, "Su dung MK cu!");
            delay_ms(2000);
            break;
        }
    }

    // Sau khi xu ly, quay lai hien thi nhap mat khau
    glcd_clear();
    glcd_outtextxy(0, 10, "Nhap mat khau:");
}

void handle_wrong_password() {
    char buffer[20];

    glcd_clear();
    remaining_attempts--;
    sprintf(buffer, "Sai! Con %d lan", remaining_attempts);
    glcd_outtextxy(0, 20, buffer);
    delay_ms(2000);

    if (remaining_attempts <= 0) {
        glcd_clear();
        glcd_outtextxy(10, 20, "Bi khoa!");
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
    } else {
        // Hien thi lai nhap mat khau
        glcd_clear();
        glcd_outtextxy(0, 10, "Nhap mat khau:");
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
    GLCDINIT_t glcd_init_data;

    glcd_init_data.font = font5x7;
    glcd_init_data.temp_coef = 140;
    glcd_init_data.bias = 4;
    glcd_init_data.vlcd = 66;
    glcd_init(&glcd_init_data);

    DDRF = 0b11101010; // Cai dat huong nhap xuat cho ban phim ma tran
    PORTF = 0b00010101; // Keo len muc cao cho cac hang
    DDRB =  0x00; // BT1, 2, 3 la dau vao
    PORTB = 0b00001101;  // Keo len muc cao cho PB3, PB2, PB0
    DDRC.3 = 1; // RELAY1 PC3 la dau ra
    DDRD.4 = 1; // LED do (PD4), LED xanh nuoc bien (PD6)
    DDRD.6 = 1;

    // Khoi tao EEPROM mat khau dung

    eeprom_write_block(password_to_write, (void *)0, 4);
    eeprom_read_block((void *)correct_password, (const void *)0, sizeof(correct_password));

    // Khoi tao timer0
    TCCR0 = (1 << CS02) | (1 << CS00); // Prescaler = 1024
    TCNT0 = 6; // Gia tri khoi tao cho chu ky 1 giay

    glcd_clear(); // Dam bao xoa man hinh luc dau
    glcd_outtextxy(0, 10, "Nhap mat khau:"); // Hien thi thong bao dau tien

    while (1) {
        BUTTON(); // Nhan mat khau
        if (my_strcmp(input_password, correct_password) == 0) {
            handle_correct_password();
        } else {
            handle_wrong_password();
        }
    }
}


