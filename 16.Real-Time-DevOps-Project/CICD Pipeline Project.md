# <span style="color: Yellow;"> Spotify on Terraform: A DevOps Journey!</span>

In this blog, we will use Terraform to construct many Spotify playlists. Terraform will automatically create and maintain these playlists.

![Spotify](https://github.com/user-attachments/assets/aa0dd720-76e3-444d-939c-c48fdfb4cd91)

## <span style="color: Yellow;"> Prerequisites </span>

Before getting started on this project, you need be familiar with the following tools and accounts:

- [x] [Clone repository for terraform code](https://github.com/mrbalraj007/DevOps_free_Bootcamp/tree/main/16.Real-Time-DevOps-Project/Terraform_Code/Code_IAC_Terraform_box)<br>
  __Note__: Replace resource names and variables as per your requirement in terraform code
  - from spotify/.env (i.e store your Spotify application's Client ID and Secret:<br>
      ```bash
      SPOTIFY_CLIENT_ID=<your_spotify_client_id>
      SPOTIFY_CLIENT_SECRET=<your_spotify_client_secret>)
      ```
  - from ```Code_IAC_Terraform_box```/main.tf (i.e keyname- ```MYLABKEY```*)

<!-- - [x] [App Repo](https://github.com/mrbalraj007/Blue-Green-Deployment.git) -->


- [x] __Terraform__: A popular Infrastructure as Code (IaC) tool used to automate cloud resources, installed on your local machine. You can download it from the official Terraform website, and ensure it's correctly installed by running the terraform version command.
- [x] __Docker__: Required to run a container that helps with Spotify account authentication.
- [x] __Spotify Account__: A standard (free or premium) Spotify account is needed to create and manage playlists.
- [x] __[Spotify Developer Account](https://developer.spotify.com/)__: This allows access to API credentials (Client ID, Client Secret, and API Key), which are essential for interacting with Spotify through Terraform.
- [x] __VS Code__: A code editor used to write Terraform configuration files.

## <span style="color: Yellow;"> Key Benefits of Using Terraform with Spotify: </span>
- __Automation__: Automates the process of creating Spotify playlists. Instead of manually creating playlists and adding tracks, you can run Terraform scripts to manage playlists easily.
- __Reusability__: Once the Terraform configuration is set, it can be reused to create multiple playlists across various Spotify accounts.
- __Hands-on Learning__: This project introduces several fundamental Terraform concepts, such as providers, modules, data blocks, and API integration, making it ideal for beginners learning Infrastructure as Code.

### <span style="color: Orange;">__Task 01__.  Register a __[Spotify Developer Account](https://developer.spotify.com/)__, then log in and create an application. </span>

Once you login into account then click on Create app

![image](https://github.com/user-attachments/assets/4c9efee0-b658-41d8-8e5f-337951850549)

Fill in the name and description from the table below, check the box to agree to the terms of service, and then click Create.
| Name | Description |
|:-----------:|:------------:|
| Terraform Playlist- BS      | Create a Spotify playlist using Terraform.  |

Copy and paste the URI below into the Redirect URI field, then click Add so that Spotify can discover its authorization application on port 27228 at the right location. Scroll to the bottom of the form and choose Save.
```sh
http://localhost:27228/spotify_callback
```
![image-1](https://github.com/user-attachments/assets/cbfdd324-0f4d-47b5-b3d8-0ee25f1c4ebd)

- To communicate with Spotify's API, you'll need a Client ID and Client Secret.

Once Spotify has created the application, locate and select the green Edit ```Settings``` icon in the upper right corner.
Note down the Client ID and Client Secret.



<!-- Copy the URI below into the Redirect URI field and click Add so that Spotify can find its authorization application locally on port 27228 at the correct path. Scroll to the bottom of the form and click Save.
Terraform Playlist- BS
Create a multiple playlist -->

![image-2](https://github.com/user-attachments/assets/ac922454-f03d-4f58-b619-f387cd50ca26)
![image-3](https://github.com/user-attachments/assets/29405788-fb88-4c18-956f-c305f93b4a96)
![image-4](https://github.com/user-attachments/assets/15e438c7-b0eb-4c95-bc7c-b49e281ea884)


+==========+
## <span style="color: Yellow;">Setting Up the Environment </span>
I have created a Terraform code to set up the entire environment, including the installation of required applications, tools and authorization proxy server. This server enables Terraform to interact with Spotify.

- [x] [Clone repository for terraform code](https://github.com/mrbalraj007/DevOps_free_Bootcamp/tree/main/16.Real-Time-DevOps-Project/Terraform_Code/Code_IAC_Terraform_box)<br>
  __Note__: Replace resource names and variables as per your requirement in terraform code
  - from spotify/.env (i.e store your Spotify application's Client ID and Secret:<br>
      ```bash
      SPOTIFY_CLIENT_ID=<your_spotify_client_id>
      SPOTIFY_CLIENT_SECRET=<your_spotify_client_secret>)
      ```
  - from spotify/playlist.tf (change the ```artist name```)    
  - from ```Code_IAC_Terraform_box```/main.tf (i.e keyname- ```MYLABKEY```*)
  
- &rArr; <span style="color: brown;"> EC2 machines will be created named as ```"Terraform-svr".```
- &rArr;<span style="color: brown;"> Docker Install

### <span style="color: Yellow;"> EC2 Instance creation

- To Create a Virtual machine ```Terraform-svr```. 

Below is a terraform configuration:

Once you [clone repo](https://github.com/mrbalraj007/DevOps_free_Bootcamp.git) then go to folder *<span style="color: cyan;">"16.Real-Time-DevOps-Project/Terraform_Code/Code_IAC_Terraform_box"</span>* and run the terraform command.
```bash
cd Terraform_Code/Code_IAC_Terraform_box

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
dar--l          23/10/24  11:49 AM                spotify
-a---l          29/09/24  10:44 AM            507 .gitignore
-a---l          21/10/24  10:47 PM           1866 main.tf
-a---l          16/07/21   4:53 PM           1696 MYLABKEY.pem
```

<!-- __<span style="color: Red;">Note__</span> &rArr; Make sure to run ```main.tf``` , not infrom inside the folders. -->

```bash
16.Real-Time-DevOps-Project/Terraform_Code/Code_IAC_Terraform_box/

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
dar--l          23/10/24  11:49 AM                spotify
-a---l          29/09/24  10:44 AM            507 .gitignore
-a---l          21/10/24  10:47 PM           1866 main.tf
-a---l          16/07/21   4:53 PM           1696 MYLABKEY.pem
```
You need to run ```main.tf``` file using following terraform command.

Now, run the following command.
```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply 
# Optional <terraform apply --auto-approve>
```

Once you run the terraform command, then we will verify the following things to make sure everything is setup via a terraform.

### <span style="color: Orange;"> Inspect the ```Cloud-Init``` logs</span>: 
Once connected to EC2 instance then you can check the status of the ```user_data``` script by inspecting the [log files]
```bash
# Primary log file for cloud-init
sudo tail -f /var/log/cloud-init-output.log
                    or 
sudo cat /var/log/cloud-init-output.log | more
```
- If the user_data script runs successfully, you will see output logs and any errors encountered during execution.
- If there’s an error, this log will provide clues about what failed.

- Outcome of "```cloud-init-output.log```"

![image-11](https://github.com/user-attachments/assets/ab0137bf-87c0-4356-ae50-81e8153d339a)

### <span style="color: cyan;"> Verify the Installation 

- [x] <span style="color: brown;"> Docker version
```bash
ubuntu@ip-172-31-95-197:~$ docker --version
Docker version 24.0.7, build 24.0.7-0ubuntu4.1

docker ps -a
ubuntu@ip-172-31-94-25:~$ docker ps
```
- [x] <span style="color: brown;"> Terraform version
```bash
ubuntu@ip-172-31-89-97:~$ terraform version
Terraform v1.9.6
on linux_amd64
```

When you review ```cloud-init-output.log``` then you will get the following outcomes.

```bash
0a5fcebc27b3   ghcr.io/conradludgate/spotify-auth-proxy   "/bin/spotify_auth_p…"   2 minutes ago   Up 2 minutes   0.0.0.0:27228->27228/tcp, :::27228->27228/tcp   zen_engelbart
Container logs for debugging:
APIKey:   G71jLPKnPQG_yaGmbLPfNYYtbeNnDW_0YuVzRSVAuWlAfw5DfUbNSohsTk3KJeRn
Auth URL: http://localhost:27228/authorize?token=uT4xo8nLCgdkX6M4tbyWikvbbf6CKj9c9-G-68Y37fkyzOI0DCKhxW8RfWh2oXqC
Debug: APIKey retrieved is 'G71jLPKnPQG_yaGmbLPfNYYtbeNnDW_0YuVzRSVAuWlAfw5DfUbNSohsTk3KJeRn'
APIKey successfully retrieved: G71jLPKnPQG_yaGmbLPfNYYtbeNnDW_0YuVzRSVAuWlAfw5DfUbNSohsTk3KJeRn
Updating terraform.tfvars with the retrieved APIKey...
To show container logs...
APIKey:   G71jLPKnPQG_yaGmbLPfNYYtbeNnDW_0YuVzRSVAuWlAfw5DfUbNSohsTk3KJeRn
Auth URL: http://localhost:27228/authorize?token=uT4xo8nLCgdkX6M4tbyWikvbbf6CKj9c9-G-68Y37fkyzOI0DCKhxW8RfWh2oXqC
ubuntu@Terraform-svr:~$
```
You have to copy the ```Auth URL``` and open it in the browser

The first time you run it, it will show you like this, but you have to run it again until you get successfully authenticated.
```bash
<http://<publicIPaddress of EC2 instance>:27228/authorize?token=uT4xo8nLCgdkX6M4tbyWikvbbf6CKj9c9-G-68Y37fkyzOI0DCKhxW8RfWh2oXqC>
# You should use your own token
```
```bash
http://54.210.254.122:27228/authorize?token=uT4xo8nLCgdkX6M4tbyWikvbbf6CKj9c9-G-68Y37fkyzOI0DCKhxW8RfWh2oXqC
```
![image-13](https://github.com/user-attachments/assets/4ee6f200-948f-4036-b1ac-e5ca76f2e684)

Now, again you have to type below in broser.
![image-12](https://github.com/user-attachments/assets/47ccac0a-0967-4b3a-a363-66155762f8ab)



**Note**&rArr; To get spotify provider info
```sh  
https://registry.terraform.io/providers/conradludgate/spotify/latest/docs
https://github.com/conradludgate/terraform-provider-spotify?tab=readme-ov-file
```
### <span style="color: Yellow;"> Create Terraform playlist

Now, go to folder ```spotify``` and initiate a terraform command 
```bash
cd spotify
ubuntu@Terraform-svr:~/spotify$ ls
MYLABKEY.pem  provider.tf  terraform.tfvars  variable.tf
ubuntu@Terraform-svr:~/spotify$
```
Now, run the following command.
```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply 
# Optional <terraform apply --auto-approve>
```



<!-- 

docker run --rm -it -p 27228:27228 --env-file .env ghcr.io/conradludgate/spotify-auth-proxy


```bash
ubuntu@Terraform-svr:~/spotify$ docker run --rm -it -p 27228:27228 --env-file .env ghcr.io/conradludgate/spotify-auth-proxy
Unable to find image 'ghcr.io/conradludgate/spotify-auth-proxy:latest' locally
latest: Pulling from conradludgate/spotify-auth-proxy
29291e31a76a: Pull complete
94079f231dbc: Pull complete
Digest: sha256:cf6d1f553df686882ec32589e835e48576faf39321fae476bcd0140ce6bc432a
Status: Downloaded newer image for ghcr.io/conradludgate/spotify-auth-proxy:latest
APIKey:   _cySQkTeAjy_ThRANjgwQof-P-PfCGNRJv2_hJsfVcmLQU5Hlzmc604ahaKPPHvm
Auth URL: http://localhost:27228/authorize?token=fh4-7D8JOmlmvHcmRMqBhycOJk1oy9zVN9URVqcCtTxVkYrvMrxP69ZwZ0Pgh-Pc
Authorization successful
``` -->
### <span style="color: Yellow;"> Verify Spotify playlist

Go to https://open.spotify.com/

You will see below playlist.

![image-8](https://github.com/user-attachments/assets/7d1ce1b5-ab75-41ab-9d4d-000edec6b4a8)
![image-9](https://github.com/user-attachments/assets/7b7832a9-1116-4732-bd2b-c3ddf77cc174)
![image-10](https://github.com/user-attachments/assets/0874a356-c52d-4fcc-9d6b-0ca750757de4)

<!-- Troubleshooting
```bash
Option 1: Find and Stop the Process Using Port 27228
You can find the process currently using port 27228 and stop it.

Check which process is using the port:

bash
Copy code
sudo lsof -i :27228
This will output the process ID (PID) of the process using the port.

Kill the process using the port:

bash
Copy code
sudo kill -9 <PID>
Replace <PID> with the process ID you found in the previous step.

Run your Docker container again:

bash
Copy code
sudo docker run --rm -it -p 27228:27228 --env-file .env ghcr.io/conradludgate/spotify-auth
```


```sh
Option 1: SSH Port Forwarding (Recommended)
You can use SSH port forwarding to forward the port from your EC2 instance to your local machine. This allows you to open the URL in your browser as if the service was running locally.

Open an SSH connection to your EC2 instance, forwarding port 27228:

bash
Copy code
ssh -i your-ec2-key.pem -L 27228:localhost:27228 ubuntu@your-ec2-public-ip
Replace:

your-ec2-key.pem with the path to your EC2 key file.
your-ec2-public-ip with the public IP address of your EC2 instance.

```bash
sudo ssh -i MYLABKEY.pem -L 27228:localhost:27228 ubuntu@54.210.254.122
```

Once connected, open your browser on your local machine and go to:

bash
Copy code
http://localhost:27228/authorize?token=8ZefkEoShF0_faUNBxKxGuD5Kdrwi8cvdFptouGSiqm5PLOOsZOynMGbMpncqMrj
Option 2: Open EC2 Security Group Port (Less Secure)
If port forwarding is not an option, you can modify your EC2 security group to allow inbound traffic to port 27228, making the URL accessible from your local machine.

In your AWS Console, navigate to EC2 > Security Groups.

Find the security group associated with your EC2 instance.

Edit the inbound rules and add a new rule:

Type: Custom TCP
Port: 27228
Source: Your IP (to restrict access to just your IP for security).
After saving the security group settings, access the URL from your local machine:

bash
Copy code
http://your-ec2-public-ip:27228/authorize?token=8ZefkEoShF0_faUNBxKxGuD5Kdrwi8cvdFptouGSiqm5PLOOsZOynMGbMpncqMrj
Remember to revert the security group changes after completing the authentication for security purposes.
```
 -->
Congratulations! :-) You have deployed the playlist using terraform successfully.


### <span style="color: Yellow;"> Resources used in AWS:
- EC2 instances

## <span style="color: Yellow;"> Environment Cleanup:
- As we are using Terraform, we will use the following command to delete 
   - __```Playlist```__ first 
   - then delete the __```virtual machine```__.

#### To delete ```Spotify playlist```
   -   Login into the Terraform EC2 instance and change the directory to /spotify, and run the following command to delete the playlist.
```bash
cd /spotify
sudo terraform destroy --auto-approve
```
#### Now, time to delete the ```Virtual machine```.
Go to folder *<span style="color: cyan;">"16.Real-Time-DevOps-Project/Terraform_Code/Code_IAC_Terraform_box"</span>* and run the terraform command.
```bash
cd Terraform_Code/Code_IAC_Terraform_box

$ ls -l
Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
da---l          26/09/24   9:48 AM                Code_IAC_Terraform_box

Terraform destroy --auto-approve
```


## <span style="color: Yellow;"> Conclusion

By using Terraform to manage your Spotify playlists, you not only automate a previously tedious process, but also receive significant hands-on experience with Infrastructure as Code. This project explains important Terraform principles while illustrating how IaC may be used beyond cloud infrastructure to common products such as Spotify. Whether you're new to Terraform or wanting to increase your automation abilities, this project provides a fun and useful method to improve your understanding of API connections and resource management. With reusable setups and automation at your fingertips, managing playlists has never been simpler!

Blog Reference:
For a detailed breakdown of the technical aspects, you can refer to the full technical blog post the user helped write. This blog covers the entire process step-by-step, ensuring smooth implementation of the project.

__Ref Link__

- [YouTube Link](https://www.youtube.com/watch?v=LjJLZRi_zGU&list=PLJcpyd04zn7p_nI0hoYRcqSqVS_9_eLaR&index=101)

- [Create a Spotify playlist with Terraform](https://developer.hashicorp.com/terraform/tutorials/community-providers/spotify-playlist)

- [Install Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)



