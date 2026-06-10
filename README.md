<div align="center">

<img src="https://capsule-render.vercel.app/api?type=waving&color=0:00A651,100:004d25&height=200&section=header&text=DBMS%20Projects&fontSize=50&fontColor=ffffff&animation=fadeIn&fontAlignY=38&desc=Database%20Management%20Systems%20%7C%20Spring%202026&descAlignY=55&descSize=18" width="100%"/>

<br/>

![Students](https://img.shields.io/badge/Students-180%2B-00A651?style=for-the-badge&logo=github&logoColor=white)
![Subject](https://img.shields.io/badge/Subject-DBMS-004d25?style=for-the-badge&logo=mysql&logoColor=white)
![Semester](https://img.shields.io/badge/Semester-Spring%202026-00A651?style=for-the-badge&logo=academia&logoColor=white)
![University](https://img.shields.io/badge/Iqra%20University-Islamabad-004d25?style=for-the-badge&logo=graduation-cap&logoColor=white)

<br/>

> **"A well-structured database is the foundation of every great application."**

<br/>

</div>

---

## About This Repository

This is the official project submission repository for **Database Management Systems (DBMS)** — Spring 2026, Iqra University Islamabad.

All students are required to submit their semester projects here by following the contribution workflow below.

**Instructor:** Tayyaba Shehzad

---

## Repository Structure

```
dbms-projects-spring2026/
│
├── projects/
│   ├── _template/              ← Copy this folder
│   │   └── README.md
│   │
│   ├── ali-hassan-41600/       ← Your folder (name-rollno)
│   │   ├── README.md           ← Project description
│   │   ├── schema.sql          ← Database schema
│   │   ├── queries.sql         ← SQL queries
│   │   └── report.pdf          ← Project report (optional)
│   │
│   └── ...
│
└── README.md
```

---

## How to Submit Your Project

### Step 1 — Fork this repository

Click the **Fork** button on the top right of this page.
This creates your own copy of the repo.

### Step 2 — Clone your fork

```bash
git clone https://github.com/YOUR-USERNAME/dbms-projects-spring2026.git
cd dbms-projects-spring2026
```

### Step 3 — Create your branch

```bash
git checkout -b feature/your-name-rollno
```

Example:
```bash
git checkout -b feature/ali-hassan-41600
```

### Step 4 — Create your project folder

```bash
mkdir projects/ali-hassan-41600
cd projects/ali-hassan-41600
```

> **Important:** Folder name must be `your-name-rollno` — no spaces, use hyphens.

### Step 5 — Add your project files

Copy your project files into your folder:

```
projects/ali-hassan-41600/
├── README.md       ← What your project is about (required)
├── schema.sql      ← Your database schema
├── queries.sql     ← Your SQL queries
└── report.pdf      ← Project report (if any)
```

### Step 6 — Commit and push

```bash
git add .
git commit -m "feat: add project by ali-hassan-41600"
git push origin feature/ali-hassan-41600
```

### Step 7 — Create a Pull Request

1. Go to your forked repo on GitHub
2. Click **Compare & pull request**
3. Set **base repository** → `tayyabashehzad/dbms-projects-spring2026`
4. Set **base branch** → `main`
5. Add a title: `Project submission - Ali Hassan - 41600`
6. Click **Create pull request**

---

## Project Folder README Template

Inside your folder, create a `README.md` with this structure:

```markdown
# Project Title

**Student Name:** Ali Hassan
**Roll Number:** 41600
**Section:** BSSE-4A

## Project Description
Brief description of your project.

## Database Design
- Tables: Users, Orders, Products...
- Relationships: One-to-many, Many-to-many...

## How to Run
Steps to set up and run your project.
```

---

## Submission Checklist

Before submitting your PR, make sure:

- [ ] Folder name is `your-name-rollno` (no spaces)
- [ ] `README.md` is included inside your folder
- [ ] SQL files are properly formatted
- [ ] PR title includes your name and roll number
- [ ] Base branch is set to `main`

---

## Common Mistakes to Avoid

| Wrong | Right |
|---|---|
| Pushing directly to main | Create a branch first |
| Empty folder | Add all project files |
| Missing README | Include README.md |
| Wrong folder name | Use `name-rollno` format |
| PR to wrong branch | Always target `main` |

---

<div align="center">

<img src="https://capsule-render.vercel.app/api?type=waving&color=0:004d25,100:00A651&height=120&section=footer&animation=fadeIn" width="100%"/>

**© 2026 Iqra University Islamabad — Database Management Systems**

*Tayyaba Shehzad*

</div>
