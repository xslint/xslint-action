# SPDX-FileCopyrightText: Copyright (c) 2026 Max Trunnikov
# SPDX-License-Identifier: MIT

.SHELLFLAGS := -e -o pipefail -c
.ONESHELL:
SHELL := bash
.PHONY: all test test-default test-with-arg clean

all: test test-default test-with-arg

test:
	output=$$(GITHUB_WORKSPACE='.' INPUT_ARGS=$$'xsl-packs/xsl-with-no-violations.xsl\nxsl-packs/xsl-with-some-violations.xsl' INPUT_SUPPRESS=$$'empty-content-in-instruction\nstarts-with-double-slash' node index.js 2>&1 || true)
	echo "$$output"
	for expected in \
		"Processed files: 2" \
		"Defects found: 12" \
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
		"Defects found: 15" \
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
		"Defects found: 15" \
		"::warning file=" \
		"Directories and files to process: xsl-packs/xsl-with-no-violations.xsl, xsl-packs/xsl-with-some-violations.xsl"; \
	do \
		echo "$$output" | grep -q "$$expected" || (echo "Expected, but not found '$$expected'" && exit 1;) \
	done
	echo "All assertions passed"
