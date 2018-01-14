build:
	gcc -o glasscon -F/System/Library/PrivateFrameworks -framework MultitouchSupport -framework ApplicationServices -lSDL2 gamecon/*.c

run:
	./glasscon
