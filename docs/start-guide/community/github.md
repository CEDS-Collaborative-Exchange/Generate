---
icon: github
layout:
  title:
    visible: true
  description:
    visible: false
  tableOfContents:
    visible: true
  outline:
    visible: true
  pagination:
    visible: true
---

# GitHub

## How to Download Generate from GitHub

This guide will walk you through the steps to download the “Generate” project from GitHub using three different methods: GitHub UI, Visual Studio Code (VSCode), and SQL Server Management Studio (SSMS).

***

### GitHub UI

1. **Navigate to the Repository**
   * Open your web browser and go to the GitHub repository URL for “Generate”.
2. **Clone or Download**
   * Click on the green **Code** button.
   * You will see options to **Clone** or **Download ZIP**.
   * To clone, copy the URL provided.
   * To download, click on **Download ZIP** and save the file to your desired location.
3. **Extract the ZIP File**
   * If you downloaded the ZIP file, extract it to access the project files.

***

### VSCode

1. **Open VSCode**
   * Launch Visual Studio Code on your computer.
2. **Open Command Palette**
   * Press `Ctrl+Shift+P` (Windows/Linux) or `Cmd+Shift+P` (Mac) to open the Command Palette.
3. **Clone Repository**
   * Type `Git: Clone` and select the option.
   * Paste the repository URL for “Generate” and press `Enter`.
4. **Select Destination**
   * Choose a directory where you want to clone the repository.
5. **Open the Project**
   * Once the cloning is complete, open the cloned directory in VSCode.

***

### SSMS

1. **Open SSMS**
   * Launch SQL Server Management Studio on your computer.
2. **Open Command Prompt**
   * Go to `Tools` > `External Tools` and add a new tool for Command Prompt if not already available.
3. **Clone Repository**
   * Open Command Prompt from SSMS.
   * Navigate to the directory where you want to clone the repository using the `cd` command.
   * Run the command: `git clone <repository URL>`.
4. **Access the Files**
   * Navigate to the cloned directory to access the project files.
