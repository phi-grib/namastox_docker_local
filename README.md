## DOCKER WITH A SINGLE USER VERSION OF NAMASTOX

This repository contains a dockerfile and instructions for building a docker image suitable for running NAMASTOX without keycloak authentication. As a consequence, no user read and write permissions can be assigned to the projects. Otherwyse, this version has the same functionalities found in regular NAMASTOX images.

Start cloning locally the repositories:
- namastox
- namastox_API
- namastox_wb

Then, apply the following changes:

### namastox_API configuration
1. Delete **keycloak.py** file because it contains the logic to work with keycloak authentication.
2. Replace **namastox_API's app.py** with the one contained in the repository.
   
### mamastox_web configuration
1. In the  **app.component.ts** file, comment function to get the logged-in user  and define static username
<img width="513" height="167"  alt="image" src="https://github.com/user-attachments/assets/77b60b37-e3d3-48be-a895-9b16cf178417" /> <br>
2. Generate production version of interface
```
ng build
```
3. Change name of folder generated **namastox_web** to **static**
4. Move **static** folder inside  **namastox_API** if the static folder exists, replace it with yours.


### How to create docker image

1. Create
```
docker build -t namedocker .
```
2. Execute
```
docker run -d -p 5000:80 namedocker 
```

It is advisable to map a local folder of the host to the internal /data folder for storing persistently the projects. Otherwise, all the projects created by NAMASTOX will be completely lost every time the container is stoped. For doing this, map the internal /data file using a command like this:
```
docker run -d -p 5000:80 -v /home/namastox/data:/data namedocker
```
where **/home/namatox/data** is the name of the local folder (change for any suitable name)
