#!/bin/bash

set -xe

# always create self signed certificate if none was provided
/usr/libexec/cockpit-certificate-ensure

# startup of cockpit
exec /usr/libexec/cockpit-ws --local-ssh
