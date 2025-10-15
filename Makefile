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
	@git commit -m "Update site: $$(date +'%Y-%m-%d %H:%M:%S')" || echo "No changes to commit"
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
