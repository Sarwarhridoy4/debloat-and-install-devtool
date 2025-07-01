# 🧰 Dev Environment Setup & System Debloater for Debian-based Linux

This repository includes two powerful shell scripts to help you clean up and prepare your development system on Debian-based distributions (like Ubuntu, Linux Mint, etc.):

- `debloater.sh`: Removes unnecessary pre-installed apps and packages.
- `install_dev_tools.sh`: Installs essential tools such as Git, VS Code, Node.js (via fnm), and Postman — while cleaning up any existing versions first.

---

## 🚀 How to Use

### 1. Run the Debloater (Optional but Recommended)

This step removes bloatware and unwanted software from your system before setting up your dev tools.

```bash
chmod +x debloater.sh
sudo ./debloater.sh
```

````

⚠️ **Warning:** Review the script before running to make sure it won’t remove anything important to you.

---

### 2. Install Development Tools

This script will:

- **Remove** any existing versions of Git, VS Code, Node.js, and Postman.
- **Install** fresh copies of:

  - Git
  - Visual Studio Code (from Microsoft repository)
  - Node.js (via FNM – Fast Node Manager, installs version 23)
  - Postman (via Snap)

```bash
chmod +x install_dev_tools.sh
sudo ./install_dev_tools.sh
```

After running:

- Reload your shell with `source ~/.bashrc` or log out and back in.
- You can use Node via `fnm`, and all tools should be ready from the terminal or app launcher.

---

## 🧩 Requirements

These scripts are designed for Debian-based systems and require:

- `sudo` access
- Internet connection
- Snap support for Postman installation

---

## ✅ What's Installed

| Tool    | Version Source | Notes                                 |
| ------- | -------------- | ------------------------------------- |
| Git     | APT            | Latest version from the official repo |
| VS Code | Microsoft Repo | Installed from packages.microsoft.com |
| Node.js | fnm            | Installs Node.js v23 using fnm        |
| Postman | Snap           | Installed via Snap store              |

---

## 📁 File Structure

```
.
├── debloater.sh             # Optional: Removes bloatware
├── install_dev_tools.sh     # Main installer script for dev tools
└── README.md                # You're here!
```

---

## 📌 License

MIT License — free to use, modify, and distribute.

---

## 🙋 Need Help?

Open an issue or contact the maintainer if you run into problems or want to suggest improvements.

Happy Coding!

````
