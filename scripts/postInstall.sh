#set env vars
set -o allexport; source .env; set +o allexport;

#wait until the server is ready
echo "Waiting for software to be ready ..."
sleep 30s;

#register the local server in the web ui
target=$(docker-compose port mealie 3000)


JWT=$(curl http://$target/api/auth/token \
-H 'accept-language: fr-FR' \
-H 'content-type: multipart/form-data; boundary=----WebKitFormBoundaryb3mcOTjCtjAsVY9m' \
-H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36' \
--data-raw $'------WebKitFormBoundaryb3mcOTjCtjAsVY9m\r\nContent-Disposition: form-data;name="username"\r\n\r\n'${ADMIN_EMAIL}$'\r\n------WebKitFormBoundaryb3mcOTjCtjAsVY9m\r\nContent-Disposition: form-data; name="password"\r\n\r\nMyPassword\r\n------WebKitFormBoundaryb3mcOTjCtjAsVY9m\r\nContent-Disposition: form-data; name="remember_me"\r\n\r\nfalse\r\n------WebKitFormBoundaryb3mcOTjCtjAsVY9m--\r\n' \
--compressed)
  
echo "JWT " ${JWT}

access_token=$(echo $JWT | jq -r '.access_token' )

echo "access_token1 " ${access_token}


curl http://${target}/api/users/password \
  -X 'PUT' \
  -H 'accept: application/json, text/plain, */*' \
  -H 'accept-language: fr-FR' \
  -H 'authorization: Bearer '${access_token}'' \
  -H 'content-type: application/json' \
  -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36' \
  --data-raw '{"currentPassword":"MyPassword","newPassword":"'${ADMIN_PASSWORD}'"}' \
  --compressed