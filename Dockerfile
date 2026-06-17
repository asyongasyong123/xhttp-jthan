
gcloud builds submit \
  --tag gcr.io/$PROJECT_ID/$CLOUD_RUN_SERVICE_NAME \
  . \
  --quiet &
spinner $! "Cloud Build running"

# =========================
# DEPLOY CLOUD RUN
# =========================

banner "DEPLOYING CLOUD RUN"

gcloud run deploy $CLOUD_RUN_SERVICE_NAME \
  --image gcr.io/$PROJECT_ID/$CLOUD_RUN_SERVICE_NAME \
  --platform managed \
  --region $REGION \
  --allow-unauthenticated \
  --port 8080 \
  --cpu 4 \
  --memory 4Gi \
  --concurrency 1000 \
  --timeout 3600 \
  --min-instances 1 \
  --max-instances 4 \
  --execution-environment gen2 \
  --cpu-boost \
  --quiet &
spinner $! "Deploying Cloud Run"
