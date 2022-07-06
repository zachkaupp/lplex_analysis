# Repository Management

`lplex_analysis` is hosted in a GitHub repository at:

{% embed url="https://github.com/zachkaupp/lplex_analysis" %}

* This repository on GitHub only has the source code to perform the analysis, and to run the code, you need to copy the repository to your computer

To copy (clone) the repository, open terminal (or command prompt) and paste the following command:

```
git clone https://github.com/zachkaupp/lplex_analysis.git
```

* You must have `git` installed to run this command (`git` is already installed on most computers)

The command above will have copied the repository from GitHub into a folder within the working directory of your terminal, and to navigate to that new folder within terminal and open it in a GUI, run one of the following sets of commands (one line at a time):

```
cd lplex_analysis
open .
```

* Use the above for Mac

```
cd lplex_analysis
start .
```

* Use the above for Windows

Now, many of the folders and files mentioned in the documentation are visible, including the `data`, `output`, and `scripts` folders

#### To update your local repository with updates

When the repository on GitHub gets updated, the repository on your computer won't have those changes

To update your local repository with the changes, run the following commands in terminal or command prompt (one line at a time)

```
git reset --hard
git pull origin main
```

* These commands must be run inside your local repository. In order to make sure your terminal is at the right location, you can right click on the repository folder (`lplex_analysis`), and select `New Terminal at Folder`
