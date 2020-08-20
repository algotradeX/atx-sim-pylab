CONDA_ENV_NAME=atx-sim-pylab
APP_NAME=atx-sim-pylab
ALL_FILES=.

# echo _FormatCode_ guide:
# 	0 	Reset all styles
# 	1	Bold
#	32 	Green
#	34 	Blue
#	35 	Magenta
#	36	Cyan
RESET_STYLES=\033[0m
BOLD_BLUE=\033[1m\033[34m
BOLD_CYAN=\033[1m\033[36m

# Signifies our desired python version
# Makefile macros (or variables) are defined a little bit differently than traditional bash, keep in mind that in the Makefile there's top-level Makefile-only syntax, and everything else is bash script syntax.
PYTHON = python3

# .PHONY defines parts of the makefile that are not dependant on any specific file
# This is most often used to store functions
.PHONY = help setup format lint

# Defines the default target that `make` will to try to make, or in the case of a phony target, execute the specified commands
# This target is executed whenever we just type `make`
.DEFAULT_GOAL = help


# The @ makes sure that the command itself isn't echoed in the terminal
help:
	@echo "$(BOLD_BLUE)-----------------------------MAKE GUIDE----------------------------$(RESET_STYLES)"
	@echo "$(BOLD_CYAN)make setup$(RESET_STYLES) : Setup 🔬SimPyLab🐉"
	@echo "$(BOLD_CYAN)make format$(RESET_STYLES) : Format and fix python code in 🔬SimPyLab🐉"
	@echo "$(BOLD_CYAN)make lint$(RESET_STYLES) : Lint 🔬SimPyLab🐉"
	@echo "$(BOLD_BLUE)-------------------------------------------------------------------$(RESET_STYLES)"


setup: #: Use pip-tools, pip-compile, pip install
	@echo "\n$(BOLD_CYAN)Setting up 🔬SimPyLab🐉$(RESET_STYLES)"
	# Check for venv, conda else exit
	@echo "\n$(BOLD_CYAN)Installing pip-tools . . .$(RESET_STYLES)"
	pip install pip-tools
	@echo "\n$(BOLD_CYAN)Generating requirements$(RESET_STYLES)"
	pip-compile -q --build-isolation --output-file=requirements/requirements.txt requirements/requirements.in
	@echo "\n$(BOLD_CYAN)Installing requirements$(RESET_STYLES)"
	pip install -r requirements/requirements.txt
	@echo "\n$(BOLD_CYAN)Adding pre-commit hooks$(RESET_STYLES)"
	pre-commit install


format: #: Format and fix python code with black, isort, autoflake
	@echo "\n$(BOLD_CYAN)Blackifying$(RESET_STYLES) 🍳"
	black --version
	black $(ALL_FILES)
	@echo "\n$(BOLD_CYAN)ISorting$(RESET_STYLES) 〽️️"
	isort --recursive $(ALL_FILES)
	@echo "\n$(BOLD_CYAN)Flaking$(RESET_STYLES) ❄️"
	flake8 --version
	autoflake --remove-all-unused-imports --remove-unused-variables --remove-duplicate-keys --ignore-init-module-imports -i -r $(ALL_FILES)
	@echo "\n"


lint: #: Run static analysis with flake8, radon, mypy and bandit
	@echo "\n$(BOLD_CYAN)Linting with flake8$(RESET_STYLES) ❄️"
	flake8 --version
	flake8 $(ALL_FILES)
	@echo "\n$(BOLD_CYAN)Checking cyclomatic complexity with radon$(RESET_STYLES) 💫️"
	radon --version
	radon cc $(ALL_FILES) --total-average -nc
	@echo "\n$(BOLD_CYAN)Static typing with mypy$(RESET_STYLES) ⌨️"
	mypy --version
	mypy $(ALL_FILES)
	@echo "\n$(BOLD_CYAN)Securing with bandit$(RESET_STYLES) 🕵️️"
	bandit --version
	bandit -l -i -r . --format=custom
	@echo "\n$(BOLD_CYAN)Running pre-commit hooks$(RESET_STYLES) 🏁️️️"
	pre-commit run --all-files
	@echo "\n$(BOLD_CYAN)All checks passed$(RESET_STYLES) 🏳️️️️"
	@echo "\n"

