# 3. Register a model to a model registry from the catalog

<p align="center">
<a href="/docs/02-configure-model-catalog.md">Prev</a>
&nbsp;&nbsp;&nbsp;
<a href="/docs/04-deploy-from-registry.md">Next</a>
</p>

### Objectives

- Register a model to the model registry from a model catalog.

### Rationale

- Model registries provide clearer fine-grained control over models and how they are used compared to the model catalog.

### Takeaways

* Model catalogs can register models directly from the OpenShift AI web console.

## Steps

- [ ] View the model card for your model

Find your model card and click on the name

![](/assets/model-card.png)

Information about the model is present on this screen. Compare this to the information we started with in `scratch/new-model.yaml` - this is the same information as on the page! In particular, notice the model location, which tells us where the model will be coming from when we attempt to deploy it.

![](/assets/model-details.png)

From here, we can deploy the model or register it. Were we to directly deploy the model, we would see the same wizard as when we deploy it through the registry, but we will miss some positive side effects of deploying through the registry, so we will completely skip this step here.

- [ ] Register the model

Click the `Register model` button in the upper right hand corner, demonstrated below:

![](/assets/register-model-button.png)

This will take you to a page where you can fill out any relevant metadata about your model. Notice that things like the name, description, and model location are automatically populated from the information in the registry!

![](/assets/register-model.png)

When you are happy with the values, click the blue `Register model` button at the bottom of the page.

## Verifying results

If everything has gone correctly, you will be taken directly to the new model registry page for the model. Notice the information is presented differently, and we have `Versions` and `Deployments` tabs that we will discuss in the next session.

![](/assets/registered-model.png)

From now on, if you navigate to the Model Registry in the sidenav, rather than showing the empty registry page we got before, we will now see our model with information about it.

![](/assets/new-model-registry.png)

<p align="center">
<a href="/docs/02-configure-model-catalog.md">Prev</a>
&nbsp;&nbsp;&nbsp;
<a href="/docs/04-deploy-from-registry.md">Next</a>
</p>