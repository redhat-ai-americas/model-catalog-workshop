# 1. Create a model registry

<p align="center">
<a href="/docs/00-setup.md">Prev</a>
&nbsp;&nbsp;&nbsp;
<a href="/docs/02-configure-model-catalog.md">Next</a>
</p>

### Objectives

- Create a model registry with which users can interact.

### Rationale

- You will need separate model registries to keep track of models. In particular, any logical separation of projects will require separate model registries.

### Takeaways

* Model registries are straightforward to stand up
* You understand the auth requirements for MySQL to work with the model registry

## Steps

- [ ] Deploy the credential secrets needed by the database and model registry

      oc apply -f configs/01/database-creds.yaml

> Expected output
> 
> `secret/myregistry-registry created`\
> `secret/myregistry-mysql created`

- [ ] Deploy the MySQL database

> [!WARNING]
> Native password authentication is required for this step. For the version of MySQL we're using in this workshop, the command line argument is\
> `--default-authentication-plugin=mysql_native_password`

      oc apply -f configs/01/mysql.yaml

> Expected output
> 
> `persistentvolumeclaim/mysql created`\
> `service/mysql created`\
> `deployment.apps/mysql created`

- [ ] Verify the database is running and available

      oc get pods -n rhoai-model-registries -w

> Expected output
>
> `NAME                     READY   STATUS    RESTARTS   AGE`\
> `...`\
> `mysql-76cd95cc56-qsdfx   1/1     Running   0          7s`

- [ ] Deploy the model registry

      oc apply -f configs/01/model-registry.yaml

> Expected output
> 
> `secret/myregistry-registry created`

- [ ] Verify the model registry is running and available

      oc get pods -n rhoai-model-registries -w

> Expected output
>
> `NAME                         READY   STATUS    RESTARTS   AGE`\
> `...`\
> `myregistry-79699fbf6-rwlhx   2/2     Running   0          15s`

You can further validate the registry is working by finding the registry page in OpenShift AI.

![](/assets/empty-registry.png)

## Automation key (catch up)

- [ ] From this repository's root directory, run below command

```sh
./scripts/setup.sh -s 1
```

<p align="center">
<a href="/docs/00-setup.md">Prev</a>
&nbsp;&nbsp;&nbsp;
<a href="/docs/02-configure-model-catalog.md">Next</a>
</p>