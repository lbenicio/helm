SHELL := /bin/bash
.PHONY: package lint

package:
	@rm -rf public && mkdir -p public
	@for chart in $$(ls -d charts/*/); do \
		echo "Packaging $$chart"; \
		helm package $$chart -d public ; \
	done
	@helm repo index public
	@cp index.html public/
	@echo "Charts packaged and index rebuilt"

lint:
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
