"start": "node --watch src/server.js"


* If you change PORT from 8000 to something else, the existing backend Pod will not automatically receive the new environment variable. You need to restart the Deployment:
 - a) kubectl rollout restart deployment backend