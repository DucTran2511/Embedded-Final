#include <io.h>
#include <delay.h>
#include <glcd.h>
#include <font5x7.h>
#include <dht11.c>

char input_password[5] = {'0', '0', '0', '0'};

void hien_thi() {
    x = dht11(&nhietdo, &doam);
        
    if (x == 1) {
        lcd_gotoxy(0, 0);
        lcd_putsf("TEMP:");
        lcd_putchar(nhietdo / 10 + 48);
        lcd_putchar(nhietdo % 10 + 48);
        lcd_gotoxy(0, 1);
        lcd_putsf("HUMI:");
        lcd_putchar(doam / 10 + 48);
        lcd_putchar(doam % 10 + 48);
    }
}

void BUTTON() {
    int i, j, index = 0;
    char buffer[16];
    while (index < 4) { // Nhap du 4 ki tu
        for (j = 0; j < 3; j++) {
            if (j == 0) PORTF = 0b11111101;
            if (j == 1) PORTF = 0b11110111;
            if (j == 2) PORTF = 0b11011111;
            for (i = 0; i < 3; i++) {
                if ((i == 0 && PINF.2 == 0) ||
                    (i == 1 && PINF.4 == 0) ||
                    (i == 2 && PINF.0 == 0)) {
                    input_password[index] = keypad[i][j] + '0'; // Luu ki tu nhap vao
                    if(index == 0){
                        sprintf(buffer, "MAX TEMP: %d_", input_password[index]);
                    }else if(index == 1){
                        sprintf(buffer, "MAX TEMP: %d%d", input_password[index-1], input_password[index]);
                    }else if(index == 2){
                        sprintf(buffer, "MAX HUM: %d_", input_password[index]);
                    }else{
                        sprintf(buffer, "MAX HUM: %d%d", input_password[index-1], input_password[index]);
                    }
                    delay_ms(500);
                    index++;
                    break;
                }
            }
        }
    }
    input_password[4] = '\0'; // Ket thuc chuoi
}

void display_max_ht(){
    char buffer[16];
    lcd_clear();
    lcd_gotoxy(0, 0);
    sprintf(buffer, "MAX TEMP: %d%d", input_password[0], input_password[1]);
    lcd_gotoxy(0, 1);
    sprintf(buffer, "MAX HUM: %d%d", input_password[3], input_password[4]);
    
}

void main(){
bool state_1 = true;
bool state_2 = true;
int count = 0;
DDRB = 0x00;
PORTB = 0x04;
while(1){
    // Button 1
    if(PINB.2 == 0){
            delay_ms(50);
            if(PIB.2 == 0){
                state_1 = !state_1;
            }
    }
    
    // Button 2
    if(PINB.3 == 0){
            delay_ms(50);
            if(PIB.3 == 0){
                state_2 = !state_2;
            }
    }
    
    if(state_1 == true && state_2 == true){ 
        hien_thi();
    }else if (state_1 == false && state_2 == true){ // If button 1 is pressed
        BUTTON();
    }else if (state_1 == true && state_2 == false){ // If button 2 is pressed
        display_max_ht();
    }
    
}
}

