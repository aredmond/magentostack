# Where to get Magento, can be http link or git path
default['magentostack']['install_method'] = 'ark' # can be ark, git, cloudfiles, or none

# How to configure magento initially
default['magentostack']['configure_method'] = 'installer' # can be installer, template, or none

# Distribution of magento and a checksum for that download
default['magentostack']['checksum'] = '338df88796a445cd3be2a10b5c79c50e9900a4a1b1d8e9113a79014d3186a8e0'
default['magentostack']['flavor'] = 'community' # could also be enterprise

# for ark download method
default['magentostack']['download_url'] = 'http://www.magentocommerce.com/downloads/assets/1.9.0.1/magento-1.9.0.1.tar.gz'

# for cloudfiles download method
default['magentostack']['download_region'] = 'iad'
default['magentostack']['download_dir'] = 'magento'
default['magentostack']['download_file'] = 'magento.tar.gz'

# for git download method
default['magentostack']['git_repository'] = 'git@github.com:example/deployment.git'
default['magentostack']['git_revision'] = 'master' # e.g. staging, testing, dev
default['magentostack']['git_deploykey'] = nil

# Database creation by the mysql cookbook
normal['magentostack']['mysql']['databases']['magento_database']['mysql_user'] = 'magento_user'
normal['magentostack']['mysql']['databases']['magento_database']['mysql_password'] = 'magento_password'
normal['magentostack']['mysql']['databases']['magento_database']['privileges'] = ['all']
normal['magentostack']['mysql']['databases']['magento_database']['global_privileges'] = [:usage, :select, :'lock tables', :'show view', :reload, :super]

# Magento configuration
## localisation
default['magentostack']['config']['tz'] = 'Etc/UTC'
default['magentostack']['config']['locale'] = 'en_US'
default['magentostack']['config']['default_currency'] = 'GBP'

## Database
### We *do* look in node.run_state first
default['magentostack']['config']['db']['prefix'] = ''
default['magentostack']['config']['db']['initStatements'] = 'SET NAMES utf8'
default['magentostack']['config']['db']['model'] = 'mysql4'
default['magentostack']['config']['db']['type'] = 'pdo_mysql'
default['magentostack']['config']['db']['pdoType'] = ''
default['magentostack']['config']['db']['active'] = 1
default['magentostack']['config']['db']['persistent'] = 1

## Admin user
default['magentostack']['config']['admin_frontname'] = 'admin'
default['magentostack']['config']['admin_user']['firstname'] = 'Admin'
default['magentostack']['config']['admin_user']['lastname'] = 'User'
default['magentostack']['config']['admin_user']['email'] = 'admin@example.org'
default['magentostack']['config']['admin_user']['username'] = 'MagentoAdmin'
default['magentostack']['config']['admin_user']['password'] = 'magPass.123'

## Other configs
default['magentostack']['config']['encryption_key'] = nil
default['magentostack']['config']['session']['save'] = 'db'

default['magentostack']['config']['use_rewrites'] = 'yes'
default['magentostack']['config']['use_secure'] = 'yes'
default['magentostack']['config']['use_secure_admin'] = 'yes'
default['magentostack']['config']['enable_charts'] = 'yes'
