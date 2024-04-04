# Troubleshooting repository mirroring

DETAILS:
**Tier:** Free, Premium, Ultimate
**Offering:** GitLab.com, Self-managed, GitLab Dedicated

## `The repository is being updated`, but neither fails nor succeeds visibly

This can be run on any Patroni node, but be aware that `sudo gitlab-ctl patroni reinitialize-replica`.

## Errors in Patroni logs: the requested start point is ahead of the Write Ahead Log (WAL) flush position

```plaintext
Error while reinitializing replica on the current node: Attributes not found in
/opt/gitlab/embedded/nodes/<HOSTNAME>.json, has reconfigure been run yet?
```

```shell
sudo gitlab-ctl patroni reinitialize-replica
```

# How Git object deduplication works in GitLab

1. Establish the alternates link in the special file `A.git/objects/info/alternates`
   by writing a path that resolves to `B.git/objects`.

#### 1. SQL says repository A belongs to pool P but Gitaly says A has no alternate objects
