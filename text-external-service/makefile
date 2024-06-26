PORT=8001

VENV_DIR=venv

.PHONY: build run stop logs setup run-local

setup:
	python3 -m venv $(VENV_DIR)
	$(VENV_DIR)/bin/pip install -r requirements.txt

run-local:
	$(VENV_DIR)/bin/uvicorn app:app --reload --port $(PORT)