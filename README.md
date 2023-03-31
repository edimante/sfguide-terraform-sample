# Terraforming Snowflake

Gotchas:

- to follow the guidelenes you need to run terraform using the EC2 instance or similar
- You need to have SSH setup done in Git to push to SSH URL `git remote add origin git@github.com:YOUR_GITHUB_USERNAME/sfguide-terraform-sample.git` or change the command to push to HTTPS URL
- Best to add full path for the Private Key and include cloud (eg. .aws) after adding cloud region id:

`export SNOWFLAKE_PRIVATE_KEY_PATH="home/<user>/.ssh/snowflake_tf_snow_key.p8"`

`export SNOWFLAKE_REGION="<cloud_region_id>.<cloud>"`

next thing
