# SPDX-FileCopyrightText: Copyright (c) 2026 Max Trunnikov
# SPDX-License-Identifier: MIT

.SHELLFLAGS := -e -o pipefail -c
.ONESHELL:
SHELL := bash
.PHONY: all test test-default test-with-arg test-baseline clean

all: test test-default test-with-arg test-baseline

test:
	output=$$(GITHUB_WORKSPACE='.' INPUT_ARGS=$$'xsl-packs/xsl-with-no-violations.xsl\nxsl-packs/xsl-with-some-violations.xsl' INPUT_SUPPRESS=$$'empty-content-in-instruction\nstarts-with-double-slash' INPUT_CONFIG='xsl-packs/all.xslint.yml' node index.js 2>&1 || true)
	echo "$$output"
	for expected in \
		"Processed files: 2" \
		"Defects found:" \
		"Directories and files to process: xsl-packs/xsl-with-no-violations.xsl, xsl-packs/xsl-with-some-violations.xsl"; \
	do \
		echo "$$output" | grep -q "$$expected" || (echo "Expected, but not found '$$expected'" && exit 1;) \
	done
	for absent in \
		"empty-content-in-instruction" \
        "starts-with-double-slash"; \
    do \
      	echo "$$output" | grep -q "$$absent" && (echo "Unexpected, but found '$$absent'" && exit 1;) \
    done
	echo "All assertions passed"

test-default:
	output=$$(GITHUB_WORKSPACE='.' node index.js 2>&1 || true)
	echo "$$output"
	for expected in \
		"Processed files: 2" \
		"Defects found:" \
		"Directories and files to process: ."; \
	do \
		echo "$$output" | grep -q "$$expected" || (echo "Expected, but not found '$$expected'" && exit 1;) \
	done
	echo "All assertions passed"

test-with-arg:
	output=$$(GITHUB_WORKSPACE='.' INPUT_ARGS=$$'xsl-packs/xsl-with-no-violations.xsl\nxsl-packs/xsl-with-some-violations.xsl' node index.js 2>&1 || true)
	echo "$$output"
	for expected in \
		"Processed files: 2" \
		"Defects found:" \
		"::warning file=" \
		"Directories and files to process: xsl-packs/xsl-with-no-violations.xsl, xsl-packs/xsl-with-some-violations.xsl"; \
	do \
		echo "$$output" | grep -q "$$expected" || (echo "Expected, but not found '$$expected'" && exit 1;) \
	done
	echo "All assertions passed"

test-baseline:
	dir=$$(mktemp -d)
	npx --yes "$$(grep -oE '@maxonfjvipon/xslint@[0-9.]+' index.js)" --baseline-write="$$dir/xslint-baseline.json" xsl-packs/xsl-with-some-violations.xsl
	env GITHUB_WORKSPACE='.' INPUT_ARGS='xsl-packs/xsl-with-some-violations.xsl' INPUT_BASELINE="$$dir/xslint-baseline.json" 'INPUT_MAX-WARNINGS=0' node index.js || (echo "Expected the baseline to absorb every recorded defect, but the run failed" && exit 1)
	echo "All assertions passed"
