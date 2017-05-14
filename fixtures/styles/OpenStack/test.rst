To determine whether your Object Storage system supports this feature,
see :doc:`managing-openstack-object-storage-with-swift-cli`.
Alternatively, check with your service provider.

Set environment variables
~~~~~~~~~~~~~~~~~~~~~~~~~

To set up environmental variables and authenticate against Compute API
endpoints, see :ref:`sdk_authenticate`.

.. _get-openstack-credentials:

For details about how to install the clients, see
:doc:`../common/cli-install-openstack-command-line-clients`.

The Static Web filter must be added to the pipeline in your
``/etc/swift/proxy-server.conf`` file below any authentication
middleware. You must also add a Static Web middleware configuration
section.

You can contact the HA community directly in `the #openstack-ha
channel on Freenode IRC <https://wiki.openstack.org/wiki/IRC>`_,

openstack can't open stack
