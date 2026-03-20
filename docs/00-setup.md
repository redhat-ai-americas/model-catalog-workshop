# 0. Prerequisite

<p align="center">
<a href="/README.md">Prev</a>
&nbsp;&nbsp;&nbsp;
<a href="/docs/01-add-administrative-user.md">Next</a>
</p>

> Intended commands to be executed from the root directory of this repository. The majority of the configurations to be applied are already created, with the exception of the ones that prompts you for specifics that are either created in the command or dumped to a `scratch` dir that is ignored in the `.gitignore`.

- [ ] Have `cluster-admin` access to an OpenShift 4.20+ cluster
- [ ] Have OpenShift AI 3.2 installed on your OpenShift cluster
- [ ] Have the `modelregistry` component of OpenShift AI's DataScienceCluster custom resource set to `Managed`. This workshop assumes the default namespace of `rhoai-model-registries`.
- [ ] Have access to a GPU with at least 10 GB of VRAM
- [ ] Have the GPU accessible to OpenShift. Typically this will mean have Node Feature Discovery and the NVIDIA GPU Operators installed and setup.
- [ ] Open a `bash` terminal on your local machine
- [ ] Git clone this repository

```sh
git clone https://github.com/redhat-ai-americas/model-catalog-workshop.git

cd model-catalog-workshop
```

- [ ] Create scratch directory

```sh
mkdir -p scratch
```

- [ ] Login to the cluster via terminal

```sh
oc login <openshift_cluster_url> -u <admin_username> -p <password>
```

> [!IMPORTANT]
> Don't forget to run below step

- [ ] Run prerequisites (from this repository's root directory)

```sh
./scripts/setup.sh -s 0
```

> [!NOTE]
> This will automatically setup the [web terminal](/docs/info-install-web-terminal.md).  
> You will have to manually 'Refresh' the console page to be able to invoke the web terminal.

> For running the remaining steps you have two options:
>
> - Use the `bash` terminal on your local machine OR
> - Invoke web terminal (Refer below image)

![](/assets/00-web-terminal.gif)

<p align="center">
<a href="/README.md">Prev</a>
&nbsp;&nbsp;&nbsp;
<a href="/docs/01-add-model-registry.md">Next</a>
</p>