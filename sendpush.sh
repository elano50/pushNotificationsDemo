deviceToken=9f95828d096f015bd76c927660c40569ee920973d33e4f8e9ac7fc71d6229f90

authKey="./AuthKey_Z9G9QXK9YB.p8"
authKeyId=Z9G9QXK9YB
teamId=7MSPFU2KV4
bundleId=BR.pushNotifications
endpoint=https://api.development.push.apple.com

read -r -d '' payload <<-'EOF'
{
   "aps": {
      "badge": 2,
      "sound": "default",
      "thread-id": "2",
      "category": "com.suchapp",
      "alert": {
         "title": "my title",
         "subtitle": "my subtitle",
         "body": "my body text message",
      }
   },
   "custom": {
      "mykey": "myvalue"
   }
}
EOF

# --------------------------------------------------------------------------

base64() {
   openssl base64 -e -A | tr -- '+/' '-_' | tr -d =
}

sign() {
   printf "$1"| openssl dgst -binary -sha256 -sign "$authKey" | base64
}

time=$(date +%s)
header=$(printf '{ "alg": "ES256", "kid": "%s" }' "$authKeyId" | base64)
claims=$(printf '{ "iss": "%s", "iat": %d }' "$teamId" "$time" | base64)
jwt="$header.$claims.$(sign $header.$claims)"

curl --verbose \
   --header "content-type: application/json" \
   --header "authorization: bearer $jwt" \
   --header "apns-topic: $bundleId" \
   --data "$payload" \
   $endpoint/3/device/$deviceToken