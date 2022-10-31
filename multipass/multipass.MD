multipass launch -n cassandra-0 --cloud-init cassandra-cloud-init.yaml

multipass shell cassandra-0

multipass delete cassandra-0

multipass purge