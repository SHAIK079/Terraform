# Terraform workspaces allow you to maintain multiple instances
# of a single configuration using separate state files.
# Common workspace names are "default", "dev", and "prod".

resource "aws_instance" "name" {
    ami = "ami-002192a70217ac181"
    instance_type = "t2.micro" 

    # This instance is created in the current workspace.
    # Use `terraform workspace show` to see which workspace is active.
    # Each workspace stores its own state, so the same config can
    # manage separate environments without changing the code.
}