## LOCAL VERSION OF NAMASTOX
### Namastox_API configuration
1. Delete or comment  **Keycloak.py** file because it contains the logic to work with keycloak authentication.
2. Replace **namastox_API's app.py** with the one contained in the repository.
   
### Namastox_WEB configuration
1. In the  **app.component.ts** file, comment function to get the logged-in user  and define static username
<img width="513" height="167"  alt="image" src="https://github.com/user-attachments/assets/77b60b37-e3d3-48be-a895-9b16cf178417" /> <br>
2. Generate production version of interface
```
npm run build
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
