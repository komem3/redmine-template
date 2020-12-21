# redmine+gcp template

## Required

- smtp credentials
- domain
- toolchain
  - terraform
  - gcloud
  - docker

## Initialize

1. set project

```shell
$ gcloud config set project ${taget-project}
```

2. activate services

```shell
$ ./script/activate.sh
```

3. edit sensitive.tfvars

- `project_id` project id
- `db_pass` password of database user used by redmine
- `project_id` gcp project id
- `redmine_admin` administor name for redmine
- `redmine_pass` administor password for redmine
- `db_pass` database password used by redmine
- `smtp_host` smtp host
- `smtp_port` port used for smtp
- `smtp_user` smtp user
- `smtp_pass` smtp password

4. initialize terraform

```
$ terraform init
```

5. create artifact_registry

```
$ terraform apply \
    -var "docker_tag=$(git hash-object ./docker/Dockerfile)" \
    -var-file ./sensitive.tfvars \
    -target google_artifact_registry_repository.redmine_repo
```

6. build and submit docker

```
$ ./docker_submit.sh $project_id
```

7. run terraform

```
$ terraform apply \
    -var "docker_tag=$(git hash-object ./docker/Dockerfile)" \
    -var-file ./sensitive.tfvars \
```

8. edit redminie_certificate.yml

Add your domain.

```
spec:
  domains:
    ## add domains
    - redmine.example.com
```

9. connect gke cluster

```shell
$ gcloud container clusters get-credentials redmine-cluster --region asia-northeast1
```

10. apply backend config (session setting)

```shell
$ kubectl apply -f ./kubectl/redmine_backendconfig.yml
```

11. create managed certificate

```shell
$ kubectl apply -f ./kubectl/redmine_certificate.yml
```

12. check global address

```shell
$ gcloud compute addresses describe redmine-address --global | grep address:
```

13. configure the DNS records for your domains to point to the IP address of the load balancer

14. check certificate status

```shell
$ kubectl describe managedcertificate redmine-certificate --namespace redmine-namespace
...
Spec:
  Domains:
    domain-name
Status:
  CertificateStatus: Active ← check
...
```

15. access your domain

https://yourdomain.example.com

## Recommended settings

https://redmine.jp/tech_note/first-step/admin/

## TODO

- [ ] github action

## Author

komem3

## Lisence

Copyright 2020 komem3

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
