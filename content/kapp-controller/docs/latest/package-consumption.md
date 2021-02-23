---
title: Package Consumption
---

Before jumping in, we recommend reading through the docs about the new [packaging
apis](packaging.md) to familiarize yourself with the YAML configuration used in these
workflows.

This workflow walks through the example contained in
the [`packaging-demo`](https://github.com/vmware-tanzu/carvel-kapp-controller/tree/dev-packaging/examples/packaging-demo).

## Adding package repository

kapp-controller needs to know which packages are available to install. One way to let it know about available packages is by registering a package repository. To do this, we need a PackageRepository CR:

```yaml
---
apiVersion: install.package.carvel.dev/v1alpha1
kind: PackageRepository
metadata:
  name: basic.test.carvel.dev
spec:
  fetch:
    image:
      url: k8slt/kctrl-pkg-repo:v1.0.0
```

This CR will allow kapp-controller to install any of the packages found within
the imgpkg bundle `k8slt/kctrl-pkg-repo:v1.0.0`, which is stored in a OCI registry. Save this PackageRepository to
a file named repo.yml and then apply it to the cluster using kapp:

```bash
$ kapp deploy -a repo -f repo.yml
```

Once the deploy has finished, we are able to list the packages and see which ones are now available:

```bash
$ kubectl get packages
NAME                              PUBLIC-NAME            VERSION      AGE
pkg.test.carvel.dev.1.0.0         pkg.test.carvel.dev   1.0.0        7s
pkg.test.carvel.dev.2.0.0         pkg.test.carvel.dev   2.0.0        7s
pkg.test.carvel.dev.3.0.0-rc.1    pkg.test.carvel.dev   3.0.0-rc.1   7s
```

If we want, we can inspect these packages further to get more info about what they're installing:

```bash
$ kubectl get package pkg.test.carvel.dev.1.0.0 -o yaml
```

This will show us the package yaml, which will look something like this:

```yaml
---
apiVersion: package.carvel.dev/v1alpha1
kind: Package
metadata:
  name: pkg.test.carvel.dev.1.0.0
spec:
  publicName: pkg.test.carvel.dev
  version: 1.0.0
  displayName: "Test Package in repo"
  description: "Package used for testing"
  template:
    spec:
      fetch:
      - imgpkgBundle:
          image: k8slt/kctrl-example-pkg:v1.0.0
      template:
      - ytt:
          paths:
          - "config.yml"
          - "values.yml"
      - kbld:
          paths:
          - "-"
          - ".imgpkg/images.yml"
      deploy:
      - kapp: {}
```

This simple package will fetch the templates stored in the
`k8slt/kctrl-example-pkg:v1.0.0` bundle, template them using ytt and kbld, and finally
deploy them using kapp. Once deployed, there will be a basic greeter app
running in the cluster. Since this is what we want, we can now move on to installation.

## Installing a package

Once we have the packages available for installation (as seen via `kubectl get package`) we need to let kapp-controller know what we want to install. To do this, we will need to create an InstalledPackage CR (and a secret to hold the values used by our package):

```yaml
---
apiVersion: install.package.carvel.dev/v1alpha1
kind: InstalledPackage
metadata:
  name: pkg-demo
  namespace: default
spec:
  serviceAccountName: default-ns-sa
  packageRef:
    publicName: pkg.test.carvel.dev
    version: 1.0.0
  values:
  - secretRef:
      name: pkg-demo-values
---
apiVersion: v1
kind: Secret
metadata:
  name: pkg-demo-values
stringData:
  values.yml: |
    #@data/values
    ---
    hello_msg: "hi"
```

This CR references the package we decided to install in the previous section
using the Package CR's `publicName` and `version`. The InstalledPackage also
references the service account which will be used to install the package, as well
as values to include in the templating step in order to customize our installation.

To install above package, we will also need to create `default-ns-sa` service account (refer to [Security model](security-model.md) for explanation of how service accounts are used) that give kapp-controller privileges to create resources in the default namespace:

```bash
$ kapp deploy -a default-ns-rbac -f https://raw.githubusercontent.com/vmware-tanzu/carvel-kapp-controller/develop/examples/rbac/default-ns.yml
```

Save the InstalledPackage above to a file named installedpkg.yml and then apply the
InstalledPackage using kapp:

```bash
$ kapp deploy -a pkg-demo -f installedpkg.yml
```

After the deploy has finished, kapp-controller will have installed the package in the
cluster. We can verify this by checking the pods to see that we have a workload pod
running. The output should show a single running pod which is part of simple-app:

```bash
$ kubectl get pods
NAME                          READY   STATUS    RESTARTS   AGE
simple-app-58f865df65-kmhld   1/1     Running   0          2m
```

If we now use kubectl's port forwarding functionality, we can also see the our
customized hello message as been used in the workload:

```bash
$ kubectl port-forward service/simple-app  3000:80
```

Then, from another window:

```bash
$ curl localhost:3000
<h1>Hello hi!</h1>%
```

And we see that our hello_msg value is used.

## Uninstalling a package

To uninstall a package simply delete InstalledPackage CR

```bash
$ kubectl delete installedpackage pkg-demo
```