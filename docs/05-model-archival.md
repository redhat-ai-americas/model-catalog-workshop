# 5. Deploy a model from the model registry

<p align="center">
<a href="/docs/04-deploy-from-registry.md">Prev</a>
&nbsp;&nbsp;&nbsp;
<a href="/docs/06-access-management.md">Next</a>
</p>

### Objectives

- Archive a model using the model registry.

### Rationale

- Models can be soft-deleted once you are done with them.

### Takeaways

* Models can be archived and restored as needed.

## Steps

- [ ] Delete our existing deployment

> [!NOTE]
> Models cannot be archived unless there are no active deployments. The same applies to versions of a model.

Navigate to `AI hub` > `Deployments`. If you don't see your model, change the project to show `All projects`. Click the three dots on the far right of the model (see image below) and select `Delete`.

![](/assets/delete-model.png)

You will have to type in the name of the model, then you can select `Delete model deployment`.

![](/assets/delete-validation.png)

- [ ] Archive the model

Navigate back to the model registry by following `AI hub` > `Registry` in the sidenav. Find your model, and click the three dots on the right. The last item in the list is to archive the model.

![](/assets/archive-model.png)

Fill out the verification form just like when we deleted our existing deployment.

![](/assets/archive-verify.png)

- [ ] Restore the model

You will no longer see the model in the list of models in the registry. However, a new button will have appeared at the bottom of the page labeled `View archived models`. Go ahead and click that.

![](/assets/view-archived.png)

You should see our model once again. If you want to restore it, click the three dots on the right hand side and click `Restore model`.

![](/assets/restore-model.png)

This will return the model to the state it was before you archived it.

<p align="center">
<a href="/docs/04-deploy-from-registry.md">Prev</a>
&nbsp;&nbsp;&nbsp;
<a href="/docs/06-access-management.md">Next</a>
</p>