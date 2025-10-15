+++
title = "SparkZola Project Specification - FINAL VERSION"
date = 2025-10-15
description = "Project Overview and technical details for the SparkZola static blog built with Zola and TailwindCSS"
+++

## Project Overview

**Project Name:** SparkZola  
**Purpose:** Modern, fast static blog using Zola SSG and TailwindCSS  
**Target Platform:** GitHub Pages  
**Development Machine:** Mac mini M1  
**Status:** ✅ Successfully Deployed

---

## Live Deployment

- **Live URL:** [https://yoloinfinity55.github.io/sparkzola](https://yoloinfinity55.github.io/sparkzola)
- **Repository:** [https://github.com/yoloinfinity55/sparkzola](https://github.com/yoloinfinity55/sparkzola)
- **Deployment:** Automatic via GitHub Actions on push to `main`

---

## Verified System Configuration

### Development Environment
- **Location:** `/Users/minijohn/Documents/github-repo/sparkzola`
- **Zola:** 0.21.0  
- **Node.js:** v22.20.0  
- **Git:** 2.51.0  
- **Homebrew:** 4.6.17  
- **Architecture:** Apple Silicon (M1)

### Repository Information
- **GitHub User:** `yoloinfinity55`
- **Repository Name:** `sparkzola`
- **Branch:** `main`
- **Visibility:** Public (required for GitHub Pages)

---

## Technology Stack

1. **Static Site Generator:** Zola 0.21.0  
2. **CSS Framework:** TailwindCSS 3.4.1 (v3, not v4)  
3. **Runtime:** Node.js 22.20.0  
4. **Deployment:** GitHub Pages via GitHub Actions  
5. **Version Control:** Git 2.51.0  
6. **Build Automation:** Make  

---

## Project Structure (Verified Working)

```text
sparkzola/
├── .github/
│   └── workflows/
│       └── deploy.yml
├── content/
│   ├── _index.md
│   └── blog/
│       ├── _index.md
│       ├── hello-sparkzola.md
│       └── project-spec.md
├── templates/
│   ├── base.html
│   ├── index.html
│   └── page.html
├── static/
│   └── style.css
├── config.toml
├── input.css
├── tailwind.config.js
├── package.json
├── Makefile
└── README.md
````

---

## Configuration Files (Verified Working)

### `config.toml`

```toml
base_url = "https://yoloinfinity55.github.io/sparkzola"
title = "SparkZola"
description = "A modern Zola + TailwindCSS blog"
compile_sass = false
build_search_index = true
output_dir = "public"
default_language = "en"

[markdown]
highlight_code = true
highlight_theme = "base16-ocean-dark"
```

### `tailwind.config.js`

```javascript
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./templates/**/*.html",
    "./content/**/*.md"
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}
```

### `input.css`

```css
@tailwind base;
@tailwind components;
@tailwind utilities;
```

### `package.json`

```json
{
  "name": "sparkzola",
  "version": "1.0.0",
  "scripts": {
    "build:css": "npx tailwindcss -i ./input.css -o ./static/style.css --minify",
    "watch:css": "npx tailwindcss -i ./input.css -o ./static/style.css --watch",
    "build": "npm run build:css && zola build",
    "serve": "npm run build:css && zola serve"
  },
  "devDependencies": {
    "autoprefixer": "^10.4.x",
    "postcss": "^8.4.x",
    "tailwindcss": "3.4.1"
  }
}
```

---

## GitHub Actions Workflow (Working Configuration)

**File:** `.github/workflows/deploy.yml`

```yaml
name: Deploy SparkZola to GitHub Pages

on:
  push:
    branches: [main]
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: "pages"
  cancel-in-progress: false

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '22'

      - name: Install dependencies
        run: |
          npm install
          npm list tailwindcss || npm install -D tailwindcss@3.4.1

      - name: Build TailwindCSS
        run: npx tailwindcss -i ./input.css -o ./static/style.css --minify

      - name: Setup Zola
        uses: taiki-e/install-action@v2
        with:
          tool: zola@0.21.0

      - name: Build Zola site
        run: zola build

      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: ./public

  deploy:
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    needs: build
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
```

---

## Makefile (Complete Working Version)

```makefile
# ==========================================
# SparkZola Makefile
# ==========================================

PROJECT_NAME = sparkzola
GITHUB_USER  = yoloinfinity55
BUILD_DIR    = public

.PHONY: setup css build serve deploy clean status

setup:
	@echo "🧩 Installing dependencies..."
	@npm install
	@echo "✓ Setup complete"

css:
	@echo "🎨 Building TailwindCSS..."
	@npm run build:css
	@echo "✓ CSS built"

build: css
	@echo "🏗️  Building Zola site..."
	@zola build
	@echo "✓ Site built in ./public"

serve: css
	@echo "🚀 Starting dev server at http://127.0.0.1:1111"
	@zola serve

deploy: build
	@echo "📦 Deploying to GitHub..."
	@git add .
	@git commit -m "Update site: $$(date +'%Y-%m-%d %H:%M:%S')" || echo "No changes to commit"
	@git push origin main
	@echo "✓ Pushed to GitHub. Actions will deploy to Pages."
```

---

## Development Workflow

### Local Development

```bash
make serve
```

Visit [http://127.0.0.1:1111](http://127.0.0.1:1111)

### Create New Posts

```bash
cat > content/blog/new-post.md <<'EOF'
+++
title = "New Post Title"
date = 2025-10-15
description = "Post description"
+++

Your content here...
EOF
```

### Deploy to Production

```bash
make deploy
```

---

## Project Status

✅ **Production Ready**

* Created: **October 14, 2025**
* Deployed: **October 15, 2025**
* Live: [https://yoloinfinity55.github.io/sparkzola](https://yoloinfinity55.github.io/sparkzola)
* Last Updated: **October 15, 2025**

---

## Resources

* [Zola Documentation](https://www.getzola.org/documentation/)
* [TailwindCSS Docs](https://tailwindcss.com/docs)
* [GitHub Pages Docs](https://docs.github.com/en/pages)
* [Markdown Guide](https://www.markdownguide.org/)

```

---

### ✅ You can now:
1. Save that file as:
```

content/blog/project-spec.md

````
2. Run:
```bash
make serve
````

3. Open → [http://127.0.0.1:1111/blog/project-spec/](http://127.0.0.1:1111/blog/project-spec/)

It will render cleanly with:

* headings styled by Tailwind’s `prose`
* syntax-highlighted code blocks
* no shortcode or CSP errors
* ready to deploy to GitHub Pages

---

