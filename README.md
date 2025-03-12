# district-32

<img alt="densfordcivil Logo" height="256" src="/!README/logo.png" width="256"/>

Developed by:

![BlueSky Logo](/!README/BlueSkyEmailSignature.png)

---

## Technologies

- **Core**
    - Docker (Docker-Compose 3.9)
    - Google Cloud (GCP)
    - Nginx
- **Frontend**
    - NextJS
    - React
    - Typescript
- **Backend**
    - Laravel
    - MySQL (SQL Database)

---

## URIs and Port Mapping

For local development, the following ports are used:

| URI              | Port  | Description                             |
|------------------|-------|-----------------------------------------|
| district32.local | 3000  | Admin Portal                            |
| district32.local | 8080  | Nginx/API                               |
| district32.local | 13306 | Maps to the Dockerised MariaDB Database |

---

# Project Setup Guides

## BEFORE YOU BEGIN
Please make sure you have an SSH key set up!

[setting up an ssh key](https://gist.github.com/developius/c81f021eb5c5916013dc)

If you are using a different ssh key (ie not id_rsa) add this to your ~/.ssh/config
```text
Host github.com
  HostName github.com
  User git
  IdentityFile /home/{username}/.ssh/{keyname}
  IdentitiesOnly yes
```

---
## For Running on your Local Machine (Docker)

1. **Obtain the SSH link like so:**

   ![Step 1.a](/!README/Instruction-01.png)

2. **Clone the Project to your machine:**

    ```sh
    git clone SSH-URL-YOU-COPIED-FROM-ABOVE
    ```

3. **Pull in all the submodules:**

    ```sh
    git submodule update --init --recursive
    git submodule update --recursive --remote
    ```

4. **Generate the .env files**

    ```sh
    cp .env.example .env
    cp environments/local/config/laravel.env.example environments/local/config/laravel.env
    cp environments/local/config/frontend.env.example environments/local/config/frontend.env
    ```

5. **Modify your hosts file**

    ```txt
    127.0.0.1       densfordcivil.local
    ```

   Guides for your particular platform below:
   [Windows](https://wiki.bsdl.dev/books/local-development/page/windows) | [macOS](https://wiki.bsdl.dev/books/local-development/page/macos)

6. **Build the stack**

    ```sh
   docker-compose pull
   docker-compose build
    ```

7. **Copy Frontend Dependencies**

   This step is important as the frontend will crash if it cannot find the node_modules directory
   
   > Note: You might have to run the statement below if nextjs was not installed
    ```sh
    cd modules/densfordcivil-frontend; npm install; cd ../..
    ```

   i) Find out the name of the built frontend image

    ```sh
    docker image ls
    ```

   You should see the following, take note of the highlighted image / repository name
   ![Step 7.a](/!README/Instruction-02.png)

   ii) Run the following command

    ```sh
    docker run --rm -v $PWD/modules/densfordcivil-frontend/:/mnt/out "densfordcivil-frontend" /bin/cp -r /app/node_modules/ /mnt/out/
    ```

   **FYI**

   When you run the command, it is normal to see no output. Just wait a couple of minutes for it to complete 😄

   **Important Note!**

   You may need to replace "densfordcivil_frontend" with the name of the frontend image in your system. Linux likes to replace
   dashes with underscores for example.

9. **Run the stack**

    ```sh
    docker-compose up
    ```

10. **Install Laravel Dependencies**

   Run the following commands in a new terminal window:
    ```sh
    docker exec densfordcivil_backend composer install
    ```

11. **Initialise the Database**

    Run the following commands in a new terminal window:
    ```sh
    docker exec densfordcivil_backend php artisan migrate:fresh --seed
    ```

12. **Finalise Laravel Setup**

    Set up your Personal Access Client Token:
    ```sh
    docker exec densfordcivil_backend php artisan passport:install
    ```

    **Important Note!**
    Make note of the "Personal Access Client" client ID and client secret, you will need to put this in the Laravel .env file.

    ![Step 11.a](/!README/Instruction-04.png)
    ![Step 11.b](/!README/Instruction-05.png)

    After updating the .env file you'll need to restart (docker compose down and up).
    > The file .env file should be volume linked so that you don't have to go into the container to modify. By default (from the steps above), the file to edit should be **environments/local/config/laravel.env**

    Once restarted, run the following commands in a new terminal window:
    ```sh
    docker exec densfordcivil_backend php artisan optimize
    ```

13. **Finished**

    Congratulations, you have finished the setup of the project on your local machine! :)


**Additional Notes / Troubleshooting:**
- If you are having login/logout issues, it might be due to incorrect DB settings.
  > Make sure the laravel env is pointing to the correct container name (eg. uphoria_db)

- Make sure the frontend.env points to the correct URLs. For example:
    - NEXT_PUBLIC_APIURL=http://densfordcivil.local:8080/web/v1
    - SERVER_APIURL=http://nginx:80/web/v1


docker compose -f docker-compose-local-dev.yml up -d; docker compose logs -f
