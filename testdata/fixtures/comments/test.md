<!-- vale off -->

This is some text ACT test

This is some text ACT test

<!-- vale on -->

<!-- vale vale.Redundancy = NO -->

This is some text ACT test

<!-- vale vale.Redundancy = YES -->

This is some text ACT test

<!-- vale demo.Ending-Preposition = NO -->

This is some text ACT test. This is a sentence for.

This is a sentance of.

<!-- vale demo.Ending-Preposition = YES -->

This is a sentance of.

1. Consider the following `deployment.yaml` file.

   ```yaml
   apiVersion: v1
   kind: Service
   metadata:
     name: my-nginx-svc
     labels:
       app: nginx
   spec:
     type: LoadBalancer
     ports:
     - port: 80
     selector:
       app: nginx
   ---
   apiVersion: apps/v1
   kind: Deployment
   metadata:
     name: my-nginx
     labels:
       app: nginx
   spec:
     replicas: 3
     selector:
       matchLabels:
         app: nginx
     template:
       metadata:
         labels:
           app: nginx
       spec:
         containers:
         - name: nginx
           image: nginx:1.7.9
           ports:
           - containerPort: 80
   ```

2. few other steps.
<!-- vale off -->
1. This is a sentance of.
   ```bash
   SSH should not typically be used within containers.
   Ensure that non-SSH services are not using port 22.
   ```
<!-- vale on -->

something else.

This is a sentance of.

- Unordered list example.
<!-- vale off -->
- This is a sentance of.
<!-- vale on -->
- one more item.

<!-- vale demo.Raw = NO -->

Internal Links [must not use `.html`](../index.html)

<!-- vale vale = off -->

This is some text ACT test. This is a sentence for.

This is a sentance of.

<!-- vale demo = off -->

This is some text ACT test. This is a sentence for.

This is a sentance of.

<!-- vale vale = on -->

This is some text ACT test. This is a sentence for.

This is a sentance of.

<!-- vale demo = on -->

This is some text ACT test. This is a sentence for.

This is a sentance of.

<!-- vale vale = NO -->

This is some text ACT test. This is a sentence for.

This is a sentance of.

<!-- vale demo = NO -->

This is some text ACT test. This is a sentence for.

This is a sentance of.

<!-- vale vale = YES -->

This is some text ACT test. This is a sentence for.

This is a sentance of.

<!-- vale demo = YES -->

This is some text ACT test. This is a sentence for.

This is a sentance of.

<!-- vale style = vale -->

This is some text ACT test. This is a sentence for.

This is a sentance of.

<!-- vale style = demo -->

This is some text ACT test. This is a sentence for.

This is a sentance of.

<!-- vale styles = vale, demo -->

This is some text ACT test. This is a sentence for.

This is a sentance of.
