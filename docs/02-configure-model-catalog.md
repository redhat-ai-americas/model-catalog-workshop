# 2. Add a custom model catalog

<p align="center">
<a href="/docs/01-add-model-registry.md">Prev</a>
&nbsp;&nbsp;&nbsp;
<a href="/docs/03-register-from-catalog.md">Next</a>
</p>

### Objectives

- Create a custom model catalog where you can add your own preferred models.

### Rationale

- You may want to enable your own models in the catalog (separate from the registry) for users to deploy at will. This methodology enables you to do that.

### Takeaways

* Model catalogs are controlled by the `model-catalog-sources` ConfigMap.

## Steps

- [ ] Get the default model catalog file to use as a base for our changes

Execute the following commands in a terminal

    POD_NAME=$(oc get pods -n rhoai-model-registries -l app.kubernetes.io/name=model-catalog -o name)
    oc exec -n rhoai-model-registries $POD_NAME -c catalog -- cat /shared-data/validated-models-catalog.yaml > scratch/validated-models-catalog.yaml

This command will have no expected output.

- [ ] Add the GPT-OSS-20b-essential variant model to the model catalog.

Run the following commands in a terminal

    yq '.models.[] | select(.name == "RedHatAI/gpt-oss-120b")' scratch/validated-models-catalog.yaml > scratch/new-model.yaml
    yq -i '.name = "gpt-oss-20b-essential"' scratch/new-model.yaml
    yq -i '.provider = "OpenAI by way of Red Hat"' scratch/new-model.yaml
    yq -i '.description = "This is a Red Hat packaged version of gpt-oss that streamlines the model architecture to just the essential files necessary to run the model in vLLM."' scratch/new-model.yaml
    yq -i '.artifacts[0].uri = "oci://registry.redhat.io/rhai/modelcar-gpt-oss-20b-essential:3.0"' scratch/new-model.yaml

This command will have no expected output.

- [ ] Prepare the model for insertion into the ConfigMap.

Run the following in a shell

    touch scratch/model-for-configmap.yaml
    yq -i '.source = "Organization AI"' scratch/model-for-configmap.yaml
    yq -i '.models = [load("scratch/new-model.yaml")]' scratch/model-for-configmap.yaml

This command will have no expected output.

- [ ] Get the custom model catalog ConfigMap locally for updates

Execute the following commands

    oc get configmap model-catalog-sources -n rhoai-model-registries -o yaml > scratch/model-catalog-sources.yaml
    cp scratch/model-catalog-sources.yaml scratch/new-model-catalog-sources.yaml

This command will have no expected output.

- [ ] Modify the default model catalog for a new model

> [!WARNING]
> The name of the key in the ConfigMap (e.g. `my-ai-catalog.yaml`) must match the `yamlCatalogPath` in the sources.yaml file, located at `.catalogs[].properties.yamlCatalogPath`. Furthermore, both of these attributes must be strings that contain the pertinent YAML.

    yq -i '.data."sources.yaml" = load_str("configs/02/sources.yaml")' scratch/new-model-catalog-sources.yaml
    yq -i '.data."my-ai-catalog.yaml" = load_str("scratch/model-for-configmap.yaml")' scratch/new-model-catalog-sources.yaml

There is no expected output from this command, but verify that `scratch/new-model-catalog-sources.yaml` has two keys in `.data`, `sources.yaml` and `my-ai-catalog`.

- [ ] Update the ConfigMap on the cluster with your new values

Run the following to replace the existing ConfigMap with our new one

    oc replace configmap -n rhoai-model-registries -f scratch/new-model-catalog-sources.yaml

> Expected output:
> 
> configmap/model-catalog-sources replaced

- [ ] Restart the model catalog deployment to get it to pick up the new catalog.

Run the following to restart the model catalog and watch it come back up

    oc rollout restart deployment/model-catalog -n rhoai-model-registries
    oc get pods -n rhoai-model-registries -l app.kubernetes.io/name=model-catalog -w

> Expected output:
> 
> deployment.apps/model-catalog restarted\
> `NAME                            READY   STATUS    RESTARTS   AGE`\
> model-catalog-b59948797-s4fvj    2/2     Running   0          11s

- [ ] Navigate to the Model Catalog and validate that your model is present

From the OpenShift AI web console, navigate to the "Catalog" section (`AI hub` > `Catalog`)

![](/assets/console-catalog-registry.png)

When you click into the catalog, you should see that your new catalog `My models` has been added with the model we chose.

![](/assets/my-model-catalog.png)

## Automation key (catch up)

- [ ] From this repository's root directory, run below command

```sh
./scripts/setup.sh -s 2
```

<p align="center">
<a href="/docs/01-add-model-registry.md">Prev</a>
&nbsp;&nbsp;&nbsp;
<a href="/docs/03-register-from-catalog.md">Next</a>
</p>