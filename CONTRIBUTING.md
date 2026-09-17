# Contributing to vbotka.freebsd

Thank you for your interest in contributing to the `vbotka.freebsd` Ansible
collection! Contributions of all kinds are welcome: bug reports, documentation
updates, feature requests, filter plugins, inventory plugins, connection
plugins, and bug fixes.

This document outlines the workflow and quality standards for contributing to
this project.

---

## Code of Conduct and Standards

- Be respectful, constructive, and collaborative.
- Keep changes atomic, focused, and well-documented.
- Follow standard Ansible and FreeBSD conventions.

---

## Reporting Issues & Feature Requests

Before submitting a new issue or feature request:

1. **Search Existing Issues:** Check both open and closed issues and pull
   requests on GitHub to avoid duplicates.
2. **Provide FreeBSD & Ansible Context:**
   - FreeBSD version (e.g., `freebsd-version -kru` or `uname -a`).
   - Ansible core version (`ansible --version`).
   - Python version and environment details.
3. **Provide a Minimal Reproducible Example:**
   - Include a concise playbook, role task snippet, or inventory excerpt that
     reproduces the behavior.
   - Include relevant output with `-v` or `-vvv` (ensure sensitive data like
     passwords or tokens are scrubbed).

---

## Development Setup

### 1. Fork and Clone

Clone your fork into your Ansible collection path structure so local testing and
development work seamlessly:

```bash
mkdir -p ~/.ansible/collections/ansible_collections/vbotka/
cd ~/.ansible/collections/ansible_collections/vbotka/
git clone \
  https://github.com/<your-username>/ansible-collection-freebsd.git freebsd
cd freebsd
git remote add upstream https://github.com/vbotka/ansible-collection-freebsd.git
```

### 2. Branching

Create a topic branch for your changes:

```bash
git checkout -b feature/my-new-feature
# or
git checkout -b fix/issue-description
```

---

## Coding Standards & Guidelines

### Ansible Roles, Tasks, and Modules

- **POSIX / FreeBSD Compatibility:** Ensure shell commands and scripts are
  compatible with FreeBSD `/bin/sh` and standard FreeBSD userland utilities
  (avoid GNU-specific coreutils flags unless verified or guarded).
- **Idempotency:** Tasks and modules must be idempotent whenever possible.
- **YAML Formatting:** Use 2 spaces for indentation. Quote strings when
  necessary (e.g., variables, template expressions, or reserved keywords).

### Python Plugins & Modules (Filters, Inventory, Connection)

- Follow **PEP 8** coding standards.
- Plugins and modules should maintain clean separation of concerns and avoid
  unnecessary third-party dependencies outside the standard library where
  possible (or document dependencies clearly).
- Maintain clear docstrings and Ansible `DOCUMENTATION`, `EXAMPLES`, and
  `RETURN` metadata blocks following standard Ansible collection documentation
  specs.

### Documentation

- Collection documentation is built and maintained using Sphinx and `antsibull-
  docs`.
- Keep documentation strings inside plugin source files accurate and up-to-date.
- Ensure changes render cleanly with Sphinx without syntax warnings or broken
  cross-references.

---

## Testing

Before submitting a pull request, run local verification:

1. **Ansible Lint & Syntax Check:**

```bash ansible-lint ```

2. **Sanity Testing:**

Run `ansible-test sanity` to catch licensing, formatting, and structural issues:

```bash
ansible-test sanity --docker # or natively on FreeBSD: ansible-test sanity
```

3. **Unit & Integration Tests:**

If your contribution includes custom plugins or filter logic, add or update
corresponding test cases (e.g., under `tests/unit/`).

---

## Licensing and SPDX Compliance

- This collection uses standard open-source licensing models complying with
  Ansible ecosystem standards (e.g., GPL-3.0-or-later for collection
  plugins/controllers, BSD-2-Clause for modules/independent components where
  applicable).
- All source files should include appropriate SPDX license identifiers and
  copyright notices:

```python
# SPDX-License-Identifier: GPL-3.0-or-later
```

or:

```python
# SPDX-License-Identifier: BSD-2-Clause
```

- By submitting a pull request, you agree that your contributions will be
  licensed under the project's existing license terms.

---

## Submitting Pull Requests

1. Keep commits clean, logical, and accompanied by meaningful commit messages.
2. Rebase onto the latest `master` branch before opening the PR:

```bash
git fetch upstream git rebase upstream/master
```

3. Open a Pull Request on GitHub:

   - Provide a clear summary of what changes were made and why.
   - Reference any relevant GitHub issue numbers (e.g., `Fixes #42`).
   - Confirm tests pass locally.

Thank you for helping improve FreeBSD automation with Ansible!
