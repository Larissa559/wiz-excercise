#!/bin/bash
set -euo pipefail

S3_BUCKET="wiz-mongo-backups"

# Install MongoDB (outdated 4.0)
apt-get update -y
apt-get install -y gnupg curl wget awscli
curl -fsSL https://www.mongodb.org/static/pgp/server-4.0.asc | apt-key add -
echo "deb [ arch=amd64 ] http://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.0 multiverse" \
  | tee /etc/apt/sources.list.d/mongodb-org-4.0.list
apt-get update -y
apt-get install -y mongodb-org

# Start and enable mongod
systemctl start mongod
systemctl enable mongod

# Create weak user (intentionally insecure)
mongo <<EOF
use admin
db.createUser({
  user: "wizuser",
  pwd: "12345",
  roles: [ { role: "root", db: "admin" } ]
})
EOF

# Enable auth
sed -i '/#security:/a\security:\n  authorization: enabled' /etc/mongod.conf
systemctl restart mongod

# --- Mongo Backup Script ---
cat > /usr/local/bin/mongo_backup.sh <<'EOF'
#!/bin/bash
set -e
TIMESTAMP=$(date +%F-%H%M)
BACKUP_FILE="/tmp/mongo-backup-$TIMESTAMP.gz"

mongodump \
  --username wizuser \
  --password 12345 \
  --authenticationDatabase admin \
  --archive=$BACKUP_FILE \
  --gzip

aws s3 cp $BACKUP_FILE s3://'"${S3_BUCKET}"'/mongo-backup-$TIMESTAMP.gz
rm -f $BACKUP_FILE
EOF

chmod +x /usr/local/bin/mongo_backup.sh

# Add cronjob → daily at 02:00
(crontab -l 2>/dev/null; echo "0 2 * * * /usr/local/bin/mongo_backup.sh >> /var/log/mongo_backup.log 2>&1") | crontab -
