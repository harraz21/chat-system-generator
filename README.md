# chat-system

## Installation
clone the repo
```
git clone https://github.com/harraz21/chat-system.git
```
To build the image for the first time go to the project's root directory
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

#### Create a chat application given a name and return a token for the application
```
http://localhost:3001/api/v1/applications?name=appsName
```
![create_chat_app](https://user-images.githubusercontent.com/35659954/200765306-46d00148-3d72-464e-a81e-87cd890622f2.png)



#### Create chat with application token and return chat number
```
http://localhost:3001/api/v1/applications/[application_token]/chats
```
![image](https://user-images.githubusercontent.com/35659954/200928255-e1a37c7e-f63e-456b-841e-499ea698a6ec.png)



#### Create a message with application token, number and returns message number
```
http://localhost:3001/api/v1/applications/[application_token]/chats/[chat_number]/messages?message=hello world
```
![image](https://user-images.githubusercontent.com/35659954/200929603-84cfc6a1-b1ff-4eb1-84fe-4de569b7afd8.png)


###  GET Requests

#### Get all applications
```
http://localhost:3001/api/v1/applications
```
![image](https://user-images.githubusercontent.com/35659954/200930176-ae907543-d434-42da-87f1-8c1b266360f7.png)



#### Get application with token 
```
http://localhost:3001/api/v1/applications/[application_token]
```
![image](https://user-images.githubusercontent.com/35659954/200930760-b16e4146-22ff-4084-aa72-ff3196cc9455.png)



#### Get all chats with application token 
```
http://localhost:3001/api/v1/applications/[application_token]/chats
```
![image](https://user-images.githubusercontent.com/35659954/200932710-0984b4a4-b3d5-437a-a316-8f4325f2aefd.png)



#### Get chat with application token and chat number (all messsages that belong to the chat are listed inside the chat)
```
http://localhost:3001/api/v1/applications/[application_token]/chats/[chat_number]
```
![image](https://user-images.githubusercontent.com/35659954/200933143-0b628313-0754-413f-b7b5-409be31272d8.png)



#### Search a chat with application token chat number and a search query
```
http://localhost:3001/api/v1/applications/[token]/chats/[chat_number]/search?search_query=hello
```
![image](https://user-images.githubusercontent.com/35659954/200934040-4bbbc236-7ba3-46a9-8d58-af2b55c5fb8f.png)


#### Get all messages with application token and chat number
```
http://localhost:3001/api/v1/applications/[application_token]/chats/[chat_number]/messages
```
![image](https://user-images.githubusercontent.com/35659954/200934997-6cab964f-cc71-4a65-9770-abc3bea2fab5.png)



#### Get a message with application token number, chat number and message number
```
http://localhost:3001/api/v1/applications/[application_token]/chats/[chat_number]/messages/[message_number]
```
![image](https://user-images.githubusercontent.com/35659954/200935778-5e45db81-d180-45cf-8929-c7f773daf4bf.png)



### PUT Requests


#### Update message by token, chat number, message number and new message
```
http://localhost:3001/api/v1/applications/[application_token]/chats/[chat_number]/messages/[message_number]/?message=[new message]
```
![image](https://user-images.githubusercontent.com/35659954/200938883-0b861b0d-91b7-4fa3-ad77-fa474e69ef24.png)
![image](https://user-images.githubusercontent.com/35659954/200939027-6b83cbf0-dde6-4e54-8642-abf7cd748657.png)



#### Update Application name by token and new name
```
http://localhost:3001/api/v1/applications/[application_token]?name=[new_name]
```



### DELETE Requests

#### Delete message by token, chat number and message number
```
http://localhost:3001/api/v1/applications/[application_token]/chats/[chat_number]/messages/[message_number]
```
![image](https://user-images.githubusercontent.com/35659954/200939430-136d6d39-b82f-41c3-8a8f-79cb58707a29.png)



#### Delete chat by token and chat number
```
http://localhost:3001/api/v1/applications/[application_token]/chats/[chat_number]
```
![image](https://user-images.githubusercontent.com/35659954/200940501-291f2b52-9b4f-4a1e-a259-ef63625ebe06.png)
![image](https://user-images.githubusercontent.com/35659954/200941270-d8eba5ad-48a9-4345-87e2-5da96eeed527.png)



#### Delete Application by token
```
http://localhost:3001/api/v1/applications/[application_token]
```


                
