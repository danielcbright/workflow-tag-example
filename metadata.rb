name 'bitbucket-version-test-cookbook'
maintainer 'Daniel Bright'
maintainer_email 'danielcbright@gmail.com'
license 'Apache 2.0'
description 'Installs/Configures bitbucket-version-test-cookbook'
long_description 'Installs/Configures bitbucket-version-test-cookbook'
version '2.0.6'
chef_version '>= 12.1' if respond_to?(:chef_version)

# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook's page when
# uploaded to a Supermarket.
#
# issues_url 'https://github.com/<insert_org_here>/bitbucket-version-test-cookbook/issues'

# The `source_url` points to the development repository for this cookbook.  A
# `View Source` link will be displayed on this cookbook's page when uploaded to
# a Supermarket.
#
# source_url 'https://github.com/<insert_org_here>/bitbucket-version-test-cookbook'

depends 'delivery-truck'
depends 'delivery-sugar'
