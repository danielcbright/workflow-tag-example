# workflow-tag-example

This is an example Delivery cookbook and how-to guide that shows you how to use
the `delivery_github` resource to tag your repo during the `publish` phase.
You'll notice that this cookbook has no functional code other than what's needed
to update the repo tag -- it's a freshly initialized delivery cookbook. This has
been tested on Bitbucket and GitHub, not extensively, but it seems to work well
for both.

### 1. Create ssh keys & workflow-vault

1. Read [this post](http://blog.jerryaldrichiii.com/chef_automate/2016/12/12/workflow-using-chef-vaults-in-workflow.html)
by my colleague Jerry Aldrich to get a better understanding of how Chef vaults
work in Workflow. Seriously, this is important, so read it!
1. Following [GitHub](https://help.github.com/articles/adding-a-new-ssh-key-to-your-github-account/)/[Bitbucket](https://confluence.atlassian.com/bitbucket/set-up-an-ssh-key-728138079.html)
instructions, create an ssh keypair.
1. Create a `<workflow-enterprise>-<workflow-org>.json` file with the following
contents, replace the contents of `key` with the private key you generated in
step 2, also be sure to use only `github` or `bitbucket` as the remote name:
  ```
  {
  "id":"<workflow-enterprise>-<workflow-org>",
  "publish": {
    "<github|bitbucket>": {
        "key": "-----BEGIN RSA PRIVATE KEY-----\nPRIVATEKEY WITH NEWLINES REPLACED BY SO IT'S ALL ONE LINE\n-----END RSA PRIVATE KEY-----"
      }
    }
  }
```
  _A note on `<workflow-enterprise>-<workflow-org>`, if my Workflow Enterprise is
called "BallJoints", and my Workflow org is called "web-frontends", my id's in
this guide would be `BallJoints-web-frontends`._
1. Before the next step, let's make sure our `knife.rb` is configured properly,
make sure `vault_mode='client'` is somewhere in your config, also note that you
will need to add the `-M client` switch to **all** `knife vault` commands.
1. Run the following command, changing everything in `< >`'s.
  ```
  $ knife vault create \
     workflow-vaults \
     <workflow-enterprise>-<workflow-org> \
     -J /path/to/json/you/created/in/step/3/<workflow-enterprise>-<workflow-org>.json \
     -A 'delivery' \
     -S 'tags:delivery-job-runner' \
     -M client
  ```
1. Run the following to make sure you see your newly created vault:
  ```
  $ knife vault show workflow-vaults -M client
  ```

### 2. Edit the `publish.rb`

1. Now, on to the `publish.rb`, open the `.delivery/build_cookbook/recipes/publish.rb` file and add the following below `include_recipe 'delivery-truck::publish'`, replacing everything
between `< >`'s.:
  ```ruby
  vault_data = get_workflow_vault_data

  execute "Set git username information" do
    command "git config --global user.email \"<you@email.com>\" && git config --global user.name \"<Your Name>\""
    live_stream true
  end

  delivery_github 'tag' do
    deploy_key vault_data['publish']['<github|bitbucket>']['key']
    tag '<v1.0>'
    branch node['delivery']['change']['pipeline']
    remote_url 'ssh://git@<HOSTNAME:PORT>/<somepath>.git'
    repo_path node['delivery']['workspace']['repo']
    cache_path node['delivery']['workspace']['cache']
    action :push
  end
  ```
1. Do your usual `git add, commit, push` + `delivery review` process, and if all
is successful, you will see your tag applied to the latest commit to your repo!

### Tips
It's a little finicky to setup at first, so I recommend editing the
`config.json` and adding the following to the 'skip_phases' section to skip some
tests while your testing it out:

```json
"smoke",
"unit",
"lint",
"syntax"
```

### Contributing
Bug reports and pull requests are welcome on GitHub at https://github.com/danielcbright/workflow-tag-example.

### ToDo

* Add auto-tag feature that automatically sets the version to what's in your
`metadata.rb`

### License
Apache 2.0 (see [LICENSE](./LICENSE))
