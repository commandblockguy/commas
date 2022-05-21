# ----------------------------
# Makefile Options
# ----------------------------

NAME = SPACES
DESCRIPTION = "Adds commas as thousands separators."
COMPRESSED = NO
ARCHIVED = YES

CFLAGS = -Wall -Wextra -Oz
CXXFLAGS = -Wall -Wextra -Oz

# ----------------------------

include $(shell cedev-config --makefile)
