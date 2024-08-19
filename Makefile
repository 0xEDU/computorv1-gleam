NAME = computorv1
INPUT_STR = "input=$$(echo \${1@Q})"

all:
	@gleam export erlang-shipment
	@echo "#!/bin/bash" >> $(NAME)
	@echo 'set -f' >> $(NAME)
	@echo ${INPUT_STR} >> $(NAME)
	# @echo 'bash ./build/erlang-shipment/entrypoint.sh run "$$input"' >> $(NAME)
	@chmod +x computorv1

clean:
	@gleam clean

fclean: clean
	@rm -f $(NAME)

re: fclean all

.PHONY: all clean fclean re
