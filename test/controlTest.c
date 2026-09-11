/**
 * @file
 *
 * @date Created on: May 6, 2020
 * @author Attila Kovacs
 *
 *      This simple program demonstrates and tests the use of remote program control using SMA-X.
 *      You may use SMA-X to control programs remotely and receive confirmation of the controlled
 *      commands / variables.
 */

#define _POSIX_C_SOURCE 199309L       ///< for nanosleep()

#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>

#include "smax.h"

#ifndef SMAX_TEST_TIMEOUT
#  define SMAX_TEST_TIMEOUT 10     ///< [s] Default timeout
#endif

#define TABLE           "_test_" X_SEP "control"
#define NAME            "value"
#define CONTROL_NAME    NAME "_control"



static void checkStatus(const char *op, int status) {
  if(!status) return;
  fprintf(stderr, "ERROR! %s: %s\n", op, smaxErrorDescription(status));
  exit(EXIT_FAILURE);
}

int ControlFunction(const char *table, const char *key, void *parg) {
  const char *replyKey = (const char *) parg;
  int value = smaxPullInt(table, key, X_FAILURE);
  return smaxShareInt(table, replyKey, value);
}

int main() {
  int reply;

  // Because this process is doing both the control and the service parts, we'll use the interactive
  // channel exclusively, to avoid any race conditions on the Redis server. Normally it is not
  // necessary when we control one process from another.
  smaxSetPipelined(FALSE);

  xSetDebug(TRUE);
  //redisxDebugTraffic(TRUE);

  checkStatus("connect", smaxConnect());

  // Initialize the value that we will control, and change at some later time...
  checkStatus("share", smaxShareInt(TABLE, CONTROL_NAME, 0));

  checkStatus("setControlFunction", smaxSetControlFunction(TABLE, CONTROL_NAME, ControlFunction, NAME));

  // We'll update the value here...
  // The waiting thread should set gotUpdate when it unblocks...
  errno = 0;
  reply = smaxControlInt(TABLE, CONTROL_NAME, 1, NULL, NAME, X_FAILURE, SMAX_TEST_TIMEOUT);
  if(reply != 1) {
    fprintf(stderr, "ERROR! Unexpected reply: expected %d, got %d.\n", 1, reply);
    if(errno) fprintf(stderr, "      errno = %d (%s)\n", errno, strerror(errno));
    fprintf(stderr, "control: FAILED\n");
    return EXIT_FAILURE;
  }

  fprintf(stderr, "control: OK\n");

  return 0;
}


