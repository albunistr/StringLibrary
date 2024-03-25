FLAGS = -Wall -Werror -Wextra -std=c11
UNAME_S := $(shell uname -s)
OBJ = s21_string.c s21_sprintf.c
OBJ_TEST = s21_string_test.c

ifeq ($(UNAME_S),Linux)
OPEN_CMD = xdg-open
ADD_LIB = -lcheck -lsubunit -lm -lrt -lpthread -D_GNU_SOURCE
LEAKS_CMD = valgrind --tool=memcheck --leak-check=yes
endif

ifeq ($(UNAME_S),Darwin)
OPEN_CMD = open -a "Google Chrome"
ADD_LIB = -lcheck -lm
LEAKS_CMD = leaks -atExit --
endif

all: clean s21_string.a gcov_report 

s21_string.a:
	@gcc $(CFLAGS) $(OBJ) -c
	@ar rc s21_string.a *.o
	@ranlib s21_string.a
	@rm *.o

test:
	@rm -rf test
	@gcc $(FLAGS) --coverage $(OBJ) $(OBJ_TEST) -o test $(ADD_LIB)
	@./test

gcov_report:
	@gcc $(FLAGS) --coverage $(OBJ) $(OBJ_TEST) -o test $(ADD_LIB)
	@./test
	@lcov -t "s21_string_test" -o fizzbuzz.info -c -d .
	@genhtml -o report fizzbuzz.info
	@$(OPEN_CMD) report/src/index.html
	@rm *.gcda *.gcno

style:
	@clang-format -style=google -i *.c *.h

clean:
	@rm -rf *.gcda *.gcno *.out *.info s21_string.a test report