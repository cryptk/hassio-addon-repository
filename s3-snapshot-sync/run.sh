#!/usr/bin/with-contenv bashio

KEY=$(bashio::config 'aws_access_key_id')
SECRET=$(bashio::config 'aws_secret_access_key')
BUCKET=$(bashio::config 's3_bucket_name')

aws configure set aws_access_key_id $KEY
aws configure set aws_secret_access_key $SECRET

aws s3 sync /backup/ s3://$BUCKET/

if bashio::config.has_value 'purge_days'; then
	bashio::log "purge_days is set, cleaning up old backups"
	DAYS=$(bashio::config 'purge_days')
	find /backup/ -mindepth 1 -mtime +${DAYS} -print -exec rm {} \;
fi

bashio::exit.ok "Backup run complete"
