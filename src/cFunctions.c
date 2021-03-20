/* Copyright (c) Lucas Toole 2021 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <errno.h>
#include <net/if.h>
#include <linux/if_tun.h>
#include <fcntl.h>
#include <unistd.h>

#include "cFunctions.h"

int get_iface_fd(int fd) {
	char *if_name = "tap1"; /* TEMP */
	struct ifreq iface;
	memset(&iface, 0, sizeof(iface));

	strncpy(iface.ifr_name, if_name, strlen(if_name));

	iface.ifr_flags = IFF_NO_PI | IFF_TAP;

	if (ioctl(fd, TUNSETIFF, (void *) &iface) == -1) {
		perror("IOCTL ERROR");
		close(fd);
		return -1;
	}

	printf("%d\n", fd);
	return 0;
}
