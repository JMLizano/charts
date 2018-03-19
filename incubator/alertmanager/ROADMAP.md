This repo will merge:
 - Alertmanager from prometheus chart 
 - Alertmanager chart from prometheus-operator repo

It should support the following installing modes:
 - Deployment: For testing/dev purposes. Deploys as a deployment with no HA modes
 - StatefulSet: For prod, HA mode enabled
 - Prometheus-operator component: To use only with prometheus-operator, use its CRD/TPR to create the alertmanager component

 Tasks:
 - [ ] Implement support for deployment installing mode
    1 replica:
      - [x] With no PV and no rbac
      - [x] With PV no rbac
      - [ ] With PV and rbac
    2 replicas:
      - [x] With no PV and no rbac
      - [x] With PV no rbac
      - [ ] With PV and rbac
 - [x] Implement support for StatefulSet installing mode
    - [x] With no PV and no rbac
    - [x] With PV no rbac 
    - [ ] With PV and rbac  
 - [ ] Implement prometheus-operator installing mode
    - [ ] Copy from prometheus operator repo
 - [ ] Merge values.yaml
    - [ ] Remove non necessary parameters inherited from prometheus chart
 - [ ] Merge _helpers.tpl

NOTES/Decisions:
- Deployment installing mode has been deprecated. It makes no sense to use a Deployment with a PV:
  - This will only works if all the pods are scheduled in the same node, since the volume is ReadWriteOnce (only accepted by EBS). Otherwise you will get a Multi-Attach error.
- Alertmanager configuration has to be a secret, because it may include passwords/tokens for the services
  that it sends notifications to.
- Do something with routePrefix on ingress (is important?)