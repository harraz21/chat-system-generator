# chat-system

## Installation
clone the repo
```
git clone https://github.com/harraz21/chat-system.git
```
To build the image go to the project's root directory
```
cd chat-system-generator
```
```
cd rails-docker
```

``` 
docker-compose build
```

to run the server and the infrastructure for the project

```
docker-compose up
```

## API 

### POST Requests

Create a chat application given a name and return chat number
returns a token for the application

```
http://localhost:3001/api/v1/applications?name=appsName
```


![create_chat_app](https://user-images.githubusercontent.com/35659954/200765306-46d00148-3d72-464e-a81e-87cd890622f2.png)

Create chat with application token
```
http://localhost:3001/api/v1/applications/[application_token]/chats
```
![image](https://user-images.githubusercontent.com/35659954/200928255-e1a37c7e-f63e-456b-841e-499ea698a6ec.png)
