#!/bin/sh
set -eu  # Exit on error and undefined variables

USE_MMAP=${USE_MMAP:-true}
SKIP_SSL_VERIFY=${SKIP_SSL_VERIFY:-true}
ENABLE_AUTH=${ENABLE_AUTH:-true}
ENABLE_RC=${ENABLE_RC:-false}

echo "Starting rclone WebDAV server..."

if [ ! -f /data/rclone.conf ]; then
    echo "Error: Config file /data/rclone.conf not found!"
    exit 1
fi

# Log default values
echo "Cache Directory: ${CACHE_DIR:-/cache}"
echo "Buffer Size: ${BUFFER_SIZE:-1M}"
echo "Dir Cache Time: ${DIR_CACHE_TIME:-10s}"
echo "Timeout: ${TIMEOUT:-10m}"
echo "VFS Cache Mode: ${VFS_CACHE_MODE:-full}"
echo "VFS Cache Size: ${VFS_MAX_CACHE_SIZE:-10G}"
echo "VFS Cache Age: ${VFS_CACHE_MAX_AGE:-1h}"
echo "VFS Min Free Space: ${VFS_MIN_FREE_SPACE:-off}"
echo "VFS Read Chunk Size: ${VFS_READ_CHUNK_SIZE:-4M}"
echo "VFS Read Chunk Limit: ${VFS_READ_CHUNK_LIMIT:-16M}"
echo "UMask: ${UMASK:-002}"
echo "Log Level: ${LOG_LEVEL:-INFO}"
echo "Remote: $MOUNTNAME"

# Base rclone command
CMD="rclone serve webdav $MOUNTNAME \
       --config=/data/rclone.conf \
       --addr 0.0.0.0:8080 \
       --log-level ${LOG_LEVEL:-INFO} \
       --cache-dir ${CACHE_DIR:-/cache} \
       --buffer-size=${BUFFER_SIZE:-1M} \
       --dir-cache-time=${DIR_CACHE_TIME:-10s} \
       --timeout=${TIMEOUT:-10m} \
       --umask=${UMASK:-002} \
       --vfs-cache-min-free-space=${VFS_MIN_FREE_SPACE:-off} \
       --vfs-cache-max-age=${VFS_CACHE_MAX_AGE:-1h} \
       --vfs-cache-max-size=${VFS_MAX_CACHE_SIZE:-10G} \
       --vfs-cache-mode=${VFS_CACHE_MODE:-full} \
       --vfs-read-chunk-size-limit=${VFS_READ_CHUNK_LIMIT:-16M} \
       --vfs-read-chunk-size=${VFS_READ_CHUNK_SIZE:-4M} \
       --no-traverse \
       --ignore-existing \
       --poll-interval=0"

# Conditionally enable authentication
if [ "$ENABLE_AUTH" = "true" ] || [ "$ENABLE_AUTH" = "1" ]; then
    if [ -z "${USER:-}" ] || [ -z "${PASS:-}" ]; then
        echo "Error: Authentication enabled but USER or PASS is missing."
        exit 1
    fi
    CMD="$CMD \
        --user $USER \
        --pass $PASS"
    echo "Authentication enabled for user $USER."
fi

# Conditionally skip SSL verification
if [ "$SKIP_SSL_VERIFY" = "true" ] || [ "$SKIP_SSL_VERIFY" = "1" ]; then
    CMD="$CMD --no-check-certificate"
    echo "Skipping SSL verification."
fi

# Conditionally enable MMAP
if [ "$USE_MMAP" = "true" ] || [ "$USE_MMAP" = "1" ]; then
    CMD="$CMD --use-mmap"
    echo "Using MMAP (memory-mapped I/O)."
fi

# Conditionally enable remote control (RC) features
if [ "$ENABLE_RC" = "true" ] || [ "$ENABLE_RC" = "1" ]; then
    CMD="$CMD \
       --rc \
       --rc-enable-metrics \
       --rc-no-auth \
       --rc-web-gui \
       --rc-web-gui-no-open-browser"
    echo "Remote Control (RC) enabled."
fi

# Execute the final command
exec $CMD