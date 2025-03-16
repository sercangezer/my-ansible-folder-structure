# ANSIBLE için kullandığım dosya yapısı

* `ansible.cfg` dosyamızı oluşturalım.

```yaml
[defaults]
inventory=hosts
ask_pass=false
interpreter_python=auto_silent
#Playbook summary açmak için
callbacks_enabled=ansible.posix.profile_tasks, ansible.posix.timer
deprecation_warnings = False
roles_path=roles/
#Collection Path
collections_paths = collections/

[privilege_escalation]
become=false
become_user=root
become_ask_pass=false
become_method=sudo

[ssh_connection]
ssh_args=-o ControlMaster=auto -o ServerAliveInterval=60 -o ControlPersist=60s -o ControlPath=/tmp/ansible-ssh-%h-%p-%r

[callback_profile_tasks]
#Playbook summary'de görevleri sırasına göre listeler
sort_order = none
```

* `.ansible-lint` dosyamız

```yaml
exclude_paths:
  - collections/*
```

* `.github/workflows/ansible_lint.yaml` dosyamız

```yaml
name: Ansible Lint

"on":
  pull_request:
    paths:
      - '**/*.yml'
      - '**/*.yaml'

  push:
    branches:
      - main
      - 'feature/*'
    paths:
      - '**/*.yml'
      - '**/*.yaml'

jobs:
  lint:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v2

      - name: Run Ansible Lint
        uses: ansible/ansible-lint-action@v6
        with:
          path: .

```