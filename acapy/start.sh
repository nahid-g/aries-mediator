#!/bin/bash

set -euxo pipefail

if [[ -z "$MEDIATOR_URL" ]]; then
    MEDIATOR_URL=$(curl -s http://ngrok:4040/api/tunnels | jq -r '[.tunnels[] | select(.proto == "https")][0].public_url')
fi

echo "Starting agent with endpoint(s): ${MEDIATOR_URL} wss://${MEDIATOR_URL#*://*}"

acapyCommand=(
    'aca-py'
    'start'
    '--auto-provision'
    '--arg-file' "${MEDIATOR_ARG_FILE}"
    '--label' "${MEDIATOR_AGENT_LABEL}"
    '--inbound-transport' 'http' '0.0.0.0' "${MEDIATOR_AGENT_HTTP_IN_PORT}"
    '--inbound-transport' 'ws' '0.0.0.0' "${MEDIATOR_AGENT_WS_IN_PORT}"
    '--outbound-transport' 'ws'
    '--outbound-transport' 'http'
    '--emit-new-didcomm-prefix'
    '--wallet-type' 'askar'
    '--wallet-storage-type' 'postgres_storage'
    '--admin' '0.0.0.0' "${MEDIATOR_AGENT_HTTP_ADMIN_PORT}"
    '--admin-api-key' "${MEDIATOR_AGENT_ADMIN_API_KEY}"
    '--endpoint' "${MEDIATOR_URL}" wss://"${MEDIATOR_URL#*://*}"
)

if [ "${USE_FIREBASE_PLUGIN}" = "true" ]; then
    echo "Using Firebase plugin"
    acapyCommand+=('--plugin' 'firebase_push_notifications')
else
    echo "Not using Firebase plugin"
fi

"${acapyCommand[@]}"
