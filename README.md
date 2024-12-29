# Rclone Webdav Serve Wrapper

## ENV VARS

| Variable                | Description                                                    | Default Value         |
|-------------------------|----------------------------------------------------------------|-----------------------|
| USE_MMAP                | Enable memory-mapped I/O for better performance                | true                  |
| SKIP_SSL_VERIFY         | Skip SSL/TLS certificate verification                          | true                  |
| ENABLE_AUTH             | Enable WebDAV authentication (requires USER and PASS)          | true                  |
| ENABLE_RC               | Enable rclone remote control (RC) and web GUI                  | false                 |
| CACHE_DIR               | Directory to store cache files                                 | /cache                |
| BUFFER_SIZE             | Size of the in-memory buffer for transfers                     | 1M                    |
| DIR_CACHE_TIME          | How long to cache directory listings                           | 10s                   |
| TIMEOUT                 | Operation timeout for transfers                                | 10m                   |
| UMASK                   | File permissions mask                                          | 002                   |
| VFS_CACHE_MIN_FREE_SPACE| Minimum free space required for VFS cache                      | off                   |
| VFS_CACHE_MAX_AGE       | Maximum age of cached files in VFS                             | 1h                    |
| VFS_MAX_CACHE_SIZE      | Maximum size of the VFS cache                                  | 10G                   |
| VFS_CACHE_MODE          | Cache mode for VFS (off, minimal, writes, full)                | full                  |
| VFS_READ_CHUNK_SIZE     | Initial size of chunks read from remote                        | 4M                    |
| VFS_READ_CHUNK_LIMIT    | Maximum size of read chunks                                    | 16M                   |
| LOG_LEVEL               | Logging level for rclone (INFO, DEBUG, ERROR)                  | INFO                  |
| MOUNTNAME               | Name of the remote being mounted                               | _(no default)_        |
| USER                    | WebDAV username (required if ENABLE_AUTH is true)              | _(no default)_        |
| PASS                    | WebDAV password (required if ENABLE_AUTH is true)              | _(no default)_        |


## Example Docker RUN
```bash
docker run -d \
  -e MOUNTNAME="torbox:" \
  -e USER=myuser \
  -e PASS=mypassword \
  -e ENABLE_AUTH=true \
  -e ENABLE_RC=false \
  -p 8080:8080 \
  -v /path/to/rclone.conf:/data/rclone.conf \
  -v /path/to/cache:/cache \
  --name torbox-webdav \
  ipromknight/rclone-webdav-serve:latest
```
