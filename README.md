# Suspension Kinematics

This MATLAB script performs a kinematic sweep of a suspension system by moving the wheel center through a defined travel range and calculating key geometry values at each step.

### What It Computes
- Wheel vertical displacement  
- Camber  
- Caster  
- Toe (bump steer)  
- Mechanical trail  
- Scrub radius  
- Front and side instant centers  
- Anti-dive and anti-lift percentages  
- Roll center height (heave and roll)  
- Roll angle  

### What It Produces
- Plots for each kinematic metric

## How to Use

1. Open NX, right click the top header and click "Customize"
1. In the "Customize" window, select/drag "New user command" into your toolbar
1. Right click and choose `/src/main-nx.cs` file as the action file.
1. Run your action, on Success you should see a confirmation that a csv was generated.
1. *Optional:* confirm the file was creaetd by going to `C:\Users\<unique name>\Kinematic Points.csv`. Ensure the X-axis is oriented in the forward direction and the Y-axis is oriented in the left direction when facing forward.
1. Open Matlab and run `/src/main.m`. Make sure you set `USE_NX_DATA = true;`. This will tell the script to use the csv file you just generated. Double check the car configuration (CoG, Brake Bias) values.
1. *Optional:* If you also want to generate a PDF set `GENERATE_PDF = true;`. The PDF will appear in the root of the matlab project.

## Getting Started with Git/Gitlab

Follow these steps to set up Git, generate an SSH key, add your key to GitLab, and verify your connection.

### 1. Install Git

- Download and install git. You can follow the instructions [here](https://git-scm.com/install/).
- Default installation settings work fine.

### 2. Generate an SSH Key

See the GitLab SSH documentation here:  
https://gitlab.eecs.umich.edu/help/user/ssh.md

TL;DR: open Command Prompt/Terminal and run the following

```bash
cd
ssh-keygen -t ed25519 -C "<your umich email>"
# Press Enter to accept the default file path
# Press Enter twice for no passphrase (optional)
cat ~/.ssh/id_ed25519.pub
```

Copy the full output of the cat command — this is your public key.

### 3. Add SSH Key to GitLab
1. Open your browser and go to: `https://gitlab.eecs.umich.edu`
1. Sign in to GitLab.
1. On the left sidebar, click your **avatar**.
1. Select **Edit profile**.
1. In the left sidebar, select **SSH Keys**.
1. Click **Add new key**.
1. Paste your public key (generated in step 2) into the **Key** box.  
   Make sure you paste the *entire* key. It should start with one of:  
   `ssh-ed25519`, `ssh-rsa`, `ecdsa-sha2-nistp256`, `ecdsa-sha2-nistp384`, `ecdsa-sha2-nistp521`,  
   or a hardware-backed variant (`sk-ecdsa-sha2-nistp256@openssh.com`, `sk-ssh-ed25519@openssh.com`).  
   It may end with a comment (usually your email).
1. Enter a descriptive **Title** (e.g., `Work Laptop`, `Home Workstation`).
1. Click **Add key**.

### 5. Verify SSH access

You may need to be on the UMich VPN when using git/ssh. You can follow the instructions [here](https://its.umich.edu/enterprise/wifi-networks/vpn/getting-started) to install the vpn.

Back in Command Prompt/Terminal, run:
```bash
ssh -T git@gitlab.eecs.umich.edu
```

The first time, you may be asked
```
"Are you sure you want to continue connecting (yes/no)?"
```

Type yes and press Enter.

If everything is set up correctly, you should see a success message from GitLab.


## Basic Git Workflow (Beginner Friendly)

Follow these steps if you're new to Git and want to clone a repository, switch to a branch, make changes, and commit them.

### 1. Clone the Repository

Open Command Prompt and navigate to the folder where you want the project to live. I typically leave it in my home direcotry so run:

```
cd %USERPROFILE%
```

Clone this repository using SSH:

```
git clone git@gitlab.eecs.umich.edu:m-racing/libraries/suspension-kinematics.git
```

Move into the project folder:

```
cd suspension-kinematics
```


### 2. Check Out an Existing Branch

List all branches:

```
git branch
```


If its your first time working in the repo, create a new branch:

```
git checkout -b <new-branch-name>
```

If you have an existing branch with code changes on it, you can switch to it with:

```
git checkout <branch-name>
```

### 3. Make Changes

Edit files in your editor (VS Code, MATLAB, etc.).

After editing, check what changed:

```
git status
```


### 4. Stage Your Changes

This tells Git which changes you want to include in the next commit:

```
git add <file1> <file2>
```

Or stage everything:

```
git add .
```


### 5. Commit Your Changes

Write a clear, short message describing what you did:

```
git commit -m "Describe your change here"
```


### 6. Push Your Changes to the Branch

Push your commits to the remote branch:

```
git push
```

If it's a new branch, the first push may require:

```
git push --set-upstream origin <branch-name>
```


### 7. Optional: Pull Latest Changes

Before working each day, it's good practice to update your branch:

```
git pull
```

This ensures you're up to date with the latest changes.

## Important Notes
1. **Never commit directly to the `main` branch.**  
   The `main` branch is the “clean” version of the project.  
   Any changes you make should be done on a **new branch**.  
   After pushing your branch with `git push`, you can create a **Merge Request (MR)** on GitLab to merge your changes into `main`.

1. **Always create new branches *from* `main`.**  
   Before you make a new branch, switch to `main` first:  
   - Run `git branch` to see which branch you're on.  
   - If you're not on `main`, switch to it with:  
     ```
     git checkout main
     ``` 
   Then create your new branch:  
   ```
   git checkout -b <new-branch-name>
   ```

1. **Run `git pull` on `main` often.**  
   This updates your local copy so you don’t miss important changes other people made.  
   Do this regularly — especially before creating a new branch:  
   ```
   git pull
   ```
