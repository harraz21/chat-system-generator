# chat-system

## Installation
clone the repo
```
git clone https://github.com/harraz21/chat-system.git
```
To build the image cd chat-system/rails-docker to be at the project's root directory
``` 
docker-compose build
```

to run the server and the infrastructure for the project

```
docker-compose up
```

## API 

Create a chat application given a name 
returns a token for the application

```
http://localhost:3001/api/v1/applications?name=appsName
```


![create_chat_app](https://user-images.githubusercontent.com/35659954/200765306-46d00148-3d72-464e-a81e-87cd890622f2.png)
