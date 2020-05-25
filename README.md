# Vagrant Box Google Cloud Storage (GCS)

[![Gem Version](https://badge.fury.io/rb/vagrant-box-gcs.svg)](https://badge.fury.io/rb/vagrant-box-gcs)

This is a [Vagrant](http://www.vagrantup.com) 2.2.0+ plugin that adds the ability to download boxes from
[Google Compute Storage](http://cloud.google.com/storage/) (GCS).

## Installation
```bash
$ vagrant plugin install vagrant-box-gcs
```

## Usage

Only the `gs://` protocol shorthand is supported

The plugin supports fetching compatible metadata file of structured boxes repository

#### From metadata box:

```bash
$ vagrant box add gs://my-bucket/my-org/my-box-metadata.json
```

The `box update` command line is available when using metadata
```bash
$ vagrant box update --box my-org/my-box
```

```ruby
# Vagrantfile
Vagrant.configure('2') do |config|
  config.vm.box     = 'my-org/my-box'
  config.vm.box_url = 'gs://my-bucket/my-org/my-box-metadata.json'
end
```

#### From simple box:

```bash
$ vagrant box add gs://my-bucket/my-org/my-box/virtualbox.box
```

```ruby
# Vagrantfile
Vagrant.configure('2') do |config|
  config.vm.box_url = 'gs://my-bucket/my-org/my-box/virtualbox.box'
end
```

## Authentication

Authenticating with Google Cloud services requires at most one JSON file.
Vagrant will look for credentials in the following places, preferring the first location found:

1.  A JSON file (Service Account) whose path is specified by the
    `GOOGLE_APPLICATION_CREDENTIALS` environment variable.

2.  A JSON file in a location known to the `gcloud` command-line tool.
    (`gcloud auth application-default login` creates it)

    On Windows, this is:

        %APPDATA%/gcloud/application_default_credentials.json

    On other systems:

        $HOME/.config/gcloud/application_default_credentials.json

3.  On Google Compute Engine and Google App Engine Managed VMs, it fetches
    credentials from the metadata server. (Needs a correct VM authentication
    scope configuration)


## Auto-install

Auto-install with some shell in your `Vagrantfile`:

```ruby
# Vagrantfile
unless Vagrant.has_plugin?('vagrant-box-gcs')
  system('vagrant plugin install vagrant-box-gcs') || exit!
  exit system('vagrant', *ARGV)
end

Vagrant.configure('2') do |config|
  config.vm.box_url = 'gs://my-bucket/my-org/my-box/virtualbox.box'
  # ...
end
```
