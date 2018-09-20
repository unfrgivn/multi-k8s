#Build images
#Tag images with both latest and current GIT SHA for the master commit used in CI deployment
#SHA gives our Docker builds a unique tag so k8s knows when we have updated our deployment images
docker build -t unfrgivn/multi-client:latest -t unfrgivn/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t unfrgivn/multi-server:latest -t unfrgivn/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t unfrgivn/multi-worker:latest -t unfrgivn/multi-worker:$SHA -f ./worker/Dockerfile ./worker

#Push images to Docker Hub
docker push unfrgivn/multi-client:latest
docker push unfrgivn/multi-server:latest
docker push unfrgivn/multi-worker:latest

docker push unfrgivn/multi-client:$SHA
docker push unfrgivn/multi-server:$SHA
docker push unfrgivn/multi-worker:$SHA

#Apply k8s config files
kubectl apply -f k8s

#Tag images with latest build for future updates
kubectl set image deployments/client-deployment client=unfrgivn/multi-client:$SHA
kubectl set image deployments/server-deployment server=unfrgivn/multi-server:$SHA
kubectl set image deployments/worker-deployment worker=unfrgivn/multi-worker:$SHA
