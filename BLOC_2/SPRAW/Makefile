BUILD_DIR=build

all:
	pdflatex -output-directory=$(BUILD_DIR) sprawozdanie_szablon.tex --shell-escape

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

clean:
	rm -rf $(BUILD_DIR)
