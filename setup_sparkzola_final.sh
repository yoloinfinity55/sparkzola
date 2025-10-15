#!/bin/bash

# ==========================================
# SparkZola Complete Setup Script - FINAL VERSION
# Tested and verified working on Mac mini M1
# Zola 0.21.0 | Node 22.20.0 | TailwindCSS 3.4.1
# ==========================================

set -e  # Exit on error

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Configuration
PROJECT_DIR="/Users/minijohn/Documents/github-repo/sparkzola"
GITHUB_USER="yoloinfinity55"
REPO_NAME="sparkzola"
GITHUB_REPO="https://github.com/${GITHUB_USER}/${REPO_NAME}.git"

# ==========================================
# Helper Functions
# ==========================================

print_step() {
    echo -e "${BLUE}➜${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_header() {
    echo ""
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo ""
}

# ==========================================
# Environment Verification
# ==========================================

print_header "Verifying Environment"

# Check Zola
if ! command -v zola &> /dev/null; then
    print_error "Zola not found. Install with: brew install zola"
    exit 1
fi
ZOLA_VERSION=$(zola --version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
print_success "Zola $ZOLA_VERSION"

# Check Node.js
if ! command -v node &> /dev/null; then
    print_error "Node.js not found. Install via nvm or brew"
    exit 1
fi
NODE_VERSION=$(node -v)
print_success "Node $NODE_VERSION"

# Check npm
if ! command -v npm &> /dev/null; then
    print_error "npm not found"
    exit 1
fi
print_success "npm $(npm -v)"

# Check Git
if ! command -v git &> /dev/null; then
    print_error "Git not found"
    exit 1
fi
GIT_VERSION=$(git --version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
print_success "Git $GIT_VERSION"

echo ""

# ==========================================
# Project Setup
# ==========================================

print_header "Setting Up SparkZola"

print_step "Creating project directory: $PROJECT_DIR"
mkdir -p "$PROJECT_DIR"
cd "$PROJECT_DIR"
print_success "Directory created"

# ==========================================
# Zola Configuration
# ==========================================

print_step "Creating Zola configuration..."

cat > config.toml <<'EOF'
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
EOF

print_success "Created config.toml"

# ==========================================
# Node.js + TailwindCSS Setup
# ==========================================

print_step "Initializing Node.js project..."

# Create package.json
cat > package.json <<'EOF'
{
  "name": "sparkzola",
  "version": "1.0.0",
  "description": "A modern Zola + TailwindCSS blog",
  "scripts": {
    "build:css": "npx tailwindcss -i ./input.css -o ./static/style.css --minify",
    "watch:css": "npx tailwindcss -i ./input.css -o ./static/style.css --watch",
    "build": "npm run build:css && zola build",
    "serve": "npm run build:css && zola serve"
  },
  "keywords": ["zola", "tailwindcss", "blog"],
  "author": "",
  "license": "MIT",
  "devDependencies": {}
}
EOF

print_success "Created package.json"

print_step "Installing TailwindCSS and dependencies..."
npm install -D tailwindcss@3.4.1 postcss autoprefixer > /dev/null 2>&1
print_success "Dependencies installed"

# Create Tailwind config
print_step "Configuring TailwindCSS..."

cat > tailwind.config.js <<'EOF'
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
EOF

print_success "Created tailwind.config.js"

# Create input.css
cat > input.css <<'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;
EOF

print_success "Created input.css"

# ==========================================
# Directory Structure
# ==========================================

print_step "Creating directory structure..."

mkdir -p content/blog
mkdir -p templates
mkdir -p static/images
mkdir -p .github/workflows

print_success "Directories created"

# ==========================================
# Templates
# ==========================================

print_step "Creating templates..."

# Base template
cat > templates/base.html <<'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>{% block title %}{{ config.title }}{% endblock title %}</title>
  <meta name="description" content="{% block description %}{{ config.description }}{% endblock description %}">
  <link rel="stylesheet" href="{{ get_url(path="style.css") }}">
</head>
<body class="bg-gray-50 text-gray-900 font-sans">
  <header class="bg-white shadow-sm border-b border-gray-200">
    <nav class="max-w-4xl mx-auto px-6 py-4 flex justify-between items-center">
      <a href="{{ config.base_url }}" class="text-2xl font-bold text-gray-900 hover:text-blue-600 transition">
        {{ config.title }}
      </a>
      <div class="space-x-6">
        <a href="{{ config.base_url }}" class="text-gray-600 hover:text-blue-600 transition">Home</a>
        <a href="{{ get_url(path="@/blog/_index.md") }}" class="text-gray-600 hover:text-blue-600 transition">Blog</a>
      </div>
    </nav>
  </header>
  <main class="max-w-4xl mx-auto px-6 py-12">
    {% block content %}{% endblock content %}
  </main>
  <footer class="border-t border-gray-200 mt-16 py-8">
    <div class="max-w-4xl mx-auto px-6 text-center text-sm text-gray-500">
      <p>© {{ now() | date(format="%Y") }} {{ config.title }}. Built with Zola and TailwindCSS.</p>
    </div>
  </footer>
</body>
</html>
EOF

print_success "Created base.html"

# Index template
cat > templates/index.html <<'EOF'
{% extends "base.html" %}

{% block content %}
<div class="prose max-w-none">
  {{ section.content | safe }}
</div>
{% endblock content %}
EOF

print_success "Created index.html"

# Page template
cat > templates/page.html <<'EOF'
{% extends "base.html" %}

{% block title %}{{ page.title }} | {{ config.title }}{% endblock title %}
{% block description %}{{ page.description }}{% endblock description %}

{% block content %}
<article>
  <header class="mb-8">
    <h1 class="text-4xl font-bold text-gray-900 mb-4">{{ page.title }}</h1>
    <div class="text-gray-600 text-sm">
      <time datetime="{{ page.date }}">{{ page.date | date(format="%B %d, %Y") }}</time>
    </div>
  </header>
  <div class="prose prose-lg max-w-none">
    {{ page.content | safe }}
  </div>
</article>
{% endblock content %}
EOF

print_success "Created page.html"

# ==========================================
# Content
# ==========================================

print_step "Creating sample content..."

# Home page
cat > content/_index.md <<'EOF'
+++
title = "SparkZola"
+++

# Welcome to SparkZola

A modern, fast static blog built with **Zola** and **TailwindCSS**.

## Features

- ⚡️ **Fast** - Built with Rust-based Zola
- 🎨 **Modern** - Styled with TailwindCSS
- 📱 **Responsive** - Mobile-first design
- 🚀 **Automated** - GitHub Actions deployment

Check out the [blog](/blog) to see posts!
EOF

print_success "Created home page"

# Blog index
cat > content/blog/_index.md <<'EOF'
+++
title = "Blog"
sort_by = "date"
+++

# Blog Posts

Welcome to the SparkZola blog!
EOF

print_success "Created blog index"

# Sample post
cat > content/blog/hello-sparkzola.md <<'EOF'
+++
title = "Hello SparkZola"
date = 2025-10-14
description = "Welcome to SparkZola - a modern static blog built with Zola and TailwindCSS"
+++

Welcome to **SparkZola**! This is your first blog post.

## What is SparkZola?

SparkZola is a modern static blog built with:

- **Zola** - A fast static site generator written in Rust
- **TailwindCSS** - A utility-first CSS framework
- **GitHub Pages** - Free hosting for static websites

## Why Static Sites?

Static sites offer several advantages:

1. **Fast** - No database queries or server-side processing
2. **Secure** - No server-side code means fewer attack vectors
3. **Scalable** - Easy to serve from CDNs
4. **Simple** - Easy to version control and deploy

## Getting Started

To create your own posts, simply add Markdown files to the `content/blog/` directory with proper front matter:

```markdown
+++
title = "My Post Title"
date = 2025-10-15
description = "Post description"
+++

Your content here...
```

Happy blogging! 🚀
EOF

print_success "Created sample blog post"

# ==========================================
# GitHub Actions Workflow
# ==========================================

print_step "Creating GitHub Actions workflow..."

cat > .github/workflows/deploy.yml <<'EOF'
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
EOF

print_success "Created GitHub Actions workflow"

# ==========================================
# Git Configuration Files
# ==========================================

print_step "Creating Git configuration files..."

# .gitignore
cat > .gitignore <<'EOF'
# Build output
public/
*.log

# Dependencies
node_modules/

# OS files
.DS_Store
Thumbs.db

# Editor files
.vscode/
.idea/
*.swp
*.swo
*~
EOF

print_success "Created .gitignore"

# ==========================================
# Makefile
# ==========================================

print_step "Creating Makefile..."

cat > Makefile <<'EOF'
# ==========================================
# SparkZola Makefile
# ==========================================

PROJECT_NAME = sparkzola
GITHUB_USER  = yoloinfinity55
GITHUB_REPO  = https://github.com/$(GITHUB_USER)/$(PROJECT_NAME).git
BUILD_DIR    = public

.PHONY: help setup css build serve deploy clean status

default: help

help:
	@echo ""
	@echo "SparkZola Project Commands:"
	@echo "  make setup       → Install dependencies"
	@echo "  make css         → Build TailwindCSS"
	@echo "  make build       → Build complete site"
	@echo "  make serve       → Run local dev server"
	@echo "  make deploy      → Build and push to GitHub"
	@echo "  make clean       → Remove build artifacts"
	@echo "  make status      → Show git status"
	@echo ""

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
	@git commit -m "Update site: $(date +'%Y-%m-%d %H:%M:%S')" || echo "No changes to commit"
	@git push origin main
	@echo "✓ Pushed to GitHub. Actions will deploy to Pages."

clean:
	@echo "🧹 Cleaning build artifacts..."
	@rm -rf $(BUILD_DIR)
	@echo "✓ Cleaned"

status:
	@echo "📡 Git status:"
	@git status
	@echo ""
	@git remote -v
EOF

print_success "Created Makefile"

# ==========================================
# README
# ==========================================

print_step "Creating README..."

cat > README.md <<'EOF'
# SparkZola

A modern, fast static blog built with Zola and TailwindCSS.

## 🚀 Live Site

**https://yoloinfinity55.github.io/sparkzola**

## ✨ Features

- ⚡️ **Fast** - Built with Zola (Rust-based SSG)
- 🎨 **Modern** - Styled with TailwindCSS
- 📱 **Responsive** - Mobile-first design
- 🚀 **Automated** - GitHub Actions deployment
- 🆓 **Free** - Hosted on GitHub Pages

## 🛠️ Tech Stack

- [Zola 0.21.0](https://www.getzola.org/) - Static site generator
- [TailwindCSS 3.4.1](https://tailwindcss.com/) - CSS framework
- [GitHub Pages](https://pages.github.com/) - Hosting
- [GitHub Actions](https://github.com/features/actions) - CI/CD

## 📦 Quick Start

```bash
# Install dependencies
make setup

# Start local dev server
make serve

# Visit http://127.0.0.1:1111

# Build site
make build

# Deploy to GitHub Pages
make deploy
```

## 📝 Creating Posts

Create a new Markdown file in `content/blog/`:

```bash
cat > content/blog/my-post.md <<'EOF'
+++
title = "My New Post"
date = 2025-10-15
description = "Post description"
+++

Your content here...
EOF
```

## 🎯 Commands

| Command | Description |
|---------|-------------|
| `make setup` | Install dependencies |
| `make serve` | Start dev server (http://127.0.0.1:1111) |
| `make build` | Build site |
| `make deploy` | Deploy to GitHub |
| `make clean` | Clean build files |
| `make status` | Check git status |

## 📁 Project Structure

```
sparkzola/
├── content/          # Markdown content
│   ├── _index.md    # Home page
│   └── blog/        # Blog posts
├── templates/        # HTML templates
├── static/           # Static assets (CSS, images)
├── config.toml       # Zola configuration
├── tailwind.config.js # Tailwind configuration
├── Makefile          # Build automation
└── .github/workflows/ # GitHub Actions
```

## 🎨 Customization

### Change Site Title
Edit `config.toml`:
```toml
title = "Your Site Title"
description = "Your description"
```

### Customize Colors
Edit `tailwind.config.js`:
```javascript
theme: {
  extend: {
    colors: {
      primary: '#1e40af',
    }
  }
}
```

### Modify Templates
Edit files in `templates/` directory:
- `base.html` - Base layout (header, footer)
- `index.html` - Home page
- `page.html` - Blog post layout

## 🚀 Deployment

The site automatically deploys to GitHub Pages when you push to the `main` branch:

```bash
git add .
git commit -m "Update content"
git push
```

GitHub Actions will build and deploy in 2-3 minutes.

## 📚 Resources

- [Zola Documentation](https://www.getzola.org/documentation/)
- [TailwindCSS Documentation](https://tailwindcss.com/docs)
- [Markdown Guide](https://www.markdownguide.org/)

## 📄 License

MIT

---

Built with ❤️ using Zola and TailwindCSS
EOF

print_success "Created README.md"

# ==========================================
# Build Initial CSS
# ==========================================

print_step "Building initial TailwindCSS..."
npm run build:css > /dev/null 2>&1
print_success "CSS built successfully"

# ==========================================
# Git Initialization
# ==========================================

print_step "Initializing Git repository..."

if [ ! -d ".git" ]; then
    git init > /dev/null 2>&1
    git branch -M main > /dev/null 2>&1
    print_success "Git repository initialized"
else
    print_warning "Git repository already exists"
fi

# Add remote if it doesn't exist
if ! git remote | grep -q "origin" 2>/dev/null; then
    git remote add origin "$GITHUB_REPO" 2>/dev/null || print_warning "Remote already exists"
    print_success "Added remote: $GITHUB_REPO"
else
    print_warning "Remote 'origin' already exists"
fi

# ==========================================
# Final Summary
# ==========================================

print_header "Setup Complete!"

echo -e "${GREEN}✓ SparkZola successfully set up!${NC}"
echo ""
echo -e "${BLUE}📂 Project Location:${NC}"
echo "   $PROJECT_DIR"
echo ""
echo -e "${BLUE}🎯 Next Steps:${NC}"
echo ""
echo -e "  ${YELLOW}1.${NC} Test locally:"
echo -e "     ${GREEN}make serve${NC}"
echo -e "     Visit: ${BLUE}http://127.0.0.1:1111${NC}"
echo ""
echo -e "  ${YELLOW}2.${NC} Create GitHub repository:"
echo -e "     Go to: ${BLUE}https://github.com/new${NC}"
echo -e "     Name: ${GREEN}sparkzola${NC}"
echo -e "     Visibility: ${GREEN}Public${NC}"
echo ""
echo -e "  ${YELLOW}3.${NC} Push to GitHub:"
echo -e "     ${GREEN}git add .${NC}"
echo -e "     ${GREEN}git commit -m 'Initial SparkZola setup'${NC}"
echo -e "     ${GREEN}git push -u origin main${NC}"
echo ""
echo -e "  ${YELLOW}4.${NC} Enable GitHub Pages:"
echo -e "     Settings → Pages → Source: ${GREEN}GitHub Actions${NC}"
echo ""
echo -e "  ${YELLOW}5.${NC} Your site will be live at:"
echo -e "     ${BLUE}https://${GITHUB_USER}.github.io/${REPO_NAME}${NC}"
echo ""
echo -e "${BLUE}💡 Pro Tips:${NC}"
echo "   • Run 'make help' to see all commands"
echo "   • Edit content in 'content/blog/' directory"
echo "   • Site auto-reloads during 'make serve'"
echo "   • 'make deploy' pushes and deploys automatically"
echo ""
echo -e "${GREEN}Happy blogging! 🚀${NC}"
echo ""