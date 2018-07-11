#!/bin/sh
docker run -d --hostname artifactory --name artifactory -p 8081:8081 docker.bintray.io/jfrog/artifactory-oss

sleep 45

until curl -i -u admin:password http://localhost:8081/artifactory/api/ >/dev/null ; do

  >&2 echo "artifactory is unavailable - sleeping"

  sleep 5

done

curl -i -u admin:password -T ./tests/fixtures/distr/1.0/1Cv8.cf  \
     http://localhost:8081/artifactory/example-repo-local/org/test/cf/10/1.0/org-test-cf-1.0.cf

curl -i -u admin:password -T ./tests/fixtures/distr/1.1/1cv8.cf  \
     http://localhost:8081/artifactory/example-repo-local/org/test/cf/10/1.1/org-test-cf-1.1.cf

curl -i -u admin:password -T ./tests/fixtures/distr/1.1/1cv8.cfu  \
     http://localhost:8081/artifactory/example-repo-local/org/test/cf/10/1.1/org-test-cf-1.1.cfu
