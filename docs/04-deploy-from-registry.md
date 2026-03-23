# 4. Deploy a model from the model registry

<p align="center">
<a href="/docs/03-register-from-catalog.md">Prev</a>
&nbsp;&nbsp;&nbsp;
<a href="/docs/05-model-archival.md">Next</a>
</p>

### Objectives

- Deploy a model using the model registry.

### Rationale

- Model deployments can be self-served through the model registry.

### Takeaways

* There are multiple ways in the OpenShift AI web console to deploy and manage your model deployments.

## Steps

- [ ] Find the right model version

From the final screen in <a href="/docs/04-deploy-from-registry.md">the previous step</a>, click on the model name link, which should be `gpt-oss-20-essential`. This page contains details about the model. As before, note that the information is pulled from the details we had in the model catalog.

![](/assets/registry-model-page.png)

From here, click on the `Versions` tab, note the different options available, then click on the current version, which will match the name you gave it when registering the model from the model catalog. If you're using the defaults, it will be `Version 1`. You should see a page that looks like this

![](/assets/model-version.png)

- [ ] Deploy the model

Click the `Deploy` button in the upper right hand corner, as shown below:

![](/assets/deploy-button.png)

Select the project where you want the model to be deployed, in this case `models`.

![](/assets/model-deploy-project.png)

Click `Deploy` and it will take you to a wizard with. Many of the details will already be filled in from the model registry - do not change these. In the first, you need to scroll down and give the mode a name, `gpt-oss-20b`, and a Model type, `Generative AI model (Example, LLM)`. It will look like this:

![](/assets/model-deploy-name.png)

When you are ready, click the `Next` button. In this next section of the wizard, you will configure the deployment itself.

> [!NOTE]
> The model deployment name is the name of the InferenceService (and thus the pods), whereas the name in the last section is the model name as it will appear in the data contract when calling it from your other tools. For simplicity, I strongly recommend matching the names.

Set the model name to `gpt-oss-20b` to match the last step, and give the deployment a description if you want. Set the hardware profile to `NVIDIA GPU`. The serving runtime will autoselect to `vLLM NVIDIA GPU ServingRuntime for KServe`, which is the right value. We will deploy 1 replica. With everything selected, it should look like this:

![](/assets/model-deploy-model.png)

When you are ready, click the `Next` button. In the advanced settings, check `Make model deployment available through an external route` and `Require token authentication`, the latter of which will appear after you do the first. All other checkboxes will be left empty.

![](/assets/model-deploy-advanced-1.png)

Last, set the `Deployment strategy` to `Recreate`.

![](/assets/model-deploy-advanced-2.png)

When you are ready, click `Next`. Review the information to make sure everything is correct, then click `Deploy model` at the bottom of the screen. If your cluster has enough resources, this model will take about 10 minutes to pull and deploy.

- [ ] Track the deployment

After deploying your model, you will be bumped back out to the model version page on the `Deployments` tab. Check the `Details` tab for confirmation, then head back to `Deployments`. This shows you any deployments you have made so you can track their status.

> [!NOTE]
> This page will not show you any deployments someone else has made from the model registry.

![](/assets/deployed-models.png)

Depending on whether you are looking at the model overall or the specific model version, the `Deployments` tab will show you just the pertinent models. The main difference between this and the `Deployments` page under `AI hub` more broadly (see image below) is that the `AI hub` page shows you *all* deployments, regardless of what it is or who deployed it, whereas the model registry filters to just your deployments.

![](/assets/aihub-deployments.png)

<p align="center">
<a href="/docs/03-register-from-catalog.md">Prev</a>
&nbsp;&nbsp;&nbsp;
<a href="/docs/05-model-archival.md">Next</a>
</p>