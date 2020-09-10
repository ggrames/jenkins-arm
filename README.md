# jenkins-arm
Jenkins build Server for installation on aarch64 (arm64)

##  Jenkins 2.256 for arm architecture

    e.g Raspberry Pi 4 ModelB

## Example Kubernetes yaml for the needed resources

 with nfs persistent volume


    apiVersion: v1
    kind: PersistentVolumeClaim
    metadata:
      name: jenkins
      namespace: cicd
      annotations:
        volume.beta.kubernetes.io/storage-class: "managed-nfs-storage"
    spec:
      accessModes:
        - ReadWriteOnce
      resources:
        requests:
          storage: 4Gi
      storageClassName: "managed-nfs-storage"
    ---
    apiVersion: v1
    kind: Service
    metadata:
      labels:
    run: jenkins
      name: jenkins
      namespace: cicd
    spec:
      ports:
      - name: web
        port: 80
        protocol: TCP
        targetPort: 8080
      - name: slaves
        port: 50000
        protocol: TCP
        targetPort: 50000
      selector:
        run: jenkins
    ---
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      annotations:
      labels:
        run: jenkins
      name: jenkins
      namespace: cicd
    spec:
      replicas: 1
      selector:
        matchLabels:
          run: jenkins
      template:
        metadata:
          labels:
            run: jenkins
        spec:
          containers:
            - image: ggrames/jenkins-arm:2.256
              imagePullPolicy: IfNotPresent
              name: jenkins
              ports:
              - containerPort: 8080
                protocol: TCP
                name: web
              - containerPort: 50000
                protocol: TCP
                name: slaves
              volumeMounts:
              - mountPath: /var/jenkins_home
                name: jenkinshome
          volumes:
          - name: jenkinshome
            persistentVolumeClaim:
              claimName: jenkins
    ---
    apiVersion: extensions/v1beta1
    kind: Ingress
    metadata:
      name: jenkins
      namespace: cicd
    spec:
      rules:
      - host: jenkins.mydomain.com
        http:
          paths:
          - backend:
              serviceName: jenkins
              servicePort: 8080
            pathType: ImplementationSpecific
      tls:
      - hosts:
        - jenkins.mydomain.com
        secretName: tls-secret
