#!/bin/sh

set -eu

PORT="${PORT:-2222}"

USERNAME="${USERNAME:-railway}"
PASSWORD="${PASSWORD:-}"

if [ -z "$PASSWORD" ]; then
    echo "ERROR: PASSWORD environment variable is required"
    exit 1
fi

echo "Generating SSH host keys..."

ssh-keygen -A

echo "Creating SSH user: $USERNAME"

if ! id "$USERNAME" >/dev/null 2>&1; then
    useradd \
        --create-home \
        --shell /bin/bash \
        "$USERNAME"
fi

echo "$USERNAME:$PASSWORD" | chpasswd

cat > /etc/ssh/sshd_config <<EOF
Port $PORT
ListenAddress 0.0.0.0

Protocol 2

PermitRootLogin no
PasswordAuthentication yes
KbdInteractiveAuthentication no
PubkeyAuthentication no

UsePAM no

AllowUsers $USERNAME

X11Forwarding no
PrintMotd no

ClientAliveInterval 60
ClientAliveCountMax 3

LogLevel VERBOSE
EOF

echo "Starting OpenSSH server..."
echo "Listening on 0.0.0.0:$PORT"

exec /usr/sbin/sshd -D -e
