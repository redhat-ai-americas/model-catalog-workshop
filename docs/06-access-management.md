# 5. Manage who can access 

<p align="center">
<a href="/docs/05-model-archival.md">Prev</a>
</p>

### Objectives

- Control who can access a model registry.

### Rationale

- Model registry access may need to be separated out based on roles or for compliance reasons.

### Takeaways

* Model registry access can easily be controlled through the UI or through normal OpenShift RBAC.

## Steps

- [ ] Manage permissions through the web console

On the OpenShift AI web console sidenav, expand the following options: `Settings` > `Model resources and operations` > `AI registry settings`.

![](/assets/registry-settings.png)

This page lists all your model registries. You can also create a model registry through this page by providing a database connection, which is exactly what we did in <a href="/docs/01-add-model-registry.md">Section 1</a>. Click `Manage permissions` on the right hand side of the row with our model registry.

![](/assets/registry-manage-permissions.png)

From this page, you can manage users, groups (both on the `Users` tab), and service accounts (on the `Projects` tab).

![](/assets/registry-user-permissions.png)

- [ ] Underlying permissions

Let's peel this back a layer further so you have better control over who has access to what. Head back to the OpenShift console (not OpenShift AI!) and find `User Management` > `Roles`.

![](/assets/roles.png)

Every registry creates a paired Role in `rhoai-model-registries`. The naming template is `registry-user-<registry name>`. In this case, you should see a role called `registry-user-myregistry`.

![](/assets/registry-user-role.png)

You can click in to see the minimum permissions needed to access and interact with the registry. Creating a RoleBinding like the following manifest will give the user permissions to interact with the model registry as though you had followed the UI.

> [!WARNING]
> If you don't include the labels in the RoleBinding, the user will still have permissions but won't show up in the OpenShift AI web console as having them.

```yaml
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: registry-user-myregistry-myuser
  namespace: rhoai-model-registries
  labels:
    app: myregistry
    app.kubernetes.io/component: model-registry
    app.kubernetes.io/name: myregistry
    app.kubernetes.io/part-of: model-registry
    component: model-registry
    opendatahub.io/dashboard: 'true'
subjects:
  - kind: User
    apiGroup: rbac.authorization.k8s.io
    name: myuser
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: registry-user-myregistry
```

<p align="center">
<a href="/docs/05-model-archival.md">Prev</a>
</p>