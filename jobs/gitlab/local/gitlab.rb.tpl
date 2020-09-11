external_url '{{ env "attr.unique.hostname" }}'

gitlab_rails['object_store']['enabled'] = false
gitlab_rails['object_store']['connection'] = {}
gitlab_rails['object_store']['storage_options'] = {}
gitlab_rails['object_store']['proxy_download'] = false
gitlab_rails['object_store']['objects']['artifacts']['bucket'] = nil
gitlab_rails['object_store']['objects']['external_diffs']['bucket'] = nil
gitlab_rails['object_store']['objects']['lfs']['bucket'] = nil
gitlab_rails['object_store']['objects']['uploads']['bucket'] = nil
gitlab_rails['object_store']['objects']['packages']['bucket'] = nil
gitlab_rails['object_store']['objects']['dependency_proxy']['bucket'] = nil
gitlab_rails['object_store']['objects']['terraform_state']['bucket'] = nil

postgresql['enable'] = false
gitlab_rails['db_adapter'] = "postgresql"
gitlab_rails['db_encoding'] = "utf8"
gitlab_rails['db_collation'] = nil
gitlab_rails['db_database'] = "gitlab"
gitlab_rails['db_username'] = "gitlab"
gitlab_rails['db_password'] = "gitlab"
gitlab_rails['db_host'] = "{{ range service "gitlab-postgres" }}{{ .Address }}{{ end }}"
gitlab_rails['db_port'] = "{{ range service "gitlab-postgres" }}{{ .Port }}{{ end }}"
