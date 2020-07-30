# backupMongo

this Repo of for backing up a mongodb database twice a day at 7h30min & 12h30min

Steps:

1- create a Service account with role Storage object Viewer/ Storage Object Creator 
   ```
   gcloud iam service-accounts create
   
   ```
2- Create a secret in tou cluster using 
   ```
   kubectl create secret generic backup-gcs --from-file=backup.json 
   
   ```
3- Create your cron job 
```
   Kubectl apply -f cron.yaml 
   
 ```
   
