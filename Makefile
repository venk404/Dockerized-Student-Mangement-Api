.SLIENT: 
.ONESHELL:
VENV := venv

include .env

API_IMAGE_NAME := restapi
API_IMAGE_VERSION := v1.0.0	
API_CONTAINER_NAME := restapi_container
DOCKER_NETWORK := dem



all:  Start_DB install Schema-creation api-build api-run

install: $(VENV)\Scripts\activate

$(VENV)\Scripts\activate: requirements.txt
	python -m venv $(VENV)

ifeq ($(OS),Windows_NT)
	. .\$(VENV)\Scripts\Activate.ps1
	$(VENV)\Scripts\python -m pip install --upgrade pip
	$(VENV)\Scripts\pip install -r requirements.txt
else
	chmod +x $(VENV)/bin/activate
	source $(VENV)/bin/activate
	$(VENV)/bin/python -m pip install --upgrade pip
	$(VENV)/bin/pip install -r requirements.txt
endif

Start_DB:
ifeq ($(OS),Windows_NT)
	docker-compose up -d --wait
else
	docker-compose up -d --wait
endif

Schema-creation:
ifeq ($(OS),Windows_NT)
	$(VENV)\Scripts\pyway migrate --config DB\Schemas\pyway.conf 
else
	$(VENV)/bin/pyway migrate --config DB/Schemas/pyway.conf
endif


api-build:
ifeq ($(OS),Windows_NT)
	docker build -t ${API_IMAGE_NAME}:${API_IMAGE_VERSION} .
else
	docker build -t ${API_IMAGE_NAME}:${API_IMAGE_VERSION} .
endif

api-run:
ifeq ($(OS),Windows_NT)
	docker run --name ${API_CONTAINER_NAME} -d -p ${APP_PORT}:8000 --network ${DOCKER_NETWORK} \
	-e POSTGRES_DB=${POSTGRES_DB} \
	-e POSTGRES_USER=${POSTGRES_USER} \
	-e POSTGRES_PASSWORD=${POSTGRES_PASSWORD} \
	-e POSTGRES_PORT=${POSTGRES_PORT} \
	-e POSTGRES_HOST=${POSTGRES_HOST} \
	${API_IMAGE_NAME}:${API_IMAGE_VERSION}
else
	@docker run --rm --name ${API_CONTAINER_NAME} -d -p $(APP_PORT):8000 --network ${DOCKER_NETWORK} \
	-e POSTGRES_DB=$(POSTGRES_DB) \
	-e POSTGRES_USER=$(POSTGRES_USER) \
	-e POSTGRES_PASSWORD=$(POSTGRES_PASSWORD) \
	-e POSTGRES_PORT=$(POSTGRES_PORT) \
	-e POSTGRES_HOST=$(POSTGRES_HOST) \
	$(API_IMAGE_NAME):$(API_IMAGE_VERSION)
endif



# Define a clean step
clean:
ifeq ($(OS),Windows_NT)
	@powershell -Command "Get-ChildItem -Recurse -Directory -Filter '__pycache__' | Remove-Item -Recurse -Force"
	@powershell -Command "Get-ChildItem -Recurse -Directory -Filter 'data' | Remove-Item -Recurse -Force"
	@powershell -Command "Get-ChildItem -Recurse -Directory -Filter 'venv' | Remove-Item -Recurse -Force"
else
	find . -type d -name "__pycache__" -exec rm -rf {} +
	find . -type d -name "data" -exec rm -rf {} +
	find . -type d -name "venv" -exec rm -rf {} +
endif


test:
ifeq ($(OS),Windows_NT)
	$(VENV)\Scripts\python test/test.py
else:
	$(VENV)\bin\python test/test.py
endif

.PHONY: install all Start_DB Schema-creation api-build api-run test clean 
