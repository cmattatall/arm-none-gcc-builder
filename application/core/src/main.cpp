#include "private_application_header.h"
#include "application_header.h"

#include "middleware.h"

void application_do_stuff() {
  struct private_application_struct my_private_application_struct;
  // do stuff
}

int main() {
  application_do_stuff();
  while (1) {
    middlware_talk_to_modem();
  }
}