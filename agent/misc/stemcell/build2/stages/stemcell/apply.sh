#!/usr/bin/env bash
#
# Copyright (c) 2009-2012 VMware, Inc.

set -e

base_dir=$(readlink -nf $(dirname $0)/../..)
source $base_dir/lib/prelude_apply.bash

pushd $work/stemcell

# NOTE: architecture and root_device_name aren't dynamically detected
# as we don't have a way to persist values across stages, and until we
# build for multiple architectures or multiple root devices, hardcoding
# the values is fine.
# The values are only used in AWS, but still applies to vSphere
$ruby_bin <<EOS
require "yaml"

stemcell_name = "$stemcell_name"
version = "$stemcell_version"
bosh_protocol = "$bosh_protocol_version".to_i
stemcell_infrastructure = "$stemcell_infrastructure"

manifest = {
    "name" => stemcell_name,
    "version" => version,
    "bosh_protocol" => bosh_protocol,
    "cloud_properties" => {
        "infrastructure" => stemcell_infrastructure,
        "architecture" => "x86_64",
        "root_device_name" => "/dev/sda1"
    }
}

File.open("stemcell.MF", "w") do |f|
  f.write(YAML.dump(manifest))
end
EOS

stemcell_tgz="$stemcell_name-$stemcell_infrastructure-$stemcell_version.tgz"
tar zvcf ../$stemcell_tgz *

echo "Generated stemcell: $work/$stemcell_tgz"
