# GitOps Repo for Demo App

- 📁`chart` ArgoCD will render this helm chart and output the results to `all.yml`. Kustomize then applies overrides based on the environment.

  - 📄`Chart.yaml` Standard Helm Chart file. It declares [ds-chrlib](https://github.com/ch-robinson-internal/ds-chrlib) as a dependency.

  - 📄`.helmignore` Standard Helm file.

  - 📄`components.yaml` List of all the components and their specific configurations. This file is passed into the rendering of the Helm chart as an additional values file. It is validated against [the ds-chrlib schema.](https://github.com/ch-robinson-internal/ds-chrlib/blob/master/schemadocs/componentsfile.md)

  - 📄`default.env` Shared environment variables for all environments. Kustomize uses it to create a hashed config map for the environment. Changes to it will trigger all pods to do a rolling restart to re-load their environment.

  - 📄`kustomization.yml` The [kustomizations](https://kustomize.io) to apply to all environments. Each app environment will then apply its own kustomizations to the result of this.

  - 📄`values.yaml` The primary source of deployment configuration. Is validated against [the ds-chrlib schema.](https://github.com/ch-robinson-internal/ds-chrlib/blob/master/schemadocs/valuesfile.md)

- 📁`env-template` This is a template used when generating new production or non-production environments.

- 📁`non-prod-envs` This is where static non-production environments' configuration lives. The ArgoCD `ApplicationSet` configuration deploys sub-folders into their own environments based on the primary branch.

  - 📁`dev` This is the `dev` environment. It is only deployed using the primary branch. Other branches can modify this, but they will only take effect once the branch is merged.

  - 📁`pr-env` This is a template environment used for ephemeral Pull Request environments. It only exists for as long as the branch does and uses values from the branch.

- 📁`prod-envs` This is where static production environments' configuration lives. The ArgoCD `ApplicationSet` configuration deploys sub-folders into environments based on the primary branch.

  - 📁`prod` This is the `prod` environment. It is only deployed using the primary branch. Other branches can modify this, but they will only take effect once the branch is merged.
