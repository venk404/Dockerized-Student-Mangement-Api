
# Student Management API(SRE/Assignment 2)

This project is a simple Student Management API built using FastAPI. It allows for basic CRUD operations on student data. The API supports creating, reading, updating, and deleting student information.



## Features

- Create Student: Add a new student.
- Get All Students: Retrieve a list of all students.
- Get Student by ID: Retrieve a specific student by their ID.
- Update Student: Update a student's information.
- Delete Student: Delete a student by their ID.


## Requirments
- Python 3.13
- PIP
- Docker & Docker Compose(For database)
- Make (Optional)


## Installation
1) Clone the repository:

```bash
  git clone https://github.com/venk404/Assignment-2.git
```
3) ## There are one .env example files and  pyway.conf file for migartion:

- The .env example is located in the current directory.
- The  pyway.conf is located in the DB directory for migartions.

3) Update the env files and run the command to set up the DB, schema, build the REST API image, and start it.
 ```bash
  make all
```
### you can manually run it.

3) Navigate to the DB folder and run docker-compose to start the database.
 ```bash
  docker-compose up -d
```

### Migartion
4) Run the DB DML migrations

```bash
  make Schema-creation
```

### Build & Run the API Docker Image

5) Build the REST API Docker image.
 ```bash
  make api-build
```

6) Let start the Restapi in container on the given port.
 ```bash
  make api-run
```

## Documentation(API Documentation)

- Refer to the API documentation for the endpoints listed below
```bash
  http://127.0.0.1:8000/docs
```