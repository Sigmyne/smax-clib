/**
 * @file
 *
 * @date Created  on Sep 11, 2026
 * @author Attila Kovacs
 */


#include <stdlib.h>

#if defined(_MSC_VER)
char *readpassphrase(const char *prompt, char *buf, size_t bufsiz, int flags) {
    char c;
    int pos = 0;

    printf(prompt);

    // Read until Enter (carriage return) is pressed
    while ((c = _getch()) != '\r') {
        // Handle Backspace
        if (c == '\b') {
            if (pos) {
              printf("\b \b");
              pos--;
            }
        }
        // Ignore newline characters and strictly append valid input
        else if (c >= 32 && c <= 126) {
            if(pos < bufsiz) buf[pos] = c;
            pos++;
            printf("*");
        }
    }
    printf("\n");

    // Terminate the buffer
    buf[pos < bufsiz ? pos : bufsiz - 1] = '\0';
    return buf;
}
#endif
