## Personal Setup / Dev Enviroment

1. Just Run the Install script
```bash
$ sh ./setup.sh
```

### Configure Keys

1. Copy your ssh keys into `~/.shh` directory

2. Set the right permissions
```bash
$ chown 744 ~/.ssh
$ chown 644 ~/.ssh/$KEY_FILE.pub
$ chown 600 ~/.ssh/$KEY_FILE

$ chown 644 ~/.ssh/known_hosts
$ chown 644 ~/.ssh/authorized_keys
$ chown 644 ~/.ssh/config
```

3. Run de `ssh-agent`
```bash
$ eval "$(ssh-agent -s)"
```

4. Add your ssh keys into the keystore
```bash
$ ssh-add -K ~/.ssh/$KEY_FILE
```

#### If you have problems with the authorization

1. Remove your ssh keys from the keystore
```bash
$ ssh-add -D
```

2. Remove the `known_hosts` file
```bash
$ rm ~/.ssh/known_hosts
```

3. Kill your `ssh-agent` daemons
```bash
$ pids=`ps -ef | awk '/node/{ print $2 }'` && for p in $(echo $pids | tr -s "\n"); do kill $p; done
```

4. Run de `ssh-agent`
```bash
$ eval "$(ssh-agent -s)"
```

5. Add your ssh keys into the keystore
```bash
$ ssh-add -K ~/.ssh/$KEY_FILE
```