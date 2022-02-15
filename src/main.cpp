// SPDX-FileCopyrightText: 2022 Matthew Nickson <mnickson@sidingsmedia.com>
// SPDX-License-Identifier: MIT
#include <avr/io.h>
#include <util/delay.h>

#define LED_PORT PB1

int main()
{
    // Place holder blink program.
    DDRB |= (1 << LED_PORT);
    while (1)
    {
        PORTB |= (1 << LED_PORT);
        _delay_ms(200);
        PORTB &= ~(1 << LED_PORT);
        _delay_ms(400);
    }
    return 0;
}