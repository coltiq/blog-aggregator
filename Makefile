# Go parameters
GOCMD=go
GOBUILD=$(GOCMD) build
GOCLEAN=$(GOCMD) clean
GOTEST=$(GOCMD) test
GOFMT=$(GOCMD) fmt
GOLINT=staticcheck
GOSEC=gosec
GOGET=$(GOCMD) get
BINARY_NAME=bin/out
BINARY_UNIX=$(BINARY_NAME)_unix

# Default target executed when no arguments are given to make.
all: deps fmt lint secure test

# Build the project
build: clean
	@$(GOBUILD) -o $(BINARY_NAME)
	@echo "Building... Success"

# Run the tests
test:
	@echo "Testing..."
	@$(GOTEST) -v ./...
	@echo ""

secure:
	@echo -n "Security checks... "; \
	govulncheck ./...

# Clean the build directory
clean:
	@echo -n "Cleaning... "; \
	CLEAN_OUTPUT=$$($(GOCLEAN)); \
	if [ -z "$$CLEAN_OUTPUT" ]; then \
		rm -f $(BINARY_NAME) $(BINARY_UNIX); \
		if [ $$? -eq 0 ]; then \
			echo "Success"; \
		else \
			echo "x       Error removing binaries"; \
		fi \
	else \
		echo "$$CLEAN_OUTPUT" | while IFS= read -r line; do echo "x       $$line"; done; \
	fi

# Format the code
fmt:
	@echo -n "Formatting... "; \
	FORMAT_OUTPUT=$$($(GOFMT) ./...); \
	if [ -z "$$FORMAT_OUTPUT" ]; then \
		echo "Success"; \
	else \
		echo "Failed"; \
		echo "$$FORMAT_OUTPUT" | while IFS= read -r line; do echo "x       $$line"; done; \
	fi

# Lint the code
lint:
	@echo -n "Linting... "; \
	LINT_OUTPUT=$$($(GOLINT) ./...); \
	if [ -z "$$LINT_OUTPUT" ]; then \
		echo "Success"; \
	else \
		echo "Failed"; \
		echo "$$LINT_OUTPUT" | while IFS= read -r line; do echo "x       $$line"; done; \
	fi
	@echo ""

# Run the web server
run: build
	@$(GOBUILD) -o $(BINARY_NAME)
	@./$(BINARY_NAME)

# Install dependencies
deps:
	@$(GOGET) -u ./...

# Cross compilation for Linux
build-linux:
	GOOS=linux GOARCH=amd64 $(GOBUILD) -o $(BINARY_UNIX) -v

.PHONY: all build test clean run deps build-linux fmt lint secure
