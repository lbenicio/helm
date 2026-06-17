SHELL := /bin/bash
.PHONY: package lint lint-charts

package:
	@rm -f *.tgz index.yaml
	@for chart in $$(ls -d charts/*/); do \
		echo "Packaging $$chart"; \
		helm package $$chart -d . ; \
	done
	@helm repo index .
	@echo "Charts packaged and index rebuilt"

lint: lint-charts

lint-charts:
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
