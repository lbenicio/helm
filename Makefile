SHELL := /bin/bash
.PHONY: all help package lint test changelog

.DEFAULT_GOAL := help

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-14s\033[0m %s\n", $$1, $$2}'

all: lint test package ## Lint, test, and package all charts

package: ## Package charts and rebuild Helm index
	@rm -rf public && mkdir -p public
	@for chart in $$(ls -d charts/*/); do \
		echo "Packaging $$chart"; \
		helm package $$chart -d public ; \
	done
	@helm repo index public
	@cp landingpage/index.html public/
	@cp landingpage/style.css public/
	@cp landingpage/app.js public/
@	cp landingpage/artifacthub-repo.yml public/
	@echo "Charts packaged and index rebuilt"

lint: ## Lint charts (helm lint + kube-linter)
	@echo "Linting Helm charts..."
	@for chart in $$(ls -d charts/*/); do \
		echo "  $$chart"; \
		helm lint $$chart 2>&1; \
	done
	@echo "Running kube-linter on rendered templates..."
	@for chart in $$(ls -d charts/*/); do \
		echo "  $$chart"; \
		helm template $$chart | kube-linter lint - 2>&1 || true; \
	done

test: ## Run helm-unittest on all charts
	@echo "Running unit tests..."
	@for chart in $$(ls -d charts/*/); do \
		echo "  $$chart"; \
		helm unittest $$chart 2>&1; \
	done

changelog: ## Generate changelog (make changelog [--dry-run] <version>)
	@V=$$(echo $(filter-out $@,$(MAKECMDGOALS)) | sed 's/--dry-run//g' | tr -d '-'); \
	DRY=$$(echo $(filter-out $@,$(MAKECMDGOALS)) | grep -q '--dry-run' && echo '--dry-run' || echo ''); \
	if [ -z "$$V" ]; then echo "Usage: make changelog [--dry-run] 0.2.0"; exit 1; fi; \
	./scripts/changelog.sh $$DRY "$$V"

%:
	@:
